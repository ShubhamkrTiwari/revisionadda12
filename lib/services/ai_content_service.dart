import '../models/subject.dart';
import '../services/data_service.dart';

class AIContentService {
  // Generate AI content for a chapter
  static Map<String, dynamic> generateChapterContent(String subjectId, String chapterId) {
    final chapter = DataService.getChapterById(subjectId, chapterId);
    final subject = DataService.getSubjectById(subjectId);
    
    if (chapter == null || subject == null) {
      return _getDefaultContent();
    }

    // Generate comprehensive content based on chapter and subject
    return {
      'overview': _generateOverview(subject.name, chapter.name, chapter.description),
      'keyConcepts': _generateKeyConcepts(subject.name, chapter.name, chapter.description),
      'importantFormulas': _generateFormulas(subject.name, chapter.name),
      'studyTips': _generateStudyTips(subject.name, chapter.name),
      'practiceQuestions': _generatePracticeQuestions(subject.name, chapter.name),
      'summary': _generateSummary(subject.name, chapter.name, chapter.description),
    };
  }

  static String _generateOverview(String subject, String chapter, String description) {
    return '''
📚 **Chapter Overview: $chapter**

This chapter is a fundamental part of $subject that covers essential concepts and principles. 

**What You'll Learn:**
${description.isNotEmpty ? description : 'Core concepts, important theories, and practical applications that form the foundation of this topic.'}

**Why It's Important:**
This chapter builds the groundwork for understanding more advanced topics. Mastering these concepts will help you excel in exams and apply knowledge in real-world scenarios.

**Difficulty Level:** Moderate
**Estimated Study Time:** 4-6 hours
**Best Approach:** Start with theory, practice with examples, then solve problems
''';
  }

  static List<Map<String, String>> _generateKeyConcepts(String subject, String chapter, String description) {
    // Extract key concepts from description or generate based on subject/chapter
    List<Map<String, String>> concepts = [];
    
    if (description.toLowerCase().contains('electric')) {
      concepts = [
        {
          'title': 'Electric Charge',
          'description': 'Understanding the fundamental property of matter that causes it to experience a force when placed in an electromagnetic field.'
        },
        {
          'title': 'Electric Field',
          'description': 'A region around a charged particle where electric force is experienced by other charged particles.'
        },
        {
          'title': 'Coulomb\'s Law',
          'description': 'The force between two point charges is directly proportional to the product of charges and inversely proportional to square of distance.'
        },
      ];
    } else if (description.toLowerCase().contains('derivative') || description.toLowerCase().contains('differentiation')) {
      concepts = [
        {
          'title': 'Rate of Change',
          'description': 'Understanding how a function changes with respect to its variable.'
        },
        {
          'title': 'Derivative Rules',
          'description': 'Power rule, product rule, quotient rule, and chain rule for finding derivatives.'
        },
        {
          'title': 'Applications',
          'description': 'Using derivatives to find maxima, minima, and rates of change in real-world problems.'
        },
      ];
    } else if (description.toLowerCase().contains('reaction') || description.toLowerCase().contains('chemical')) {
      concepts = [
        {
          'title': 'Chemical Reactions',
          'description': 'Processes where reactants transform into products with energy changes.'
        },
        {
          'title': 'Reaction Mechanisms',
          'description': 'Step-by-step process showing how reactants convert to products.'
        },
        {
          'title': 'Equilibrium',
          'description': 'State where forward and reverse reactions occur at equal rates.'
        },
      ];
    } else {
      // Default concepts based on chapter name
      concepts = [
        {
          'title': 'Core Principles',
          'description': 'Fundamental principles and laws that govern this topic.'
        },
        {
          'title': 'Key Definitions',
          'description': 'Important terms and definitions you must understand.'
        },
        {
          'title': 'Practical Applications',
          'description': 'Real-world applications and examples of these concepts.'
        },
      ];
    }

    return concepts;
  }

