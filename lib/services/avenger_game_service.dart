import '../models/avenger_game.dart';
import '../models/game_level.dart';
import '../models/subject.dart';
import '../services/data_service.dart';
import '../services/roadmap_service.dart';
import '../services/ai_content_service.dart';

class AvengerGameService {
  // Store current chapter and subject for question generation
  static Chapter? _currentChapter;
  static Subject? _currentSubject;
  
  static AvengerGame generateGameForChapter(String subjectId, String chapterId) {
    final chapter = DataService.getChapterById(subjectId, chapterId);
    final subject = DataService.getSubjectById(subjectId);
    
    if (chapter == null || subject == null) {
      return _getDefaultGame(chapterId, 'Unknown Chapter');
    }

    // Store for question generation
    _currentChapter = chapter;
    _currentSubject = subject;

    final chapterIndex = subject.chapters.indexWhere((ch) => ch.id == chapterId);
    final mainAvenger = RoadmapService.getChapterAvenger(chapterIndex >= 0 ? chapterIndex : 0);
    
    // Get AI content to generate questions
    final aiContent = AIContentService.generateChapterContent(subjectId, chapterId);
    
    // Generate 50 levels
    final levels = <GameLevel>[];
    final allQuestions = <AvengerGameQuestion>[];
    
    // Generate questions from concepts
    final concepts = aiContent['keyConcepts'] as List;
    final formulas = aiContent['importantFormulas'] as List;
    final studyTips = aiContent['studyTips'] as List<String>;
    final practiceQuestions = aiContent['practiceQuestions'] as List;
    
    int questionIndex = 0;
    final Set<String> usedQuestionIds = {}; // Track used questions to avoid repetition
    
    // Create 50 levels
    for (int levelNum = 1; levelNum <= 50; levelNum++) {
      final levelAvenger = RoadmapService.getChapterAvenger((chapterIndex + levelNum * 2) % 50);
      final levelQuestions = <AvengerGameQuestion>[];
      
      // Each level has 3-5 questions (increasing difficulty)
      int questionsPerLevel = levelNum <= 10 ? 3 : (levelNum <= 25 ? 4 : 5);
      
      for (int q = 0; q < questionsPerLevel; q++) {
        AvengerGameQuestion? question;
        int attempts = 0;
        
        // Try to generate unique questions
        while (question == null && attempts < 10) {
          final questionType = (questionIndex + levelNum + q) % 4;
          
          if (questionType == 0 && concepts.isNotEmpty) {
            // Concept questions - vary based on level
            final conceptIndex = (questionIndex + levelNum * 3) % concepts.length;
            final concept = concepts[conceptIndex];
            final avenger = RoadmapService.getChapterAvenger((chapterIndex + questionIndex + levelNum * 5) % 50);
            question = _generateQuestionFromConcept(
              concept,
              avenger,
              questionIndex + levelNum * 100 + q,
              subject.name,
              chapter.name,
              levelNum,
            );
          } else if (questionType == 1 && formulas.isNotEmpty) {
            // Formula questions
            final formulaIndex = (questionIndex + levelNum * 2) % formulas.length;
            final formula = formulas[formulaIndex];
            final avenger = RoadmapService.getChapterAvenger((chapterIndex + questionIndex + levelNum * 7) % 50);
            question = _generateQuestionFromFormula(
              formula,
              avenger,
              questionIndex + levelNum * 100 + q,
              subject.name,
              levelNum,
            );
          } else if (questionType == 2 && practiceQuestions.isNotEmpty) {
            // Practice question based
            final practiceIndex = (questionIndex + levelNum * 4) % practiceQuestions.length;
            final practiceQ = practiceQuestions[practiceIndex];
            final avenger = RoadmapService.getChapterAvenger((chapterIndex + questionIndex + levelNum * 11) % 50);
            question = _generateQuestionFromPractice(
              practiceQ,
              avenger,
              questionIndex + levelNum * 100 + q,
              subject.name,
              chapter.name,
              levelNum,
            );
          } else {
            // General and advanced questions
            final avenger = RoadmapService.getChapterAvenger((chapterIndex + questionIndex + levelNum * 13) % 50);
            question = _generateAdvancedQuestion(
              chapter,
              subject,
              avenger,
              questionIndex + levelNum * 100 + q,
              levelNum,
              studyTips,
            );
          }
          
          // Check if question is unique
          if (question != null && usedQuestionIds.contains(question.id)) {
            question = null;
            attempts++;
          } else if (question != null) {
            usedQuestionIds.add(question.id);
            break;
          }
          
          attempts++;
        }
        
        if (question != null) {
          levelQuestions.add(question);
          allQuestions.add(question);
          questionIndex++;
        }
      }
      
      levels.add(
        GameLevel(
          levelNumber: levelNum,
          levelName: _getLevelName(levelNum, chapter.name),
          avengerName: levelAvenger['name']!,
          avengerIcon: levelAvenger['icon']!,
          avengerColor: levelAvenger['color']!,
          questions: levelQuestions,
          isUnlocked: levelNum == 1, // Only first level unlocked
        ),
      );
    }

    return AvengerGame(
      chapterId: chapterId,
      chapterName: chapter.name,
      questions: allQuestions,
      mainAvengerName: mainAvenger['name']!,
      mainAvengerIcon: mainAvenger['icon']!,
      mainAvengerColor: mainAvenger['color']!,
      levels: levels,
    );
  }

