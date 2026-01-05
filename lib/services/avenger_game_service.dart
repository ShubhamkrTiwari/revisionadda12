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
    final Set<String> usedQuestionIds = {}; // Track used question IDs
    final Set<String> usedQuestionTexts = {}; // Track used question texts to avoid duplicates
    final Map<String, int> conceptUsageCount = {}; // Track how many times each concept is used
    final Map<String, int> formulaUsageCount = {}; // Track how many times each formula is used
    
    // Create 50 levels
    for (int levelNum = 1; levelNum <= 50; levelNum++) {
      final levelAvenger = RoadmapService.getChapterAvenger((chapterIndex + levelNum * 2) % 50);
      final levelQuestions = <AvengerGameQuestion>[];
      
      // Each level has 3-5 questions (increasing difficulty)
      int questionsPerLevel = levelNum <= 10 ? 3 : (levelNum <= 25 ? 4 : 5);
      
      for (int q = 0; q < questionsPerLevel; q++) {
        AvengerGameQuestion? question;
        int attempts = 0;
        final int uniqueSeed = levelNum * 1000 + questionIndex * 100 + q * 10 + DateTime.now().millisecondsSinceEpoch % 1000;
        
        // Try to generate unique questions
        while (question == null && attempts < 20) {
          // Use more randomization for question type selection
          final questionType = (uniqueSeed + attempts * 7) % 4;
          
          if (questionType == 0 && concepts.isNotEmpty) {
            // Concept questions - vary based on level and ensure distribution
            final conceptIndex = (uniqueSeed + levelNum * 3 + q * 5) % concepts.length;
            final concept = concepts[conceptIndex];
            final conceptKey = concept['title']?.toString() ?? conceptIndex.toString();
            conceptUsageCount[conceptKey] = (conceptUsageCount[conceptKey] ?? 0) + 1;
            
            // Skip if this concept has been used too many times
            if ((conceptUsageCount[conceptKey] ?? 0) > 3 && attempts < 15) {
              attempts++;
              continue;
            }
            
            final avenger = RoadmapService.getChapterAvenger((chapterIndex + uniqueSeed + levelNum * 5) % 50);
            question = _generateQuestionFromConcept(
              concept,
              avenger,
              uniqueSeed,
              subject.name,
              chapter.name,
              levelNum,
            );
          } else if (questionType == 1 && formulas.isNotEmpty) {
            // Formula questions - ensure variety
            final formulaIndex = (uniqueSeed + levelNum * 2 + q * 3) % formulas.length;
            final formula = formulas[formulaIndex];
            final formulaKey = formula['formula']?.toString() ?? formulaIndex.toString();
            formulaUsageCount[formulaKey] = (formulaUsageCount[formulaKey] ?? 0) + 1;
            
            // Skip if this formula has been used too many times
            if ((formulaUsageCount[formulaKey] ?? 0) > 3 && attempts < 15) {
              attempts++;
              continue;
            }
            
            final avenger = RoadmapService.getChapterAvenger((chapterIndex + uniqueSeed + levelNum * 7) % 50);
            question = _generateQuestionFromFormula(
              formula,
              avenger,
              uniqueSeed,
              subject.name,
              levelNum,
            );
          } else if (questionType == 2 && practiceQuestions.isNotEmpty) {
            // Practice question based - ensure variety
            final practiceIndex = (uniqueSeed + levelNum * 4 + q * 7) % practiceQuestions.length;
            final practiceQ = practiceQuestions[practiceIndex];
            final avenger = RoadmapService.getChapterAvenger((chapterIndex + uniqueSeed + levelNum * 11) % 50);
            question = _generateQuestionFromPractice(
              practiceQ,
              avenger,
              uniqueSeed,
              subject.name,
              chapter.name,
              levelNum,
            );
          } else {
            // General and advanced questions - always unique
            final avenger = RoadmapService.getChapterAvenger((chapterIndex + uniqueSeed + levelNum * 13) % 50);
            question = _generateAdvancedQuestion(
              chapter,
              subject,
              avenger,
              uniqueSeed,
              levelNum,
              studyTips,
            );
          }
          
          // Check if question is unique by both ID and text
          if (question != null) {
            final questionTextHash = question.question.toLowerCase().trim();
            
            // Check if question text is duplicate
            if (usedQuestionTexts.contains(questionTextHash)) {
              question = null;
              attempts++;
              continue;
            }
            
            // Check if question ID is duplicate
            if (usedQuestionIds.contains(question.id)) {
              question = null;
              attempts++;
              continue;
            }
            
            // Question is unique - add to tracking sets
            usedQuestionIds.add(question.id);
            usedQuestionTexts.add(questionTextHash);
            break;
          }
          
          attempts++;
        }
        
        if (question != null) {
          levelQuestions.add(question);
          allQuestions.add(question);
          questionIndex++;
        } else {
          // If we couldn't generate a unique question, create a fallback unique question
          final avenger = RoadmapService.getChapterAvenger((chapterIndex + uniqueSeed) % 50);
          question = _generateAdvancedQuestion(
            chapter,
            subject,
            avenger,
            uniqueSeed + 99999,
            levelNum,
            studyTips,
          );
          if (question != null) {
            final questionTextHash = question.question.toLowerCase().trim();
            if (!usedQuestionTexts.contains(questionTextHash) && !usedQuestionIds.contains(question.id)) {
              usedQuestionIds.add(question.id);
              usedQuestionTexts.add(questionTextHash);
              levelQuestions.add(question);
              allQuestions.add(question);
              questionIndex++;
            }
          }
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
    final questionType = practiceQ['type'] as String? ?? 'Conceptual';
    final subjectName = subject.toLowerCase();
    
    // Generate CBSE board exam style questions with proper options
    String question;
    List<String> options;
    int correctAnswer;
    String explanation;
    
    final chapterDesc = _currentChapter?.description ?? '';
    
    // Use the CBSE question text directly and generate appropriate options
    if (questionText.isNotEmpty && questionText.length > 15) {
      question = questionText;
      
      // Generate CBSE-style options based on question type and subject
      if (questionType == 'FillInTheBlanks' || questionText.contains('______')) {
        options = _generateCBSEFillInTheBlanksOptions(questionText, subjectName, chapter, chapterDesc, index, levelNum);
        correctAnswer = 0; // First option is usually correct
        explanation = _generateCBSEExplanation(questionText, subjectName, chapter, chapterDesc);
      } else if (questionType == 'MCQ' || questionType == 'Numerical') {
        options = _generateCBSEMCQOptions(questionText, subjectName, chapter, chapterDesc, index, levelNum);
        correctAnswer = 0; // First option is usually correct for CBSE questions
        explanation = _generateCBSEExplanation(questionText, subjectName, chapter, chapterDesc);
      } else if (questionType == 'Conceptual') {
        options = _generateCBSEConceptualOptions(questionText, subjectName, chapter, chapterDesc, index, levelNum);
        correctAnswer = 0;
        explanation = _generateCBSEExplanation(questionText, subjectName, chapter, chapterDesc);
      } else {
        // Default options for other types
        options = _generateCBSEDefaultOptions(questionText, subjectName, chapter, chapterDesc, index, levelNum);
        correctAnswer = 0;
        explanation = _generateCBSEExplanation(questionText, subjectName, chapter, chapterDesc);
      }
    } else {
      // Fallback: Generate question from chapter description with variation
      final keywords = chapterDesc.split(',').where((k) => k.trim().isNotEmpty).take(3).toList();
      final questionVariations = [
        'What is an important aspect of $chapter as per CBSE syllabus?',
        'Which concept is crucial in $chapter (CBSE)?',
        'What key principle applies to $chapter in CBSE board exams?',
        'What fundamental idea is central to $chapter (CBSE)?',
      ];
      final variationIndex = (index + levelNum) % questionVariations.length;
      question = questionVariations[variationIndex];
      options = _generateCBSEDefaultOptions(question, subjectName, chapter, chapterDesc, index, levelNum);
      correctAnswer = 0;
      explanation = _generateCBSEExplanation(question, subjectName, chapter, chapterDesc);
    }
    
    // Create unique ID with timestamp and multiple factors
    final uniqueId = 'practice_${index}_${levelNum}_${question.hashCode}_${DateTime.now().millisecondsSinceEpoch % 100000}';
    
    return AvengerGameQuestion(
      id: uniqueId,
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
        question = 'Q. What is the SI unit of electric charge? (1 mark)';
        options = ['Coulomb (C)', 'Volt (V)', 'Ampere (A)', 'Ohm (Ω)'];
        correctAnswer = 0;
        explanation = 'Electric charge is measured in Coulombs (C). This is a fundamental unit in physics as per CBSE syllabus.';
      } else if (chapterName.contains('current') || chapterDesc.contains('ohm') || chapterDesc.contains('resistance') || chapterDesc.contains('kirchhoff') || chapterDesc.contains('wheatstone') || title.toLowerCase().contains('current')) {
        question = 'Q. According to Ohm\'s Law, what is the relationship between voltage (V), current (I), and resistance (R)? (1 mark)';
        options = ['V = IR', 'I = VR', 'R = VI', 'V = I/R'];
        correctAnswer = 0;
        explanation = 'Ohm\'s Law states: V = IR, where V is voltage, I is current, and R is resistance. This is a fundamental law in CBSE Class 12 Physics.';
      } else if (chapterName.contains('magnetic') || chapterDesc.contains('magnetic') || chapterDesc.contains('magnet') || chapterDesc.contains('biot-savart') || chapterDesc.contains('ampere') || title.toLowerCase().contains('magnetic')) {
        question = 'Q. What is the SI unit of magnetic field strength? (1 mark)';
        options = ['Tesla (T)', 'Gauss (G)', 'Weber (Wb)', 'Henry (H)'];
        correctAnswer = 0;
        explanation = 'Magnetic field is measured in Tesla (T) in SI units. This is an important unit in CBSE Class 12 Physics.';
      } else if (chapterName.contains('wave') || chapterDesc.contains('wave') || chapterDesc.contains('electromagnetic') || chapterDesc.contains('spectrum') || title.toLowerCase().contains('wave')) {
        question = 'Q. What is the speed of light in vacuum? (1 mark)';
        options = ['3 × 10⁸ m/s', '3 × 10⁶ m/s', '3 × 10¹⁰ m/s', '3 × 10⁴ m/s'];
        correctAnswer = 0;
        explanation = 'The speed of light in vacuum is approximately 3 × 10⁸ meters per second. This is a fundamental constant in physics.';
      } else if (chapterDesc.contains('potential') || chapterName.contains('potential') || chapterDesc.contains('capacitance') || chapterDesc.contains('capacitor')) {
        question = 'Q. Define electric potential. (2 marks)';
        options = [
          'Work done per unit charge',
          'Force per unit charge',
          'Charge per unit area',
          'Current per unit time'
        ];
        correctAnswer = 0;
        explanation = 'Electric potential is the work done per unit charge to bring a charge from infinity to a point. This is an important concept in CBSE Class 12 Physics.';
      } else if (chapterDesc.contains('induction') || chapterName.contains('induction') || chapterDesc.contains('faraday') || chapterDesc.contains('lenz')) {
        question = 'Q. State Faraday\'s law of electromagnetic induction. (2 marks)';
        options = [
          'EMF is induced when magnetic flux changes',
          'EMF is constant',
          'No EMF is induced',
          'EMF depends only on current'
        ];
        correctAnswer = 0;
        explanation = 'Faraday\'s law states that an electromotive force (EMF) is induced in a circuit when the magnetic flux through it changes. This is a fundamental law in CBSE Class 12 Physics.';
      } else {
        // Generate question from chapter description keywords with variation
        final keywords = chapterDesc.split(',').where((k) => k.trim().isNotEmpty).take(3).toList();
        final questionVariations = [
          'Q. What is a key concept in $chapter as per CBSE syllabus? (2 marks)',
          'Q. Which principle is fundamental in $chapter (CBSE)? (2 marks)',
          'Q. What important idea is central to $chapter in CBSE board exams? (2 marks)',
          'Q. What core concept defines $chapter (CBSE)? (2 marks)',
        ];
        final variationIndex = (index + levelNum) % questionVariations.length;
        question = questionVariations[variationIndex];
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
        question = 'Q. Find the derivative of f(x) = x² with respect to x. (2 marks)';
        options = ['2x', 'x', 'x²', '2x²'];
        correctAnswer = 0;
        explanation = 'Using the power rule: d/dx(xⁿ) = nxⁿ⁻¹, so d/dx(x²) = 2x. This is a fundamental rule in CBSE Class 12 Mathematics.';
      } else if (chapterName.contains('integral') || chapterDesc.contains('integral') || chapterDesc.contains('integration') || title.toLowerCase().contains('integral')) {
        question = 'Q. Evaluate ∫(2x) dx. (2 marks)';
        options = ['x² + C', '2x + C', 'x²', '2x'];
        correctAnswer = 0;
        explanation = 'The integral of 2x is x² + C, where C is the constant of integration. This is a basic integration problem in CBSE Class 12 Mathematics.';
      } else if (chapterName.contains('trigonometric') || chapterDesc.contains('trigonometric') || chapterDesc.contains('sin') || chapterDesc.contains('cos') || title.toLowerCase().contains('trigonometric')) {
        question = 'Q. What is the value of sin²θ + cos²θ? (1 mark)';
        options = ['1', '0', 'sin(2θ)', 'cos(2θ)'];
        correctAnswer = 0;
        explanation = 'This is a fundamental trigonometric identity: sin²θ + cos²θ = 1. This identity is frequently asked in CBSE board exams.';
      } else if (chapterName.contains('matrix') || chapterDesc.contains('matrix') || chapterDesc.contains('determinant') || title.toLowerCase().contains('matrix')) {
        question = 'Q. What is the determinant of a 2×2 matrix [[a,b],[c,d]]? (2 marks)';
        options = ['ad - bc', 'ab - cd', 'a + d', 'b + c'];
        correctAnswer = 0;
        explanation = 'For a 2×2 matrix, the determinant is calculated as ad - bc. This is a standard formula in CBSE Class 12 Mathematics.';
      } else if (chapterDesc.contains('function') || chapterName.contains('function') || chapterDesc.contains('relation')) {
        question = 'Q. Define a function. (2 marks)';
        options = [
          'A relation where each input has exactly one output',
          'A relation with multiple outputs',
          'Any relation',
          'A set of numbers'
        ];
        correctAnswer = 0;
        explanation = 'A function is a relation where each input (domain) has exactly one output (range). This is a fundamental concept in CBSE Class 12 Mathematics.';
      } else {
        // Generate question from chapter description keywords with variation
        final keywords = chapterDesc.split(',').where((k) => k.trim().isNotEmpty).take(3).toList();
        final questionVariations = [
          'Q. What is a key concept in $chapter as per CBSE syllabus? (2 marks)',
          'Q. Which principle is fundamental in $chapter (CBSE)? (2 marks)',
          'Q. What important idea is central to $chapter in CBSE board exams? (2 marks)',
          'Q. What core concept defines $chapter (CBSE)? (2 marks)',
        ];
        final variationIndex = (index + levelNum) % questionVariations.length;
        question = questionVariations[variationIndex];
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
        question = 'Q. What happens in a chemical reaction? (2 marks)';
        options = [
          'Atoms rearrange to form new substances',
          'Atoms are destroyed',
          'Energy is created',
          'Mass is lost'
        ];
        correctAnswer = 0;
        explanation = 'In a chemical reaction, atoms rearrange to form new substances. Atoms are neither created nor destroyed (Law of Conservation of Mass). This is a fundamental principle in CBSE Chemistry.';
      } else if (chapterName.contains('solution') || chapterDesc.contains('solution') || chapterDesc.contains('solute') || chapterDesc.contains('solvent') || title.toLowerCase().contains('solution')) {
        question = 'Q. Define a solution. (2 marks)';
        options = [
          'A homogeneous mixture of two or more substances',
          'A heterogeneous mixture',
          'A pure substance',
          'A compound'
        ];
        correctAnswer = 0;
        explanation = 'A solution is a homogeneous mixture where one substance (solute) is dissolved in another (solvent). This is an important concept in CBSE Chemistry.';
      } else if (chapterName.contains('equilibrium') || chapterDesc.contains('equilibrium') || chapterDesc.contains('reversible') || title.toLowerCase().contains('equilibrium')) {
        question = 'Q. Define chemical equilibrium. (2 marks)';
        options = [
          'State where forward and reverse reaction rates are equal',
          'State where no reaction occurs',
          'State where only forward reaction occurs',
          'State where only reverse reaction occurs'
        ];
        correctAnswer = 0;
        explanation = 'Chemical equilibrium is a dynamic state where the rates of forward and reverse reactions are equal. This is a key concept in CBSE Class 12 Chemistry.';
      } else if (chapterDesc.contains('solid') || chapterName.contains('solid') || chapterDesc.contains('crystal')) {
        question = 'Q. What is a crystal lattice? (2 marks)';
        options = [
          'Regular arrangement of atoms or molecules',
          'Random arrangement',
          'Liquid structure',
          'Gas structure'
        ];
        correctAnswer = 0;
        explanation = 'A crystal lattice is a regular, repeating arrangement of atoms, ions, or molecules in a solid. This is an important concept in CBSE Class 12 Chemistry.';
      } else {
        // Generate question from chapter description keywords with variation
        final keywords = chapterDesc.split(',').where((k) => k.trim().isNotEmpty).take(3).toList();
        final questionVariations = [
          'Q. What is a key concept in $chapter as per CBSE syllabus? (2 marks)',
          'Q. Which principle is fundamental in $chapter (CBSE)? (2 marks)',
          'Q. What important idea is central to $chapter in CBSE board exams? (2 marks)',
          'Q. What core concept defines $chapter (CBSE)? (2 marks)',
        ];
        final variationIndex = (index + levelNum) % questionVariations.length;
        question = questionVariations[variationIndex];
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
        question = 'Q. What is the main difference between asexual and sexual reproduction? (2 marks)';
        options = [
          'Sexual reproduction involves fusion of gametes',
          'Asexual reproduction involves fusion of gametes',
          'Both are identical',
          'Neither involves cell division'
        ];
        correctAnswer = 0;
        explanation = 'Sexual reproduction involves the fusion of male and female gametes, while asexual reproduction does not. This is an important concept in CBSE Biology.';
      } else if (chapterName.contains('genetics') || chapterDesc.contains('genetics') || chapterDesc.contains('gene') || chapterDesc.contains('heredity') || chapterDesc.contains('dna') || title.toLowerCase().contains('genetics')) {
        question = 'Q. Define a gene. (2 marks)';
        options = [
          'A unit of heredity that codes for a protein',
          'A type of cell',
          'A type of tissue',
          'A type of organ'
        ];
        correctAnswer = 0;
        explanation = 'A gene is a unit of heredity that contains the information to code for a specific protein. This is a fundamental concept in CBSE Biology.';
      } else if (chapterName.contains('ecosystem') || chapterDesc.contains('ecosystem') || chapterDesc.contains('biodiversity') || chapterDesc.contains('environment') || chapterDesc.contains('conservation') || title.toLowerCase().contains('ecosystem')) {
        question = 'Q. Define an ecosystem. (2 marks)';
        options = [
          'A community of living organisms and their environment',
          'Only living organisms',
          'Only non-living environment',
          'A single species'
        ];
        correctAnswer = 0;
        explanation = 'An ecosystem includes all living organisms (biotic) and their physical environment (abiotic) interacting as a system. This is an important concept in CBSE Biology.';
      } else if (chapterDesc.contains('cell') || chapterName.contains('cell') || chapterDesc.contains('mitosis') || chapterDesc.contains('meiosis')) {
        question = 'Q. What is the basic structural and functional unit of life? (1 mark)';
        options = [
          'Cell',
          'Tissue',
          'Organ',
          'Organism'
        ];
        correctAnswer = 0;
        explanation = 'The cell is the basic structural and functional unit of all living organisms. This is a fundamental concept in CBSE Biology.';
      } else {
        // Generate question from chapter description keywords with variation
        final keywords = chapterDesc.split(',').where((k) => k.trim().isNotEmpty).take(3).toList();
        final questionVariations = [
          'Q. What is a key concept in $chapter as per CBSE syllabus? (2 marks)',
          'Q. Which principle is fundamental in $chapter (CBSE)? (2 marks)',
          'Q. What important idea is central to $chapter in CBSE board exams? (2 marks)',
          'Q. What core concept defines $chapter (CBSE)? (2 marks)',
        ];
        final variationIndex = (index + levelNum) % questionVariations.length;
        question = questionVariations[variationIndex];
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
    // Default for any other subject with variation
    else {
      final questionVariations = [
        'Q. What is the main concept of $title in $chapter as per CBSE syllabus? (2 marks)',
        'Q. Which principle does $title represent in $chapter (CBSE)? (2 marks)',
        'Q. What important idea does $title convey in $chapter in CBSE board exams? (2 marks)',
        'Q. What core concept is $title in $chapter (CBSE)? (2 marks)',
      ];
      final variationIndex = (index + levelNum) % questionVariations.length;
      question = questionVariations[variationIndex];
      options = [
        description.isNotEmpty ? description.substring(0, description.length > 50 ? 50 : description.length) : 'Key principle of $chapter',
        'Secondary concept',
        'Advanced topic',
        'Basic definition'
      ];
      correctAnswer = 0;
      explanation = description.isNotEmpty ? description : 'This is an important concept in $chapter.';
    }

    // Create unique ID with timestamp and multiple factors
    final uniqueId = 'concept_${index}_${levelNum}_${title.hashCode}_${question.hashCode}_${DateTime.now().millisecondsSinceEpoch % 100000}';
    
    return AvengerGameQuestion(
      id: uniqueId,
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
        question = 'Q. According to Ohm\'s Law, if a voltage of 12V is applied across a resistor of 4Ω, calculate the current flowing through it. (2 marks)';
        options = ['3A', '48A', '8A', '16A'];
        correctAnswer = 0;
        explanation = 'Using V = IR: I = V/R = 12/4 = 3A. This is a typical numerical problem in CBSE Class 12 Physics.';
      } else if (formulaText.contains('F = k') || formulaText.contains('Coulomb')) {
        question = 'Q. State Coulomb\'s Law. What does the formula F = k(q₁q₂)/r² describe? (2 marks)';
        options = [
          'Force between two charges',
          'Electric field strength',
          'Potential difference',
          'Current flow'
        ];
        correctAnswer = 0;
        explanation = 'Coulomb\'s Law (F = k(q₁q₂)/r²) describes the force between two point charges. This is a fundamental law in CBSE Class 12 Physics.';
      } else if (formulaText.contains('E = mc²') || formulaText.contains('E=mc')) {
        question = 'Q. What does the equation E = mc² represent? (2 marks)';
        options = [
          'Mass-energy equivalence',
          'Kinetic energy',
          'Potential energy',
          'Mechanical energy'
        ];
        correctAnswer = 0;
        explanation = 'E = mc² represents mass-energy equivalence, where E is energy, m is mass, and c is speed of light. This is Einstein\'s famous equation in physics.';
      } else {
        // Generate meaningful question from chapter and formula
        final chapterDesc = _currentChapter?.description ?? '';
        final chapterName = _currentChapter?.name ?? '';
        final keywords = chapterDesc.split(',').where((k) => k.trim().isNotEmpty).take(2).toList();
        
        if (formulaText.isNotEmpty && formulaText.length > 3) {
          question = 'Q. What does the formula $formulaText represent in $chapterName? (2 marks)';
          options = [
            description.isNotEmpty ? description.substring(0, description.length > 60 ? 60 : description.length) : (keywords.isNotEmpty ? keywords[0].trim() : 'Physics principle'),
            keywords.length > 1 ? keywords[1].trim() : 'Electric field',
            'Chemical reaction',
            'Mathematical theorem'
          ];
        } else {
          question = 'Q. What is an important physics formula in $chapterName as per CBSE syllabus? (2 marks)';
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
        question = 'Q. What does the derivative of a function represent? (2 marks)';
        options = [
          'Rate of change',
          'Total value',
          'Average value',
          'Maximum value'
        ];
        correctAnswer = 0;
        explanation = 'The derivative represents the rate of change of a function with respect to its variable. This is a fundamental concept in CBSE Class 12 Mathematics.';
      } else if (formulaText.contains('∫') || formulaText.contains('integral')) {
        question = 'Q. What does an integral represent? (2 marks)';
        options = [
          'Area under a curve',
          'Slope of a curve',
          'Maximum value',
          'Minimum value'
        ];
        correctAnswer = 0;
        explanation = 'An integral represents the area under a curve or the accumulation of quantities. This is an important concept in CBSE Class 12 Mathematics.';
      } else if (formulaText.contains('sin') || formulaText.contains('cos') || formulaText.contains('tan')) {
        question = 'Q. What is the value of sin²θ + cos²θ? (1 mark)';
        options = ['1', '0', 'sin(2θ)', 'cos(2θ)'];
        correctAnswer = 0;
        explanation = 'This is a fundamental trigonometric identity: sin²θ + cos²θ = 1. This identity is frequently asked in CBSE board exams.';
      } else {
        // Generate meaningful question from chapter and formula
        final chapterDesc = _currentChapter?.description ?? '';
        final chapterName = _currentChapter?.name ?? '';
        final keywords = chapterDesc.split(',').where((k) => k.trim().isNotEmpty).take(2).toList();
        
        if (formulaText.isNotEmpty && formulaText.length > 3) {
          question = 'Q. What does the formula $formulaText represent in $chapterName? (2 marks)';
          options = [
            description.isNotEmpty ? description.substring(0, description.length > 60 ? 60 : description.length) : (keywords.isNotEmpty ? keywords[0].trim() : 'Mathematical principle'),
            keywords.length > 1 ? keywords[1].trim() : 'Algebraic expression',
            'Physics formula',
            'Chemistry equation'
          ];
        } else {
          question = 'Q. What is an important mathematics formula in $chapterName as per CBSE syllabus? (2 marks)';
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
        question = 'Q. What does the equation PV = nRT represent? (2 marks)';
        options = [
          'Ideal gas law',
          'Boyle\'s law',
          'Charles\' law',
          'Avogadro\'s law'
        ];
        correctAnswer = 0;
        explanation = 'PV = nRT is the ideal gas law, where P is pressure, V is volume, n is moles, R is gas constant, and T is temperature. This is a fundamental law in CBSE Class 12 Chemistry.';
      } else if (formulaText.contains('pH') || formulaText.contains('pOH')) {
        question = 'Q. Define pH. What does it represent? (2 marks)';
        options = [
          'Negative logarithm of H⁺ concentration',
          'Positive logarithm of H⁺ concentration',
          'Concentration of OH⁻',
          'Total ion concentration'
        ];
        correctAnswer = 0;
        explanation = 'pH = -log[H⁺], representing the acidity or basicity of a solution. This is an important concept in CBSE Class 12 Chemistry.';
      } else {
        // Generate meaningful question from chapter and formula
        final chapterDesc = _currentChapter?.description ?? '';
        final chapterName = _currentChapter?.name ?? '';
        final keywords = chapterDesc.split(',').where((k) => k.trim().isNotEmpty).take(2).toList();
        
        if (formulaText.isNotEmpty && formulaText.length > 3) {
          question = 'Q. What does the formula $formulaText represent in $chapterName? (2 marks)';
          options = [
            description.isNotEmpty ? description.substring(0, description.length > 60 ? 60 : description.length) : (keywords.isNotEmpty ? keywords[0].trim() : 'Chemistry principle'),
            keywords.length > 1 ? keywords[1].trim() : 'Chemical reaction',
            'Physics formula',
            'Mathematical equation'
          ];
        } else {
          question = 'Q. What is an important chemistry formula in $chapterName as per CBSE syllabus? (2 marks)';
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
        question = 'Q. What is the basic structural and functional unit of all living organisms? (1 mark)';
        options = ['Cell', 'Tissue', 'Organ', 'Organ system'];
        correctAnswer = 0;
        explanation = 'The cell is the basic structural and functional unit of all living organisms. This is a fundamental concept in CBSE Biology.';
      } else if (chapterDesc.contains('dna') || chapterDesc.contains('genetic') || chapterName.toLowerCase().contains('genetic')) {
        question = 'Q. What does DNA stand for? (1 mark)';
        options = [
          'Deoxyribonucleic Acid',
          'Ribonucleic Acid',
          'Deoxyribose Nucleic Acid',
          'Double Nucleic Acid'
        ];
        correctAnswer = 0;
        explanation = 'DNA stands for Deoxyribonucleic Acid, which carries genetic information. This is an important term in CBSE Biology.';
      } else if (chapterDesc.contains('photosynthesis') || chapterName.toLowerCase().contains('photosynthesis')) {
        question = 'Q. What is the primary product of photosynthesis? (1 mark)';
        options = ['Glucose', 'Oxygen', 'Carbon dioxide', 'Water'];
        correctAnswer = 0;
        explanation = 'Photosynthesis produces glucose (C₆H₁₂O₆) as the primary product, along with oxygen. This is a key concept in CBSE Biology.';
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
        question = 'Q. What are the two main components of an ecosystem? (2 marks)';
        options = [
          'Biotic and abiotic factors',
          'Plants and animals',
          'Land and water',
          'Producers and consumers'
        ];
        correctAnswer = 0;
        explanation = 'An ecosystem consists of biotic (living) and abiotic (non-living) components that interact. This is a fundamental concept in CBSE Biology.';
      } else {
        // Generate meaningful question from chapter description
        final keywords = chapterDesc.split(',').where((k) => k.trim().isNotEmpty).take(2).toList();
        if (keywords.isNotEmpty) {
          question = 'Q. Which of these is a key concept in ${chapterName} as per CBSE Biology? (2 marks)';
          options = [
            keywords[0].trim(),
            keywords.length > 1 ? keywords[1].trim() : 'Secondary biological process',
            'Unrelated biology concept',
            'Physics principle'
          ];
          correctAnswer = 0;
          explanation = description.isNotEmpty ? description : 'This is an important concept in ${chapterName} as per CBSE syllabus.';
        } else {
          question = 'Q. What is a fundamental principle in ${chapterName} (CBSE Biology)? (2 marks)';
          options = [
            description.isNotEmpty ? description.substring(0, description.length > 60 ? 60 : description.length) : 'Core biological process',
            'Chemical reaction',
            'Physical law',
            'Mathematical formula'
          ];
          correctAnswer = 0;
          explanation = description.isNotEmpty ? description : 'This chapter covers important biological concepts in CBSE syllabus.';
        }
      }
    }
    // Default - generate from chapter description
    else {
      final chapterDesc = _currentChapter?.description ?? '';
      final chapterName = _currentChapter?.name ?? '';
      final keywords = chapterDesc.split(',').where((k) => k.trim().isNotEmpty).take(2).toList();
      
      if (formulaText.isNotEmpty && formulaText.length > 3) {
        question = 'Q. What does the formula $formulaText represent in $chapterName? (2 marks)';
        options = [
          description.isNotEmpty ? description.substring(0, description.length > 60 ? 60 : description.length) : (keywords.isNotEmpty ? keywords[0].trim() : 'Core concept'),
          keywords.length > 1 ? keywords[1].trim() : 'Related principle',
          'Unrelated formula',
          'Basic definition'
        ];
      } else {
        question = 'Q. What is an important formula or concept in $chapterName as per CBSE syllabus? (2 marks)';
        options = [
          keywords.isNotEmpty ? keywords[0].trim() : (description.isNotEmpty ? description.substring(0, description.length > 60 ? 60 : description.length) : 'Key principle'),
          keywords.length > 1 ? keywords[1].trim() : 'Secondary concept',
          'Unrelated topic',
          'Basic definition'
        ];
      }
      correctAnswer = 0;
      explanation = description.isNotEmpty ? description : (chapterDesc.isNotEmpty ? chapterDesc : 'This is an important concept in $chapterName as per CBSE syllabus.');
    }

    // Create unique ID with timestamp and multiple factors
    final uniqueId = 'formula_${index}_${levelNum}_${formulaText.hashCode}_${question.hashCode}_${DateTime.now().millisecondsSinceEpoch % 100000}';
    
    return AvengerGameQuestion(
      id: uniqueId,
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
        question = 'Q. What is the main topic covered in ${chapter.name} as per CBSE Class 12 Mathematics? (2 marks)';
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
            : 'This chapter covers fundamental mathematical concepts as per CBSE syllabus.';
      } else if (subjectName == 'chemistry') {
        question = 'Q. What is the main topic covered in ${chapter.name} as per CBSE Class 12 Chemistry? (2 marks)';
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
            : 'This chapter covers fundamental chemistry concepts as per CBSE syllabus.';
      } else if (subjectName == 'biology') {
        question = 'Q. What is the main topic covered in ${chapter.name} as per CBSE Class 12 Biology? (2 marks)';
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
            : 'This chapter covers fundamental biology concepts as per CBSE syllabus.';
      } else {
        question = 'Q. What is the main topic of ${chapter.name} as per CBSE syllabus? (2 marks)';
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
            : 'This chapter covers fundamental concepts as per CBSE syllabus.';
      }
    } else if (levelNum <= 30) {
      // Intermediate level - importance and applications
      question = 'Q. Why is ${chapter.name} important in ${subject.name} as per CBSE syllabus? (3 marks)';
      options = [
        'It forms the foundation for advanced topics in ${subject.name}',
        'It is optional in ${subject.name}',
        'It is only for exams',
        'It has no practical use'
      ];
      correctAnswer = 0;
      explanation = 'This chapter is important because it builds the foundation for understanding more advanced concepts in ${subject.name}. This is a key chapter in CBSE board exams.';
    } else if (levelNum <= 40) {
      // Advanced level - study approach
      question = 'Q. Which study approach is most effective for ${chapter.name} in ${subject.name} (CBSE)? (3 marks)';
      options = [
        'Understanding concepts first, then practicing ${subject.name.toLowerCase()} problems',
        'Memorizing everything without understanding',
        'Only reading notes',
        'Skipping difficult parts'
      ];
      correctAnswer = 0;
      explanation = 'Understanding concepts first helps build a strong foundation in ${subject.name}, then practice reinforces learning. This approach is recommended for CBSE board exam preparation.';
    } else {
      // Expert level - mastery
      question = 'Q. What is the best way to master ${chapter.name} in ${subject.name} for CBSE board exams? (3 marks)';
      options = [
        'Regular practice, revision, and solving ${subject.name.toLowerCase()}-related problems',
        'Reading once',
        'Only memorizing formulas',
        'Avoiding practice questions'
      ];
      correctAnswer = 0;
      explanation = 'Mastery of ${chapter.name} comes from regular practice, consistent revision, and solving various types of ${subject.name.toLowerCase()} problems. This is the recommended approach for CBSE board exam success.';
    }

    // Create unique ID with timestamp and multiple factors
    final uniqueId = 'advanced_${index}_${levelNum}_${chapter.name.hashCode}_${question.hashCode}_${DateTime.now().millisecondsSinceEpoch % 100000}';
    
    return AvengerGameQuestion(
      id: uniqueId,
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
  
  // Helper methods for generating CBSE-style options
  static List<String> _generateCBSEMCQOptions(String question, String subject, String chapter, String chapterDesc, int index, int levelNum) {
    final subjectLower = subject.toLowerCase();
    final questionLower = question.toLowerCase();
    
    // Physics MCQ options
    if (subjectLower.contains('physics')) {
      if (questionLower.contains('unit') || questionLower.contains('si unit')) {
        if (questionLower.contains('charge')) {
          return ['Coulomb (C)', 'Volt (V)', 'Ampere (A)', 'Ohm (Ω)'];
        } else if (questionLower.contains('current')) {
          return ['Ampere (A)', 'Volt (V)', 'Coulomb (C)', 'Watt (W)'];
        } else if (questionLower.contains('resistance')) {
          return ['Ohm (Ω)', 'Volt (V)', 'Ampere (A)', 'Joule (J)'];
        } else if (questionLower.contains('electric field')) {
          return ['N/C or V/m', 'J/C', 'C/N', 'V·m'];
        } else if (questionLower.contains('magnetic field')) {
          return ['Tesla (T)', 'Weber (Wb)', 'Gauss (G)', 'Henry (H)'];
        }
      } else if (questionLower.contains('force') || questionLower.contains('calculate')) {
        // Numerical questions - generate calculation-based options
        final seed = (index + levelNum) % 4;
        if (seed == 0) {
          return ['13.5 N', '15.2 N', '18.7 N', '20.1 N'];
        } else if (seed == 1) {
          return ['2.5 × 10⁻³ N', '3.2 × 10⁻³ N', '4.1 × 10⁻³ N', '5.0 × 10⁻³ N'];
        } else {
          return ['1.35 N', '2.15 N', '3.25 N', '4.50 N'];
        }
      }
    }
    // Chemistry MCQ options
    else if (subjectLower.contains('chemistry')) {
      if (questionLower.contains('ph') || questionLower.contains('calculate')) {
        final seed = (index + levelNum) % 4;
        if (seed == 0) {
          return ['pH = 3', 'pH = 4', 'pH = 5', 'pH = 6'];
        } else {
          return ['pH = 11', 'pH = 10', 'pH = 9', 'pH = 8'];
        }
      } else if (questionLower.contains('reaction') || questionLower.contains('balance') || questionLower.contains('equation')) {
        // Generate actual balanced chemical equations based on chapter
        if (questionLower.contains('solution') || chapter.toLowerCase().contains('solution')) {
          // Solutions chapter - show actual balanced equations related to solutions
          final seed = (index + levelNum) % 4;
          if (seed == 0) {
            return [
              'NaCl(s) + H₂O(l) → Na⁺(aq) + Cl⁻(aq)',
              'NaCl(s) → Na(s) + Cl₂(g)',
              'NaCl(aq) + H₂O(l) → NaOH(aq) + HCl(aq)',
              'NaCl(s) + H₂O(l) → Na₂O(aq) + Cl₂(g)'
            ];
          } else if (seed == 1) {
            return [
              'CuSO₄(s) + 5H₂O(l) → CuSO₄·5H₂O(aq)',
              'CuSO₄(s) → Cu(s) + SO₄²⁻(aq)',
              'CuSO₄(s) + H₂O(l) → CuO(aq) + H₂SO₄(aq)',
              'CuSO₄(s) → Cu²⁺(aq) + SO₄²⁻(aq)'
            ];
          } else if (seed == 2) {
            return [
              'NaOH(s) + H₂O(l) → Na⁺(aq) + OH⁻(aq)',
              'NaOH(s) → Na(s) + OH⁻(aq)',
              'NaOH(aq) + H₂O(l) → Na₂O(aq) + H₂(g)',
              'NaOH(s) + H₂O(l) → NaH(aq) + O₂(g)'
            ];
          } else {
            return [
              'CaCl₂(s) + H₂O(l) → Ca²⁺(aq) + 2Cl⁻(aq)',
              'CaCl₂(s) → Ca(s) + Cl₂(g)',
              'CaCl₂(aq) + H₂O(l) → CaO(aq) + 2HCl(aq)',
              'CaCl₂(s) → Ca²⁺(aq) + Cl⁻(aq)'
            ];
          }
        } else if (questionLower.contains('acid') || chapter.toLowerCase().contains('acid')) {
          return [
            'HCl(aq) + NaOH(aq) → NaCl(aq) + H₂O(l)',
            'HCl(aq) + NaOH(aq) → NaCl(aq) + H₂(g)',
            'HCl(aq) + NaOH(aq) → NaCl(aq) + O₂(g)',
            'HCl(aq) + NaOH(aq) → Na₂Cl(aq) + H₂O(l)'
          ];
        } else if (questionLower.contains('redox') || chapter.toLowerCase().contains('redox')) {
          return [
            'Zn(s) + 2H⁺(aq) → Zn²⁺(aq) + H₂(g)',
            'Zn(s) + H⁺(aq) → Zn²⁺(aq) + H₂(g)',
            'Zn(s) + 2H⁺(aq) → Zn⁺(aq) + H₂(g)',
            'Zn(s) + H⁺(aq) → Zn²⁺(aq) + H(g)'
          ];
        } else {
          // Generic balanced equations
          final seed = (index + levelNum) % 3;
          if (seed == 0) {
            return [
              '2H₂(g) + O₂(g) → 2H₂O(l)',
              'H₂(g) + O₂(g) → H₂O(l)',
              '2H₂(g) + O₂(g) → H₂O₂(l)',
              'H₂(g) + 2O₂(g) → 2H₂O(l)'
            ];
          } else if (seed == 1) {
            return [
              'CaCO₃(s) → CaO(s) + CO₂(g)',
              'CaCO₃(s) → Ca(s) + CO₂(g)',
              '2CaCO₃(s) → CaO(s) + CO₂(g)',
              'CaCO₃(s) → CaO(s) + 2CO₂(g)'
            ];
          } else {
            return [
              'CH₄(g) + 2O₂(g) → CO₂(g) + 2H₂O(l)',
              'CH₄(g) + O₂(g) → CO₂(g) + H₂O(l)',
              'CH₄(g) + 2O₂(g) → CO(g) + 2H₂O(l)',
              '2CH₄(g) + O₂(g) → CO₂(g) + 2H₂O(l)'
            ];
          }
        }
      } else if (questionLower.contains('acid') || questionLower.contains('base')) {
        if (questionLower.contains('define') || questionLower.contains('what is')) {
          return [
            'Acid: H⁺ donor; Base: OH⁻ donor (Arrhenius)',
            'Acid: electron acceptor; Base: electron donor',
            'Acid: H⁺ acceptor; Base: H⁺ donor',
            'Acid: OH⁻ donor; Base: H⁺ donor'
          ];
        } else {
          return [
            'pH < 7 (acidic), pH > 7 (basic)',
            'pH > 7 (acidic), pH < 7 (basic)',
            'pH = 7 (acidic), pH = 7 (basic)',
            'pH < 0 (acidic), pH > 14 (basic)'
          ];
        }
      }
    }
    // Biology MCQ options
    else if (subjectLower.contains('biology')) {
      if (questionLower.contains('cell')) {
        return [
          'Basic structural and functional unit of life',
          'Only structural unit',
          'Only functional unit',
          'Largest unit of life'
        ];
      } else if (questionLower.contains('dna')) {
        return [
          'Deoxyribonucleic Acid',
          'Ribonucleic Acid',
          'Protein molecule',
          'Lipid molecule'
        ];
      } else if (questionLower.contains('reproduction')) {
        return [
          'Process of producing offspring',
          'Process of growth',
          'Process of metabolism',
          'Process of respiration'
        ];
      }
    }
    // Mathematics MCQ options
    else if (subjectLower.contains('mathematics') || subjectLower.contains('math')) {
      if (questionLower.contains('derivative') || questionLower.contains('differentiate')) {
        final seed = (index + levelNum) % 4;
        if (seed == 0) {
          return ['3x² + 4x - 5', '3x² + 4x', 'x² + 2x', '6x + 4'];
        } else if (seed == 1) {
          return ['2x·cos(x² + 3x)', 'cos(x² + 3x)', '2x·sin(x² + 3x)', 'sin(x² + 3x)'];
        } else {
          return ['eˣ·ln(x) + eˣ/x', 'eˣ·ln(x)', 'eˣ/x', 'ln(x)'];
        }
      } else if (questionLower.contains('integral') || questionLower.contains('evaluate')) {
        final seed = (index + levelNum) % 4;
        if (seed == 0) {
          return ['x³ + x² - x + C', 'x³ + x² + C', '3x² + 2x + C', 'x² + x + C'];
        } else {
          return ['-cos x + sin x + C', 'cos x + sin x + C', '-cos x - sin x + C', 'sin x - cos x + C'];
        }
      } else if (questionLower.contains('trigonometric') || questionLower.contains('sin') || questionLower.contains('cos')) {
        return ['1', '0', 'sin(2θ)', 'cos(2θ)'];
      }
    }
    
    // Default CBSE options
    return _generateCBSEDefaultOptions(question, subject, chapter, chapterDesc, index, levelNum);
  }
  
  static List<String> _generateCBSEConceptualOptions(String question, String subject, String chapter, String chapterDesc, int index, int levelNum) {
    final questionLower = question.toLowerCase();
    final subjectLower = subject.toLowerCase();
    final chapterLower = chapter.toLowerCase();
    
    // Chemistry conceptual questions - generate realistic options
    if (subjectLower.contains('chemistry')) {
      if (questionLower.contains('solution') || chapterLower.contains('solution')) {
        return [
          'Homogeneous mixture of solute and solvent',
          'Heterogeneous mixture of two liquids',
          'Pure compound',
          'Mixture of gases only'
        ];
      } else if (questionLower.contains('acid') || questionLower.contains('base')) {
        return [
          'Acid: pH < 7, turns blue litmus red; Base: pH > 7, turns red litmus blue',
          'Acid: pH > 7, turns red litmus blue; Base: pH < 7, turns blue litmus red',
          'Acid: pH = 7, no color change; Base: pH = 7, no color change',
          'Acid: pH > 14; Base: pH < 0'
        ];
      } else if (questionLower.contains('reaction') || questionLower.contains('chemical')) {
        return [
          'Rearrangement of atoms to form new substances',
          'Destruction of atoms',
          'Creation of new atoms',
          'No change in molecular structure'
        ];
      } else if (questionLower.contains('equilibrium')) {
        return [
          'Dynamic state where forward and reverse reaction rates are equal',
          'Static state where no reaction occurs',
          'State where only forward reaction occurs',
          'State where only reverse reaction occurs'
        ];
      }
    }
    
    // Physics conceptual questions
    if (subjectLower.contains('physics')) {
      if (questionLower.contains('electric') || questionLower.contains('charge')) {
        return [
          'Coulomb (C) - fundamental unit of charge',
          'Volt (V) - unit of potential difference',
          'Ampere (A) - unit of current',
          'Ohm (Ω) - unit of resistance'
        ];
      } else if (questionLower.contains('current') || questionLower.contains('ohm')) {
        return [
          'V = IR (Ohm\'s Law)',
          'I = VR',
          'R = VI',
          'V = I/R'
        ];
      } else if (questionLower.contains('magnetic')) {
        return [
          'Tesla (T) - SI unit of magnetic field',
          'Weber (Wb) - unit of magnetic flux',
          'Gauss (G) - CGS unit',
          'Henry (H) - unit of inductance'
        ];
      }
    }
    
    // Biology conceptual questions
    if (subjectLower.contains('biology')) {
      if (questionLower.contains('cell')) {
        return [
          'Basic structural and functional unit of all living organisms',
          'Largest unit of life',
          'Only found in plants',
          'Only found in animals'
        ];
      } else if (questionLower.contains('dna') || questionLower.contains('genetic')) {
        return [
          'Deoxyribonucleic Acid - carries genetic information',
          'Ribonucleic Acid - protein synthesis',
          'Protein molecule - structural component',
          'Lipid molecule - energy storage'
        ];
      } else if (questionLower.contains('photosynthesis')) {
        return [
          'Process by which plants convert CO₂ and H₂O into glucose using sunlight',
          'Process of breaking down glucose',
          'Process of protein synthesis',
          'Process of cell division'
        ];
      }
    }
    
    // Mathematics conceptual questions
    if (subjectLower.contains('mathematics') || subjectLower.contains('math')) {
      if (questionLower.contains('derivative') || questionLower.contains('differentiate')) {
        return [
          'Rate of change of function with respect to variable',
          'Total value of function',
          'Average value of function',
          'Maximum value of function'
        ];
      } else if (questionLower.contains('integral')) {
        return [
          'Area under the curve or accumulation of quantities',
          'Slope of the curve',
          'Maximum value',
          'Minimum value'
        ];
      } else if (questionLower.contains('trigonometric') || questionLower.contains('sin') || questionLower.contains('cos')) {
        return [
          'sin²θ + cos²θ = 1 (fundamental identity)',
          'sin²θ + cos²θ = 0',
          'sin²θ + cos²θ = sin(2θ)',
          'sin²θ + cos²θ = cos(2θ)'
        ];
      }
    }
    
    // Fallback to keywords if available
    final keywords = chapterDesc.split(',').where((k) => k.trim().isNotEmpty).take(4).toList();
    if (keywords.length >= 3) {
      return [
        keywords[0].trim(),
        keywords.length > 1 ? keywords[1].trim() : 'Related concept',
        keywords.length > 2 ? keywords[2].trim() : 'Secondary principle',
        keywords.length > 3 ? keywords[3].trim() : 'Unrelated concept'
      ];
    }
    
    // Final fallback
    return [
      'Correct answer as per CBSE syllabus',
      'Incorrect option 1',
      'Incorrect option 2',
      'Incorrect option 3'
    ];
  }
  
  static List<String> _generateCBSEDefaultOptions(String question, String subject, String chapter, String chapterDesc, int index, int levelNum) {
    final keywords = chapterDesc.split(',').where((k) => k.trim().isNotEmpty).take(4).toList();
    
    if (keywords.length >= 2) {
      return [
        keywords[0].trim(),
        keywords.length > 1 ? keywords[1].trim() : 'Option 2',
        keywords.length > 2 ? keywords[2].trim() : 'Option 3',
        keywords.length > 3 ? keywords[3].trim() : 'Option 4'
      ];
    }
    
    return [
      'Correct answer (CBSE board exam style)',
      'Incorrect option',
      'Partially correct option',
      'Completely incorrect option'
    ];
  }
  
  static String _generateCBSEExplanation(String question, String subject, String chapter, String chapterDesc) {
    final questionLower = question.toLowerCase();
    final subjectLower = subject.toLowerCase();
    
    // Generate CBSE-style explanations
    if (questionLower.contains('unit') || questionLower.contains('si unit')) {
      return 'This is a fundamental unit in $subject as per CBSE syllabus. Understanding units is crucial for solving numerical problems in board exams.';
    } else if (questionLower.contains('calculate') || questionLower.contains('find') || questionLower.contains('evaluate')) {
      return 'This numerical problem is typical of CBSE board exams. Practice similar problems to master $chapter concepts.';
    } else if (questionLower.contains('state') || questionLower.contains('define') || questionLower.contains('explain')) {
      return 'This conceptual question tests your understanding of $chapter as per CBSE curriculum. Make sure to study NCERT textbook thoroughly.';
    } else if (questionLower.contains('differentiate') || questionLower.contains('compare')) {
      return 'This analytical question is important for CBSE board exams. Understanding differences helps in answering long answer questions.';
    } else if (questionLower.contains('derive') || questionLower.contains('prove')) {
      return 'Derivations are crucial for CBSE board exams. Practice writing step-by-step derivations as shown in NCERT textbook.';
    } else if (questionLower.contains('______') || questionLower.contains('fill')) {
      return 'This fill-in-the-blanks question tests your knowledge of key terms and concepts in $chapter. Make sure to memorize important definitions and formulas for CBSE board exams.';
    }
    
    return 'This question is based on $chapter from CBSE syllabus. Understanding these concepts is essential for scoring well in board exams. Refer to NCERT textbook for detailed explanations.';
  }
  
  // Generate options for fill-in-the-blanks questions
  static List<String> _generateCBSEFillInTheBlanksOptions(String question, String subject, String chapter, String chapterDesc, int index, int levelNum) {
    final questionLower = question.toLowerCase();
    final subjectLower = subject.toLowerCase();
    
    // Physics fill-in-the-blanks
    if (subjectLower.contains('physics')) {
      if (questionLower.contains('si unit') && questionLower.contains('charge')) {
        return ['Coulomb (C)', 'Volt (V)', 'Ampere (A)', 'Ohm (Ω)'];
      } else if (questionLower.contains('coulomb') && questionLower.contains('constant')) {
        return ['Electrostatic', 'Gravitational', 'Magnetic', 'Electric'];
      } else if (questionLower.contains('electric field') && questionLower.contains('perpendicular')) {
        return ['Perpendicular', 'Parallel', 'At 45°', 'At 60°'];
      } else if (questionLower.contains('electric field') && questionLower.contains('distance')) {
        return ['Inversely proportional to r²', 'Directly proportional to r', 'Proportional to r³', 'Independent of r'];
      } else if (questionLower.contains('ohm') && questionLower.contains('law')) {
        return ['Current (I)', 'Voltage (V)', 'Resistance (R)', 'Power (P)'];
      } else if (questionLower.contains('series') && questionLower.contains('resistance')) {
        return ['Sum', 'Product', 'Difference', 'Quotient'];
      } else if (questionLower.contains('power')) {
        return ['Watt (W)', 'Joule (J)', 'Volt (V)', 'Ampere (A)'];
      } else if (questionLower.contains('magnetic field')) {
        return ['Tesla (T)', 'Weber (Wb)', 'Gauss (G)', 'Henry (H)'];
      } else if (questionLower.contains('magnetic field lines')) {
        return ['Closed', 'Open', 'Straight', 'Curved'];
      } else if (questionLower.contains('magnetic flux')) {
        return ['B·A·cos(θ)', 'B·A', 'B/A', 'A/B'];
      }
    }
    // Chemistry fill-in-the-blanks
    else if (subjectLower.contains('chemistry')) {
      if (questionLower.contains('conservation') && questionLower.contains('mass')) {
        return ['Products', 'Reactants', 'Catalysts', 'Enzymes'];
      } else if (questionLower.contains('combination') && questionLower.contains('reaction')) {
        return ['Combination', 'Decomposition', 'Displacement', 'Double displacement'];
      } else if (questionLower.contains('ph') && questionLower.contains('ion')) {
        return ['Hydrogen (H⁺)', 'Hydroxide (OH⁻)', 'Sodium (Na⁺)', 'Chloride (Cl⁻)'];
      } else if (questionLower.contains('ph') && questionLower.contains('acidic')) {
        return ['Acidic, Basic', 'Basic, Acidic', 'Neutral, Neutral', 'Both Acidic'];
      } else if (questionLower.contains('ph') && questionLower.contains('water')) {
        return ['7', '0', '14', '1'];
      } else if (questionLower.contains('exothermic') && questionLower.contains('endothermic')) {
        return ['Exothermic, Endothermic', 'Endothermic, Exothermic', 'Both Exothermic', 'Both Endothermic'];
      }
    }
    // Biology fill-in-the-blanks
    else if (subjectLower.contains('biology')) {
      if (questionLower.contains('unit of life') || questionLower.contains('basic structural')) {
        return ['Cell', 'Tissue', 'Organ', 'Organism'];
      } else if (questionLower.contains('cell wall')) {
        return ['Cell wall', 'Cell membrane', 'Cytoplasm', 'Nucleus'];
      } else if (questionLower.contains('mitochondria') && questionLower.contains('powerhouse')) {
        return ['Powerhouse', 'Control center', 'Storage unit', 'Transport system'];
      } else if (questionLower.contains('nucleus') && questionLower.contains('genetic')) {
        return ['DNA', 'RNA', 'Protein', 'Lipid'];
      } else if (questionLower.contains('ribosomes') && questionLower.contains('protein')) {
        return ['Protein', 'DNA', 'RNA', 'Lipid'];
      } else if (questionLower.contains('reproduction')) {
        return ['Reproduction', 'Respiration', 'Photosynthesis', 'Digestion'];
      }
    }
    // Mathematics fill-in-the-blanks
    else if (subjectLower.contains('mathematics') || subjectLower.contains('math')) {
      if (questionLower.contains('derivative') && questionLower.contains('xⁿ')) {
        return ['nxⁿ⁻¹', 'xⁿ', 'nxⁿ', 'xⁿ⁻¹'];
      } else if (questionLower.contains('chain rule')) {
        return ['f\'(g(x))·g\'(x)', 'f\'(x)·g\'(x)', 'f(x)·g(x)', 'f\'(x) + g\'(x)'];
      } else if (questionLower.contains('derivative') && questionLower.contains('constant')) {
        return ['Zero (0)', 'One (1)', 'The constant itself', 'Undefined'];
      } else if (questionLower.contains('integral') && questionLower.contains('xⁿ')) {
        return ['xⁿ⁺¹/(n+1) + C', 'xⁿ + C', 'nxⁿ⁻¹ + C', 'xⁿ⁻¹/(n-1) + C'];
      } else if (questionLower.contains('trigonometric') && questionLower.contains('sin²')) {
        return ['1', '0', 'sin(2θ)', 'cos(2θ)'];
      }
    }
    
    // Default fill-in-the-blanks options based on chapter keywords
    final keywords = chapterDesc.split(',').where((k) => k.trim().isNotEmpty).take(4).toList();
    if (keywords.length >= 2) {
      return [
        keywords[0].trim(),
        keywords.length > 1 ? keywords[1].trim() : 'Option 2',
        keywords.length > 2 ? keywords[2].trim() : 'Option 3',
        keywords.length > 3 ? keywords[3].trim() : 'Option 4'
      ];
    }
    
    return [
      'Correct answer',
      'Incorrect option 1',
      'Incorrect option 2',
      'Incorrect option 3'
    ];
  }
}