  static List<Map<String, String>> _generateFormulas(String subject, String chapter) {
    List<Map<String, String>> formulas = [];
    
    if (subject.toLowerCase().contains('physics')) {
      if (chapter.toLowerCase().contains('electric')) {
        formulas = [
          {
            'formula': 'F = k(q₁q₂)/r²',
            'description': 'Coulomb\'s Law - Force between two charges'
          },
          {
            'formula': 'E = F/q',
            'description': 'Electric Field Strength'
          },
          {
            'formula': 'V = kq/r',
            'description': 'Electric Potential'
          },
        ];
      } else if (chapter.toLowerCase().contains('current')) {
        formulas = [
          {
            'formula': 'V = IR',
            'description': 'Ohm\'s Law - Voltage, Current, Resistance relationship'
          },
          {
            'formula': 'P = VI = I²R',
            'description': 'Power in electrical circuits'
          },
          {
            'formula': 'R = ρL/A',
            'description': 'Resistance of a conductor'
          },
        ];
      }
    } else if (subject.toLowerCase().contains('mathematics')) {
      if (chapter.toLowerCase().contains('derivative')) {
        formulas = [
          {
            'formula': 'd/dx(xⁿ) = nxⁿ⁻¹',
            'description': 'Power Rule for Derivatives'
          },
          {
            'formula': 'd/dx(uv) = u\'v + uv\'',
            'description': 'Product Rule'
          },
          {
            'formula': 'd/dx(u/v) = (u\'v - uv\')/v²',
            'description': 'Quotient Rule'
          },
        ];
      } else if (chapter.toLowerCase().contains('integral')) {
        formulas = [
          {
            'formula': '∫xⁿ dx = xⁿ⁺¹/(n+1) + C',
            'description': 'Power Rule for Integration'
          },
          {
            'formula': '∫eˣ dx = eˣ + C',
            'description': 'Exponential Integration'
          },
          {
            'formula': '∫(1/x) dx = ln|x| + C',
            'description': 'Logarithmic Integration'
          },
        ];
      }
    } else if (subject.toLowerCase().contains('chemistry')) {
      formulas = [
        {
          'formula': 'Rate = k[A]ᵐ[B]ⁿ',
          'description': 'Rate Law for Chemical Reactions'
        },
        {
          'formula': 'pH = -log[H⁺]',
          'description': 'pH Calculation'
        },
        {
          'formula': 'ΔG = ΔH - TΔS',
          'description': 'Gibbs Free Energy'
        },
      ];
    }

    if (formulas.isEmpty) {
      formulas = [
        {
          'formula': 'Key Formula 1',
          'description': 'Important formula related to this chapter'
        },
        {
          'formula': 'Key Formula 2',
          'description': 'Essential formula for problem solving'
        },
      ];
    }

    return formulas;
  }

  static List<String> _generateStudyTips(String subject, String chapter) {
    return [
      '📖 Read the chapter thoroughly at least twice',
      '✍️ Make notes of important points and formulas',
      '🎯 Focus on understanding concepts rather than memorizing',
      '📝 Practice solved examples from NCERT',
      '✅ Solve previous year questions',
      '🔄 Revise regularly to retain information',
      '💡 Create mind maps for visual learning',
      '⏰ Allocate dedicated study time daily',
      '🤔 Solve practice problems to test understanding',
      '📊 Track your progress and identify weak areas',
    ];
  }

