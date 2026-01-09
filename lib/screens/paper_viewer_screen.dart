import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../services/data_service.dart';
import '../services/ai_question_service.dart';

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
              ? '90% Match Paper - All Subjects'
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
    final widgets = <Widget>[];

    // Group questions by section for both previous year and 90% match papers
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

    return widgets;
  }

  Map<String, String> _getSectionInfo(String section) {
    if (paperType == '90match') {
      // For 90% match papers
      switch (section) {
        case 'A':
          return {'title': 'Section A', 'subtitle': 'Multiple Choice Questions (1 mark each)', 'range': 'Q. No. 1 to 20'};
        case 'B':
          return {'title': 'Section B', 'subtitle': 'Short Answer Type Questions (2 marks each)', 'range': 'Q. No. 21 to 30'};
        case 'C':
          return {'title': 'Section C', 'subtitle': 'Long Answer Type I Questions (3 marks each)', 'range': 'Q. No. 31 to 40'};
        case 'D':
          return {'title': 'Section D', 'subtitle': 'Long Answer Type II Questions (4 marks each)', 'range': 'Q. No. 41 to 45'};
        case 'E':
          return {'title': 'Section E', 'subtitle': 'Very Long Answer/Case-based Questions (5 marks each)', 'range': 'Q. No. 46 to 50'};
        default:
          return {'title': 'Section $section', 'subtitle': '', 'range': ''};
      }
    } else {
      // For previous year papers
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
                if (question['subject'] != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      question['subject'],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                ],
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
      // Include questions from ALL subjects (Physics, Chemistry, Mathematics, Biology)
      final allSubjects = DataService.getSubjects();
      final subjectIds = allSubjects.map((s) => s.id).toList();
      
      // Section A - MCQs (1 mark) - 20 questions (Q1-Q20)
      // Distribute: 5 questions from each subject
      for (int i = 1; i <= 20; i++) {
        final questionSubjectId = subjectIds[(i - 1) % subjectIds.length];
        questions.add({
          'question': _generateMCQ(questionSubjectId, i),
          'options': _generateOptions(questionSubjectId, i),
          'section': 'A',
          'marks': 1,
          'subject': allSubjects.firstWhere((s) => s.id == questionSubjectId).name,
        });
      }

      // Section B - Short Answer (2 marks) - 10 questions (Q21-Q30)
      // Distribute: ~2-3 questions from each subject
      for (int i = 21; i <= 30; i++) {
        final questionSubjectId = subjectIds[(i - 21) % subjectIds.length];
        questions.add({
          'question': _generateShortAnswer(questionSubjectId, i),
          'section': 'B',
          'marks': 2,
          'subject': allSubjects.firstWhere((s) => s.id == questionSubjectId).name,
        });
      }

      // Section C - Long Answer I (3 marks) - 10 questions (Q31-Q40)
      // Distribute: ~2-3 questions from each subject
      for (int i = 31; i <= 40; i++) {
        final questionSubjectId = subjectIds[(i - 31) % subjectIds.length];
        questions.add({
          'question': _generateLongAnswer(questionSubjectId, i),
          'section': 'C',
          'marks': 3,
          'subject': allSubjects.firstWhere((s) => s.id == questionSubjectId).name,
        });
      }

      // Section D - Long Answer II (4 marks) - 5 questions (Q41-Q45)
      // Distribute: 1-2 questions from each subject
      for (int i = 41; i <= 45; i++) {
        final questionSubjectId = subjectIds[(i - 41) % subjectIds.length];
        questions.add({
          'question': _generateLongAnswerII(questionSubjectId, i),
          'section': 'D',
          'marks': 4,
          'subject': allSubjects.firstWhere((s) => s.id == questionSubjectId).name,
        });
      }

      // Section E - Very Long Answer/Case-based (5 marks) - 5 questions (Q46-Q50)
      // Distribute: 1-2 questions from each subject
      for (int i = 46; i <= 50; i++) {
        final questionSubjectId = subjectIds[(i - 46) % subjectIds.length];
        questions.add({
          'question': _generateVeryLongAnswer(questionSubjectId, i),
          'section': 'E',
          'marks': 5,
          'subQuestions': _generateSubQuestions(questionSubjectId, i),
          'subject': allSubjects.firstWhere((s) => s.id == questionSubjectId).name,
        });
      }
    }

    return questions;
  }

  String _generateMCQ(String subjectId, int num) {
    final topics = _getChapterTopics();
    final allTopics = _getSubjectLevelTopics(subjectId);
    // Use different calculation to avoid repetition
    final topicIndex = (num * 7 + 13) % topics.length;
    final topic = topics[topicIndex];
    final relatedTopic = allTopics[(num * 11 + 17) % allTopics.length];
    final is90Match = paperType == '90match';
    
    if (is90Match) {
      // Use AI service to generate questions
      return AIQuestionService.generateMCQ(subjectId, num, topic, relatedTopic);
    }
    
    return 'Q$num. ${topic} is related to which of the following concepts in $_paperName?';
  }

  List<String> _getMCQTemplates(String subjectId, String topic, String relatedTopic) {
    if (subjectId == 'physics') {
      return [
        'Q\$num. Which of the following statements is correct regarding $topic?',
        'Q\$num. In the context of $topic and $relatedTopic, which principle is being applied?',
        'Q\$num. What is the relationship between $topic and $relatedTopic?',
        'Q\$num. Which formula correctly represents $topic?',
        'Q\$num. What happens to $topic when $relatedTopic changes?',
        'Q\$num. Which law or principle governs $topic?',
        'Q\$num. What is the SI unit of $topic?',
        'Q\$num. In $topic, which factor determines the magnitude?',
        'Q\$num. What is the direction of $topic in relation to $relatedTopic?',
        'Q\$num. Which statement best describes $topic?',
        'Q\$num. How does $topic relate to $relatedTopic?',
        'Q\$num. Which property of $topic is most significant?',
        'Q\$num. What is the effect of $relatedTopic on $topic?',
        'Q\$num. Which experiment demonstrates $topic?',
        'Q\$num. What is the physical significance of $topic?',
      ];
    } else if (subjectId == 'chemistry') {
      return [
        'Q\$num. Which of the following is correct about $topic?',
        'Q\$num. In $topic, what is the correct order or sequence?',
        'Q\$num. Which reaction type is involved in $topic?',
        'Q\$num. What is the product formed when $topic reacts with $relatedTopic?',
        'Q\$num. Which reagent is used for $topic?',
        'Q\$num. What is the mechanism involved in $topic?',
        'Q\$num. Which statement is true regarding $topic?',
        'Q\$num. What is the IUPAC name for $topic?',
        'Q\$num. Which property is characteristic of $topic?',
        'Q\$num. What is the correct formula for $topic?',
        'Q\$num. How does $topic differ from $relatedTopic?',
        'Q\$num. Which condition favors $topic?',
        'Q\$num. What is the relationship between $topic and $relatedTopic?',
        'Q\$num. Which factor affects $topic?',
        'Q\$num. What is the role of $relatedTopic in $topic?',
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
        'Q\$num. How is $topic related to $relatedTopic?',
        'Q\$num. What is the range of $topic?',
        'Q\$num. Which method is used to solve $topic?',
        'Q\$num. What is the geometric interpretation of $topic?',
        'Q\$num. Which condition is necessary for $topic?',
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
        'Q\$num. How does $topic interact with $relatedTopic?',
        'Q\$num. What is the relationship between $topic and $relatedTopic?',
        'Q\$num. Which factor regulates $topic?',
        'Q\$num. What is the importance of $topic in $relatedTopic?',
        'Q\$num. How is $topic different from $relatedTopic?',
      ];
    }
  }

  List<String> _generateOptions(String subjectId, int questionNum) {
    final topics = _getChapterTopics();
    final is90Match = paperType == '90match';
    
    if (is90Match) {
      // Generate more realistic options from all subjects for 90% match papers
      final allSubjects = DataService.getSubjects();
      final allOptions = <String>[];
      
      // Collect topics from all subjects
      for (var subject in allSubjects) {
        final subjectTopics = AIQuestionService.getAllSubjectTopics(subject.id);
        allOptions.addAll(subjectTopics);
      }
      
      // If not enough topics, use chapter topics
      if (allOptions.length < 4) {
        allOptions.addAll(_getSubjectLevelTopics(subjectId));
      }
      
      // Generate unique options
      final baseIndex = (questionNum * 7) % allOptions.length;
      return [
        'Option A: ${allOptions[baseIndex % allOptions.length]}',
        'Option B: ${allOptions[(baseIndex + questionNum * 3) % allOptions.length]}',
        'Option C: ${allOptions[(baseIndex + questionNum * 5) % allOptions.length]}',
        'Option D: ${allOptions[(baseIndex + questionNum * 11) % allOptions.length]}',
      ];
    }
    
    return [
      'Option A: ${_getRandomConcept(questionNum)}',
      'Option B: ${_getRandomConcept(questionNum + 1)}',
      'Option C: ${_getRandomConcept(questionNum + 2)}',
      'Option D: ${_getRandomConcept(questionNum + 3)}',
    ];
  }

  // Section A - Very Short Answer (1 mark)
  String _generateVeryShortAnswer(String subjectId, int num) {
    final topics = _getChapterTopics();
    // Use different calculation to avoid repetition
    final topicIndex = ((num - 1) * 3 + 7) % topics.length;
    final topic = topics[topicIndex];
    final questions = _getVeryShortAnswerQuestions(subjectId, topic);
    final questionIndex = ((num - 1) * 5 + 11) % questions.length;
    return questions[questionIndex];
  }

  // Section B - Short Answer (2 marks) - Q21-Q30
  String _generateShortAnswer(String subjectId, int num) {
    final topics = _getChapterTopics();
    // Use different calculation to avoid repetition
    final topicIndex = ((num - 21) * 7 + 13) % topics.length;
    final topic = topics[topicIndex];
    
    if (paperType == '90match') {
      // Use AI service to generate questions
      return AIQuestionService.generateShortAnswer(subjectId, num, topic);
    }
    
    final questions = _getShortAnswerQuestions(subjectId, topic);
    final questionIndex = ((num - 21) * 3 + 17) % questions.length;
    return questions[questionIndex];
  }

  // Section C - Long Answer I (3 marks) - Q31-Q40
  String _generateLongAnswer(String subjectId, int num) {
    final topics = _getChapterTopics();
    final allTopics = _getSubjectLevelTopics(subjectId);
    // Use different calculation to avoid repetition
    final topicIndex = ((num - 31) * 11 + 19) % topics.length;
    final topic = topics[topicIndex];
    final relatedTopic = allTopics[((num - 31) * 13 + 23) % allTopics.length];
    
    if (paperType == '90match') {
      // Use AI service to generate questions
      return AIQuestionService.generateLongAnswer(subjectId, num, topic, relatedTopic);
    }
    
    final questions = _getLongAnswerQuestions(subjectId, topic);
    final questionIndex = ((num - 31) * 7 + 23) % questions.length;
    return questions[questionIndex];
  }

  // Section D - Long Answer II (4 marks) - Q41-Q45
  String _generateLongAnswerII(String subjectId, int num) {
    final topics = _getChapterTopics();
    final allTopics = _getSubjectLevelTopics(subjectId);
    // Use different calculation to avoid repetition
    final topicIndex = ((num - 41) * 13 + 29) % topics.length;
    final topic = topics[topicIndex];
    final relatedTopic = allTopics[((num - 41) * 17 + 37) % allTopics.length];
    
    if (paperType == '90match') {
      // Use AI service to generate questions
      return AIQuestionService.generateLongAnswer(subjectId, num, topic, relatedTopic);
    }
    
    final questions = _getLongAnswerIIQuestions(subjectId, topic);
    final questionIndex = ((num - 41) * 11 + 31) % questions.length;
    return questions[questionIndex];
  }

  // Section E - Case-based Question (5 marks) - Q46-Q50
  String _generateCaseBasedQuestion(String subjectId, int num) {
    final topics = _getChapterTopics();
    // Use different calculation to avoid repetition
    final topicIndex = ((num - 46) * 17 + 37) % topics.length;
    final topic = topics[topicIndex];
    return _getCaseBasedQuestionText(subjectId, topic);
  }

  String _generateVeryLongAnswer(String subjectId, int num) {
    final topics = _getChapterTopics();
    final topic = topics[(num - 46) % topics.length];
    final allTopics = _getSubjectLevelTopics(subjectId);
    final relatedTopic = allTopics[(num * 3) % allTopics.length];
    
    if (paperType == '90match') {
      // Use AI service to generate questions
      return AIQuestionService.generateVeryLongAnswer(subjectId, num, topic, relatedTopic);
    }
    
    final questionTemplates = _getVeryLongAnswerTemplates(subjectId, topic, relatedTopic);
    return questionTemplates[(num - 46) % questionTemplates.length].replaceAll('\$num', '$num');
  }

  List<String> _getVeryLongAnswerTemplates(String subjectId, String topic, String relatedTopic) {
    if (subjectId == 'physics') {
      return [
        'Q\$num. A student is studying $topic and its relationship with $relatedTopic. Answer the following:',
        'Q\$num. Consider a scenario involving $topic. Based on this, answer the following questions:',
        'Q\$num. An experiment was conducted to study $topic and $relatedTopic. Answer the following:',
        'Q\$num. Explain the concept of $topic and its connection to $relatedTopic. Answer:',
        'Q\$num. A problem related to $topic requires understanding of $relatedTopic. Answer:',
        'Q\$num. Discuss $topic in detail and relate it to $relatedTopic. Answer:',
        'Q\$num. Analyze the principles of $topic and their application in $relatedTopic. Answer:',
        'Q\$num. Compare and contrast $topic with $relatedTopic. Answer:',
      ];
    } else if (subjectId == 'chemistry') {
      return [
        'Q\$num. A reaction involving $topic and $relatedTopic was observed. Answer the following:',
        'Q\$num. Explain the mechanism of $topic and its relationship with $relatedTopic. Answer:',
        'Q\$num. A compound related to $topic shows properties of $relatedTopic. Answer:',
        'Q\$num. Discuss $topic and its applications in $relatedTopic. Answer:',
        'Q\$num. Analyze the structure and properties of $topic in context of $relatedTopic. Answer:',
        'Q\$num. A synthesis process uses $topic to produce $relatedTopic. Answer:',
        'Q\$num. Compare the behavior of $topic and $relatedTopic. Answer:',
        'Q\$num. Explain how $topic influences $relatedTopic. Answer:',
      ];
    } else if (subjectId == 'mathematics') {
      return [
        'Q\$num. Solve a problem involving $topic and $relatedTopic. Answer the following:',
        'Q\$num. Apply the concepts of $topic to solve problems related to $relatedTopic. Answer:',
        'Q\$num. A mathematical model uses $topic and $relatedTopic. Answer:',
        'Q\$num. Derive and explain the relationship between $topic and $relatedTopic. Answer:',
        'Q\$num. Use $topic to analyze and solve problems in $relatedTopic. Answer:',
        'Q\$num. Prove a theorem connecting $topic and $relatedTopic. Answer:',
        'Q\$num. Apply $topic to find solutions in $relatedTopic. Answer:',
        'Q\$num. Analyze the mathematical properties of $topic and $relatedTopic. Answer:',
      ];
    } else {
      return [
        'Q\$num. A biological process involving $topic and $relatedTopic was studied. Answer:',
        'Q\$num. Explain the mechanism of $topic and its role in $relatedTopic. Answer:',
        'Q\$num. Discuss the relationship between $topic and $relatedTopic. Answer:',
        'Q\$num. Analyze how $topic affects $relatedTopic. Answer:',
        'Q\$num. Compare the functions of $topic and $relatedTopic. Answer:',
        'Q\$num. Explain the significance of $topic in context of $relatedTopic. Answer:',
        'Q\$num. A study was conducted on $topic and $relatedTopic. Answer:',
        'Q\$num. Discuss the interaction between $topic and $relatedTopic. Answer:',
      ];
    }
  }

  List<Map<String, dynamic>> _generateSubQuestions(String subjectId, int questionNum) {
    final topics = _getChapterTopics();
    final topic = topics[(questionNum * 7) % topics.length];
    
    if (paperType == '90match') {
      // Generate AI-based sub-questions
      final subject = DataService.getSubjectById(subjectId);
      final chapters = subject?.chapters ?? [];
      final chapterContext = chapters.isNotEmpty 
          ? chapters[(questionNum * 3) % chapters.length].name 
          : topic;
      
      final subQuestions = _getAISubQuestions(subjectId, topic, chapterContext);
      return subQuestions.take(2).map((q) => {
        'question': q,
        'options': null,
      }).toList();
    }
    
    final subQuestionTemplates = _getSubQuestionTemplates(subjectId, topic);
    final selectedTemplates = subQuestionTemplates.take(2).toList();
    
    return selectedTemplates.map((template) => {
      'question': template,
      'options': null,
    }).toList();
  }

  List<String> _getAISubQuestions(String subjectId, String topic, String chapter) {
    List<String> templates;
    if (subjectId == 'physics') {
      templates = [
        'Explain the fundamental principles of \$topic from \$chapter with relevant examples.',
        'Discuss the applications of \$topic from \$chapter in real-world scenarios.',
        'Derive the mathematical relationship governing \$topic in \$chapter.',
        'Compare \$topic with similar concepts from \$chapter and highlight differences.',
        'Analyze the factors that influence \$topic in \$chapter.',
      ];
    } else if (subjectId == 'chemistry') {
      templates = [
        'Explain the chemical principles underlying \$topic in \$chapter.',
        'Discuss the mechanism and steps involved in \$topic from \$chapter.',
        'Describe the conditions required for \$topic to occur in \$chapter.',
        'Compare \$topic with related chemical processes from \$chapter.',
        'Analyze the factors affecting the rate of \$topic in \$chapter.',
      ];
    } else if (subjectId == 'mathematics') {
      templates = [
        'State and prove the theorem related to \$topic in \$chapter.',
        'Solve a problem using the concepts of \$topic from \$chapter.',
        'Derive the formula for \$topic in \$chapter step by step.',
        'Apply \$topic to solve a real-world problem from \$chapter.',
        'Prove the properties of \$topic in \$chapter mathematically.',
      ];
    } else {
      templates = [
        'Explain the biological significance of \$topic in \$chapter.',
        'Describe the process and mechanism of \$topic from \$chapter.',
        'Discuss the factors that regulate \$topic in \$chapter.',
        'Compare \$topic with similar biological processes from \$chapter.',
        'Analyze the role of \$topic in \$chapter.',
      ];
    }
    
    // Replace placeholders
    return templates.map((template) => 
      template.replaceAll('\$topic', topic).replaceAll('\$chapter', chapter)
    ).toList();
  }

  List<String> _getSubQuestionTemplates(String subjectId, String topic) {
    if (subjectId == 'physics') {
      return [
        'Explain the fundamental principles of $topic with relevant examples.',
        'Discuss the applications of $topic in real-world scenarios.',
        'Derive the mathematical relationship governing $topic.',
        'Compare $topic with similar concepts and highlight differences.',
        'Analyze the factors that influence $topic.',
        'Describe the experimental methods used to study $topic.',
        'Explain the physical significance of $topic.',
        'Discuss the limitations and scope of $topic.',
      ];
    } else if (subjectId == 'chemistry') {
      return [
        'Explain the chemical principles underlying $topic.',
        'Discuss the mechanism and steps involved in $topic.',
        'Describe the conditions required for $topic to occur.',
        'Compare $topic with related chemical processes.',
        'Analyze the factors affecting the rate of $topic.',
        'Explain the industrial applications of $topic.',
        'Discuss the environmental impact of $topic.',
        'Describe the methods to identify and characterize $topic.',
      ];
    } else if (subjectId == 'mathematics') {
      return [
        'State and prove the theorem related to $topic.',
        'Solve a problem using the concepts of $topic.',
        'Derive the formula for $topic step by step.',
        'Apply $topic to solve a real-world problem.',
        'Prove the properties of $topic mathematically.',
        'Explain the geometric interpretation of $topic.',
        'Discuss the applications of $topic in different fields.',
        'Analyze the conditions under which $topic is valid.',
      ];
    } else {
      return [
        'Explain the biological significance of $topic.',
        'Describe the process and mechanism of $topic.',
        'Discuss the factors that regulate $topic.',
        'Compare $topic with similar biological processes.',
        'Analyze the role of $topic in maintaining homeostasis.',
        'Explain how $topic contributes to the overall function.',
        'Discuss the disorders related to $topic.',
        'Describe the experimental evidence supporting $topic.',
      ];
    }
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

  String _getRandomConcept(int seed) {
    final concepts = _getChapterTopics();
    return concepts[seed % concepts.length];
  }

}

