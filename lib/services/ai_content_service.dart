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
    return [
      {
        'question': 'What is the main concept covered in this chapter?',
        'type': 'Conceptual',
        'difficulty': 'Easy',
      },
      {
        'question': 'Explain the key principles with examples.',
        'type': 'Descriptive',
        'difficulty': 'Medium',
      },
      {
        'question': 'Solve numerical problems based on formulas.',
        'type': 'Numerical',
        'difficulty': 'Hard',
      },
      {
        'question': 'Compare and contrast related concepts.',
        'type': 'Analytical',
        'difficulty': 'Medium',
      },
      {
        'question': 'Apply concepts to real-world scenarios.',
        'type': 'Application',
        'difficulty': 'Hard',
      },
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