  static List<Map<String, String>> _generatePracticeQuestions(String subject, String chapter) {
    final subjectLower = subject.toLowerCase();
    final chapterLower = chapter.toLowerCase();
    
    // Get chapter description
    String description = '';
    try {
      final subjects = DataService.getSubjects();
      for (var sub in subjects) {
        if (sub.name.toLowerCase() == subjectLower) {
          for (var ch in sub.chapters) {
            if (ch.name.toLowerCase() == chapterLower) {
              description = ch.description;
              break;
            }
          }
        }
      }
    } catch (e) {
      description = '';
    }
    
    List<Map<String, String>> questions = [];
    
    // Physics CBSE Questions
    if (subjectLower.contains('physics')) {
      if (chapterLower.contains('electric') || description.toLowerCase().contains('electric') || description.toLowerCase().contains('charge')) {
        questions = [
          {'question': 'Q. What is the SI unit of electric charge? (1 mark)', 'type': 'MCQ', 'difficulty': 'Easy'},
          {'question': 'Q. Two point charges of +5μC and -3μC are placed 10cm apart in vacuum. Calculate the magnitude of force between them. (Given: k = 9 × 10⁹ Nm²/C²) (2 marks)', 'type': 'Numerical', 'difficulty': 'Medium'},
          {'question': 'Q. State Coulomb\'s law. Write its mathematical expression and explain the significance of each term. (2 marks)', 'type': 'Conceptual', 'difficulty': 'Medium'},
          {'question': 'Q. The SI unit of electric charge is ______. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Easy'},
          {'question': 'Q. According to Coulomb\'s law, F = k(q₁q₂)/r², where k is the ______ constant. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Easy'},
          {'question': 'Q. A point charge of 2μC is placed in a uniform electric field of intensity 500 N/C. Calculate the magnitude of force experienced by the charge. (2 marks)', 'type': 'Numerical', 'difficulty': 'Easy'},
          {'question': 'Q. Electric field lines are always ______ to the equipotential surfaces. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Medium'},
          {'question': 'Q. The electric field due to a point charge varies as ______ with distance from the charge. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Medium'},
          {'question': 'Q. Calculate the electric field intensity at a point 5cm away from a point charge of 10μC placed in vacuum. (Given: k = 9 × 10⁹ Nm²/C²) (3 marks)', 'type': 'Numerical', 'difficulty': 'Medium'},
          {'question': 'Q. Define electric dipole moment. Derive an expression for the electric field due to an electric dipole at a point on its axial line. (5 marks)', 'type': 'Conceptual', 'difficulty': 'Hard'},
          {'question': 'Q. Two identical point charges, each of magnitude q, are placed at a distance 2a apart. Find the electric field at the midpoint of the line joining them. (3 marks)', 'type': 'Numerical', 'difficulty': 'Hard'},
          {'question': 'Q. Explain why electric field lines never intersect each other. (2 marks)', 'type': 'Conceptual', 'difficulty': 'Medium'},
        ];
      } else if (chapterLower.contains('current') || description.toLowerCase().contains('current') || description.toLowerCase().contains('circuit')) {
        questions = [
          {'question': 'Q. State Ohm\'s law. Under what conditions is it valid? (2 marks)', 'type': 'Conceptual', 'difficulty': 'Easy'},
          {'question': 'Q. A resistor of resistance 10Ω is connected across a battery of emf 12V and negligible internal resistance. Calculate the current flowing through the resistor. (2 marks)', 'type': 'Numerical', 'difficulty': 'Easy'},
          {'question': 'Q. According to Ohm\'s law, V = ______ × R, where V is potential difference, R is resistance. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Easy'},
          {'question': 'Q. Explain the difference between series and parallel combination of resistors. Give one example of each. (3 marks)', 'type': 'Conceptual', 'difficulty': 'Medium'},
          {'question': 'Q. Three resistors of resistances 2Ω, 3Ω, and 6Ω are connected in parallel. Calculate the equivalent resistance of the combination. (3 marks)', 'type': 'Numerical', 'difficulty': 'Medium'},
          {'question': 'Q. In a series combination of resistors, the equivalent resistance is equal to the ______ of individual resistances. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Medium'},
          {'question': 'Q. Calculate the power dissipated in a resistor of resistance 5Ω when a current of 2A flows through it. (2 marks)', 'type': 'Numerical', 'difficulty': 'Medium'},
          {'question': 'Q. The SI unit of electrical power is ______. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Easy'},
          {'question': 'Q. Define electrical power. Derive the expressions: P = VI, P = I²R, and P = V²/R. (5 marks)', 'type': 'Derivation', 'difficulty': 'Hard'},
          {'question': 'Q. Three resistors of resistances 4Ω, 6Ω, and 10Ω are connected in series across a battery of emf 20V. Calculate the current flowing through each resistor. (3 marks)', 'type': 'Numerical', 'difficulty': 'Hard'},
          {'question': 'Q. State Kirchhoff\'s laws. Apply them to find the current in a given circuit. (5 marks)', 'type': 'Conceptual', 'difficulty': 'Hard'},
          {'question': 'Q. A wire of resistance R is stretched to double its length. What will be its new resistance? (2 marks)', 'type': 'Numerical', 'difficulty': 'Medium'},
        ];
      } else if (chapterLower.contains('magnetic') || description.toLowerCase().contains('magnetic') || description.toLowerCase().contains('field')) {
        questions = [
          {'question': 'What is magnetic field? State the SI unit of magnetic field strength.', 'type': 'Conceptual', 'difficulty': 'Easy'},
          {'question': 'A current of 5A flows through a straight wire. Calculate the magnetic field at a distance of 10cm from the wire.', 'type': 'Numerical', 'difficulty': 'Medium'},
          {'question': 'The SI unit of magnetic field is ______.', 'type': 'FillInTheBlanks', 'difficulty': 'Easy'},
          {'question': 'State Fleming\'s left-hand rule and explain its application.', 'type': 'Conceptual', 'difficulty': 'Medium'},
          {'question': 'According to Biot-Savart law, the magnetic field is proportional to the ______.', 'type': 'FillInTheBlanks', 'difficulty': 'Medium'},
          {'question': 'Calculate the magnetic field at the center of a circular loop of radius 5cm carrying a current of 2A.', 'type': 'Numerical', 'difficulty': 'Hard'},
          {'question': 'Magnetic field lines form ______ loops.', 'type': 'FillInTheBlanks', 'difficulty': 'Easy'},
          {'question': 'Derive the expression for magnetic field due to a straight current-carrying conductor.', 'type': 'Derivation', 'difficulty': 'Hard'},
          {'question': 'Explain the concept of magnetic flux and state Faraday\'s law of electromagnetic induction.', 'type': 'Conceptual', 'difficulty': 'Hard'},
          {'question': 'The magnetic flux through a surface is given by Φ = ______.', 'type': 'FillInTheBlanks', 'difficulty': 'Medium'},
        ];
      } else {
        questions = _generateCBSEPhysicsQuestions(chapter, description);
      }
    }
    // Chemistry CBSE Questions
    else if (subjectLower.contains('chemistry')) {
      if (chapterLower.contains('reaction') || description.toLowerCase().contains('reaction') || description.toLowerCase().contains('chemical')) {
        questions = [
          {'question': 'Q. What is a chemical reaction? Give one example of a combination reaction. (2 marks)', 'type': 'Conceptual', 'difficulty': 'Easy'},
          {'question': 'Q. Balance the following chemical equation: Fe + H₂O → Fe₃O₄ + H₂ (2 marks)', 'type': 'Numerical', 'difficulty': 'Medium'},
          {'question': 'Q. According to the Law of Conservation of Mass, in a chemical reaction, the total mass of reactants equals the total mass of ______. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Easy'},
          {'question': 'Q. State the Law of Conservation of Mass. Explain this law with a suitable example. (3 marks)', 'type': 'Conceptual', 'difficulty': 'Medium'},
          {'question': 'Q. A reaction in which two or more substances combine to form a single product is called a ______ reaction. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Easy'},
          {'question': 'Q. Classify the following reactions: (a) 2H₂ + O₂ → 2H₂O (b) CaCO₃ → CaO + CO₂ (2 marks)', 'type': 'Conceptual', 'difficulty': 'Medium'},
          {'question': 'Q. Calculate the mass of oxygen required to react completely with 56g of iron to form Fe₂O₃. (Given: Atomic mass of Fe = 56, O = 16) (3 marks)', 'type': 'Numerical', 'difficulty': 'Hard'},
          {'question': 'Q. The reaction 2H₂ + O₂ → 2H₂O is an example of a ______ reaction. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Medium'},
          {'question': 'Q. If 4g of hydrogen reacts completely with 32g of oxygen, calculate the mass of water formed. (2 marks)', 'type': 'Numerical', 'difficulty': 'Medium'},
          {'question': 'Q. Explain the difference between exothermic and endothermic reactions with one example of each. (3 marks)', 'type': 'Conceptual', 'difficulty': 'Hard'},
          {'question': 'Q. Write balanced chemical equations for: (a) Decomposition reaction (b) Displacement reaction (2 marks)', 'type': 'Conceptual', 'difficulty': 'Medium'},
          {'question': 'Q. In the reaction: 2Mg + O₂ → 2MgO, if 24g of Mg reacts completely, calculate the mass of MgO formed. (Given: Atomic mass of Mg = 24, O = 16) (3 marks)', 'type': 'Numerical', 'difficulty': 'Hard'},
        ];
      } else if (chapterLower.contains('acid') || description.toLowerCase().contains('acid') || description.toLowerCase().contains('base')) {
        questions = [
          {'question': 'Define acids and bases according to Arrhenius theory. Give examples.', 'type': 'Conceptual', 'difficulty': 'Easy'},
          {'question': 'Calculate the pH of a solution with [H⁺] = 0.001 M.', 'type': 'Numerical', 'difficulty': 'Medium'},
          {'question': 'pH is defined as the negative logarithm of ______ ion concentration.', 'type': 'FillInTheBlanks', 'difficulty': 'Easy'},
          {'question': 'Explain the process of neutralization reaction with a balanced chemical equation.', 'type': 'Conceptual', 'difficulty': 'Medium'},
          {'question': 'A solution with pH < 7 is ______, while pH > 7 is ______.', 'type': 'FillInTheBlanks', 'difficulty': 'Easy'},
          {'question': 'What is the pH scale? How does it help in identifying acidic and basic solutions?', 'type': 'Conceptual', 'difficulty': 'Medium'},
          {'question': 'A solution has pH = 11. Calculate the [H⁺] and [OH⁻] concentrations.', 'type': 'Numerical', 'difficulty': 'Hard'},
          {'question': 'The pH of pure water at 25°C is ______.', 'type': 'FillInTheBlanks', 'difficulty': 'Easy'},
          {'question': 'Calculate the pH of a solution with [OH⁻] = 0.0001 M.', 'type': 'Numerical', 'difficulty': 'Medium'},
          {'question': 'Explain the concept of buffer solution and its importance.', 'type': 'Conceptual', 'difficulty': 'Hard'},
        ];
      } else if (chapterLower.contains('organic') || description.toLowerCase().contains('organic') || description.toLowerCase().contains('carbon')) {
        questions = [
          {'question': 'What is the unique property of carbon that makes it form millions of compounds?', 'type': 'Conceptual', 'difficulty': 'Easy'},
          {'question': 'Write the structural formula of ethane (C₂H₆) and propane (C₃H₈).', 'type': 'Conceptual', 'difficulty': 'Medium'},
          {'question': 'Explain the difference between saturated and unsaturated hydrocarbons with examples.', 'type': 'Conceptual', 'difficulty': 'Medium'},
          {'question': 'Name the functional groups present in: (a) Alcohol (b) Aldehyde (c) Carboxylic acid', 'type': 'Conceptual', 'difficulty': 'Medium'},
          {'question': 'Write the IUPAC name for CH₃-CH₂-CH₂-CH₃.', 'type': 'Conceptual', 'difficulty': 'Easy'},
        ];
      } else {
        questions = _generateCBSEChemistryQuestions(chapter, description);
      }
    }
    // Biology CBSE Questions
    else if (subjectLower.contains('biology')) {
      if (chapterLower.contains('cell') || description.toLowerCase().contains('cell') || description.toLowerCase().contains('cellular')) {
        questions = [
          {'question': 'Q. What is a cell? Name the scientist who first observed cells under a microscope. (2 marks)', 'type': 'Conceptual', 'difficulty': 'Easy'},
          {'question': 'Q. The basic structural and functional unit of life is the ______. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Easy'},
          {'question': 'Q. Differentiate between plant cell and animal cell with respect to (a) cell wall (b) chloroplast. (2 marks)', 'type': 'Conceptual', 'difficulty': 'Medium'},
          {'question': 'Q. Plant cells have a rigid ______ which is absent in animal cells. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Easy'},
          {'question': 'Q. Explain the structure and function of mitochondria. Draw a labeled diagram. (3 marks)', 'type': 'Conceptual', 'difficulty': 'Medium'},
          {'question': 'Q. Mitochondria are known as the ______ of the cell. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Easy'},
          {'question': 'Q. What is the function of nucleus in a cell? Describe its structure with a labeled diagram. (3 marks)', 'type': 'Conceptual', 'difficulty': 'Medium'},
          {'question': 'Q. The nucleus contains ______ which carries genetic information. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Medium'},
          {'question': 'Q. Name the cell organelles involved in protein synthesis. Explain the role of each. (5 marks)', 'type': 'Conceptual', 'difficulty': 'Hard'},
          {'question': 'Q. Ribosomes are the sites of ______ synthesis in the cell. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Medium'},
          {'question': 'Q. Draw a labeled diagram of a plant cell and mention the functions of any three organelles. (5 marks)', 'type': 'Conceptual', 'difficulty': 'Hard'},
          {'question': 'Q. Explain why mitochondria are called semi-autonomous organelles. (2 marks)', 'type': 'Conceptual', 'difficulty': 'Medium'},
        ];
      } else if (chapterLower.contains('reproduction') || description.toLowerCase().contains('reproduction')) {
        questions = [
          {'question': 'What is reproduction? Name two types of reproduction.', 'type': 'Conceptual', 'difficulty': 'Easy'},
          {'question': 'Differentiate between sexual and asexual reproduction with examples.', 'type': 'Conceptual', 'difficulty': 'Medium'},
          {'question': 'Explain the process of binary fission in Amoeba with a diagram.', 'type': 'Conceptual', 'difficulty': 'Medium'},
          {'question': 'What is fertilization? Describe the process in flowering plants.', 'type': 'Conceptual', 'difficulty': 'Hard'},
          {'question': 'Compare and contrast mitosis and meiosis.', 'type': 'Conceptual', 'difficulty': 'Hard'},
        ];
      } else if (chapterLower.contains('genetic') || description.toLowerCase().contains('genetic') || description.toLowerCase().contains('dna')) {
        questions = [
          {'question': 'What is DNA? Where is it located in a cell?', 'type': 'Conceptual', 'difficulty': 'Easy'},
          {'question': 'Explain the structure of DNA molecule as proposed by Watson and Crick.', 'type': 'Conceptual', 'difficulty': 'Medium'},
          {'question': 'What is a gene? How does it relate to DNA and protein synthesis?', 'type': 'Conceptual', 'difficulty': 'Medium'},
          {'question': 'Differentiate between genotype and phenotype with examples.', 'type': 'Conceptual', 'difficulty': 'Medium'},
          {'question': 'Explain Mendel\'s law of segregation with a suitable example.', 'type': 'Conceptual', 'difficulty': 'Hard'},
        ];
      } else {
        questions = _generateCBSEBiologyQuestions(chapter, description);
      }
    }
    // Mathematics CBSE Questions
    else if (subjectLower.contains('mathematics') || subjectLower.contains('math')) {
      if (chapterLower.contains('derivative') || description.toLowerCase().contains('derivative') || description.toLowerCase().contains('differentiation')) {
        questions = [
          {'question': 'Q. Find the derivative of f(x) = x³ + 2x² - 5x + 1 with respect to x. (2 marks)', 'type': 'Numerical', 'difficulty': 'Easy'},
          {'question': 'Q. The derivative of xⁿ with respect to x is ______. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Easy'},
          {'question': 'Q. Differentiate y = (x² + 1)(x³ - 2x) with respect to x. (3 marks)', 'type': 'Numerical', 'difficulty': 'Medium'},
          {'question': 'Q. Find dy/dx if y = sin(x² + 3x). (3 marks)', 'type': 'Numerical', 'difficulty': 'Medium'},
          {'question': 'Q. According to the chain rule, if y = f(g(x)), then dy/dx = ______. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Medium'},
          {'question': 'Q. State the product rule and quotient rule for differentiation. Give one example of each. (3 marks)', 'type': 'Conceptual', 'difficulty': 'Medium'},
          {'question': 'Q. The derivative of a constant function is always ______. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Easy'},
          {'question': 'Q. Find the derivative of f(x) = eˣ · ln(x) using product rule. (3 marks)', 'type': 'Numerical', 'difficulty': 'Hard'},
          {'question': 'Q. Calculate the derivative of f(x) = (2x + 3)⁴. (2 marks)', 'type': 'Numerical', 'difficulty': 'Medium'},
          {'question': 'Q. Explain the geometric interpretation of derivative. What does it represent? (3 marks)', 'type': 'Conceptual', 'difficulty': 'Hard'},
          {'question': 'Q. If y = x²·eˣ, find dy/dx. (3 marks)', 'type': 'Numerical', 'difficulty': 'Hard'},
          {'question': 'Q. Find the derivative of f(x) = (x + 1)/(x - 1) using quotient rule. (3 marks)', 'type': 'Numerical', 'difficulty': 'Medium'},
        ];
      } else if (chapterLower.contains('integral') || description.toLowerCase().contains('integral') || description.toLowerCase().contains('integration')) {
        questions = [
          {'question': 'Evaluate ∫(3x² + 2x - 1) dx.', 'type': 'Numerical', 'difficulty': 'Easy'},
          {'question': 'Find ∫(x³ + 2x + 5) dx.', 'type': 'Numerical', 'difficulty': 'Easy'},
          {'question': 'Evaluate ∫₀² (x² + 1) dx.', 'type': 'Numerical', 'difficulty': 'Medium'},
          {'question': 'Explain the fundamental theorem of calculus with an example.', 'type': 'Conceptual', 'difficulty': 'Hard'},
          {'question': 'Evaluate ∫(sin x + cos x) dx.', 'type': 'Numerical', 'difficulty': 'Medium'},
        ];
      } else if (chapterLower.contains('trigonometric') || description.toLowerCase().contains('trigonometric') || description.toLowerCase().contains('trigonometry')) {
        questions = [
          {'question': 'Prove that sin²θ + cos²θ = 1.', 'type': 'Conceptual', 'difficulty': 'Easy'},
          {'question': 'Find the value of sin(30°) and cos(60°).', 'type': 'Numerical', 'difficulty': 'Easy'},
          {'question': 'If sin A = 3/5, find the value of cos A and tan A.', 'type': 'Numerical', 'difficulty': 'Medium'},
          {'question': 'Prove the identity: tan²θ + 1 = sec²θ.', 'type': 'Conceptual', 'difficulty': 'Medium'},
          {'question': 'Solve for x: 2sin²x - 3sin x + 1 = 0, where 0° ≤ x ≤ 360°.', 'type': 'Numerical', 'difficulty': 'Hard'},
        ];
      } else {
        questions = _generateCBSEMathematicsQuestions(chapter, description);
      }
    }
    // Default CBSE Questions
    else {
      questions = [
        {'question': 'Explain the main concept covered in $chapter as per CBSE syllabus.', 'type': 'Conceptual', 'difficulty': 'Easy'},
        {'question': 'State the important principles related to $chapter and give examples.', 'type': 'Conceptual', 'difficulty': 'Medium'},
        {'question': 'Solve a numerical problem based on $chapter concepts.', 'type': 'Numerical', 'difficulty': 'Medium'},
        {'question': 'Compare and contrast key concepts in $chapter.', 'type': 'Conceptual', 'difficulty': 'Hard'},
        {'question': 'Apply the concepts of $chapter to a real-world scenario.', 'type': 'Application', 'difficulty': 'Hard'},
      ];
    }
    
    return questions;
  }
  
