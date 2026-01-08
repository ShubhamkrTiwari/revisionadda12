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
      'practiceQuestions': generatePracticeQuestions(subject.name, chapter.name),
      'summary': _generateSummary(subject.name, chapter.name, chapter.description),
    };
  }

  static String _generateOverview(String subject, String chapter, String description) {
    // Generate detailed AI-powered overview
    String importance = '';
    String difficulty = 'Moderate';
    String studyTime = '4-6 hours';
    String approach = 'Start with theory, practice with examples, then solve problems';
    
    final subjectLower = subject.toLowerCase();
    final chapterLower = chapter.toLowerCase();
    
    if (subjectLower.contains('physics')) {
      if (chapterLower.contains('electric') && chapterLower.contains('charge')) {
        importance = 'This chapter is fundamental for understanding all electricity and magnetism topics. It introduces the concept of electric charge, which is the basis for current electricity, circuits, and electromagnetic phenomena. Mastery here is essential for advanced topics.';
        difficulty = 'Moderate to Hard';
        studyTime = '6-8 hours';
        approach = 'Start with charge properties, then Coulomb\'s law, practice vector addition, learn electric field concepts, master Gauss\'s law applications';
      } else if (chapterLower.contains('current') || chapterLower.contains('electricity')) {
        importance = 'Essential for understanding electrical circuits, which are fundamental in modern technology. This chapter connects electrostatics with practical applications. Required for electronics, power systems, and all electrical devices.';
        difficulty = 'Moderate';
        studyTime = '5-7 hours';
        approach = 'Master Ohm\'s law first, understand resistance, practice series-parallel circuits, learn Kirchhoff\'s laws, solve circuit problems systematically';
      }
    } else if (subjectLower.contains('chemistry')) {
      if (chapterLower.contains('solid state')) {
        importance = 'Fundamental for understanding materials science, semiconductor technology, and properties of solids. Essential for advanced chemistry and engineering applications. Connects atomic structure with bulk properties.';
        difficulty = 'Moderate';
        studyTime = '5-6 hours';
        approach = 'Visualize crystal structures, understand unit cells, practice packing efficiency calculations, learn coordination numbers, relate structure to properties';
      }
    } else if (subjectLower.contains('mathematics')) {
      if (chapterLower.contains('derivative') || chapterLower.contains('differentiation')) {
        importance = 'Core concept in calculus, essential for optimization, rate of change problems, and advanced mathematics. Foundation for integration, differential equations, and applications in physics and engineering.';
        difficulty = 'Moderate';
        studyTime = '6-8 hours';
        approach = 'Master definition first, learn all rules (power, product, quotient, chain), practice trigonometric and exponential derivatives, apply to problems, focus on applications';
      }
    }
    
    if (importance.isEmpty) {
      importance = 'This chapter builds the groundwork for understanding more advanced topics. Mastering these concepts will help you excel in exams and apply knowledge in real-world scenarios.';
    }
    
    return '''
📚 **Chapter Overview: $chapter**

This chapter is a fundamental part of $subject that covers essential concepts and principles essential for comprehensive understanding.

**What You'll Learn:**
${description.isNotEmpty ? description : 'Core concepts, important theories, mathematical relationships, practical applications, and problem-solving techniques that form the foundation of this topic. You will develop both conceptual understanding and analytical skills.'}

**Why It's Important:**
$importance

**Key Topics Covered:**
• Fundamental principles and laws
• Important definitions and terminology  
• Mathematical relationships and formulas
• Practical applications and real-world examples
• Problem-solving strategies and techniques
• Connections with other topics

**Difficulty Level:** $difficulty
**Estimated Study Time:** $studyTime
**Best Approach:** $approach

**Exam Weightage:** Typically 8-12 marks in board examinations
**Common Question Types:** Definitions (1-2 marks), Numerical problems (2-3 marks), Derivations (3-5 marks), Application-based questions (2-3 marks)
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
    final subjectLower = subject.toLowerCase();
    final chapterLower = chapter.toLowerCase();
    
    // Generate subject and chapter-specific study tips
    List<String> tips = [];
    
    if (subjectLower.contains('physics')) {
      tips = [
        '📖 **Read Actively**: Read the chapter twice - first for overview, second for details. Focus on understanding "why" not just "what". Physics requires conceptual clarity.',
        '📐 **Master Formulas**: Create a formula sheet. For each formula: write it, understand variables, know units, derive if possible, practice 5-10 problems. Understanding > memorization.',
        '🔬 **Visualize Concepts**: Draw diagrams for every concept - field lines, circuits, vectors. Visualization helps in understanding and remembering. Use different colors for different elements.',
        '⚡ **Practice Problems**: Solve 30-50 problems covering all difficulty levels. Start with NCERT examples, then previous year questions, then additional practice. Time yourself: 3-5 min per problem.',
        '✅ **Check Units**: Always convert to SI units before calculation. Common mistake: using cm instead of m, μC instead of C. Double-check units in final answer.',
        '📊 **Vector Operations**: For physics problems, master vector addition/subtraction. Draw vectors, resolve components, use trigonometry. Practice vector problems regularly.',
        '🔄 **Regular Revision**: Revise formulas daily for first week, then weekly. Create flashcards for quick revision. Review solved problems to reinforce methods.',
        '💡 **Connect Concepts**: Understand how concepts relate. For example: charge → field → potential → energy. Creating connections improves retention and understanding.',
        '🎯 **Exam Strategy**: Practice time-bound solving. 1-mark: 1 min, 2-3 marks: 3-4 min, 5 marks: 5-7 min. Leave 10-15 min for revision. Show all steps for full marks.',
        '📚 **NCERT First**: Complete NCERT thoroughly before additional resources. Most exam questions are based on NCERT concepts. Solve all in-text questions and exercises.',
      ];
    } else if (subjectLower.contains('chemistry')) {
      tips = [
        '📖 **Conceptual Understanding**: Chemistry requires understanding mechanisms, not just memorization. Focus on "how" and "why" reactions occur, not just "what" happens.',
        '🧪 **Practice Reactions**: Write chemical equations repeatedly. Balance equations correctly. Practice different types: combination, decomposition, displacement, redox reactions.',
        '📐 **Formula Mastery**: Create formula cards. For each: formula, variables, units, conditions, applications. Practice calculations: molarity, molality, equilibrium constants, etc.',
        '🔬 **Visual Learning**: Draw structures: Lewis structures, molecular geometry, crystal structures. Use 3D models if available. Visualization is crucial for organic and solid state chemistry.',
        '📊 **Periodic Trends**: Understand periodic table trends: atomic size, ionization energy, electronegativity. Create charts and practice predicting properties.',
        '⚗️ **Stoichiometry Practice**: Master mole concept and stoichiometric calculations. Practice: limiting reactant, percentage yield, empirical/molecular formula. These are frequently asked.',
        '✅ **Regular Practice**: Solve 20-30 problems daily. Focus on: calculations, balancing equations, structure drawing, mechanism understanding. Chemistry improves with practice.',
        '🔄 **Revision Strategy**: Revise reactions weekly. Create reaction summary sheets. Group similar reactions. Understand mechanisms to remember products.',
        '💡 **Real-World Connection**: Relate concepts to daily life: rusting (corrosion), cooking (reactions), cleaning (acids/bases). This improves retention and interest.',
        '🎯 **Exam Tips**: Show balanced equations clearly. Include units in calculations. Draw structures neatly. For mechanisms, show electron movement. Practice time management.',
      ];
    } else if (subjectLower.contains('mathematics')) {
      tips = [
        '📖 **Understand First**: Don\'t memorize formulas blindly. Understand derivation, geometric meaning, and conditions. Mathematics is about understanding patterns and relationships.',
        '📐 **Practice Daily**: Mathematics requires daily practice. Solve 15-20 problems daily. Start with easy, progress to medium, then hard. Regular practice is key to mastery.',
        '✍️ **Show All Steps**: Always show complete solutions. This helps in: (1) Finding mistakes, (2) Getting partial marks, (3) Understanding process, (4) Building confidence.',
        '🔢 **Check Answers**: Always verify answers. Methods: substitute back, use alternative method, check reasonableness, use calculator for verification. Develop checking habit.',
        '📊 **Problem Types**: Practice all types: direct application, word problems, proofs, applications. Don\'t avoid difficult problems - they build problem-solving skills.',
        '⏰ **Time Management**: Practice time-bound solving. Easy: 2-3 min, Medium: 4-5 min, Hard: 6-8 min. Develop speed without sacrificing accuracy.',
        '🔄 **Regular Revision**: Revise formulas weekly. Create formula sheet. Practice from it without looking. Regular revision prevents forgetting.',
        '💡 **Multiple Methods**: Learn alternative methods. Sometimes substitution is easier than direct calculation. Having multiple approaches increases problem-solving flexibility.',
        '📚 **NCERT Focus**: Complete NCERT thoroughly. Most exam questions are NCERT-based. Solve all examples, exercises, and miscellaneous questions. Understand each step.',
        '🎯 **Exam Strategy**: Read problem twice. Identify given and required. Choose method. Solve step-by-step. Verify answer. Show work clearly. Manage time effectively.',
      ];
    } else {
      // Biology or default tips
      tips = [
        '📖 **Read & Understand**: Biology requires understanding processes, not just memorization. Focus on mechanisms, relationships, and significance. Read actively, not passively.',
        '🔬 **Draw Diagrams**: Draw labeled diagrams for every structure and process. Drawing helps in: understanding, remembering, and scoring marks. Practice drawing from memory.',
        '📊 **Process Understanding**: Understand step-by-step processes: photosynthesis, respiration, reproduction, etc. Create flowcharts. Know what happens at each step and why.',
        '🔗 **Make Connections**: Connect concepts: structure → function, process → significance, mechanism → application. Understanding relationships improves retention.',
        '📝 **Terminology Mastery**: Learn scientific terms with meanings. Create flashcards. Practice spelling correctly. Many marks lost due to spelling errors in biological terms.',
        '✅ **Regular Revision**: Biology has lots of information. Revise daily for first week, then weekly. Use spaced repetition. Review diagrams regularly.',
        '💡 **Real Examples**: Relate to real-world: diseases, agriculture, environment, daily life. Examples help in understanding and remembering. CBSE often asks application-based questions.',
        '🔄 **Practice Questions**: Solve previous year questions. Focus on: definitions, diagrams, processes, applications. Practice time-bound solving for exam preparation.',
        '📚 **NCERT Priority**: NCERT is most important. Read thoroughly. Understand each diagram. Solve all questions. Most exam questions are directly or indirectly from NCERT.',
        '🎯 **Exam Strategy**: For diagrams: draw neatly, label clearly, add details. For processes: write step-by-step, mention significance. Show all steps for full marks.',
      ];
    }
    
    // Add chapter-specific tips if needed
    if (chapterLower.contains('derivative') || chapterLower.contains('differentiation')) {
      tips.add('⚡ **Chain Rule Mastery**: Chain rule is crucial. Practice composite functions. Break complex functions into simpler parts. Common mistake: forgetting to multiply by inner derivative.');
      tips.add('📐 **Applications Focus**: Derivatives have many applications. Practice: rate of change, optimization, curve sketching. These are frequently asked in exams.');
    }
    
    return tips;
  }

  static List<Map<String, String>> generatePracticeQuestions(String subject, String chapter) {
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
          {'question': 'Q. Three point charges +q, +q, and -2q are placed at vertices of an equilateral triangle. Find the net force on one of the +q charges. (3 marks)', 'type': 'Numerical', 'difficulty': 'Hard'},
          {'question': 'Q. What is the electric field at a point on the perpendicular bisector of an electric dipole? Derive the expression. (5 marks)', 'type': 'Derivation', 'difficulty': 'Hard'},
          {'question': 'Q. Explain the concept of electric flux. How is it related to Gauss\'s law? (3 marks)', 'type': 'Conceptual', 'difficulty': 'Medium'},
          {'question': 'Q. A charge of 10μC is placed at the center of a cube of side 10cm. Calculate the electric flux through one face of the cube. (3 marks)', 'type': 'Numerical', 'difficulty': 'Medium'},
          {'question': 'Q. Define electric potential. How is it related to electric field? (2 marks)', 'type': 'Conceptual', 'difficulty': 'Medium'},
          {'question': 'Q. Calculate the electric potential at a distance of 0.2m from a point charge of 5μC. (2 marks)', 'type': 'Numerical', 'difficulty': 'Easy'},
          {'question': 'Q. What is the work done in moving a charge of 2μC from infinity to a point at potential 100V? (2 marks)', 'type': 'Numerical', 'difficulty': 'Easy'},
          {'question': 'Q. Explain the principle of superposition for electric potential. (2 marks)', 'type': 'Conceptual', 'difficulty': 'Medium'},
          {'question': 'Q. Derive the expression for electric field due to an infinite line charge using Gauss\'s law. (5 marks)', 'type': 'Derivation', 'difficulty': 'Hard'},
          {'question': 'Q. Two charges of +4μC and -6μC are placed 20cm apart. Find the point where electric field is zero. (3 marks)', 'type': 'Numerical', 'difficulty': 'Hard'},
          {'question': 'Q. What is the electric field inside a uniformly charged spherical shell? Justify your answer. (3 marks)', 'type': 'Conceptual', 'difficulty': 'Medium'},
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
          {'question': 'Q. Explain the working principle of a potentiometer. Why is it more accurate than a voltmeter? (3 marks)', 'type': 'Conceptual', 'difficulty': 'Medium'},
          {'question': 'Q. A cell of EMF 2V and internal resistance 0.5Ω is connected to a resistor of 3.5Ω. Calculate the current and terminal voltage. (3 marks)', 'type': 'Numerical', 'difficulty': 'Medium'},
          {'question': 'Q. Derive the expression for equivalent resistance of resistors in parallel. (3 marks)', 'type': 'Derivation', 'difficulty': 'Medium'},
          {'question': 'Q. What is the effect of temperature on resistance of a conductor? Explain with formula. (2 marks)', 'type': 'Conceptual', 'difficulty': 'Medium'},
          {'question': 'Q. Three cells of EMF 1.5V each and internal resistance 0.2Ω are connected in series. Find the total EMF and internal resistance. (2 marks)', 'type': 'Numerical', 'difficulty': 'Easy'},
          {'question': 'Q. Explain the difference between EMF and terminal voltage. (2 marks)', 'type': 'Conceptual', 'difficulty': 'Easy'},
          {'question': 'Q. A 100W bulb operates at 220V. Calculate its resistance and current. (2 marks)', 'type': 'Numerical', 'difficulty': 'Easy'},
          {'question': 'Q. What is the maximum power transfer theorem? State the condition. (2 marks)', 'type': 'Conceptual', 'difficulty': 'Medium'},
          {'question': 'Q. Calculate the equivalent resistance between points A and B in a given complex circuit. (5 marks)', 'type': 'Numerical', 'difficulty': 'Hard'},
          {'question': 'Q. Explain the concept of drift velocity of electrons in a conductor. (2 marks)', 'type': 'Conceptual', 'difficulty': 'Medium'},
          {'question': 'Q. A wire of length L and resistance R is cut into n equal parts. If these parts are connected in parallel, find the equivalent resistance. (3 marks)', 'type': 'Numerical', 'difficulty': 'Medium'},
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
    ];
  }
  
  static List<Map<String, String>> _generateCBSEChemistryQuestions(String chapter, String description) {
    return [
      // Chemical Reactions and Equations
      {'question': 'Q. What is a chemical equation? Why is it necessary to balance a chemical equation? (2 marks)', 'type': 'Conceptual', 'difficulty': 'Easy'},
      {'question': 'Q. Balance the following chemical equation: Fe + H₂O → Fe₃O₄ + H₂ (2 marks)', 'type': 'Numerical', 'difficulty': 'Medium'},
      {'question': 'Q. The process of gain of oxygen or loss of hydrogen is called ______. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Easy'},
      
      // Acids, Bases and Salts
      {'question': 'Q. What is the pH scale? What is the pH of a neutral solution? (2 marks)', 'type': 'Conceptual', 'difficulty': 'Easy'},
      {'question': 'Q. A solution turns red litmus blue. The pH of the solution is likely to be ______. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Easy'},
      {'question': 'Q. What happens when an acid reacts with a metal carbonate? Write the chemical equation. (3 marks)', 'type': 'Conceptual', 'difficulty': 'Medium'},
      
      // Metals and Non-metals
      {'question': 'Q. What are the main physical properties of metals and non-metals? (2 marks)', 'type': 'Conceptual', 'difficulty': 'Easy'},
      {'question': 'Q. The most reactive metal is ______ while the most reactive non-metal is ______. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Medium'},
      {'question': 'Q. Explain the process of electrolytic refining of copper with a neat labeled diagram. (5 marks)', 'type': 'Conceptual', 'difficulty': 'Hard'},
      
      // Carbon and its Compounds
      {'question': 'Q. What is a homologous series? Give one example. (2 marks)', 'type': 'Conceptual', 'difficulty': 'Medium'},
      {'question': 'Q. The functional group present in alcohols is ______. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Easy'},
      {'question': 'Q. Draw the electron dot structure of ethane (C₂H₆) and ethene (C₂H₄). (3 marks)', 'type': 'Numerical', 'difficulty': 'Medium'},
      
      // Periodic Classification of Elements
      {'question': 'Q. State Mendeleev\'s Periodic Law. (2 marks)', 'type': 'Conceptual', 'difficulty': 'Easy'},
      {'question': 'Q. In the modern periodic table, elements are arranged in order of their ______ numbers. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Easy'},
      {'question': 'Q. How does the valency of elements vary in a period and in a group? (3 marks)', 'type': 'Conceptual', 'difficulty': 'Hard'},
      
      // Chemical Bonding
      {'question': 'Q. What is an ionic bond? Give an example. (2 marks)', 'type': 'Conceptual', 'difficulty': 'Medium'},
      {'question': 'Q. The bond formed by sharing of electrons is called a ______ bond. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Easy'},
      {'question': 'Q. Explain the formation of a double bond in an oxygen molecule. (3 marks)', 'type': 'Conceptual', 'difficulty': 'Hard'},
      
      // States of Matter
      {'question': 'Q. What is the effect of temperature on the rate of diffusion? (2 marks)', 'type': 'Conceptual', 'difficulty': 'Easy'},
      {'question': 'Q. The process by which a solid changes directly into vapor is called ______. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Medium'}
    ];
  }
  
  static List<Map<String, String>> _generateCBSEBiologyQuestions(String chapter, String description) {
    return [
      // Life Processes
      {'question': 'Q. What are the basic life processes common to all living organisms? (2 marks)', 'type': 'Conceptual', 'difficulty': 'Easy'},
      {'question': 'Q. The process of taking in food and its utilization by the body is called ______. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Easy'},
      {'question': 'Q. Explain the process of photosynthesis with a labeled diagram. (5 marks)', 'type': 'Conceptual', 'difficulty': 'Medium'},
      
      // Control and Coordination
      {'question': 'Q. What is a reflex action? Explain with an example. (2 marks)', 'type': 'Conceptual', 'difficulty': 'Easy'},
      {'question': 'Q. The gap between two neurons is called a ______. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Easy'},
      {'question': 'Q. Draw a neat labeled diagram of a neuron and explain its structure. (3 marks)', 'type': 'Conceptual', 'difficulty': 'Medium'},
      
      // How do Organisms Reproduce
      {'question': 'Q. Differentiate between sexual and asexual reproduction with examples. (3 marks)', 'type': 'Conceptual', 'difficulty': 'Medium'},
      {'question': 'Q. The process of fusion of male and female gametes is called ______. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Easy'},
      {'question': 'Q. Explain the process of binary fission in Amoeba with diagrams. (5 marks)', 'type': 'Conceptual', 'difficulty': 'Medium'},
      
      // Heredity and Evolution
      {'question': 'Q. What is meant by the term \'evolution\'? (2 marks)', 'type': 'Conceptual', 'difficulty': 'Easy'},
      {'question': 'Q. The study of heredity and variation is called ______. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Easy'},
      {'question': 'Q. Explain Mendel\'s law of inheritance with a monohybrid cross. (5 marks)', 'type': 'Conceptual', 'difficulty': 'Hard'},
      
      // Our Environment
      {'question': 'Q. What is an ecosystem? List its main components. (2 marks)', 'type': 'Conceptual', 'difficulty': 'Easy'},
      {'question': 'Q. The flow of energy in a food chain is ______. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Easy'},
      {'question': 'Q. Explain the role of decomposers in an ecosystem. (3 marks)', 'type': 'Conceptual', 'difficulty': 'Medium'},
      
      // Management of Natural Resources
      {'question': 'Q. Why should we conserve forests and wildlife? (2 marks)', 'type': 'Conceptual', 'difficulty': 'Easy'},
      {'question': 'Q. The three R\'s to save the environment are ______, ______, and ______. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Easy'},
      {'question': 'Q. Explain the concept of sustainable development with examples. (5 marks)', 'type': 'Conceptual', 'difficulty': 'Hard'},
      
      // Human Health and Disease
      {'question': 'Q. What are communicable diseases? Give two examples. (2 marks)', 'type': 'Conceptual', 'difficulty': 'Easy'},
      {'question': 'Q. The disease caused by the bite of a female Anopheles mosquito is ______. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Medium'}
    ];
  }
  
  static List<Map<String, String>> _generateCBSEMathematicsQuestions(String chapter, String description) {
    return [
      // Real Numbers
      {'question': 'Q. State Euclid\'s division lemma. (2 marks)', 'type': 'Conceptual', 'difficulty': 'Easy'},
      {'question': 'Q. The decimal expansion of a rational number is either ______ or ______. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Easy'},
      {'question': 'Q. Use Euclid\'s division algorithm to find the HCF of 135 and 225. (3 marks)', 'type': 'Numerical', 'difficulty': 'Medium'},
      
      // Polynomials
      {'question': 'Q. What is the degree of the polynomial 4x³ + 2x² - 5x + 1? (1 mark)', 'type': 'Numerical', 'difficulty': 'Easy'},
      {'question': 'Q. The zeroes of the polynomial x² - 2x - 8 are ______ and ______. (2 marks)', 'type': 'Numerical', 'difficulty': 'Medium'},
      {'question': 'Q. If α and β are the zeroes of the polynomial x² - 5x + 6, find the value of α² + β². (3 marks)', 'type': 'Numerical', 'difficulty': 'Hard'},
      
      // Pair of Linear Equations in Two Variables
      {'question': 'Q. What is the condition for a pair of linear equations to be consistent? (2 marks)', 'type': 'Conceptual', 'difficulty': 'Easy'},
      {'question': 'Q. The pair of equations x + 2y = 5 and 3x + 6y = 15 is ______. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Medium'},
      {'question': 'Q. Solve the following pair of equations: 2x + 3y = 11 and 2x - 4y = -24. (3 marks)', 'type': 'Numerical', 'difficulty': 'Medium'},
      
      // Quadratic Equations
      {'question': 'Q. What is the standard form of a quadratic equation? (1 mark)', 'type': 'Conceptual', 'difficulty': 'Easy'},
      {'question': 'Q. The nature of roots of the equation x² - 4x + 4 = 0 is ______. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Easy'},
      {'question': 'Q. Find the roots of the quadratic equation 2x² - 5x + 3 = 0 by factorization. (3 marks)', 'type': 'Numerical', 'difficulty': 'Medium'},
      
      // Arithmetic Progressions
      {'question': 'Q. What is the common difference of the AP: 5, 2, -1, -4, ...? (1 mark)', 'type': 'Numerical', 'difficulty': 'Easy'},
      {'question': 'Q. The sum of first n natural numbers is given by the formula ______. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Easy'},
      {'question': 'Q. Find the 10th term of the AP: 3, 8, 13, 18, ... (2 marks)', 'type': 'Numerical', 'difficulty': 'Medium'},
      
      // Triangles
      {'question': 'Q. State the Basic Proportionality (Thales) Theorem. (2 marks)', 'type': 'Conceptual', 'difficulty': 'Easy'},
      {'question': 'Q. In two similar triangles, the ratio of their areas is equal to the square of the ratio of their corresponding ______. (1 mark)', 'type': 'FillInTheBlanks', 'difficulty': 'Medium'},
      {'question': 'Q. In a triangle ABC, if DE || BC and AD/DB = 3/5, find AE/EC. (3 marks)', 'type': 'Numerical', 'difficulty': 'Hard'},
      
      // Coordinate Geometry
      {'question': 'Q. Find the distance between the points (2, 3) and (5, 7). (2 marks)', 'type': 'Numerical', 'difficulty': 'Easy'},
      {'question': 'Q. The coordinates of the mid-point of the line segment joining (4, -3) and (8, 5) are ______. (1 mark)', 'type': 'Numerical', 'difficulty': 'Medium'}
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