  static String _getLevelName(int levelNum, String chapterName) {
    if (levelNum <= 5) {
      return 'Beginner: $chapterName Basics';
    } else if (levelNum <= 15) {
      return 'Intermediate: Core Concepts';
    } else if (levelNum <= 30) {
      return 'Advanced: Deep Understanding';
    } else if (levelNum <= 40) {
      return 'Expert: Complex Applications';
    } else {
      return 'Master: Ultimate Challenge';
    }
  }

  static AvengerGameQuestion _generateQuestionFromPractice(
    Map<String, dynamic> practiceQ,
    Map<String, String> avenger,
    int index,
    String subject,
    String chapter,
    int levelNum,
  ) {
    final questionText = practiceQ['question'] as String? ?? 'What is an important aspect of $chapter?';
    final difficulty = practiceQ['difficulty'] as String? ?? 'medium';
    final subjectName = subject.toLowerCase();
    
    // Generate subject and chapter-specific practice questions
    String question;
    List<String> options;
    int correctAnswer;
    String explanation;
    
    final chapterDesc = _currentChapter?.description ?? '';
    
    // Generate meaningful questions based on chapter description and practice question
    if (levelNum <= 15) {
      // Beginner level - use actual practice question text if meaningful
      if (questionText.isNotEmpty && questionText.length > 20 && !questionText.contains('related to this chapter')) {
        question = questionText;
        // Generate realistic options based on subject and chapter
        if (subjectName == 'physics') {
          final keywords = chapterDesc.split(',').where((k) => k.trim().isNotEmpty).take(3).toList();
          options = [
            keywords.isNotEmpty ? keywords[0].trim() : 'Physics principle',
            keywords.length > 1 ? keywords[1].trim() : 'Electric current',
            keywords.length > 2 ? keywords[2].trim() : 'Magnetic field',
            'Unrelated concept'
          ];
        } else if (subjectName == 'mathematics' || subjectName.contains('math')) {
          final keywords = chapterDesc.split(',').where((k) => k.trim().isNotEmpty).take(3).toList();
          options = [
            keywords.isNotEmpty ? keywords[0].trim() : 'Mathematical concept',
            keywords.length > 1 ? keywords[1].trim() : 'Algebraic expression',
            keywords.length > 2 ? keywords[2].trim() : 'Geometric property',
            'Unrelated concept'
          ];
        } else if (subjectName == 'chemistry') {
          final keywords = chapterDesc.split(',').where((k) => k.trim().isNotEmpty).take(3).toList();
          options = [
            keywords.isNotEmpty ? keywords[0].trim() : 'Chemical reaction',
            keywords.length > 1 ? keywords[1].trim() : 'Molecular structure',
            keywords.length > 2 ? keywords[2].trim() : 'Chemical bond',
            'Unrelated concept'
          ];
        } else if (subjectName == 'biology') {
          final keywords = chapterDesc.split(',').where((k) => k.trim().isNotEmpty).take(3).toList();
          options = [
            keywords.isNotEmpty ? keywords[0].trim() : 'Biological process',
            keywords.length > 1 ? keywords[1].trim() : 'Cellular function',
            keywords.length > 2 ? keywords[2].trim() : 'Organ system',
            'Unrelated concept'
          ];
        } else {
          final keywords = chapterDesc.split(',').where((k) => k.trim().isNotEmpty).take(3).toList();
          options = [
            keywords.isNotEmpty ? keywords[0].trim() : 'Core concept',
            keywords.length > 1 ? keywords[1].trim() : 'Key principle',
            keywords.length > 2 ? keywords[2].trim() : 'Important topic',
            'Unrelated concept'
          ];
        }
        correctAnswer = 0;
        explanation = 'This question tests your understanding of $chapter concepts.';
      } else {
        // Generate question from chapter description
        final keywords = chapterDesc.split(',').where((k) => k.trim().isNotEmpty).take(2).toList();
        question = 'What is an important aspect of $chapter?';
        options = [
          keywords.isNotEmpty ? keywords[0].trim() : 'Fundamental principles',
          keywords.length > 1 ? keywords[1].trim() : 'Core concepts',
          'Unrelated topic',
          'Basic definition'
        ];
        correctAnswer = 0;
        explanation = 'This chapter covers important concepts in ${subject.toLowerCase()}.';
      }
    } else if (levelNum <= 30) {
      // Intermediate level - application questions
      final keywords = chapterDesc.split(',').where((k) => k.trim().isNotEmpty).take(2).toList();
      question = 'How can you apply concepts from $chapter in real-world scenarios?';
      options = [
        keywords.isNotEmpty ? 'Through ${keywords[0].trim().toLowerCase()} applications' : 'Through practical applications',
        'Only in theoretical problems',
        'Not applicable in real life',
        'Only in laboratory settings'
      ];
      correctAnswer = 0;
      explanation = 'Understanding practical applications helps master $chapter concepts.';
    } else {
      // Advanced level - deeper understanding
      final keywords = chapterDesc.split(',').where((k) => k.trim().isNotEmpty).take(2).toList();
      question = 'What advanced understanding is required for $chapter?';
      options = [
        keywords.isNotEmpty ? 'Deep knowledge of ${keywords[0].trim().toLowerCase()}' : 'Advanced conceptual understanding',
        'Basic memorization',
        'Simple definitions',
        'Surface-level knowledge'
      ];
      correctAnswer = 0;
      explanation = 'Advanced levels require deep understanding of $chapter principles.';
    }
    
    return AvengerGameQuestion(
      id: 'practice_${index}_${levelNum}',
      question: question,
      options: options,
      correctAnswer: correctAnswer,
      explanation: explanation,
      avengerName: avenger['name']!,
      avengerIcon: avenger['icon']!,
      avengerColor: avenger['color']!,
      concept: chapter,
    );
  }