  // Helper methods for generating CBSE questions
  static List<Map<String, String>> _generateCBSEPhysicsQuestions(String chapter, String description) {
    return [
      {'question': 'Q. State the fundamental principle related to $chapter as per CBSE Class 12 Physics. (2 marks)', 'type': 'Conceptual', 'difficulty': 'Easy'},
      {'question': 'Q. The main concept in $chapter is related to ______. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Easy'},
      {'question': 'Q. Derive the expression for the main formula in $chapter. Show all steps clearly. (5 marks)', 'type': 'Derivation', 'difficulty': 'Hard'},
      {'question': 'Q. Solve the following numerical problem based on $chapter: [Problem with given values] (3 marks)', 'type': 'Numerical', 'difficulty': 'Medium'},
      {'question': 'Q. Explain the practical applications of $chapter concepts with examples. (3 marks)', 'type': 'Conceptual', 'difficulty': 'Medium'},
      {'question': 'Q. The SI unit for the main quantity in $chapter is ______. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Medium'},
      {'question': 'Q. Calculate the numerical value using the formula from $chapter. (Given values) (2 marks)', 'type': 'Numerical', 'difficulty': 'Medium'},
      {'question': 'Q. Compare and contrast the concepts in $chapter with related topics in Physics. (5 marks)', 'type': 'Conceptual', 'difficulty': 'Hard'},
    ];
  }
  
