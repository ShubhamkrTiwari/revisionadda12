import '../models/avenger_game.dart';
import '../models/game_level.dart';
import '../services/data_service.dart';
import '../services/roadmap_service.dart';
import '../services/ai_content_service.dart';

class AvengerGameService {
  static AvengerGame generateGameForChapter(String subjectId, String chapterId) {
    final chapter = DataService.getChapterById(subjectId, chapterId);
    final subject = DataService.getSubjectById(subjectId);
    
    if (chapter == null || subject == null) {
      return _getDefaultGame(chapterId, 'Unknown Chapter');
    }

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
    
    if (levelNum <= 15) {
      // Beginner level
      if (subjectName == 'physics') {
        question = questionText.contains('?') ? questionText : '$questionText in $chapter?';
        options = [
          'Physics principle related to $chapter',
          'Chemistry concept',
          'Mathematics theorem',
          'Biology process'
        ];
        correctAnswer = 0;
        explanation = 'This is a fundamental physics concept in $chapter that helps build your understanding.';
      } else if (subjectName == 'mathematics' || subjectName.contains('math')) {
        question = questionText.contains('?') ? questionText : '$questionText in $chapter?';
        options = [
          'Mathematical concept related to $chapter',
          'Physics formula',
          'Chemical equation',
          'Biological system'
        ];
        correctAnswer = 0;
        explanation = 'This is a fundamental mathematics concept in $chapter that helps build your understanding.';
      } else if (subjectName == 'chemistry') {
        question = questionText.contains('?') ? questionText : '$questionText in $chapter?';
        options = [
          'Chemistry concept related to $chapter',
          'Physics law',
          'Mathematical formula',
          'Biological process'
        ];
        correctAnswer = 0;
        explanation = 'This is a fundamental chemistry concept in $chapter that helps build your understanding.';
      } else if (subjectName == 'biology') {
        question = questionText.contains('?') ? questionText : '$questionText in $chapter?';
        options = [
          'Biological concept related to $chapter',
          'Physics principle',
          'Chemical reaction',
          'Mathematical theorem'
        ];
        correctAnswer = 0;
        explanation = 'This is a fundamental biology concept in $chapter that helps build your understanding.';
      } else {
        question = questionText;
        options = [
          'Correct answer related to $chapter',
          'Incorrect option 1',
          'Incorrect option 2',
          'Incorrect option 3',
        ];
        correctAnswer = 0;
        explanation = 'This is a fundamental concept in $chapter that helps build your understanding.';
      }
    } else if (levelNum <= 30) {
      // Intermediate level
      question = 'How does $questionText apply in $chapter?';
      options = [
        'Through practical application in ${subject.toLowerCase()}',
        'Only theoretically',
        'Not applicable to ${subject.toLowerCase()}',
        'Only in exams'
      ];
      correctAnswer = 0;
      explanation = 'Understanding practical applications helps master $chapter concepts in ${subject.toLowerCase()}.';
    } else {
      // Advanced level
      question = 'What advanced concept in ${subject.toLowerCase()} relates to: $questionText?';
      options = [
        'Advanced application of $chapter in ${subject.toLowerCase()}',
        'Basic definition',
        'Unrelated ${subject.toLowerCase()} concept',
        'Simple example'
      ];
      correctAnswer = 0;
      explanation = 'Advanced levels require deep understanding of $chapter principles in ${subject.toLowerCase()}.';
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
    
    // Get chapter details for better question generation
    final chapterData = DataService.getChapterById(
      DataService.getSubjects().firstWhere((s) => s.name.toLowerCase() == subject.toLowerCase()).id,
      DataService.getSubjects()
          .firstWhere((s) => s.name.toLowerCase() == subject.toLowerCase())
          .chapters.firstWhere((ch) => ch.name.toLowerCase() == chapter.toLowerCase()).id,
    );
    final chapterDesc = chapterData?.description ?? '';
    
    // Generate subject and chapter-specific questions
    String question;
    List<String> options;
    int correctAnswer;
    String explanation;

    // Physics-specific questions
    if (subject.toLowerCase() == 'physics') {
      if (chapter.toLowerCase().contains('electric') || title.toLowerCase().contains('electric')) {
        question = 'What is the unit of electric charge?';
        options = ['Coulomb (C)', 'Volt (V)', 'Ampere (A)', 'Ohm (Ω)'];
        correctAnswer = 0;
        explanation = 'Electric charge is measured in Coulombs (C). This is a fundamental unit in physics.';
      } else if (chapter.toLowerCase().contains('current') || title.toLowerCase().contains('current')) {
        question = 'According to Ohm\'s Law, what is the relationship between voltage, current, and resistance?';
        options = ['V = IR', 'I = VR', 'R = VI', 'V = I/R'];
        correctAnswer = 0;
        explanation = 'Ohm\'s Law states: V = IR, where V is voltage, I is current, and R is resistance.';
      } else if (chapter.toLowerCase().contains('magnetic') || title.toLowerCase().contains('magnetic')) {
        question = 'What is the SI unit of magnetic field?';
        options = ['Tesla (T)', 'Gauss (G)', 'Weber (Wb)', 'Henry (H)'];
        correctAnswer = 0;
        explanation = 'Magnetic field is measured in Tesla (T) in SI units.';
      } else if (chapter.toLowerCase().contains('wave') || title.toLowerCase().contains('wave')) {
        question = 'What is the speed of light in vacuum?';
        options = ['3 × 10⁸ m/s', '3 × 10⁶ m/s', '3 × 10¹⁰ m/s', '3 × 10⁴ m/s'];
        correctAnswer = 0;
        explanation = 'The speed of light in vacuum is approximately 3 × 10⁸ meters per second.';
      } else {
        question = 'What is a key concept in $chapter?';
        options = [
          description.isNotEmpty ? description.substring(0, description.length > 50 ? 50 : description.length) : 'Fundamental principle of $chapter',
          'Unrelated physics concept',
          'Chemistry concept',
          'Mathematics concept'
        ];
        correctAnswer = 0;
        explanation = description.isNotEmpty ? description : 'This is an important concept in $chapter.';
      }
    }
    // Mathematics-specific questions
    else if (subject.toLowerCase() == 'mathematics' || subject.toLowerCase().contains('math')) {
      if (chapter.toLowerCase().contains('derivative') || title.toLowerCase().contains('derivative')) {
        question = 'What is the derivative of x²?';
        options = ['2x', 'x', 'x²', '2x²'];
        correctAnswer = 0;
        explanation = 'Using the power rule: d/dx(xⁿ) = nxⁿ⁻¹, so d/dx(x²) = 2x.';
      } else if (chapter.toLowerCase().contains('integral') || title.toLowerCase().contains('integral')) {
        question = 'What is the integral of 2x?';
        options = ['x² + C', '2x + C', 'x²', '2x'];
        correctAnswer = 0;
        explanation = 'The integral of 2x is x² + C, where C is the constant of integration.';
      } else if (chapter.toLowerCase().contains('trigonometric') || title.toLowerCase().contains('trigonometric')) {
        question = 'What is sin²θ + cos²θ equal to?';
        options = ['1', '0', 'sin(2θ)', 'cos(2θ)'];
        correctAnswer = 0;
        explanation = 'This is a fundamental trigonometric identity: sin²θ + cos²θ = 1.';
      } else if (chapter.toLowerCase().contains('matrix') || title.toLowerCase().contains('matrix')) {
        question = 'What is the determinant of a 2×2 matrix [[a,b],[c,d]]?';
        options = ['ad - bc', 'ab - cd', 'a + d', 'b + c'];
        correctAnswer = 0;
        explanation = 'For a 2×2 matrix, the determinant is calculated as ad - bc.';
      } else {
        question = 'What is a key concept in $chapter?';
        options = [
          description.isNotEmpty ? description.substring(0, description.length > 50 ? 50 : description.length) : 'Fundamental principle of $chapter',
          'Unrelated math concept',
          'Physics concept',
          'Chemistry concept'
        ];
        correctAnswer = 0;
        explanation = description.isNotEmpty ? description : 'This is an important concept in $chapter.';
      }
    }
    // Chemistry-specific questions
    else if (subject.toLowerCase() == 'chemistry') {
      if (chapter.toLowerCase().contains('reaction') || title.toLowerCase().contains('reaction')) {
        question = 'What happens in a chemical reaction?';
        options = [
          'Atoms rearrange to form new substances',
          'Atoms are destroyed',
          'Energy is created',
          'Mass is lost'
        ];
        correctAnswer = 0;
        explanation = 'In a chemical reaction, atoms rearrange to form new substances. Atoms are neither created nor destroyed (Law of Conservation of Mass).';
      } else if (chapter.toLowerCase().contains('solution') || title.toLowerCase().contains('solution')) {
        question = 'What is a solution?';
        options = [
          'A homogeneous mixture of two or more substances',
          'A heterogeneous mixture',
          'A pure substance',
          'A compound'
        ];
        correctAnswer = 0;
        explanation = 'A solution is a homogeneous mixture where one substance (solute) is dissolved in another (solvent).';
      } else if (chapter.toLowerCase().contains('equilibrium') || title.toLowerCase().contains('equilibrium')) {
        question = 'What is chemical equilibrium?';
        options = [
          'State where forward and reverse reaction rates are equal',
          'State where no reaction occurs',
          'State where only forward reaction occurs',
          'State where only reverse reaction occurs'
        ];
        correctAnswer = 0;
        explanation = 'Chemical equilibrium is a dynamic state where the rates of forward and reverse reactions are equal.';
      } else {
        question = 'What is a key concept in $chapter?';
        options = [
          description.isNotEmpty ? description.substring(0, description.length > 50 ? 50 : description.length) : 'Fundamental principle of $chapter',
          'Unrelated chemistry concept',
          'Physics concept',
          'Biology concept'
        ];
        correctAnswer = 0;
        explanation = description.isNotEmpty ? description : 'This is an important concept in $chapter.';
      }
    }
    // Biology-specific questions
    else if (subject.toLowerCase() == 'biology') {
      if (chapter.toLowerCase().contains('reproduction') || title.toLowerCase().contains('reproduction')) {
        question = 'What is the main difference between asexual and sexual reproduction?';
        options = [
          'Sexual reproduction involves fusion of gametes',
          'Asexual reproduction involves fusion of gametes',
          'Both are identical',
          'Neither involves cell division'
        ];
        correctAnswer = 0;
        explanation = 'Sexual reproduction involves the fusion of male and female gametes, while asexual reproduction does not.';
      } else if (chapter.toLowerCase().contains('genetics') || title.toLowerCase().contains('genetics')) {
        question = 'What is a gene?';
        options = [
          'A unit of heredity that codes for a protein',
          'A type of cell',
          'A type of tissue',
          'A type of organ'
        ];
        correctAnswer = 0;
        explanation = 'A gene is a unit of heredity that contains the information to code for a specific protein.';
      } else if (chapter.toLowerCase().contains('ecosystem') || title.toLowerCase().contains('ecosystem')) {
        question = 'What is an ecosystem?';
        options = [
          'A community of living organisms and their environment',
          'Only living organisms',
          'Only non-living environment',
          'A single species'
        ];
        correctAnswer = 0;
        explanation = 'An ecosystem includes all living organisms (biotic) and their physical environment (abiotic) interacting as a system.';
      } else {
        question = 'What is a key concept in $chapter?';
        options = [
          description.isNotEmpty ? description.substring(0, description.length > 50 ? 50 : description.length) : 'Fundamental principle of $chapter',
          'Unrelated biology concept',
          'Physics concept',
          'Chemistry concept'
        ];
        correctAnswer = 0;
        explanation = description.isNotEmpty ? description : 'This is an important concept in $chapter.';
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
        question = 'What does this physics formula represent: $formulaText?';
        options = [
          description.isNotEmpty ? description : 'Physics principle',
          'Chemistry formula',
          'Mathematics formula',
          'Biology concept'
        ];
        correctAnswer = 0;
        explanation = description.isNotEmpty ? description : 'This is an important formula in physics.';
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
        question = 'What does this mathematics formula represent: $formulaText?';
        options = [
          description.isNotEmpty ? description : 'Mathematical principle',
          'Physics formula',
          'Chemistry formula',
          'Biology concept'
        ];
        correctAnswer = 0;
        explanation = description.isNotEmpty ? description : 'This is an important formula in mathematics.';
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
        question = 'What does this chemistry formula represent: $formulaText?';
        options = [
          description.isNotEmpty ? description : 'Chemistry principle',
          'Physics formula',
          'Mathematics formula',
          'Biology concept'
        ];
        correctAnswer = 0;
        explanation = description.isNotEmpty ? description : 'This is an important formula in chemistry.';
      }
    }
    // Biology (usually doesn't have formulas, but concepts)
    else if (subject.toLowerCase() == 'biology') {
      question = 'What does this concept in biology represent: $formulaText?';
      options = [
        description.isNotEmpty ? description : 'Biological principle',
        'Physics concept',
        'Chemistry concept',
        'Mathematics concept'
      ];
      correctAnswer = 0;
      explanation = description.isNotEmpty ? description : 'This is an important concept in biology.';
    }
    // Default
    else {
      question = 'What does this formula represent: $formulaText?';
      options = [
        description.isNotEmpty ? description : 'Main concept',
        'Secondary formula',
        'Alternative method',
        'Basic definition'
      ];
      correctAnswer = 0;
      explanation = description.isNotEmpty ? description : 'This is an important formula.';
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