  static AvengerGameQuestion _generateQuestionFromConcept(
    Map<String, dynamic> concept,
    Map<String, String> avenger,
    int index,
    String subject,
    String chapter,
    int levelNum,
  ) {
    final title = concept['title'] as String? ?? 'Concept';
    final description = concept['description'] as String? ?? '';
    final chapterDesc = _currentChapter?.description ?? '';
    final subjectName = subject.toLowerCase();
    final chapterName = chapter.toLowerCase();
    
    // Generate subject and chapter-specific questions based on chapter description
    String question;
    List<String> options;
    int correctAnswer;
    String explanation;

    // Physics-specific questions based on chapter description
    if (subjectName == 'physics') {
      if ((chapterName.contains('electric') && (chapterName.contains('charge') || chapterDesc.contains('charge'))) || chapterDesc.contains('coulomb') || chapterDesc.contains('electric charge') || title.toLowerCase().contains('electric')) {
        question = 'What is the unit of electric charge?';
        options = ['Coulomb (C)', 'Volt (V)', 'Ampere (A)', 'Ohm (Ω)'];
        correctAnswer = 0;
        explanation = 'Electric charge is measured in Coulombs (C). This is a fundamental unit in physics.';
      } else if (chapterName.contains('current') || chapterDesc.contains('ohm') || chapterDesc.contains('resistance') || chapterDesc.contains('kirchhoff') || chapterDesc.contains('wheatstone') || title.toLowerCase().contains('current')) {
        question = 'According to Ohm\'s Law, what is the relationship between voltage, current, and resistance?';
        options = ['V = IR', 'I = VR', 'R = VI', 'V = I/R'];
        correctAnswer = 0;
        explanation = 'Ohm\'s Law states: V = IR, where V is voltage, I is current, and R is resistance.';
      } else if (chapterName.contains('magnetic') || chapterDesc.contains('magnetic') || chapterDesc.contains('magnet') || chapterDesc.contains('biot-savart') || chapterDesc.contains('ampere') || title.toLowerCase().contains('magnetic')) {
        question = 'What is the SI unit of magnetic field?';
        options = ['Tesla (T)', 'Gauss (G)', 'Weber (Wb)', 'Henry (H)'];
        correctAnswer = 0;
        explanation = 'Magnetic field is measured in Tesla (T) in SI units.';
      } else if (chapterName.contains('wave') || chapterDesc.contains('wave') || chapterDesc.contains('electromagnetic') || chapterDesc.contains('spectrum') || title.toLowerCase().contains('wave')) {
        question = 'What is the speed of light in vacuum?';
        options = ['3 × 10⁸ m/s', '3 × 10⁶ m/s', '3 × 10¹⁰ m/s', '3 × 10⁴ m/s'];
        correctAnswer = 0;
        explanation = 'The speed of light in vacuum is approximately 3 × 10⁸ meters per second.';
      } else if (chapterDesc.contains('potential') || chapterName.contains('potential') || chapterDesc.contains('capacitance') || chapterDesc.contains('capacitor')) {
        question = 'What is electric potential?';
        options = [
          'Work done per unit charge',
          'Force per unit charge',
          'Charge per unit area',
          'Current per unit time'
        ];
        correctAnswer = 0;
        explanation = 'Electric potential is the work done per unit charge to bring a charge from infinity to a point.';
      } else if (chapterDesc.contains('induction') || chapterName.contains('induction') || chapterDesc.contains('faraday') || chapterDesc.contains('lenz')) {
        question = 'What does Faraday\'s law of electromagnetic induction state?';
        options = [
          'EMF is induced when magnetic flux changes',
          'EMF is constant',
          'No EMF is induced',
          'EMF depends only on current'
        ];
        correctAnswer = 0;
        explanation = 'Faraday\'s law states that an electromotive force (EMF) is induced in a circuit when the magnetic flux through it changes.';
      } else {
        // Generate question from chapter description keywords
        final keywords = chapterDesc.split(',').where((k) => k.trim().isNotEmpty).take(3).toList();
        question = 'What is a key concept in $chapter?';
        options = [
          keywords.isNotEmpty ? keywords[0].trim() : (description.isNotEmpty ? description.substring(0, description.length > 50 ? 50 : description.length) : 'Fundamental principle of $chapter'),
          keywords.length > 1 ? keywords[1].trim() : 'Secondary concept',
          keywords.length > 2 ? keywords[2].trim() : 'Advanced topic',
          'Unrelated concept'
        ];
        correctAnswer = 0;
        explanation = description.isNotEmpty ? description : (chapterDesc.isNotEmpty ? chapterDesc : 'This is an important concept in $chapter.');
      }
    }
    // Mathematics-specific questions based on chapter description
    else if (subjectName == 'mathematics' || subjectName.contains('math')) {
      if (chapterName.contains('derivative') || chapterDesc.contains('derivative') || chapterDesc.contains('differentiation') || title.toLowerCase().contains('derivative')) {
        question = 'What is the derivative of x²?';
        options = ['2x', 'x', 'x²', '2x²'];
        correctAnswer = 0;
        explanation = 'Using the power rule: d/dx(xⁿ) = nxⁿ⁻¹, so d/dx(x²) = 2x.';
      } else if (chapterName.contains('integral') || chapterDesc.contains('integral') || chapterDesc.contains('integration') || title.toLowerCase().contains('integral')) {
        question = 'What is the integral of 2x?';
        options = ['x² + C', '2x + C', 'x²', '2x'];
        correctAnswer = 0;
        explanation = 'The integral of 2x is x² + C, where C is the constant of integration.';
      } else if (chapterName.contains('trigonometric') || chapterDesc.contains('trigonometric') || chapterDesc.contains('sin') || chapterDesc.contains('cos') || title.toLowerCase().contains('trigonometric')) {
        question = 'What is sin²θ + cos²θ equal to?';
        options = ['1', '0', 'sin(2θ)', 'cos(2θ)'];
        correctAnswer = 0;
        explanation = 'This is a fundamental trigonometric identity: sin²θ + cos²θ = 1.';
      } else if (chapterName.contains('matrix') || chapterDesc.contains('matrix') || chapterDesc.contains('determinant') || title.toLowerCase().contains('matrix')) {
        question = 'What is the determinant of a 2×2 matrix [[a,b],[c,d]]?';
        options = ['ad - bc', 'ab - cd', 'a + d', 'b + c'];
        correctAnswer = 0;
        explanation = 'For a 2×2 matrix, the determinant is calculated as ad - bc.';
      } else if (chapterDesc.contains('function') || chapterName.contains('function') || chapterDesc.contains('relation')) {
        question = 'What is a function?';
        options = [
          'A relation where each input has exactly one output',
          'A relation with multiple outputs',
          'Any relation',
          'A set of numbers'
        ];
        correctAnswer = 0;
        explanation = 'A function is a relation where each input (domain) has exactly one output (range).';
      } else {
        // Generate question from chapter description keywords
        final keywords = chapterDesc.split(',').where((k) => k.trim().isNotEmpty).take(3).toList();
        question = 'What is a key concept in $chapter?';
        options = [
          keywords.isNotEmpty ? keywords[0].trim() : (description.isNotEmpty ? description.substring(0, description.length > 50 ? 50 : description.length) : 'Fundamental principle of $chapter'),
          keywords.length > 1 ? keywords[1].trim() : 'Secondary concept',
          keywords.length > 2 ? keywords[2].trim() : 'Advanced topic',
          'Unrelated concept'
        ];
        correctAnswer = 0;
        explanation = description.isNotEmpty ? description : (chapterDesc.isNotEmpty ? chapterDesc : 'This is an important concept in $chapter.');
      }
    }
    // Chemistry-specific questions based on chapter description
    else if (subjectName == 'chemistry') {
      if (chapterName.contains('reaction') || chapterDesc.contains('reaction') || chapterDesc.contains('chemical') || title.toLowerCase().contains('reaction')) {
        question = 'What happens in a chemical reaction?';
        options = [
          'Atoms rearrange to form new substances',
          'Atoms are destroyed',
          'Energy is created',
          'Mass is lost'
        ];
        correctAnswer = 0;
        explanation = 'In a chemical reaction, atoms rearrange to form new substances. Atoms are neither created nor destroyed (Law of Conservation of Mass).';
      } else if (chapterName.contains('solution') || chapterDesc.contains('solution') || chapterDesc.contains('solute') || chapterDesc.contains('solvent') || title.toLowerCase().contains('solution')) {
        question = 'What is a solution?';
        options = [
          'A homogeneous mixture of two or more substances',
          'A heterogeneous mixture',
          'A pure substance',
          'A compound'
        ];
        correctAnswer = 0;
        explanation = 'A solution is a homogeneous mixture where one substance (solute) is dissolved in another (solvent).';
      } else if (chapterName.contains('equilibrium') || chapterDesc.contains('equilibrium') || chapterDesc.contains('reversible') || title.toLowerCase().contains('equilibrium')) {
        question = 'What is chemical equilibrium?';
        options = [
          'State where forward and reverse reaction rates are equal',
          'State where no reaction occurs',
          'State where only forward reaction occurs',
          'State where only reverse reaction occurs'
        ];
        correctAnswer = 0;
        explanation = 'Chemical equilibrium is a dynamic state where the rates of forward and reverse reactions are equal.';
      } else if (chapterDesc.contains('solid') || chapterName.contains('solid') || chapterDesc.contains('crystal')) {
        question = 'What is a crystal lattice?';
        options = [
          'Regular arrangement of atoms or molecules',
          'Random arrangement',
          'Liquid structure',
          'Gas structure'
        ];
        correctAnswer = 0;
        explanation = 'A crystal lattice is a regular, repeating arrangement of atoms, ions, or molecules in a solid.';
      } else {
        // Generate question from chapter description keywords
        final keywords = chapterDesc.split(',').where((k) => k.trim().isNotEmpty).take(3).toList();
        question = 'What is a key concept in $chapter?';
        options = [
          keywords.isNotEmpty ? keywords[0].trim() : (description.isNotEmpty ? description.substring(0, description.length > 50 ? 50 : description.length) : 'Fundamental principle of $chapter'),
          keywords.length > 1 ? keywords[1].trim() : 'Secondary concept',
          keywords.length > 2 ? keywords[2].trim() : 'Advanced topic',
          'Unrelated concept'
        ];
        correctAnswer = 0;
        explanation = description.isNotEmpty ? description : (chapterDesc.isNotEmpty ? chapterDesc : 'This is an important concept in $chapter.');
      }
    }
    // Biology-specific questions based on chapter description
    else if (subjectName == 'biology') {
      if (chapterName.contains('reproduction') || chapterDesc.contains('reproduction') || chapterDesc.contains('gamete') || chapterDesc.contains('sexual') || chapterDesc.contains('asexual') || title.toLowerCase().contains('reproduction')) {
        question = 'What is the main difference between asexual and sexual reproduction?';
        options = [
          'Sexual reproduction involves fusion of gametes',
          'Asexual reproduction involves fusion of gametes',
          'Both are identical',
          'Neither involves cell division'
        ];
        correctAnswer = 0;
        explanation = 'Sexual reproduction involves the fusion of male and female gametes, while asexual reproduction does not.';
      } else if (chapterName.contains('genetics') || chapterDesc.contains('genetics') || chapterDesc.contains('gene') || chapterDesc.contains('heredity') || chapterDesc.contains('dna') || title.toLowerCase().contains('genetics')) {
        question = 'What is a gene?';
        options = [
          'A unit of heredity that codes for a protein',
          'A type of cell',
          'A type of tissue',
          'A type of organ'
        ];
        correctAnswer = 0;
        explanation = 'A gene is a unit of heredity that contains the information to code for a specific protein.';
      } else if (chapterName.contains('ecosystem') || chapterDesc.contains('ecosystem') || chapterDesc.contains('biodiversity') || chapterDesc.contains('environment') || chapterDesc.contains('conservation') || title.toLowerCase().contains('ecosystem')) {
        question = 'What is an ecosystem?';
        options = [
          'A community of living organisms and their environment',
          'Only living organisms',
          'Only non-living environment',
          'A single species'
        ];
        correctAnswer = 0;
        explanation = 'An ecosystem includes all living organisms (biotic) and their physical environment (abiotic) interacting as a system.';
      } else if (chapterDesc.contains('cell') || chapterName.contains('cell') || chapterDesc.contains('mitosis') || chapterDesc.contains('meiosis')) {
        question = 'What is the basic unit of life?';
        options = [
          'Cell',
          'Tissue',
          'Organ',
          'Organism'
        ];
        correctAnswer = 0;
        explanation = 'The cell is the basic structural and functional unit of all living organisms.';
      } else {
        // Generate question from chapter description keywords
        final keywords = chapterDesc.split(',').where((k) => k.trim().isNotEmpty).take(3).toList();
        question = 'What is a key concept in $chapter?';
        options = [
          keywords.isNotEmpty ? keywords[0].trim() : (description.isNotEmpty ? description.substring(0, description.length > 50 ? 50 : description.length) : 'Fundamental principle of $chapter'),
          keywords.length > 1 ? keywords[1].trim() : 'Secondary concept',
          keywords.length > 2 ? keywords[2].trim() : 'Advanced topic',
          'Unrelated concept'
        ];
        correctAnswer = 0;
        explanation = description.isNotEmpty ? description : (chapterDesc.isNotEmpty ? chapterDesc : 'This is an important concept in $chapter.');
      }
    }
    // Default for any other subject
    else {
      question = 'What is the main concept of $title in $chapter?';
      options = [
        description.isNotEmpty ? description.substring(0, description.length > 50 ? 50 : description.length) : 'Key principle of $chapter',
        'Secondary concept',
        'Advanced topic',
        'Basic definition'
      ];
      correctAnswer = 0;
      explanation = description.isNotEmpty ? description : 'This is an important concept in $chapter.';
    }

    return AvengerGameQuestion(
      id: 'concept_${index}_${levelNum}_${title.hashCode}',
      question: question,
      options: options,
      correctAnswer: correctAnswer,
      explanation: explanation,
      avengerName: avenger['name']!,
      avengerIcon: avenger['icon']!,
      avengerColor: avenger['color']!,
      concept: title,
    );
  }