  static List<Map<String, String>> _generateCBSEChemistryQuestions(String chapter, String description) {
    return [
      {'question': 'Q. Define the key terms in $chapter as per CBSE Chemistry syllabus. (2 marks)', 'type': 'Conceptual', 'difficulty': 'Easy'},
      {'question': 'Q. The main reaction type in $chapter is ______. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Easy'},
      {'question': 'Q. Write balanced chemical equations related to $chapter. (2 marks)', 'type': 'Numerical', 'difficulty': 'Medium'},
      {'question': 'Q. Explain the mechanism or process involved in $chapter with a suitable example. (3 marks)', 'type': 'Conceptual', 'difficulty': 'Medium'},
      {'question': 'Q. Calculate the numerical values based on $chapter formulas. (Given data) (3 marks)', 'type': 'Numerical', 'difficulty': 'Medium'},
      {'question': 'Q. The key concept in $chapter involves ______. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Medium'},
      {'question': 'Q. Solve a stoichiometry problem related to $chapter. (Given masses) (3 marks)', 'type': 'Numerical', 'difficulty': 'Hard'},
      {'question': 'Q. Compare and contrast different concepts in $chapter with examples. (5 marks)', 'type': 'Conceptual', 'difficulty': 'Hard'},
    ];
  }
  
