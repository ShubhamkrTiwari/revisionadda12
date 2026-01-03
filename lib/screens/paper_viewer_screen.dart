import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../services/data_service.dart';

class PaperViewerScreen extends StatelessWidget {
  final Chapter? chapter; // Optional - for chapter-specific papers
  final Subject? subject; // Optional - for subject-level papers
  final String paperType; // '90match' or 'previous'
  final String subjectName;
  final int? year; // Year for previous year papers (2019-2026)

  const PaperViewerScreen({
    super.key,
    this.chapter,
    this.subject,
    required this.paperType,
    required this.subjectName,
    this.year,
  }) : assert(chapter != null || subject != null, 'Either chapter or subject must be provided');

  // Helper methods
  String get _paperName => subject?.name ?? chapter?.name ?? subjectName;
  String get _subjectId => subject?.id ?? chapter?.subjectId ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          paperType == '90match'
              ? '90% Match Paper - ${subject?.name ?? chapter?.name ?? subjectName}'
              : year != null
                  ? 'CBSE Board Exam $year - ${subject?.name ?? chapter?.name ?? subjectName}'
                  : 'Previous Year Paper - ${subject?.name ?? chapter?.name ?? subjectName}',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // TODO: Download paper
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Share paper
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Paper Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: paperType == '90match'
                      ? [Colors.orange.shade400, Colors.orange.shade600]
                      : [Colors.blue.shade400, Colors.blue.shade600],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          paperType == '90match'
                              ? Icons.verified
                              : Icons.history,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              paperType == '90match'
                                  ? '90% Match Paper'
                                  : year != null
                                      ? 'CBSE Board Exam $year'
                                      : 'Previous Year Paper',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$_paperName - $subjectName',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildInfoChip(
                        Icons.access_time,
                        '180 Minutes (3 Hours)',
                        Colors.white,
                      ),
                      const SizedBox(width: 8),
                      _buildInfoChip(
                        Icons.quiz,
                        '${_getQuestionCount()} Questions',
                        Colors.white,
                      ),
                      const SizedBox(width: 8),
                      _buildInfoChip(
                        Icons.star,
                        paperType == '90match' 
                            ? '90% Match' 
                            : year != null 
                                ? 'PYQ $year' 
                                : 'PYQ',
                        Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Instructions
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Instructions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInstruction('Total Marks: 115 (Section A: 20×1, Section B: 10×2, Section C: 10×3, Section D: 5×4, Section E: 5×5)'),
                    _buildInstruction('Time Allotted: 180 minutes (3 hours)'),
                    _buildInstruction('All questions are compulsory'),
                    if (paperType == 'previous' && year != null)
                      _buildInstruction('All questions are subjective (no multiple choice)')
                    else
                      _buildInstruction('Section A contains multiple choice questions'),
                    _buildInstruction('Read each question carefully before answering'),
                    _buildInstruction('Mark your answers clearly'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Questions Section
            const Text(
              'Questions',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ..._buildQuestionsWithSections(),
            const SizedBox(height: 24),
            // Answer Key Section
            Card(
              elevation: 2,
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green.shade700),
                        const SizedBox(width: 8),
                        const Text(
                          'Answer Key',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ..._generateAnswerKey().entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Text(
                              'Q${entry.key}: ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.green),
                              ),
                              child: Text(
                                entry.value,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Solutions Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showSolutions(context);
                },
                icon: const Icon(Icons.visibility),
                label: const Text('View Detailed Solutions'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstruction(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildQuestionsWithSections() {
    final questions = _generateQuestions();
    final isPreviousYear = paperType == 'previous' && year != null;
    final widgets = <Widget>[];

    if (isPreviousYear) {
      // Group questions by section
      String? currentSection;
      for (int i = 0; i < questions.length; i++) {
        final question = questions[i];
        final section = question['section'] as String?;
        
        // Add section header if section changed
        if (section != null && section != currentSection) {
          currentSection = section;
          widgets.add(_buildSectionHeader(section, _getSectionInfo(section)));
          widgets.add(const SizedBox(height: 8));
        }
        
        widgets.add(_buildQuestionCard(i + 1, question));
      }
    } else {
      // For 90% match papers, show questions normally
      for (int i = 0; i < questions.length; i++) {
        widgets.add(_buildQuestionCard(i + 1, questions[i]));
      }
    }

    return widgets;
  }

  Map<String, String> _getSectionInfo(String section) {
    switch (section) {
      case 'A':
        return {'title': 'Section A', 'subtitle': 'Very Short Answer Type Questions (1 mark each)', 'range': 'Q. No. 1 to 20'};
      case 'B':
        return {'title': 'Section B', 'subtitle': 'Short Answer Type Questions (2 marks each)', 'range': 'Q. No. 21 to 30'};
      case 'C':
        return {'title': 'Section C', 'subtitle': 'Long Answer Type I Questions (3 marks each)', 'range': 'Q. No. 31 to 40'};
      case 'D':
        return {'title': 'Section D', 'subtitle': 'Long Answer Type II Questions (4 marks each)', 'range': 'Q. No. 41 to 45'};
      case 'E':
        return {'title': 'Section E', 'subtitle': 'Case-based/Integrated Questions (5 marks each)', 'range': 'Q. No. 46 to 50'};
      default:
        return {'title': 'Section $section', 'subtitle': '', 'range': ''};
    }
  }

  Widget _buildSectionHeader(String section, Map<String, String> info) {
    return Container(
      margin: const EdgeInsets.only(top: 24, bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade600,
            Colors.blue.shade400,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              section,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info['title']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  info['subtitle']!,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                if (info['range']!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    info['range']!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.8),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(int questionNum, Map<String, dynamic> question) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    question['section'] != null 
                        ? 'Q$questionNum (Section ${question['section']})'
                        : 'Question $questionNum',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${question['marks']} Marks',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              question['question'],
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            if (question['options'] != null) ...[
              const SizedBox(height: 16),
              const Text(
                'Options:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
                  ...question['options']!.asMap().entries.map((entry) {
                    final optIndex = entry.key as int;
                    final option = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue.shade100,
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + optIndex), // A, B, C, D
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                              ),
                            ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            option,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
            if (question['subQuestions'] != null) ...[
              const SizedBox(height: 12),
              ...question['subQuestions']!.asMap().entries.map((entry) {
                final subIndex = entry.key as int;
                final subQ = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12, left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '(${String.fromCharCode(97 + subIndex)}) ${subQ['question']}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (subQ['options'] != null) ...[
                        const SizedBox(height: 8),
                        ...subQ['options']!.asMap().entries.map((optEntry) {
                          final optKey = optEntry.key as int;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4, left: 16),
                            child: Text(
                              '${String.fromCharCode(65 + optKey)}) ${optEntry.value}',
                              style: const TextStyle(fontSize: 13),
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  int _getQuestionCount() {
    return 50; // Both 90% match and previous year papers have 50 questions (CBSE 2026 pattern)
  }

  List<Map<String, dynamic>> _generateQuestions() {
    final subjectId = _subjectId;
    final questions = <Map<String, dynamic>>[];
    
    final is90Match = paperType == '90match';
    final isPreviousYear = paperType == 'previous' && year != null;
    
    if (isPreviousYear) {
      // Previous year papers: Exact CBSE 2026 Exam Pattern - 50 Questions
      // Section A - Very Short Answer (1 mark) - 20 questions (Q1-Q20)
      for (int i = 1; i <= 20; i++) {
        questions.add({
          'question': _generateVeryShortAnswer(subjectId, i),
          'section': 'A',
          'marks': 1,
        });
      }

      // Section B - Short Answer (2 marks) - 10 questions (Q21-Q30)
      for (int i = 21; i <= 30; i++) {
        questions.add({
          'question': _generateShortAnswer(subjectId, i),
          'section': 'B',
          'marks': 2,
        });
      }

      // Section C - Long Answer I (3 marks) - 10 questions (Q31-Q40)
      for (int i = 31; i <= 40; i++) {
        questions.add({
          'question': _generateLongAnswer(subjectId, i),
          'section': 'C',
          'marks': 3,
        });
      }

      // Section D - Long Answer II (4 marks) - 5 questions (Q41-Q45)
      for (int i = 41; i <= 45; i++) {
        questions.add({
          'question': _generateLongAnswerII(subjectId, i),
          'section': 'D',
          'marks': 4,
        });
      }

      // Section E - Case-based/Integrated (5 marks) - 5 questions (Q46-Q50)
      for (int i = 46; i <= 50; i++) {
        questions.add({
          'question': _generateCaseBasedQuestion(subjectId, i),
          'section': 'E',
          'marks': 5,
          'subQuestions': _generateCaseSubQuestions(subjectId),
        });
      }
    } else {
      // 90% Match papers: Exact CBSE 2026 Exam Pattern - 50 Questions
      // Section A - MCQs (1 mark) - 20 questions (Q1-Q20)
      for (int i = 1; i <= 20; i++) {
        questions.add({
          'question': _generateMCQ(subjectId, i),
          'options': _generateOptions(subjectId),
          'section': 'A',
          'marks': 1,
        });
      }

      // Section B - Short Answer (2 marks) - 10 questions (Q21-Q30)
      for (int i = 21; i <= 30; i++) {
        questions.add({
          'question': _generateShortAnswer(subjectId, i),
          'section': 'B',
          'marks': 2,
        });
      }

      // Section C - Long Answer I (3 marks) - 10 questions (Q31-Q40)
      for (int i = 31; i <= 40; i++) {
        questions.add({
          'question': _generateLongAnswer(subjectId, i),
          'section': 'C',
          'marks': 3,
        });
      }

      // Section D - Long Answer II (4 marks) - 5 questions (Q41-Q45)
      for (int i = 41; i <= 45; i++) {
        questions.add({
          'question': _generateLongAnswerII(subjectId, i),
          'section': 'D',
          'marks': 4,
        });
      }

      // Section E - Very Long Answer/Case-based (5 marks) - 5 questions (Q46-Q50)
      for (int i = 46; i <= 50; i++) {
        questions.add({
          'question': _generateVeryLongAnswer(subjectId, i),
          'section': 'E',
          'marks': 5,
          'subQuestions': _generateSubQuestions(subjectId),
        });
      }
    }

    return questions;
  }

  String _generateMCQ(String subjectId, int num) {
    final topics = _getChapterTopics();
    final topic = topics[num % topics.length];
    final is90Match = paperType == '90match';
    
    if (is90Match) {
      return _generateExamLikeMCQ(subjectId, num, topic);
    }
    
    return 'Q$num. ${topic} is related to which of the following concepts in $_paperName?';
  }

  String _generateExamLikeMCQ(String subjectId, int num, String topic) {
    final templates = _getMCQTemplates(subjectId, topic);
    final template = templates[num % templates.length];
    return template.replaceAll('\$num', '$num');
  }

  List<String> _getMCQTemplates(String subjectId, String topic) {
    if (subjectId == 'physics') {
      return [
        'Q\$num. Which of the following statements is correct regarding $topic?',
        'Q\$num. In the context of $topic, which principle is being applied?',
        'Q\$num. What is the relationship between $topic and the given scenario?',
        'Q\$num. Which formula correctly represents $topic?',
        'Q\$num. What happens to $topic when the given conditions change?',
        'Q\$num. Which law or principle governs $topic?',
        'Q\$num. What is the SI unit of $topic?',
        'Q\$num. In $topic, which factor determines the magnitude?',
        'Q\$num. What is the direction of $topic in the given situation?',
        'Q\$num. Which statement best describes $topic?',
      ];
    } else if (subjectId == 'chemistry') {
      return [
        'Q\$num. Which of the following is correct about $topic?',
        'Q\$num. In $topic, what is the correct order or sequence?',
        'Q\$num. Which reaction type is involved in $topic?',
        'Q\$num. What is the product formed in $topic?',
        'Q\$num. Which reagent is used for $topic?',
        'Q\$num. What is the mechanism involved in $topic?',
        'Q\$num. Which statement is true regarding $topic?',
        'Q\$num. What is the IUPAC name for $topic?',
        'Q\$num. Which property is characteristic of $topic?',
        'Q\$num. What is the correct formula for $topic?',
      ];
    } else if (subjectId == 'mathematics') {
      return [
        'Q\$num. What is the value of $topic?',
        'Q\$num. Which of the following is the derivative of $topic?',
        'Q\$num. What is the integral of $topic?',
        'Q\$num. Which theorem applies to $topic?',
        'Q\$num. What is the solution of $topic?',
        'Q\$num. Which property is used in $topic?',
        'Q\$num. What is the limit of $topic?',
        'Q\$num. Which formula is correct for $topic?',
        'Q\$num. What is the domain of $topic?',
        'Q\$num. Which statement is true about $topic?',
      ];
    } else {
      return [
        'Q\$num. Which of the following is correct about $topic?',
        'Q\$num. What is the function of $topic?',
        'Q\$num. Which process is involved in $topic?',
        'Q\$num. What is the location of $topic?',
        'Q\$num. Which statement describes $topic correctly?',
        'Q\$num. What is the significance of $topic?',
        'Q\$num. Which type is $topic?',
        'Q\$num. What is the role of $topic?',
        'Q\$num. Which condition is associated with $topic?',
        'Q\$num. What is the mechanism of $topic?',
      ];
    }
  }

  List<String> _generateOptions(String subjectId) {
    final topics = _getChapterTopics();
    final is90Match = paperType == '90match';
    
    if (is90Match) {
      // Generate more realistic options from subject topics
      final allTopics = _getSubjectLevelTopics(subjectId);
      return [
        'Option A: ${allTopics[(DateTime.now().millisecond) % allTopics.length]}',
        'Option B: ${allTopics[(DateTime.now().millisecond + 1) % allTopics.length]}',
        'Option C: ${allTopics[(DateTime.now().millisecond + 2) % allTopics.length]}',
        'Option D: ${allTopics[(DateTime.now().millisecond + 3) % allTopics.length]}',
      ];
    }
    
    return [
      'Option A: ${_getRandomConcept()}',
      'Option B: ${_getRandomConcept()}',
      'Option C: ${_getRandomConcept()}',
      'Option D: ${_getRandomConcept()}',
    ];
  }

  // Section A - Very Short Answer (1 mark)
  String _generateVeryShortAnswer(String subjectId, int num) {
    final topics = _getChapterTopics();
    final topic = topics[(num - 1) % topics.length];
    final questions = _getVeryShortAnswerQuestions(subjectId, topic);
    return questions[(num - 1) % questions.length];
  }

  // Section B - Short Answer (2 marks) - Q21-Q30
  String _generateShortAnswer(String subjectId, int num) {
    final topics = _getChapterTopics();
    final topic = topics[(num - 21) % topics.length];
    final questions = _getShortAnswerQuestions(subjectId, topic);
    return questions[(num - 21) % questions.length];
  }

  // Section C - Long Answer I (3 marks) - Q31-Q40
  String _generateLongAnswer(String subjectId, int num) {
    final topics = _getChapterTopics();
    final topic = topics[(num - 31) % topics.length];
    final questions = _getLongAnswerQuestions(subjectId, topic);
    return questions[(num - 31) % questions.length];
  }

  // Section D - Long Answer II (4 marks) - Q41-Q45
  String _generateLongAnswerII(String subjectId, int num) {
    final topics = _getChapterTopics();
    final topic = topics[(num - 41) % topics.length];
    final questions = _getLongAnswerIIQuestions(subjectId, topic);
    return questions[(num - 41) % questions.length];
  }

  // Section E - Case-based Question (5 marks) - Q46-Q50
  String _generateCaseBasedQuestion(String subjectId, int num) {
    final topics = _getChapterTopics();
    final topic = topics[(num - 46) % topics.length];
    return _getCaseBasedQuestionText(subjectId, topic);
  }

  String _generateVeryLongAnswer(String subjectId, int num) {
    final topics = _getChapterTopics();
    return 'Q$num. Answer the following questions related to $_paperName:';
  }

  List<Map<String, dynamic>> _generateSubQuestions(String subjectId) {
    return [
      {
        'question': 'Explain the main concept with examples.',
        'options': null,
      },
      {
        'question': 'Discuss its applications and importance.',
        'options': null,
      },
    ];
  }

  List<Map<String, dynamic>> _generateCaseSubQuestions(String subjectId) {
    // Case-based questions (5 marks) have 3-4 sub-questions
    return [
      {
        'question': 'Based on the given case study, explain the key concept involved.',
        'options': null,
      },
      {
        'question': 'Analyze the situation and provide your detailed reasoning.',
        'options': null,
      },
      {
        'question': 'What are the implications and applications of this case?',
        'options': null,
      },
      {
        'question': 'Draw a conclusion based on your analysis.',
        'options': null,
      },
    ];
  }

  // Helper methods for CBSE-style questions
  List<String> _getVeryShortAnswerQuestions(String subjectId, String topic) {
    if (subjectId == 'physics') {
      return [
        'Define $topic.',
        'State the SI unit of $topic.',
        'What is the formula for $topic?',
        'Name the principle related to $topic.',
        'Give one example of $topic.',
        'What does $topic represent?',
        'State the law governing $topic.',
        'Define the term $topic.',
        'What is $topic?',
        'State one application of $topic.',
      ];
    } else if (subjectId == 'chemistry') {
      return [
        'Define $topic.',
        'What is $topic?',
        'State the formula for $topic.',
        'Name the type of reaction: $topic.',
        'Give one example of $topic.',
        'What is the unit of $topic?',
        'State the law related to $topic.',
        'Define $topic with one example.',
        'What does $topic indicate?',
        'Name one application of $topic.',
      ];
    } else if (subjectId == 'mathematics') {
      return [
        'Find the value of $topic.',
        'State the formula for $topic.',
        'What is $topic?',
        'Define $topic.',
        'Evaluate $topic.',
        'State the theorem related to $topic.',
        'What is the derivative of $topic?',
        'Find the integral of $topic.',
        'State the property of $topic.',
        'What does $topic represent?',
      ];
    } else {
      return [
        'Define $topic.',
        'What is $topic?',
        'Name the process: $topic.',
        'State one function of $topic.',
        'Give one example of $topic.',
        'What is the role of $topic?',
        'Define the term $topic.',
        'State the importance of $topic.',
        'What does $topic indicate?',
        'Name one application of $topic.',
      ];
    }
  }

  List<String> _getShortAnswerQuestions(String subjectId, String topic) {
    if (subjectId == 'physics') {
      return [
        'Explain $topic with suitable examples.',
        'Derive the expression for $topic.',
        'State and explain $topic.',
        'What is $topic? Explain its significance.',
        'Discuss the principle of $topic.',
        'Explain $topic and give one application.',
        'State $topic and explain with diagram.',
        'What is $topic? How is it measured?',
        'Explain the concept of $topic.',
        'Discuss $topic with relevant examples.',
      ];
    } else if (subjectId == 'chemistry') {
      return [
        'Explain $topic with examples.',
        'What is $topic? Explain its mechanism.',
        'State and explain $topic.',
        'Discuss $topic with suitable examples.',
        'Explain the process of $topic.',
        'What is $topic? Give its applications.',
        'Explain $topic and its significance.',
        'Discuss $topic with relevant examples.',
        'State $topic and explain.',
        'What is $topic? Explain with examples.',
      ];
    } else if (subjectId == 'mathematics') {
      return [
        'Prove that $topic.',
        'Find the value of $topic.',
        'Solve: $topic.',
        'Evaluate $topic.',
        'Find the derivative of $topic.',
        'Integrate $topic.',
        'Prove the theorem: $topic.',
        'Solve the equation: $topic.',
        'Find the limit of $topic.',
        'Evaluate the expression: $topic.',
      ];
    } else {
      return [
        'Explain $topic with examples.',
        'What is $topic? Explain its importance.',
        'Discuss $topic in detail.',
        'Explain the process of $topic.',
        'What is $topic? Give its functions.',
        'Explain $topic and its significance.',
        'Discuss $topic with examples.',
        'What is $topic? Explain with diagram.',
        'Explain the mechanism of $topic.',
        'Discuss $topic and its applications.',
      ];
    }
  }

  List<String> _getLongAnswerQuestions(String subjectId, String topic) {
    if (subjectId == 'physics') {
      return [
        'Derive the expression for $topic. Explain its applications.',
        'State and prove $topic. Discuss its significance.',
        'Explain $topic in detail with necessary diagrams.',
        'What is $topic? Derive its formula and give applications.',
        'Discuss $topic thoroughly with examples and applications.',
        'Explain the principle of $topic with derivation.',
        'State $topic. Derive the expression and explain.',
        'Explain $topic with mathematical derivation and examples.',
        'Discuss $topic in detail with relevant examples.',
        'What is $topic? Explain with derivation and applications.',
      ];
    } else if (subjectId == 'chemistry') {
      return [
        'Explain $topic in detail with mechanism and examples.',
        'What is $topic? Explain its mechanism and applications.',
        'Discuss $topic thoroughly with examples.',
        'Explain the process of $topic with mechanism.',
        'What is $topic? Explain with examples and applications.',
        'Discuss $topic in detail with relevant examples.',
        'Explain $topic and its significance with examples.',
        'What is $topic? Explain the mechanism and applications.',
        'Explain $topic with suitable examples and applications.',
        'Discuss $topic thoroughly with mechanism and examples.',
      ];
    } else if (subjectId == 'mathematics') {
      return [
        'Prove that $topic. Also find its applications.',
        'Solve $topic and verify your answer.',
        'Prove the theorem: $topic with examples.',
        'Find the solution of $topic and explain.',
        'Evaluate $topic and show the steps.',
        'Prove $topic and give its applications.',
        'Solve $topic and verify.',
        'Prove the formula: $topic with examples.',
        'Find $topic and explain the method.',
        'Prove $topic and discuss its applications.',
      ];
    } else {
      return [
        'Explain $topic in detail with examples and diagrams.',
        'What is $topic? Explain its mechanism and importance.',
        'Discuss $topic thoroughly with examples.',
        'Explain the process of $topic with mechanism.',
        'What is $topic? Explain with examples and significance.',
        'Discuss $topic in detail with relevant examples.',
        'Explain $topic and its functions with examples.',
        'What is $topic? Explain the process and applications.',
        'Explain $topic with suitable examples and diagrams.',
        'Discuss $topic thoroughly with mechanism and examples.',
      ];
    }
  }

  List<String> _getLongAnswerIIQuestions(String subjectId, String topic) {
    if (subjectId == 'physics') {
      return [
        'Derive the complete expression for $topic. Explain all terms and give applications with examples.',
        'State and prove $topic. Discuss its significance and applications in detail.',
        'Explain $topic comprehensively with derivation, diagrams, and real-world applications.',
        'What is $topic? Derive its complete formula, explain all parameters, and discuss applications.',
        'Discuss $topic thoroughly with mathematical derivation, examples, and practical applications.',
      ];
    } else if (subjectId == 'chemistry') {
      return [
        'Explain $topic in complete detail with mechanism, examples, and industrial applications.',
        'What is $topic? Explain its complete mechanism, significance, and applications.',
        'Discuss $topic thoroughly with mechanism, examples, and real-world applications.',
        'Explain the complete process of $topic with mechanism and applications.',
        'What is $topic? Explain comprehensively with mechanism, examples, and applications.',
      ];
    } else if (subjectId == 'mathematics') {
      return [
        'Prove that $topic completely. Also find its applications and solve related problems.',
        'Prove the theorem: $topic with complete steps, examples, and applications.',
        'Solve $topic completely and verify. Also discuss its applications.',
        'Prove $topic with complete derivation and give multiple applications.',
        'Prove the formula: $topic completely with examples and applications.',
      ];
    } else {
      return [
        'Explain $topic in complete detail with mechanism, examples, diagrams, and significance.',
        'What is $topic? Explain its complete mechanism, functions, and applications.',
        'Discuss $topic thoroughly with mechanism, examples, and real-world applications.',
        'Explain the complete process of $topic with mechanism and applications.',
        'What is $topic? Explain comprehensively with mechanism, examples, and significance.',
      ];
    }
  }

  String _getCaseBasedQuestionText(String subjectId, String topic) {
    if (subjectId == 'physics') {
      return 'Read the following case study and answer the questions that follow:\n\n'
          'Case Study: A student is studying $topic in the laboratory. During the experiment, '
          'certain observations were made regarding the behavior of $topic under different conditions. '
          'The data collected shows interesting patterns related to $topic.\n\n'
          'Based on the above case study, answer the following questions:';
    } else if (subjectId == 'chemistry') {
      return 'Read the following case study and answer the questions that follow:\n\n'
          'Case Study: In a chemical reaction involving $topic, a chemist observed specific changes. '
          'The reaction proceeded through various stages, and the final product showed characteristics '
          'related to $topic.\n\n'
          'Based on the above case study, answer the following questions:';
    } else if (subjectId == 'mathematics') {
      return 'Read the following case study and answer the questions that follow:\n\n'
          'Case Study: A problem involving $topic was given to students. The problem required '
          'application of various mathematical concepts related to $topic. Students had to analyze '
          'the given data and solve the problem step by step.\n\n'
          'Based on the above case study, answer the following questions:';
    } else {
      return 'Read the following case study and answer the questions that follow:\n\n'
          'Case Study: A biological process related to $topic was observed in an experiment. '
          'The process showed specific characteristics and followed certain patterns. Various factors '
          'influenced the outcome of $topic.\n\n'
          'Based on the above case study, answer the following questions:';
    }
  }

  Map<int, String> _generateAnswerKey() {
    final answers = <int, String>{};
    final totalQuestions = 50; // Both types have 50 questions (CBSE 2026 pattern)
    
    if (paperType == 'previous' && year != null) {
      // Previous year papers: All questions are subjective (50 questions)
      for (int i = 1; i <= totalQuestions; i++) {
        answers[i] = 'See solution';
      }
    } else {
      // 90% Match papers: MCQs (Q1-Q20) + Subjective (Q21-Q50)
      final mcqCount = 20;
      for (int i = 1; i <= totalQuestions; i++) {
        if (i <= mcqCount) {
          // MCQ answers (Section A: Q1-Q20)
          answers[i] = ['A', 'B', 'C', 'D'][i % 4];
        } else {
          // Subjective answers (Section B-E: Q21-Q50)
          answers[i] = 'See solution';
        }
      }
    }
    return answers;
  }

  List<String> _getChapterTopics() {
    final subjectId = _subjectId;
    final is90Match = paperType == '90match';
    
    // For 90% match papers, return comprehensive subject-level topics
    if (is90Match && subject != null) {
      return _getSubjectLevelTopics(subjectId);
    }
    
    // For previous year papers, return general topics
    if (subjectId == 'physics') {
      return [
        'Electric field and potential',
        'Coulomb\'s law and its applications',
        'Gauss\'s law and electric flux',
        'Capacitance and dielectrics',
        'Current and resistance',
        'Ohm\'s law and circuits',
        'Magnetic field and forces',
        'Electromagnetic induction',
        'AC circuits and transformers',
        'Optics and wave phenomena',
      ];
    } else if (subjectId == 'chemistry') {
      return [
        'Chemical bonding and structure',
        'Reaction mechanisms',
        'Equilibrium and kinetics',
        'Thermodynamics',
        'Electrochemistry',
        'Organic reactions',
        'Coordination compounds',
        'Biomolecules',
        'Polymers and materials',
        'Environmental chemistry',
      ];
    } else if (subjectId == 'mathematics') {
      return [
        'Functions and relations',
        'Calculus and derivatives',
        'Integration techniques',
        'Differential equations',
        'Vector algebra',
        '3D geometry',
        'Probability and statistics',
        'Linear programming',
        'Matrices and determinants',
        'Trigonometric functions',
      ];
    } else {
      return [
        'Biological processes',
        'Cell structure and function',
        'Genetics and inheritance',
        'Evolution and ecology',
        'Human physiology',
        'Biotechnology',
        'Reproduction and development',
        'Health and disease',
        'Biodiversity',
        'Environmental biology',
      ];
    }
  }

  List<String> _getSubjectLevelTopics(String subjectId) {
    // Comprehensive subject-level topics covering all chapters
    if (subjectId == 'physics') {
      return [
        'Electric Charges and Fields - Coulomb\'s law, electric field, electric dipole',
        'Electrostatic Potential and Capacitance - potential, capacitance, dielectrics',
        'Current Electricity - Ohm\'s law, resistance, Kirchhoff\'s laws, potentiometer',
        'Moving Charges and Magnetism - magnetic field, force on current, Biot-Savart law',
        'Magnetism and Matter - bar magnet, magnetic properties, Earth\'s magnetism',
        'Electromagnetic Induction - Faraday\'s law, Lenz\'s law, self and mutual inductance',
        'Alternating Current - AC generator, transformer, LC oscillations, power',
        'Electromagnetic Waves - displacement current, electromagnetic spectrum',
        'Ray Optics and Optical Instruments - reflection, refraction, lenses, mirrors',
        'Wave Optics - interference, diffraction, polarization, Huygens principle',
        'Dual Nature of Radiation and Matter - photoelectric effect, de Broglie wavelength',
        'Atoms - Rutherford model, Bohr model, line spectra, energy levels',
        'Nuclei - nuclear size, mass-energy, nuclear reactions, radioactivity',
        'Semiconductor Electronics - p-n junction, diodes, transistors, logic gates',
        'Communication Systems - modulation, demodulation, propagation, satellite communication',
      ];
    } else if (subjectId == 'chemistry') {
      return [
        'The Solid State - crystal lattices, unit cells, defects, electrical properties',
        'Solutions - types, concentration, colligative properties, Raoult\'s law',
        'Electrochemistry - conductance, cell potential, Nernst equation, batteries',
        'Chemical Kinetics - rate of reaction, order, molecularity, Arrhenius equation',
        'Surface Chemistry - adsorption, catalysis, colloids, emulsions',
        'General Principles and Processes of Isolation of Elements - metallurgy, extraction',
        'The p-Block Elements - group 15, 16, 17, 18 elements and their compounds',
        'The d and f Block Elements - transition elements, lanthanides, actinides',
        'Coordination Compounds - Werner theory, IUPAC naming, isomerism, bonding',
        'Haloalkanes and Haloarenes - preparation, properties, reactions, uses',
        'Alcohols, Phenols and Ethers - preparation, properties, reactions',
        'Aldehydes, Ketones and Carboxylic Acids - preparation, reactions, uses',
        'Amines - classification, preparation, properties, diazonium salts',
        'Biomolecules - carbohydrates, proteins, nucleic acids, vitamins',
        'Polymers - classification, addition, condensation polymers, biodegradable',
        'Chemistry in Everyday Life - drugs, medicines, food additives, cleansing agents',
      ];
    } else if (subjectId == 'mathematics') {
      return [
        'Relations and Functions - types, composition, inverse, binary operations',
        'Inverse Trigonometric Functions - domain, range, principal values, properties',
        'Matrices - operations, transpose, symmetric, skew-symmetric, inverse',
        'Determinants - properties, minors, cofactors, adjoint, applications',
        'Continuity and Differentiability - limits, continuity, derivatives, chain rule',
        'Application of Derivatives - rate of change, tangents, normals, maxima, minima',
        'Integrals - indefinite, definite, integration by parts, partial fractions',
        'Application of Integrals - area under curve, area between curves',
        'Differential Equations - order, degree, general, particular solutions',
        'Vector Algebra - scalar, vector products, scalar triple product',
        'Three Dimensional Geometry - direction cosines, lines, planes, distance',
        'Linear Programming - formulation, graphical method, optimal solutions',
        'Probability - conditional probability, Bayes\' theorem, random variables',
        'Probability Distributions - binomial, Poisson, normal distributions',
        'Mathematical Reasoning - statements, negation, compound statements, validation',
      ];
    } else {
      return [
        'Reproduction in Organisms - asexual, sexual reproduction, gametogenesis',
        'Sexual Reproduction in Flowering Plants - flower structure, pollination, fertilization',
        'Human Reproduction - male, female reproductive systems, gametogenesis, pregnancy',
        'Reproductive Health - contraception, STDs, infertility, population control',
        'Principles of Inheritance and Variation - Mendel\'s laws, linkage, sex determination',
        'Molecular Basis of Inheritance - DNA structure, replication, transcription, translation',
        'Evolution - origin of life, evidence, theories, natural selection, speciation',
        'Human Health and Disease - pathogens, immunity, common diseases, cancer',
        'Strategies for Enhancement in Food Production - plant breeding, animal husbandry',
        'Microbes in Human Welfare - food production, sewage treatment, antibiotics',
        'Biotechnology: Principles and Processes - recombinant DNA, PCR, gel electrophoresis',
        'Biotechnology and its Applications - GMOs, gene therapy, molecular diagnosis',
        'Organisms and Populations - ecology, adaptations, population interactions',
        'Ecosystem - structure, productivity, energy flow, nutrient cycling',
        'Biodiversity and Conservation - patterns, importance, threats, conservation',
        'Environmental Issues - pollution, global warming, ozone depletion, waste management',
      ];
    }
  }

  String _getRandomConcept() {
    final concepts = _getChapterTopics();
    return concepts[DateTime.now().millisecond % concepts.length];
  }

  void _showSolutions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  const Text(
                    'Detailed Solutions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  ...List.generate(paperType == '90match' ? 50 : 25, (index) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Question ${index + 1} Solution',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _generateSolution(index + 1),
                              style: const TextStyle(fontSize: 14, height: 1.6),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _generateSolution(int questionNum) {
    final mcqCount = paperType == '90match' ? 20 : 10;
    if (questionNum <= mcqCount) {
      return 'The correct answer is option ${['A', 'B', 'C', 'D'][questionNum % 4]}. '
          'This is because the concept relates directly to $_paperName and follows '
          'the fundamental principles discussed in this ${subject != null ? 'subject' : 'chapter'}. The other options are '
          'incorrect as they either represent different concepts or are not applicable '
          'in this context.';
    } else {
      return 'To answer this question, we need to consider the key aspects of '
          '$_paperName. The solution involves:\n\n'
          '1. Understanding the fundamental concept\n'
          '2. Applying the relevant principles\n'
          '3. Providing examples or calculations as needed\n'
          '4. Concluding with the final answer\n\n'
          'This approach ensures a comprehensive answer that demonstrates '
          'thorough understanding of the topic.';
    }
  }
}