  static AvengerGameQuestion _generateQuestionFromFormula(
    Map<String, dynamic> formula,
    Map<String, String> avenger,
    int index,
    String subject,
    int levelNum,
  ) {
    final formulaText = formula['formula'] as String? ?? '';
    final description = formula['description'] as String? ?? '';
    
    String question;
    List<String> options;
    int correctAnswer;
    String explanation;

    // Physics formulas
    if (subject.toLowerCase() == 'physics') {
      if (formulaText.contains('V = IR') || formulaText.contains('V=IR')) {
        question = 'According to Ohm\'s Law, if voltage is 12V and resistance is 4Ω, what is the current?';
        options = ['3A', '48A', '8A', '16A'];
        correctAnswer = 0;
        explanation = 'Using V = IR: I = V/R = 12/4 = 3A';
      } else if (formulaText.contains('F = k') || formulaText.contains('Coulomb')) {
        question = 'What does Coulomb\'s Law describe?';
        options = [
          'Force between two charges',
          'Electric field strength',
          'Potential difference',
          'Current flow'
        ];
        correctAnswer = 0;
        explanation = 'Coulomb\'s Law (F = k(q₁q₂)/r²) describes the force between two point charges.';
      } else if (formulaText.contains('E = mc²') || formulaText.contains('E=mc')) {
        question = 'What does E = mc² represent?';
        options = [
          'Mass-energy equivalence',
          'Kinetic energy',
          'Potential energy',
          'Mechanical energy'
        ];
        correctAnswer = 0;
        explanation = 'E = mc² represents mass-energy equivalence, where E is energy, m is mass, and c is speed of light.';
      } else {
        // Generate meaningful question from chapter and formula
        final chapterDesc = _currentChapter?.description ?? '';
        final chapterName = _currentChapter?.name ?? '';
        final keywords = chapterDesc.split(',').where((k) => k.trim().isNotEmpty).take(2).toList();
        
        if (formulaText.isNotEmpty && formulaText.length > 3) {
          question = 'What does the formula $formulaText represent in $chapterName?';
          options = [
            description.isNotEmpty ? description.substring(0, description.length > 60 ? 60 : description.length) : (keywords.isNotEmpty ? keywords[0].trim() : 'Physics principle'),
            keywords.length > 1 ? keywords[1].trim() : 'Electric field',
            'Chemical reaction',
            'Mathematical theorem'
          ];
        } else {
          question = 'What is an important physics formula in $chapterName?';
          options = [
            keywords.isNotEmpty ? keywords[0].trim() : (description.isNotEmpty ? description.substring(0, description.length > 60 ? 60 : description.length) : 'Core physics principle'),
            keywords.length > 1 ? keywords[1].trim() : 'Related physics concept',
            'Chemistry formula',
            'Biology concept'
          ];
        }
        correctAnswer = 0;
        explanation = description.isNotEmpty ? description : (chapterDesc.isNotEmpty ? chapterDesc : 'This is an important formula in $chapterName.');
      }
    }
    // Mathematics formulas
    else if (subject.toLowerCase() == 'mathematics' || subject.toLowerCase().contains('math')) {
      if (formulaText.contains('d/dx') || formulaText.contains('derivative')) {
        question = 'What does the derivative represent?';
        options = [
          'Rate of change',
          'Total value',
          'Average value',
          'Maximum value'
        ];
        correctAnswer = 0;
        explanation = 'The derivative represents the rate of change of a function with respect to its variable.';
      } else if (formulaText.contains('∫') || formulaText.contains('integral')) {
        question = 'What does an integral represent?';
        options = [
          'Area under a curve',
          'Slope of a curve',
          'Maximum value',
          'Minimum value'
        ];
        correctAnswer = 0;
        explanation = 'An integral represents the area under a curve or the accumulation of quantities.';
      } else if (formulaText.contains('sin') || formulaText.contains('cos') || formulaText.contains('tan')) {
        question = 'What is sin²θ + cos²θ equal to?';
        options = ['1', '0', 'sin(2θ)', 'cos(2θ)'];
        correctAnswer = 0;
        explanation = 'This is a fundamental trigonometric identity: sin²θ + cos²θ = 1.';
      } else {
        // Generate meaningful question from chapter and formula
        final chapterDesc = _currentChapter?.description ?? '';
        final chapterName = _currentChapter?.name ?? '';
        final keywords = chapterDesc.split(',').where((k) => k.trim().isNotEmpty).take(2).toList();
        
        if (formulaText.isNotEmpty && formulaText.length > 3) {
          question = 'What does the formula $formulaText represent in $chapterName?';
          options = [
            description.isNotEmpty ? description.substring(0, description.length > 60 ? 60 : description.length) : (keywords.isNotEmpty ? keywords[0].trim() : 'Mathematical principle'),
            keywords.length > 1 ? keywords[1].trim() : 'Algebraic expression',
            'Physics formula',
            'Chemistry equation'
          ];
        } else {
          question = 'What is an important mathematics formula in $chapterName?';
          options = [
            keywords.isNotEmpty ? keywords[0].trim() : (description.isNotEmpty ? description.substring(0, description.length > 60 ? 60 : description.length) : 'Core mathematical principle'),
            keywords.length > 1 ? keywords[1].trim() : 'Related math concept',
            'Physics formula',
            'Chemistry equation'
          ];
        }
        correctAnswer = 0;
        explanation = description.isNotEmpty ? description : (chapterDesc.isNotEmpty ? chapterDesc : 'This is an important formula in $chapterName.');
      }
    }
    // Chemistry formulas
    else if (subject.toLowerCase() == 'chemistry') {
      if (formulaText.contains('PV = nRT') || formulaText.contains('ideal gas')) {
        question = 'What does PV = nRT represent?';
        options = [
          'Ideal gas law',
          'Boyle\'s law',
          'Charles\' law',
          'Avogadro\'s law'
        ];
        correctAnswer = 0;
        explanation = 'PV = nRT is the ideal gas law, where P is pressure, V is volume, n is moles, R is gas constant, and T is temperature.';
      } else if (formulaText.contains('pH') || formulaText.contains('pOH')) {
        question = 'What does pH represent?';
        options = [
          'Negative logarithm of H⁺ concentration',
          'Positive logarithm of H⁺ concentration',
          'Concentration of OH⁻',
          'Total ion concentration'
        ];
        correctAnswer = 0;
        explanation = 'pH = -log[H⁺], representing the acidity or basicity of a solution.';
      } else {
        // Generate meaningful question from chapter and formula
        final chapterDesc = _currentChapter?.description ?? '';
        final chapterName = _currentChapter?.name ?? '';
        final keywords = chapterDesc.split(',').where((k) => k.trim().isNotEmpty).take(2).toList();
        
        if (formulaText.isNotEmpty && formulaText.length > 3) {
          question = 'What does the formula $formulaText represent in $chapterName?';
          options = [
            description.isNotEmpty ? description.substring(0, description.length > 60 ? 60 : description.length) : (keywords.isNotEmpty ? keywords[0].trim() : 'Chemistry principle'),
            keywords.length > 1 ? keywords[1].trim() : 'Chemical reaction',
            'Physics formula',
            'Mathematical equation'
          ];
        } else {
          question = 'What is an important chemistry formula in $chapterName?';
          options = [
            keywords.isNotEmpty ? keywords[0].trim() : (description.isNotEmpty ? description.substring(0, description.length > 60 ? 60 : description.length) : 'Core chemistry principle'),
            keywords.length > 1 ? keywords[1].trim() : 'Related chemical concept',
            'Physics formula',
            'Mathematical equation'
          ];
        }
        correctAnswer = 0;
        explanation = description.isNotEmpty ? description : (chapterDesc.isNotEmpty ? chapterDesc : 'This is an important formula in $chapterName.');
      }
    }
    // Biology (usually doesn't have formulas, but concepts)
    else if (subject.toLowerCase() == 'biology') {
      final chapterDesc = _currentChapter?.description ?? '';
      final chapterName = _currentChapter?.name ?? '';
      
      // Generate biology-specific questions based on chapter
      if (chapterDesc.contains('cell') || chapterName.toLowerCase().contains('cell')) {
        question = 'What is the basic structural unit of all living organisms?';
        options = ['Cell', 'Tissue', 'Organ', 'Organ system'];
        correctAnswer = 0;
        explanation = 'The cell is the basic structural and functional unit of all living organisms.';
      } else if (chapterDesc.contains('dna') || chapterDesc.contains('genetic') || chapterName.toLowerCase().contains('genetic')) {
        question = 'What does DNA stand for?';
        options = [
          'Deoxyribonucleic Acid',
          'Ribonucleic Acid',
          'Deoxyribose Nucleic Acid',
          'Double Nucleic Acid'
        ];
        correctAnswer = 0;
        explanation = 'DNA stands for Deoxyribonucleic Acid, which carries genetic information.';
      } else if (chapterDesc.contains('photosynthesis') || chapterName.toLowerCase().contains('photosynthesis')) {
        question = 'What is the primary product of photosynthesis?';
        options = ['Glucose', 'Oxygen', 'Carbon dioxide', 'Water'];
        correctAnswer = 0;
        explanation = 'Photosynthesis produces glucose (C₆H₁₂O₆) as the primary product, along with oxygen.';
      } else if (chapterDesc.contains('respiration') || chapterName.toLowerCase().contains('respiration')) {
        question = 'What is the main purpose of cellular respiration?';
        options = [
          'To produce ATP energy',
          'To produce oxygen',
          'To produce glucose',
          'To produce carbon dioxide'
        ];
        correctAnswer = 0;
        explanation = 'Cellular respiration breaks down glucose to produce ATP (adenosine triphosphate), the energy currency of cells.';
      } else if (chapterDesc.contains('ecosystem') || chapterName.toLowerCase().contains('ecosystem')) {
        question = 'What are the two main components of an ecosystem?';
        options = [
          'Biotic and abiotic factors',
          'Plants and animals',
          'Land and water',
          'Producers and consumers'
        ];
        correctAnswer = 0;
        explanation = 'An ecosystem consists of biotic (living) and abiotic (non-living) components that interact.';
      } else {
        // Generate meaningful question from chapter description
        final keywords = chapterDesc.split(',').where((k) => k.trim().isNotEmpty).take(2).toList();
        if (keywords.isNotEmpty) {
          question = 'Which of these is a key concept in ${chapterName}?';
          options = [
            keywords[0].trim(),
            keywords.length > 1 ? keywords[1].trim() : 'Secondary biological process',
            'Unrelated biology concept',
            'Physics principle'
          ];
          correctAnswer = 0;
          explanation = description.isNotEmpty ? description : 'This is an important concept in ${chapterName}.';
        } else {
          question = 'What is a fundamental principle in ${chapterName}?';
          options = [
            description.isNotEmpty ? description.substring(0, description.length > 60 ? 60 : description.length) : 'Core biological process',
            'Chemical reaction',
            'Physical law',
            'Mathematical formula'
          ];
          correctAnswer = 0;
          explanation = description.isNotEmpty ? description : 'This chapter covers important biological concepts.';
        }
      }
    }
    // Default - generate from chapter description
    else {
      final chapterDesc = _currentChapter?.description ?? '';
      final chapterName = _currentChapter?.name ?? '';
      final keywords = chapterDesc.split(',').where((k) => k.trim().isNotEmpty).take(2).toList();
      
      if (formulaText.isNotEmpty && formulaText.length > 3) {
        question = 'What does the formula $formulaText represent in $chapterName?';
        options = [
          description.isNotEmpty ? description.substring(0, description.length > 60 ? 60 : description.length) : (keywords.isNotEmpty ? keywords[0].trim() : 'Core concept'),
          keywords.length > 1 ? keywords[1].trim() : 'Related principle',
          'Unrelated formula',
          'Basic definition'
        ];
      } else {
        question = 'What is an important formula or concept in $chapterName?';
        options = [
          keywords.isNotEmpty ? keywords[0].trim() : (description.isNotEmpty ? description.substring(0, description.length > 60 ? 60 : description.length) : 'Key principle'),
          keywords.length > 1 ? keywords[1].trim() : 'Secondary concept',
          'Unrelated topic',
          'Basic definition'
        ];
      }
      correctAnswer = 0;
      explanation = description.isNotEmpty ? description : (chapterDesc.isNotEmpty ? chapterDesc : 'This is an important concept in $chapterName.');
    }

    return AvengerGameQuestion(
      id: 'formula_${index}_${levelNum}_${formulaText.hashCode}',
      question: question,
      options: options,
      correctAnswer: correctAnswer,
      explanation: explanation,
      avengerName: avenger['name']!,
      avengerIcon: avenger['icon']!,
      avengerColor: avenger['color']!,
      concept: formulaText,
    );
  }