  static List<Map<String, String>> _generateCBSEBiologyQuestions(String chapter, String description) {
    return [
      {'question': 'Q. Define the main biological terms in $chapter (CBSE Biology). (2 marks)', 'type': 'Conceptual', 'difficulty': 'Easy'},
      {'question': 'Q. The main biological process in $chapter is ______. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Easy'},
      {'question': 'Q. Explain the structure and function of key components in $chapter with labeled diagrams. (5 marks)', 'type': 'Conceptual', 'difficulty': 'Medium'},
      {'question': 'Q. Describe the process or mechanism involved in $chapter step by step. (3 marks)', 'type': 'Conceptual', 'difficulty': 'Medium'},
      {'question': 'Q. The key organelle involved in $chapter is the ______. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Medium'},
      {'question': 'Q. Differentiate between related concepts in $chapter with examples. (3 marks)', 'type': 'Conceptual', 'difficulty': 'Medium'},
      {'question': 'Q. Explain the importance of $chapter in biological systems. (5 marks)', 'type': 'Conceptual', 'difficulty': 'Hard'},
      {'question': 'Q. $chapter plays a crucial role in ______. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Hard'},
    ];
  }
  
  static List<Map<String, String>> _generateCBSEMathematicsQuestions(String chapter, String description) {
    return [
      {'question': 'Q. State the main theorem or formula in $chapter (CBSE Mathematics). (2 marks)', 'type': 'Conceptual', 'difficulty': 'Easy'},
      {'question': 'Q. The main formula in $chapter is ______. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Easy'},
      {'question': 'Q. Prove the key theorem or identity in $chapter. Show all steps. (5 marks)', 'type': 'Conceptual', 'difficulty': 'Hard'},
      {'question': 'Q. Solve the following problem based on $chapter: [Problem statement] (3 marks)', 'type': 'Numerical', 'difficulty': 'Medium'},
      {'question': 'Q. According to the theorem in $chapter, the result is ______. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Medium'},
      {'question': 'Q. Apply the concepts of $chapter to solve a real-world problem. (5 marks)', 'type': 'Application', 'difficulty': 'Hard'},
      {'question': 'Q. Find the solution to the numerical problem in $chapter. (Given values) (3 marks)', 'type': 'Numerical', 'difficulty': 'Medium'},
      {'question': 'Q. Calculate the value using $chapter formula. Show all calculations. (3 marks)', 'type': 'Numerical', 'difficulty': 'Hard'},
    ];
  }

  static String _generateSummary(String subject, String chapter, String description) {
    return '''
📋 **Quick Summary: $chapter**

**Main Topic:** ${description.isNotEmpty ? description : 'Core concepts of $chapter in $subject'}

**Key Takeaways:**
• This chapter introduces fundamental concepts
• Understanding these concepts is crucial for advanced topics
• Regular practice is essential for mastery
• Focus on both theory and problem-solving

**Exam Focus:**
• Important for board exams
• Frequently asked in competitive exams
• Forms basis for higher studies

**Next Steps:**
1. Complete all NCERT exercises
2. Solve additional practice questions
3. Revise regularly
4. Take mock tests
''';
  }

  static Map<String, dynamic> _getDefaultContent() {
    return {
      'overview': 'Content generation in progress...',
      'keyConcepts': [],
      'importantFormulas': [],
      'studyTips': [],
      'practiceQuestions': [],
      'summary': 'Please select a valid chapter.',
    };
  }
}