  static AvengerGameQuestion _generateAdvancedQuestion(
    chapter,
    subject,
    Map<String, String> avenger,
    int index,
    int levelNum,
    List<String> studyTips,
  ) {
    String question;
    List<String> options;
    int correctAnswer;
    String explanation;
    final subjectName = subject.name.toLowerCase();
    final chapterName = chapter.name.toLowerCase();

    // Generate subject and chapter-specific advanced questions
    if (levelNum <= 15) {
      // Beginner level - basic chapter understanding
      if (subjectName == 'physics') {
        question = 'What is the main topic covered in ${chapter.name}?';
        options = [
          chapter.description.isNotEmpty 
              ? chapter.description.substring(0, chapter.description.length > 60 ? 60 : chapter.description.length)
              : 'Physics concepts and principles',
          'Chemistry reactions',
          'Mathematical theorems',
          'Biological processes'
        ];
        correctAnswer = 0;
        explanation = chapter.description.isNotEmpty 
            ? chapter.description 
            : 'This chapter covers fundamental physics concepts.';
      } else if (subjectName == 'mathematics' || subjectName.contains('math')) {
        question = 'What is the main topic covered in ${chapter.name}?';
        options = [
          chapter.description.isNotEmpty 
              ? chapter.description.substring(0, chapter.description.length > 60 ? 60 : chapter.description.length)
              : 'Mathematical concepts and methods',
          'Physics formulas',
          'Chemical equations',
          'Biological systems'
        ];
        correctAnswer = 0;
        explanation = chapter.description.isNotEmpty 
            ? chapter.description 
            : 'This chapter covers fundamental mathematical concepts.';
      } else if (subjectName == 'chemistry') {
        question = 'What is the main topic covered in ${chapter.name}?';
        options = [
          chapter.description.isNotEmpty 
              ? chapter.description.substring(0, chapter.description.length > 60 ? 60 : chapter.description.length)
              : 'Chemical concepts and reactions',
          'Physics laws',
          'Mathematical formulas',
          'Biological processes'
        ];
        correctAnswer = 0;
        explanation = chapter.description.isNotEmpty 
            ? chapter.description 
            : 'This chapter covers fundamental chemistry concepts.';
      } else if (subjectName == 'biology') {
        question = 'What is the main topic covered in ${chapter.name}?';
        options = [
          chapter.description.isNotEmpty 
              ? chapter.description.substring(0, chapter.description.length > 60 ? 60 : chapter.description.length)
              : 'Biological concepts and processes',
          'Physics principles',
          'Chemical reactions',
          'Mathematical theorems'
        ];
        correctAnswer = 0;
        explanation = chapter.description.isNotEmpty 
            ? chapter.description 
            : 'This chapter covers fundamental biology concepts.';
      } else {
        question = 'What is the main topic of ${chapter.name}?';
        options = [
          chapter.description.isNotEmpty 
              ? chapter.description.substring(0, chapter.description.length > 60 ? 60 : chapter.description.length)
              : 'Core concepts',
          'Advanced topics',
          'Basic definitions',
          'Practical applications'
        ];
        correctAnswer = 0;
        explanation = chapter.description.isNotEmpty 
            ? chapter.description 
            : 'This chapter covers fundamental concepts.';
      }
    } else if (levelNum <= 30) {
      // Intermediate level - importance and applications
      question = 'Why is ${chapter.name} important in ${subject.name}?';
      options = [
        'It forms the foundation for advanced topics in ${subject.name}',
        'It is optional in ${subject.name}',
        'It is only for exams',
        'It has no practical use'
      ];
      correctAnswer = 0;
      explanation = 'This chapter is important because it builds the foundation for understanding more advanced concepts in ${subject.name}.';
    } else if (levelNum <= 40) {
      // Advanced level - study approach
      question = 'Which study approach is most effective for ${chapter.name} in ${subject.name}?';
      options = [
        'Understanding concepts first, then practicing ${subject.name.toLowerCase()} problems',
        'Memorizing everything without understanding',
        'Only reading notes',
        'Skipping difficult parts'
      ];
      correctAnswer = 0;
      explanation = 'Understanding concepts first helps build a strong foundation in ${subject.name}, then practice reinforces learning.';
    } else {
      // Expert level - mastery
      question = 'What is the best way to master ${chapter.name} in ${subject.name}?';
      options = [
        'Regular practice, revision, and solving ${subject.name.toLowerCase()}-related problems',
        'Reading once',
        'Only memorizing formulas',
        'Avoiding practice questions'
      ];
      correctAnswer = 0;
      explanation = 'Mastery of ${chapter.name} comes from regular practice, consistent revision, and solving various types of ${subject.name.toLowerCase()} problems.';
    }

    return AvengerGameQuestion(
      id: 'advanced_${index}_${levelNum}_${chapter.name.hashCode}',
      question: question,
      options: options,
      correctAnswer: correctAnswer,
      explanation: explanation,
      avengerName: avenger['name']!,
      avengerIcon: avenger['icon']!,
      avengerColor: avenger['color']!,
      concept: chapter.name,
    );
  }

  static AvengerGame _getDefaultGame(String chapterId, String chapterName) {
    return AvengerGame(
      chapterId: chapterId,
      chapterName: chapterName,
      questions: [],
      mainAvengerName: 'Avenger',
      mainAvengerIcon: '🦸',
      mainAvengerColor: '#7B68EE',
      levels: [],
    );
  }
}

