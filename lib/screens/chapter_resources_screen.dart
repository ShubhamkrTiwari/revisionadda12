import 'package:flutter/material.dart';
import '../models/subject.dart';
import 'mcq_sets_screen.dart';

class ChapterResourcesScreen extends StatefulWidget {
  final Chapter chapter;
  final String resourceType;

  const ChapterResourcesScreen({
    super.key,
    required this.chapter,
    required this.resourceType,
  });

  @override
  State<ChapterResourcesScreen> createState() => _ChapterResourcesScreenState();
}

class _ChapterResourcesScreenState extends State<ChapterResourcesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.resourceType} - ${widget.chapter.name}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resource Type Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _getResourceColor(widget.resourceType).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _getResourceColor(widget.resourceType),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _getResourceIcon(widget.resourceType),
                    color: _getResourceColor(widget.resourceType),
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.resourceType,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _getResourceColor(widget.resourceType),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.chapter.name,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // AI Generated Content
            _buildContentSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    switch (widget.resourceType) {
      case 'Revision':
        return _buildRevisionContent();
      case 'Formula':
        return _buildFormulaContent();
      case 'NCERT':
        return _buildNCERTContent();
      case 'MCQ':
        return _buildMCQContent();
      default:
        return _buildDefaultContent();
    }
  }

  Widget _buildRevisionContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chapter Overview
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red.shade50, Colors.red.shade100],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.red.shade700, size: 24),
                    const SizedBox(width: 12),
                    const Text(
                      'Chapter Overview',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  widget.chapter.description,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      _buildInfoItem(Icons.menu_book, '${_getTotalTopics()} Topics', Colors.blue),
                      const SizedBox(width: 16),
                      _buildInfoItem(Icons.quiz, '${_getQuestionCount()} Questions', Colors.green),
                      const SizedBox(width: 16),
                      _buildInfoItem(Icons.access_time, '${_getStudyTime()} Min', Colors.orange),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Detailed Key Concepts
        const Text(
          'Detailed Key Concepts',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ..._getDetailedKeyConcepts().asMap().entries.map((entry) {
          final index = entry.key;
          final concept = entry.value;
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ExpansionTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red.shade400, Colors.red.shade600],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              title: Text(
                concept['title']!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                concept['subtitle']!,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (concept['definition'] != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.book, size: 18, color: Colors.blue.shade700),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Definition',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                concept['definition']!,
                                style: const TextStyle(fontSize: 14, height: 1.6),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (concept['points'] != null) ...[
                        const Text(
                          'Key Points:',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...concept['points']!.map((point) => Padding(
                              padding: const EdgeInsets.only(bottom: 8, left: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 6, right: 12),
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      point,
                                      style: const TextStyle(fontSize: 14, height: 1.6),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(height: 12),
                      ],
                      if (concept['formula'] != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.orange.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.functions, size: 18, color: Colors.orange.shade700),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Important Formula',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange.shade700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                concept['formula']!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'monospace',
                                  color: Colors.orange.shade900,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (concept['example'] != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.lightbulb, size: 18, color: Colors.green.shade700),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Example',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                concept['example']!,
                                style: const TextStyle(fontSize: 14, height: 1.6),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 20),
        // Important Definitions
        const Text(
          'Important Definitions',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ..._getImportantDefinitions().asMap().entries.map((entry) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.purple.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.bookmark, color: Colors.purple.shade700),
              ),
              title: Text(
                entry.value['term']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  entry.value['definition']!,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 20),
        // Mind Map
        const Text(
          'Visual Mind Map',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.account_tree, color: Colors.blue.shade700, size: 24),
                    const SizedBox(width: 12),
                    const Text(
                      'Chapter Structure',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildDetailedMindMap(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Quick Revision Summary
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.amber.shade50, Colors.orange.shade50],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.summarize, color: Colors.orange.shade700, size: 24),
                    const SizedBox(width: 12),
                    const Text(
                      'Quick Revision Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ..._getRevisionSummary().map((point) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 4, right: 12),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              point,
                              style: const TextStyle(fontSize: 14, height: 1.6),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormulaContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade400, Colors.orange.shade600],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(
                Icons.straighten,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Complete Formula Sheet',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.chapter.name,
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
        ),
        const SizedBox(height: 24),
        // Formulas List
        ..._getFormulasForChapter().map((formula) => _buildDetailedFormulaCard(formula)),
      ],
    );
  }

  Widget _buildDetailedFormulaCard(Map<String, String> formula) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.orange.shade50,
              Colors.orange.shade100.withOpacity(0.3),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Formula Name
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade400,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.functions,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      formula['name']!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Formula Display
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.orange.shade300,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    formula['formula']!,
                    style: const TextStyle(
                      fontSize: 22,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              if (formula['description'] != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          formula['description']!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue.shade900,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (formula['variables'] != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.label, color: Colors.green.shade700, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Variables:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        formula['variables']!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.green.shade900,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (formula['units'] != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.purple.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.square_foot, color: Colors.purple.shade700, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Units: ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade700,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          formula['units']!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.purple.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (formula['application'] != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.teal.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lightbulb_outline, color: Colors.teal.shade700, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Application:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        formula['application']!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.teal.shade900,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (formula['example'] != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.indigo.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calculate, color: Colors.indigo.shade700, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Example:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        formula['example']!,
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'monospace',
                          color: Colors.indigo.shade900,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNCERTContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'AI Generated NCERT Solutions',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.auto_awesome, size: 16, color: Colors.purple),
                  SizedBox(width: 4),
                  Text(
                    'AI',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Chapter Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _getNCERTSummary(),
                  style: const TextStyle(fontSize: 14, height: 1.6),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Important Questions & Answers',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(height: 12),
                ..._getNCERTQuestions().asMap().entries.map((entry) {
                  final index = entry.key;
                  final question = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Q${index + 1}. ${question['question']}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Ans: ${question['answer']}',
                            style: const TextStyle(fontSize: 14, height: 1.5),
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
      ],
    );
  }

  Widget _buildMCQContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade400, Colors.green.shade600],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.quiz,
                  color: Colors.white,
                  size: 60,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Multiple Choice Questions',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.chapter.name,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMCQStatChip(Icons.library_books, '15 Sets', Colors.white),
                    _buildMCQStatChip(Icons.quiz, '150 Questions', Colors.white),
                    _buildMCQStatChip(Icons.access_time, '10 Min/Set', Colors.white),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MCQSetsScreen(
                            chapter: widget.chapter,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward, size: 20),
                    label: const Text(
                      'View All Sets',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.green.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMCQStatChip(IconData icon, String text, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }


  String _getRandomConcept() {
    final concepts = _getChapterTopics();
    if (concepts.isEmpty) {
      return 'Concept';
    }
    return concepts[DateTime.now().millisecond % concepts.length];
  }

  List<String> _getChapterTopics() {
    final subjectId = widget.chapter.subjectId;
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

  Widget _buildDefaultContent() {
    return const Center(
      child: Text('Content coming soon!'),
    );
  }

  Widget _buildKeyPoint(String title, List<String> points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ...points.map((point) => Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 16)),
                  Expanded(
                    child: Text(
                      point,
                      style: const TextStyle(fontSize: 14, height: 1.5),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildMindMap() {
    final chapterFirstWord = widget.chapter.name.split(' ').first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: Text(
              chapterFirstWord,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildMindMapNode('Concept 1', Colors.red),
            _buildMindMapNode('Concept 2', Colors.green),
            _buildMindMapNode('Concept 3', Colors.orange),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailedMindMap() {
    final chapterFirstWord = widget.chapter.name.split(' ').first;
    final concepts = _getMindMapConcepts();
    
    return Column(
      children: [
        // Center Node
        Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade600],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Text(
              chapterFirstWord,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Main Concepts
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: concepts.map((concept) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: concept['color']!.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: concept['color']!,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Icon(concept['icon'], color: concept['color'], size: 24),
                  const SizedBox(height: 8),
                  Text(
                    concept['title']!,
                    style: TextStyle(
                      color: concept['color'],
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String text, Color color) {
    return Row(
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
    );
  }

  int _getTotalTopics() {
    return 8 + (widget.chapter.name.length % 5);
  }

  int _getQuestionCount() {
    return 70;
  }

  int _getStudyTime() {
    return 45 + (widget.chapter.name.length % 15);
  }

  List<Map<String, dynamic>> _getDetailedKeyConcepts() {
    final subjectId = widget.chapter.subjectId;
    final chapterName = widget.chapter.name;
    
    // Get chapter-specific detailed concepts
    return _getChapterSpecificConcepts(subjectId, chapterName);
  }

  List<Map<String, dynamic>> _getChapterSpecificConcepts(String subjectId, String chapterName) {
    // Physics chapters
    if (subjectId == 'physics') {
      if (chapterName.contains('Electric Charges') || chapterName.contains('Fields')) {
        return [
          {
            'title': 'Electric Charge and Its Properties',
            'subtitle': 'Fundamental concept of charge',
            'definition': 'Electric charge is a fundamental property of matter. Like charges repel and unlike charges attract. Charge is quantized (q = ne) and conserved. The SI unit is Coulomb (C).',
            'points': [
              'Charge exists in two types: positive and negative',
              'Charge is quantized: q = ±ne where n is an integer and e = 1.6 × 10⁻¹⁹ C',
              'Charge is conserved: total charge in an isolated system remains constant',
              'Conductors allow free movement of charges; insulators do not',
              'Charging by friction, conduction, and induction are three methods',
            ],
            'formula': 'q = ne, where e = 1.6 × 10⁻¹⁹ C',
            'example': 'When you rub a glass rod with silk, electrons transfer from glass to silk, leaving glass positively charged and silk negatively charged.',
            'examTip': 'Remember: Charge is always conserved. In any process, the total charge before equals total charge after.',
          },
          {
            'title': 'Coulomb\'s Law',
            'subtitle': 'Force between two point charges',
            'definition': 'Coulomb\'s law states that the force between two point charges is directly proportional to the product of charges and inversely proportional to the square of distance between them.',
            'points': [
              'F = k(q₁q₂)/r² where k = 9 × 10⁹ Nm²/C²',
              'Force is attractive for unlike charges, repulsive for like charges',
              'Force acts along the line joining the two charges',
              'In vector form: F₁₂ = k(q₁q₂/r²)r̂₁₂',
              'Superposition principle: net force is vector sum of individual forces',
            ],
            'formula': 'F = (1/4πε₀)(q₁q₂/r²) = k(q₁q₂/r²)',
            'example': 'Two charges of +2μC and -3μC placed 10cm apart experience a force of 5.4N (attractive).',
            'examTip': 'Always check units! Convert μC to C, cm to m before calculation. Common mistake: forgetting to square the distance.',
          },
          {
            'title': 'Electric Field',
            'subtitle': 'Field due to charge distribution',
            'definition': 'Electric field is the region around a charge where another charge experiences force. E = F/q₀. It is a vector quantity with SI unit N/C or V/m.',
            'points': [
              'Electric field due to point charge: E = kq/r²',
              'Field lines start from positive charge and end at negative charge',
              'Field lines never intersect',
              'Density of field lines represents field strength',
              'For continuous charge distribution, use integration',
            ],
            'formula': 'E = kq/r² (point charge), E = σ/2ε₀ (infinite plane sheet)',
            'example': 'At a distance of 5cm from a +10μC charge, electric field is 3.6 × 10⁷ N/C directed away from charge.',
            'examTip': 'For electric dipole: E = (1/4πε₀)(2p/r³) along axis, E = (1/4πε₀)(p/r³) along perpendicular bisector.',
          },
          {
            'title': 'Electric Dipole',
            'subtitle': 'System of two equal and opposite charges',
            'definition': 'An electric dipole consists of two equal and opposite charges separated by a small distance. Dipole moment p = q × 2a (vector from -q to +q).',
            'points': [
              'Dipole moment: p = q × 2a (magnitude), direction from -q to +q',
              'Torque on dipole in uniform field: τ = p × E',
              'Potential energy: U = -p·E',
              'Field due to dipole: E ∝ 1/r³ (falls faster than point charge)',
              'Dipole in non-uniform field experiences both torque and force',
            ],
            'formula': 'p = q × 2a, τ = pE sinθ, U = -pE cosθ',
            'example': 'Water molecule (H₂O) is a permanent dipole with dipole moment 1.85 D, explaining its high dielectric constant.',
            'examTip': 'Remember: Dipole moment is a vector. In calculations, use vector addition for multiple dipoles.',
          },
          {
            'title': 'Gauss\'s Law',
            'subtitle': 'Flux and charge relationship',
            'definition': 'Gauss\'s law states that electric flux through a closed surface is equal to (1/ε₀) times the charge enclosed. Φ = ∮E·dA = q/ε₀.',
            'points': [
              'Gauss\'s law: Φ = ∮E·dA = q_enclosed/ε₀',
              'Useful for symmetric charge distributions (spherical, cylindrical, planar)',
              'Flux is independent of surface shape, depends only on enclosed charge',
              'For conductors, all charge resides on surface; E = 0 inside',
              'Applications: field due to infinite plane, sphere, cylinder',
            ],
            'formula': 'Φ = q/ε₀, E = σ/ε₀ (infinite plane), E = kq/r² (outside sphere)',
            'example': 'For an infinite plane sheet with surface charge density σ, E = σ/2ε₀ on both sides, independent of distance.',
            'examTip': 'Choose Gaussian surface wisely! For spherical symmetry, use sphere; for cylindrical, use cylinder; for planar, use pillbox.',
          },
        ];
      } else if (chapterName.contains('Electrostatic Potential') || chapterName.contains('Capacitance')) {
        return [
          {
            'title': 'Electric Potential',
            'subtitle': 'Potential energy per unit charge',
            'definition': 'Electric potential at a point is the work done per unit charge in bringing a test charge from infinity to that point. V = W/q₀ = kq/r. Unit: Volt (V).',
            'points': [
              'Potential is scalar: V = kq/r for point charge',
              'Potential difference: ΔV = V_B - V_A = -∫E·dl',
              'Equipotential surfaces are perpendicular to field lines',
              'Work done in moving charge: W = qΔV',
              'Potential at infinity is taken as zero',
            ],
            'formula': 'V = kq/r, V = kq/r₁ + kq/r₂ (superposition), ΔV = -Ed',
            'example': 'Potential at 10cm from +5μC charge is 4.5 × 10⁵ V. Moving a +2μC charge from infinity to this point requires 0.9J work.',
            'examTip': 'Potential is scalar, so add algebraically. Field is vector, so add vectorially. Common mistake: mixing them up!',
          },
          {
            'title': 'Capacitance',
            'subtitle': 'Charge storage capacity',
            'definition': 'Capacitance is the ability of a conductor to store charge. C = Q/V. Unit: Farad (F). For parallel plate: C = ε₀A/d.',
            'points': [
              'C = Q/V, where Q is charge and V is potential difference',
              'Parallel plate capacitor: C = ε₀A/d',
              'Energy stored: U = (1/2)CV² = Q²/2C = (1/2)QV',
              'Capacitors in series: 1/C_eq = 1/C₁ + 1/C₂',
              'Capacitors in parallel: C_eq = C₁ + C₂',
            ],
            'formula': 'C = Q/V, C = ε₀A/d, U = (1/2)CV²',
            'example': 'A 100μF capacitor charged to 12V stores 7.2mJ energy. If connected to another 100μF uncharged capacitor in parallel, final voltage is 6V.',
            'examTip': 'In series, charge is same, voltage divides. In parallel, voltage is same, charge divides. Remember this!',
          },
          {
            'title': 'Dielectrics',
            'subtitle': 'Insulating materials in capacitors',
            'definition': 'Dielectrics are insulating materials placed between capacitor plates. They increase capacitance by factor K (dielectric constant) and reduce electric field.',
            'points': [
              'Dielectric constant K = C_with/C_without = ε/ε₀',
              'With dielectric: C = Kε₀A/d, E = E₀/K',
              'Polarization reduces effective field inside dielectric',
              'Energy stored decreases when dielectric is inserted (if battery disconnected)',
              'Common dielectrics: air (K≈1), paper (K≈3), water (K≈80)',
            ],
            'formula': 'C = Kε₀A/d, E = E₀/K, U = Q²/2KC (battery disconnected)',
            'example': 'Inserting a dielectric (K=5) in a capacitor increases capacitance 5 times. If battery is disconnected, energy becomes 1/5th of original.',
            'examTip': 'With battery connected: V constant, Q increases, U increases. With battery disconnected: Q constant, V decreases, U decreases.',
          },
        ];
      } else if (chapterName.contains('Current Electricity')) {
        return [
          {
            'title': 'Ohm\'s Law and Resistance',
            'subtitle': 'Current-voltage relationship',
            'definition': 'Ohm\'s law states V = IR, where V is potential difference, I is current, and R is resistance. Resistance R = ρl/A, where ρ is resistivity.',
            'points': [
              'Ohm\'s law: V = IR (valid for ohmic conductors)',
              'Resistance: R = ρl/A, where ρ is resistivity',
              'Resistivity depends on material and temperature: ρ = ρ₀(1 + αΔT)',
              'Power dissipated: P = VI = I²R = V²/R',
              'Resistors in series: R_eq = R₁ + R₂; in parallel: 1/R_eq = 1/R₁ + 1/R₂',
            ],
            'formula': 'V = IR, R = ρl/A, P = I²R, R_series = R₁+R₂, 1/R_parallel = 1/R₁+1/R₂',
            'example': 'A wire of length 2m, area 1mm², resistivity 1.7×10⁻⁸Ωm has resistance 0.034Ω. Current of 5A produces power 0.85W.',
            'examTip': 'Remember: In series, current is same, voltage divides. In parallel, voltage is same, current divides. Power is always I²R.',
          },
          {
            'title': 'Kirchhoff\'s Laws',
            'subtitle': 'Current and voltage rules',
            'definition': 'Kirchhoff\'s junction rule: ΣI_in = ΣI_out (charge conservation). Loop rule: ΣV = 0 around any closed loop (energy conservation).',
            'points': [
              'Junction rule: Sum of currents entering = sum leaving',
              'Loop rule: Sum of potential differences around closed loop = 0',
              'Sign convention: Voltage drop across resistor: -IR (with current), +IR (against)',
              'EMF: +E when traversing from - to +, -E from + to -',
              'Apply to complex circuits with multiple loops',
            ],
            'formula': 'ΣI_in = ΣI_out, ΣV = 0 (closed loop)',
            'example': 'In a circuit with 12V battery and two resistors (2Ω, 4Ω) in series, current is 2A. Voltage across 2Ω is 4V, across 4Ω is 8V.',
            'examTip': 'Always mark current directions. If answer is negative, current flows opposite to assumed direction. Check: sum of voltages in loop must be zero.',
          },
          {
            'title': 'Wheatstone Bridge',
            'subtitle': 'Balanced bridge condition',
            'definition': 'Wheatstone bridge is used to measure unknown resistance. When balanced (no current through galvanometer), R₁/R₂ = R₃/R₄.',
            'points': [
              'Balanced condition: R₁/R₂ = R₃/R₄ or R₁R₄ = R₂R₃',
              'When balanced, potential at B and D are equal',
              'Used to measure unknown resistance accurately',
              'Meter bridge is practical application of Wheatstone bridge',
              'Sensitivity depends on galvanometer and bridge ratio',
            ],
            'formula': 'R₁/R₂ = R₃/R₄ (balanced), R_x = R₀(l₂/l₁) (meter bridge)',
            'example': 'In balanced bridge with R₁=10Ω, R₂=20Ω, R₃=15Ω, unknown R₄ = 30Ω. If R₃ changes to 18Ω, bridge becomes unbalanced.',
            'examTip': 'Remember: Balanced bridge means no current through middle branch. Use this to find unknown resistance. Check ratio condition!',
          },
        ];
      }
      // Add more physics chapters as needed...
    } else if (subjectId == 'chemistry') {
      if (chapterName.contains('Solid State')) {
        return [
          {
            'title': 'Crystal Lattices and Unit Cells',
            'subtitle': 'Basic structure of solids',
            'definition': 'A crystal lattice is a 3D arrangement of points representing positions of atoms/ions. Unit cell is the smallest repeating unit. Types: primitive, body-centered, face-centered.',
            'points': [
              'Seven crystal systems: cubic, tetragonal, orthorhombic, hexagonal, rhombohedral, monoclinic, triclinic',
              'Bravais lattices: 14 possible arrangements',
              'Unit cell parameters: a, b, c (edge lengths) and α, β, γ (angles)',
              'Coordination number: number of nearest neighbors',
              'Packing efficiency: percentage of space occupied',
            ],
            'formula': 'Density = ZM/(N_A × a³), where Z = number of atoms per unit cell',
            'example': 'Sodium chloride has face-centered cubic structure with coordination number 6:6. Each Na⁺ is surrounded by 6 Cl⁻ ions.',
            'examTip': 'Remember: Simple cubic Z=1, BCC Z=2, FCC Z=4. Packing efficiency: SC=52%, BCC=68%, FCC=74%. HCP also has 74% efficiency.',
          },
          {
            'title': 'Packing Efficiency',
            'subtitle': 'Space utilization in crystals',
            'definition': 'Packing efficiency is the percentage of space occupied by atoms/ions in a unit cell. It depends on crystal structure type.',
            'points': [
              'Simple cubic: 52.4% (least efficient)',
              'Body-centered cubic (BCC): 68%',
              'Face-centered cubic (FCC): 74% (most efficient)',
              'Hexagonal close packing (HCP): 74%',
              'Calculation: (Volume occupied/Total volume) × 100',
            ],
            'formula': 'Packing efficiency = (Z × 4πr³/3)/(a³) × 100%',
            'example': 'In FCC structure with atoms of radius r, edge length a = 2√2r. Packing efficiency = (4 × 4πr³/3)/(16√2r³) = 74%.',
            'examTip': 'For FCC: a = 2√2r, for BCC: a = 4r/√3. Remember these relationships for calculations. Always check units!',
          },
        ];
      }
      // Add more chemistry chapters...
    } else if (subjectId == 'mathematics') {
      if (chapterName.contains('Relations') || chapterName.contains('Functions')) {
        return [
          {
            'title': 'Relations and Their Properties',
            'subtitle': 'Basic concepts of relations',
            'definition': 'A relation R from set A to set B is a subset of A×B. Types: reflexive, symmetric, transitive, equivalence relation.',
            'points': [
              'Reflexive: (a,a) ∈ R for all a ∈ A',
              'Symmetric: If (a,b) ∈ R, then (b,a) ∈ R',
              'Transitive: If (a,b) ∈ R and (b,c) ∈ R, then (a,c) ∈ R',
              'Equivalence relation: reflexive + symmetric + transitive',
              'Number of relations from A to B: 2^(|A|×|B|)',
            ],
            'formula': 'Number of relations = 2^(mn), where |A|=m, |B|=n',
            'example': 'Relation R = {(1,1), (2,2), (3,3), (1,2), (2,1)} on {1,2,3} is reflexive and symmetric but not transitive.',
            'examTip': 'Check each property separately. Draw arrow diagram or matrix to visualize. Equivalence relations partition the set into equivalence classes.',
          },
        ];
      }
      // Add more mathematics chapters...
    } else if (subjectId == 'biology') {
      if (chapterName.contains('Reproduction')) {
        return [
          {
            'title': 'Types of Reproduction',
            'subtitle': 'Asexual vs Sexual',
            'definition': 'Asexual reproduction involves single parent producing genetically identical offspring. Sexual reproduction involves fusion of gametes from two parents, producing genetic variation.',
            'points': [
              'Asexual: binary fission, budding, fragmentation, spore formation',
              'Sexual: involves gamete formation, fusion, zygote formation',
              'Advantage of sexual: genetic variation, evolution',
              'Advantage of asexual: rapid multiplication, no mate needed',
              'Many organisms show both types (alternation of generations)',
            ],
            'formula': 'Not applicable',
            'example': 'Hydra reproduces by budding (asexual) and also produces gametes (sexual). Amoeba reproduces only by binary fission.',
            'examTip': 'Remember: Asexual = clone, Sexual = variation. Know examples: binary fission (amoeba), budding (hydra), fragmentation (planaria).',
          },
        ];
      }
      // Add more biology chapters...
    }
    
    // Default comprehensive concepts if chapter-specific not found
    return _getDefaultDetailedConcepts(subjectId, chapterName);
  }

  List<Map<String, dynamic>> _getDefaultDetailedConcepts(String subjectId, String chapterName) {
    if (subjectId == 'physics') {
      return [
        {
          'title': 'Fundamental Principles',
          'subtitle': 'Core laws and theories',
          'definition': 'The fundamental principles form the foundation of ${chapterName}. These include basic laws, postulates, and theoretical frameworks that govern the behavior and interactions described in this chapter.',
          'points': [
            'Understanding the basic postulates and assumptions',
            'Application of fundamental laws in various scenarios',
            'Relationship between different principles',
            'Limitations and scope of applicability',
            'Historical development and significance',
          ],
          'formula': 'F = ma (Newton\'s Second Law)',
          'example': 'For example, in mechanics, Newton\'s laws provide the foundation for understanding motion and forces.',
          'examTip': 'Always state the law/principle clearly before applying. Show all steps in derivation. Check units and dimensions.',
        },
        {
          'title': 'Mathematical Relationships',
          'subtitle': 'Equations and derivations',
          'definition': 'Mathematical relationships in ${chapterName} describe quantitative connections between different physical quantities. Mastery of these equations is essential for problem-solving.',
          'points': [
            'Key equations and their derivations',
            'Dimensional analysis and units',
            'Graphical representations and interpretations',
            'Problem-solving strategies and approaches',
            'Limiting cases and approximations',
          ],
          'formula': 'E = mc²',
          'example': 'The relationship between energy and mass is fundamental in modern physics.',
          'examTip': 'Always check dimensions before using formulas. Draw diagrams. Use vector notation correctly. Verify answer makes physical sense.',
        },
        {
          'title': 'Practical Applications',
          'subtitle': 'Real-world uses and technology',
          'definition': 'Practical applications demonstrate how concepts from ${chapterName} are used in technology, industry, and daily life. Understanding applications helps in retention.',
          'points': [
            'Technological applications and devices',
            'Industrial and commercial uses',
            'Everyday examples and phenomena',
            'Research and scientific applications',
            'Future prospects and developments',
          ],
          'formula': 'Not applicable',
          'example': 'Concepts from this chapter are used in various technologies and devices.',
          'examTip': 'Relate theoretical concepts to real-world examples. This helps in understanding and remembering. CBSE often asks application-based questions.',
        },
        {
          'title': 'Problem-Solving Techniques',
          'subtitle': 'Systematic approach and methods',
          'definition': 'Effective problem-solving requires systematic approaches and understanding of key techniques specific to ${chapterName}. Practice is essential for mastery.',
          'points': [
            'Step-by-step problem-solving approach',
            'Common pitfalls and how to avoid them',
            'Shortcut methods where applicable',
            'Verification of answers and units',
            'Time management in exams',
          ],
          'formula': 'Not applicable',
          'example': 'Always read problem carefully, identify given and required quantities, choose appropriate formula, solve step-by-step, verify answer.',
          'examTip': 'Practice regularly. Time yourself. Review mistakes. Learn from solved examples. Show all steps clearly for full marks.',
        },
        {
          'title': 'Common Mistakes and How to Avoid',
          'subtitle': 'Error prevention strategies',
          'definition': 'Understanding common mistakes helps avoid them in exams. Most errors occur due to carelessness, unit conversion, or conceptual misunderstanding.',
          'points': [
            'Unit conversion errors: always convert to SI units',
            'Sign errors in vector calculations',
            'Forgetting to consider all forces/effects',
            'Calculation errors: double-check arithmetic',
            'Misreading problem: read carefully twice',
          ],
          'formula': 'Not applicable',
          'example': 'Common mistake: Using cm instead of m, forgetting to square distance in inverse square laws, wrong sign in potential calculations.',
          'examTip': 'Always check units. Draw free-body diagrams. Show work clearly. Review answer for reasonableness. Practice mock tests regularly.',
        },
      ];
    } else if (subjectId == 'chemistry') {
      return [
        {
          'title': 'Chemical Reactions and Mechanisms',
          'subtitle': 'Reaction types and pathways',
          'definition': 'Chemical reactions in ${chapterName} involve the transformation of substances through various mechanisms. Understanding reaction mechanisms is crucial.',
          'points': [
            'Types of reactions and their characteristics',
            'Reaction mechanisms and pathways',
            'Factors affecting reaction rates and equilibrium',
            'Catalysis and its importance',
            'Stoichiometry and balancing equations',
          ],
          'formula': 'A + B → C + D',
          'example': 'Combination reactions involve two or more substances forming a single product.',
          'examTip': 'Balance equations correctly. Check stoichiometry. Understand mechanism. Know factors affecting rate and equilibrium.',
        },
        {
          'title': 'Structure and Bonding',
          'subtitle': 'Molecular geometry and interactions',
          'definition': 'Understanding the structure and bonding in ${chapterName} is crucial for explaining properties and behavior of compounds.',
          'points': [
            'Molecular geometry and VSEPR theory',
            'Types of bonds: ionic, covalent, coordinate',
            'Intermolecular forces and their effects',
            'Structure-property relationships',
            'Hybridization and resonance',
          ],
          'formula': 'Not applicable',
          'example': 'Water\'s bent shape (due to sp³ hybridization) explains its polarity and high boiling point.',
          'examTip': 'Draw structures correctly. Understand VSEPR. Know bond angles. Relate structure to properties. Practice drawing Lewis structures.',
        },
      ];
    } else if (subjectId == 'mathematics') {
      return [
        {
          'title': 'Core Concepts and Theorems',
          'subtitle': 'Fundamental mathematical ideas',
          'definition': 'Core concepts in ${chapterName} form the mathematical foundation for understanding and solving problems. Master definitions and theorems.',
          'points': [
            'Basic definitions and terminology',
            'Key theorems and their proofs',
            'Important properties and identities',
            'Geometric or algebraic interpretations',
            'Conditions and restrictions',
          ],
          'formula': 'f(x) = ax² + bx + c',
          'example': 'Quadratic functions are fundamental in algebra and have wide applications.',
          'examTip': 'Memorize definitions precisely. Understand theorem conditions. Practice proofs. Know when to apply which theorem.',
        },
        {
          'title': 'Problem-Solving Methods',
          'subtitle': 'Techniques and strategies',
          'definition': 'Effective problem-solving in ${chapterName} requires understanding various methods and when to apply them. Practice is key.',
          'points': [
            'Step-by-step solution approaches',
            'Alternative methods and shortcuts',
            'Common mistakes to avoid',
            'Verification techniques',
            'Time-saving strategies',
          ],
          'formula': 'Not applicable',
          'example': 'For integration, try substitution first, then by parts, then partial fractions. Check answer by differentiation.',
          'examTip': 'Show all steps clearly. Check answer. Use multiple methods if time permits. Practice regularly. Review mistakes.',
        },
      ];
    } else {
      return [
        {
          'title': 'Biological Processes and Mechanisms',
          'subtitle': 'Life processes and their regulation',
          'definition': 'Biological processes in ${chapterName} describe how living organisms function and interact. Understanding mechanisms is essential.',
          'points': [
            'Mechanism of action and steps involved',
            'Regulation and control mechanisms',
            'Interconnections with other processes',
            'Significance in living systems',
            'Factors affecting the process',
          ],
          'formula': 'Not applicable',
          'example': 'Photosynthesis converts light energy to chemical energy, producing glucose and oxygen, essential for life on Earth.',
          'examTip': 'Understand step-by-step process. Know regulatory mechanisms. Draw diagrams. Relate to other processes. Memorize key terms.',
        },
        {
          'title': 'Structure and Function Relationships',
          'subtitle': 'Form and function in biology',
          'definition': 'Understanding structure-function relationships in ${chapterName} explains how biological systems work. Structure determines function.',
          'points': [
            'Structural components and organization',
            'Functional roles and significance',
            'Adaptations and specializations',
            'Evolutionary significance',
            'Comparative anatomy and physiology',
          ],
          'formula': 'Not applicable',
          'example': 'The structure of alveoli (large surface area, thin walls) is adapted for efficient gas exchange in lungs.',
          'examTip': 'Draw labeled diagrams. Understand adaptations. Compare structures. Relate to function. Know evolutionary significance.',
        },
      ];
    }
  }

  List<Map<String, String>> _getImportantDefinitions() {
    final subjectId = widget.chapter.subjectId;
    final chapterName = widget.chapter.name;
    
    // Get chapter-specific definitions
    return _getChapterSpecificDefinitions(subjectId, chapterName);
  }

  List<Map<String, String>> _getChapterSpecificDefinitions(String subjectId, String chapterName) {
    if (subjectId == 'physics') {
      if (chapterName.contains('Electric Charges') || chapterName.contains('Fields')) {
        return [
          {
            'term': 'Electric Charge',
            'definition': 'Electric charge is a fundamental property of matter that causes it to experience a force in an electric field. It exists in two types: positive and negative. Like charges repel, unlike charges attract. Charge is quantized (q = ±ne) and conserved. SI unit: Coulomb (C).',
          },
          {
            'term': 'Coulomb\'s Law',
            'definition': 'Coulomb\'s law states that the electrostatic force between two point charges is directly proportional to the product of their charges and inversely proportional to the square of the distance between them. F = k(q₁q₂)/r², where k = 9×10⁹ Nm²/C².',
          },
          {
            'term': 'Electric Field',
            'definition': 'Electric field at a point is the force experienced per unit positive test charge placed at that point. E = F/q₀. It is a vector quantity with direction same as force on positive charge. SI unit: N/C or V/m. Field lines represent electric field visually.',
          },
          {
            'term': 'Electric Dipole',
            'definition': 'An electric dipole consists of two equal and opposite charges separated by a small distance. Dipole moment p = q × 2a (vector from -q to +q). Unit: Cm. Dipole experiences torque in uniform field and both torque and force in non-uniform field.',
          },
          {
            'term': 'Electric Flux',
            'definition': 'Electric flux through a surface is the number of electric field lines passing through it. Φ = E·A = EA cosθ for uniform field. For closed surface, Φ = ∮E·dA. SI unit: Nm²/C or Vm. Gauss\'s law: Φ = q/ε₀.',
          },
          {
            'term': 'Gauss\'s Law',
            'definition': 'Gauss\'s law states that the electric flux through any closed surface is equal to (1/ε₀) times the charge enclosed by that surface. Φ = ∮E·dA = q_enclosed/ε₀. It is equivalent to Coulomb\'s law but more useful for symmetric charge distributions.',
          },
        ];
      } else if (chapterName.contains('Electrostatic Potential') || chapterName.contains('Capacitance')) {
        return [
          {
            'term': 'Electric Potential',
            'definition': 'Electric potential at a point is the work done per unit positive charge in bringing a test charge from infinity to that point. V = W/q₀ = kq/r for point charge. It is a scalar quantity. SI unit: Volt (V). Potential difference: ΔV = V_B - V_A.',
          },
          {
            'term': 'Equipotential Surface',
            'definition': 'An equipotential surface is a surface on which all points have the same electric potential. Work done in moving charge on equipotential surface is zero. Field lines are perpendicular to equipotential surfaces. No two equipotential surfaces intersect.',
          },
          {
            'term': 'Capacitance',
            'definition': 'Capacitance is the ability of a conductor to store charge. C = Q/V, where Q is charge and V is potential difference. For parallel plate capacitor: C = ε₀A/d. SI unit: Farad (F). Energy stored: U = (1/2)CV² = Q²/2C.',
          },
          {
            'term': 'Dielectric',
            'definition': 'A dielectric is an insulating material placed between capacitor plates. It increases capacitance by factor K (dielectric constant) and reduces electric field. K = C_with/C_without = ε/ε₀. Polarization of dielectric reduces effective field.',
          },
        ];
      }
    } else if (subjectId == 'chemistry') {
      if (chapterName.contains('Solid State')) {
        return [
          {
            'term': 'Crystal Lattice',
            'definition': 'A crystal lattice is a regular 3D arrangement of points representing the positions of atoms, ions, or molecules in a crystal. It is an infinite array of points in space where each point has identical surroundings.',
          },
          {
            'term': 'Unit Cell',
            'definition': 'A unit cell is the smallest repeating unit of a crystal lattice. When repeated in three dimensions, it generates the entire crystal structure. Types: primitive, body-centered, face-centered.',
          },
          {
            'term': 'Coordination Number',
            'definition': 'Coordination number is the number of nearest neighbor atoms or ions surrounding a particular atom or ion in a crystal structure. It indicates how tightly packed the structure is.',
          },
          {
            'term': 'Packing Efficiency',
            'definition': 'Packing efficiency is the percentage of space occupied by atoms or ions in a unit cell. It is calculated as (Volume occupied by atoms/Total volume of unit cell) × 100%. FCC and HCP have highest efficiency (74%).',
          },
        ];
      }
    }
    
    // Default definitions
    return [
      {
        'term': 'Fundamental Concept',
        'definition': 'A fundamental concept in ${chapterName} that describes the basic principle or phenomenon. This definition is essential for understanding all related concepts in this chapter and forms the foundation for advanced topics.',
      },
      {
        'term': 'Key Principle',
        'definition': 'An important principle that relates to ${chapterName} and helps explain the relationships between different aspects of the topic. Understanding this principle is crucial for comprehensive knowledge and problem-solving.',
      },
      {
        'term': 'Core Theory',
        'definition': 'A core theory used in ${chapterName} that has specific meaning and application in this context. This theory helps clarify the scope and provides framework for understanding related concepts.',
      },
      {
        'term': 'Essential Law',
        'definition': 'An essential law in ${chapterName} that requires precise understanding. This law provides clarity on the exact relationships and governs the behavior of systems described in this chapter.',
      },
    ];
  }

  List<Map<String, dynamic>> _getMindMapConcepts() {
    return [
      {'title': 'Basics', 'icon': Icons.school, 'color': Colors.red},
      {'title': 'Applications', 'icon': Icons.apps, 'color': Colors.green},
      {'title': 'Formulas', 'icon': Icons.functions, 'color': Colors.blue},
      {'title': 'Examples', 'icon': Icons.lightbulb, 'color': Colors.orange},
      {'title': 'Problems', 'icon': Icons.quiz, 'color': Colors.purple},
    ];
  }

  List<String> _getRevisionSummary() {
    return [
      'Review all key concepts and their definitions thoroughly',
      'Practice solving problems using the formulas and methods discussed',
      'Understand the relationships between different concepts',
      'Memorize important formulas and their applications',
      'Go through all examples and solved problems',
      'Focus on common question patterns and exam trends',
      'Revise the mind map to visualize connections between topics',
      'Practice time-bound problem solving for exam preparation',
    ];
  }

  Widget _buildMindMapNode(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  // Helper methods to generate content based on chapter
  List<String> _getKeyPointsForChapter() {
    final subjectId = widget.chapter.subjectId;
    if (subjectId == 'physics') {
      return [
        'Understanding fundamental principles and laws',
        'Mathematical relationships and derivations',
        'Practical applications and real-world examples',
        'Problem-solving strategies and techniques',
      ];
    } else if (subjectId == 'chemistry') {
      return [
        'Chemical reactions and mechanisms',
        'Structure and bonding concepts',
        'Properties and characteristics',
        'Industrial and practical applications',
      ];
    } else if (subjectId == 'mathematics') {
      return [
        'Core mathematical concepts and theorems',
        'Formulas and their applications',
        'Problem-solving methods',
        'Geometric and algebraic relationships',
      ];
    } else {
      return [
        'Biological processes and mechanisms',
        'Structure and function relationships',
        'Classification and characteristics',
        'Ecological and evolutionary significance',
      ];
    }
  }

  List<String> _getDefinitionsForChapter() {
    return [
      'Key terms and their precise meanings',
      'Scientific definitions and explanations',
      'Important concepts and their scope',
      'Terminology specific to this chapter',
    ];
  }

  List<String> _getRelationshipsForChapter() {
    return [
      'Interconnections between different concepts',
      'Cause and effect relationships',
      'Mathematical or logical connections',
      'Dependencies and correlations',
    ];
  }

  List<String> _getApplicationsForChapter() {
    return [
      'Real-world applications and examples',
      'Practical uses in daily life',
      'Industrial and technological applications',
      'Research and scientific applications',
    ];
  }

  List<Map<String, String>> _getFormulasForChapter() {
    final subjectId = widget.chapter.subjectId;
    final chapterName = widget.chapter.name.toLowerCase();
    
    if (subjectId == 'physics') {
      if (chapterName.contains('electric') && chapterName.contains('charge')) {
        return [
          {
            'name': 'Coulomb\'s Law',
            'formula': 'F = k(q₁q₂)/r²',
            'description': 'The force between two point charges is directly proportional to the product of charges and inversely proportional to the square of distance between them.',
            'variables': 'F = Force (N), k = Coulomb constant (9×10⁹ Nm²/C²), q₁, q₂ = Charges (C), r = Distance (m)',
            'units': 'F: Newton (N), q: Coulomb (C), r: Meter (m)',
            'application': 'Used to calculate electric force between charged particles, fundamental in electrostatics',
            'example': 'If q₁ = 2μC, q₂ = 3μC, r = 0.1m, then F = (9×10⁹ × 2×10⁻⁶ × 3×10⁻⁶)/(0.1)² = 5.4 N',
          },
          {
            'name': 'Electric Field',
            'formula': 'E = F/q = kq/r²',
            'description': 'Electric field is the force per unit charge. It represents the electric force experienced by a test charge.',
            'variables': 'E = Electric field (N/C), F = Force (N), q = Test charge (C), k = Coulomb constant, r = Distance (m)',
            'units': 'E: Newton per Coulomb (N/C) or Volt per Meter (V/m)',
            'application': 'Used to determine electric field strength at any point, essential for understanding electric potential and capacitance',
            'example': 'For a point charge q = 5μC at distance r = 0.2m, E = (9×10⁹ × 5×10⁻⁶)/(0.2)² = 1.125×10⁶ N/C',
          },
          {
            'name': 'Electric Potential',
            'formula': 'V = kq/r = W/q',
            'description': 'Electric potential is the work done per unit charge to bring a test charge from infinity to a point.',
            'variables': 'V = Electric potential (V), k = Coulomb constant, q = Charge (C), r = Distance (m), W = Work done (J)',
            'units': 'V: Volt (V) = Joule per Coulomb (J/C)',
            'application': 'Used to calculate potential energy, important in capacitors and electric circuits',
            'example': 'For q = 10μC at r = 0.5m, V = (9×10⁹ × 10×10⁻⁶)/0.5 = 1.8×10⁵ V',
          },
          {
            'name': 'Electric Potential Energy',
            'formula': 'U = k(q₁q₂)/r = qV',
            'description': 'Potential energy stored in a system of charges due to their positions relative to each other.',
            'variables': 'U = Potential energy (J), k = Coulomb constant, q₁, q₂ = Charges (C), r = Distance (m), V = Potential (V)',
            'units': 'U: Joule (J)',
            'application': 'Used in energy conservation problems, understanding work done in moving charges',
            'example': 'For q₁ = 2μC, q₂ = -3μC, r = 0.1m, U = (9×10⁹ × 2×10⁻⁶ × -3×10⁻⁶)/0.1 = -0.54 J',
          },
          {
            'name': 'Electric Flux',
            'formula': 'Φ = E·A = E A cos θ',
            'description': 'Electric flux is the measure of electric field lines passing through a given area.',
            'variables': 'Φ = Electric flux (Nm²/C), E = Electric field (N/C), A = Area (m²), θ = Angle between E and normal',
            'units': 'Φ: Newton meter² per Coulomb (Nm²/C)',
            'application': 'Fundamental in Gauss\'s law, used to calculate electric field for symmetric charge distributions',
            'example': 'For E = 1000 N/C, A = 0.01 m², θ = 0°, Φ = 1000 × 0.01 × cos(0°) = 10 Nm²/C',
          },
          {
            'name': 'Gauss\'s Law',
            'formula': 'Φ = ∮E·dA = Q_enc/ε₀',
            'description': 'The total electric flux through a closed surface is proportional to the charge enclosed.',
            'variables': 'Φ = Electric flux, E = Electric field, Q_enc = Enclosed charge (C), ε₀ = Permittivity of free space (8.85×10⁻¹² C²/Nm²)',
            'units': 'Q: Coulomb (C), ε₀: C²/Nm²',
            'application': 'Used to find electric field for symmetric charge distributions like spheres, cylinders, planes',
            'example': 'For a point charge Q = 5μC, using Gaussian sphere, E = Q/(4πε₀r²) = kQ/r²',
          },
        ];
      } else if (chapterName.contains('current') || chapterName.contains('electricity')) {
        return [
          {
            'name': 'Ohm\'s Law',
            'formula': 'V = IR',
            'description': 'The voltage across a conductor is directly proportional to the current flowing through it, with resistance as the constant of proportionality.',
            'variables': 'V = Voltage (V), I = Current (A), R = Resistance (Ω)',
            'units': 'V: Volt (V), I: Ampere (A), R: Ohm (Ω)',
            'application': 'Fundamental law for DC circuits, used in circuit analysis and design',
            'example': 'If V = 12V and R = 4Ω, then I = V/R = 12/4 = 3A',
          },
          {
            'name': 'Resistance',
            'formula': 'R = ρL/A',
            'description': 'Resistance of a conductor depends on its resistivity, length, and cross-sectional area.',
            'variables': 'R = Resistance (Ω), ρ = Resistivity (Ωm), L = Length (m), A = Cross-sectional area (m²)',
            'units': 'R: Ohm (Ω), ρ: Ohm-meter (Ωm)',
            'application': 'Used to calculate resistance of wires and materials, important in circuit design',
            'example': 'For copper wire: ρ = 1.68×10⁻⁸ Ωm, L = 10m, A = 1×10⁻⁶ m², R = (1.68×10⁻⁸ × 10)/(1×10⁻⁶) = 0.168Ω',
          },
          {
            'name': 'Power',
            'formula': 'P = VI = I²R = V²/R',
            'description': 'Electrical power is the rate at which electrical energy is consumed or dissipated.',
            'variables': 'P = Power (W), V = Voltage (V), I = Current (A), R = Resistance (Ω)',
            'units': 'P: Watt (W) = Joule per second (J/s)',
            'application': 'Used to calculate energy consumption, important in electrical appliances and circuits',
            'example': 'If V = 220V and I = 2A, then P = 220 × 2 = 440W',
          },
          {
            'name': 'Resistors in Series',
            'formula': 'R_eq = R₁ + R₂ + R₃ + ...',
            'description': 'Equivalent resistance of resistors connected in series is the sum of individual resistances.',
            'variables': 'R_eq = Equivalent resistance (Ω), R₁, R₂, R₃ = Individual resistances (Ω)',
            'units': 'R: Ohm (Ω)',
            'application': 'Used to simplify series circuits, calculate total resistance and current',
            'example': 'For R₁ = 2Ω, R₂ = 3Ω, R₃ = 5Ω in series, R_eq = 2 + 3 + 5 = 10Ω',
          },
          {
            'name': 'Resistors in Parallel',
            'formula': '1/R_eq = 1/R₁ + 1/R₂ + 1/R₃ + ...',
            'description': 'Reciprocal of equivalent resistance in parallel is sum of reciprocals of individual resistances.',
            'variables': 'R_eq = Equivalent resistance (Ω), R₁, R₂, R₃ = Individual resistances (Ω)',
            'units': 'R: Ohm (Ω)',
            'application': 'Used to simplify parallel circuits, calculate total resistance and current distribution',
            'example': 'For R₁ = 2Ω, R₂ = 3Ω in parallel, 1/R_eq = 1/2 + 1/3 = 5/6, so R_eq = 6/5 = 1.2Ω',
          },
          {
            'name': 'Joule\'s Law',
            'formula': 'H = I²Rt = VIt',
            'description': 'Heat produced in a resistor is proportional to square of current, resistance, and time.',
            'variables': 'H = Heat energy (J), I = Current (A), R = Resistance (Ω), t = Time (s), V = Voltage (V)',
            'units': 'H: Joule (J)',
            'application': 'Used to calculate heat dissipation in electrical devices, important in heating elements',
            'example': 'If I = 5A, R = 4Ω, t = 10s, then H = (5)² × 4 × 10 = 1000J',
          },
        ];
      } else if (chapterName.contains('magnetic') || chapterName.contains('magnetism')) {
        return [
          {
            'name': 'Magnetic Force on Current',
            'formula': 'F = BIL sin θ',
            'description': 'Force on a current-carrying conductor in a magnetic field depends on field strength, current, length, and angle.',
            'variables': 'F = Force (N), B = Magnetic field (T), I = Current (A), L = Length (m), θ = Angle between B and I',
            'units': 'F: Newton (N), B: Tesla (T), I: Ampere (A)',
            'application': 'Used in electric motors, galvanometers, and devices using magnetic force',
            'example': 'If B = 0.5T, I = 2A, L = 0.1m, θ = 90°, then F = 0.5 × 2 × 0.1 × sin(90°) = 0.1N',
          },
          {
            'name': 'Biot-Savart Law',
            'formula': 'dB = (μ₀/4π) × (Idl × r̂)/r²',
            'description': 'Magnetic field due to a small current element is proportional to current, length, and inversely proportional to square of distance.',
            'variables': 'dB = Magnetic field element (T), μ₀ = Permeability of free space (4π×10⁻⁷ Tm/A), I = Current (A), dl = Length element (m), r = Distance (m)',
            'units': 'B: Tesla (T), μ₀: Tesla meter per Ampere (Tm/A)',
            'application': 'Used to calculate magnetic field due to various current configurations',
            'example': 'For straight wire: B = (μ₀I)/(2πr) at distance r',
          },
          {
            'name': 'Ampere\'s Law',
            'formula': '∮B·dl = μ₀I_enc',
            'description': 'Line integral of magnetic field around a closed loop equals μ₀ times current enclosed.',
            'variables': 'B = Magnetic field (T), dl = Length element (m), μ₀ = Permeability, I_enc = Enclosed current (A)',
            'units': 'B: Tesla (T), I: Ampere (A)',
            'application': 'Used to find magnetic field for symmetric current distributions like solenoids, toroids',
            'example': 'For solenoid: B = μ₀nI, where n = turns per unit length',
          },
          {
            'name': 'Magnetic Flux',
            'formula': 'Φ_B = B·A = BA cos θ',
            'description': 'Magnetic flux is the measure of magnetic field lines passing through a given area.',
            'variables': 'Φ_B = Magnetic flux (Wb), B = Magnetic field (T), A = Area (m²), θ = Angle between B and normal',
            'units': 'Φ_B: Weber (Wb) = Tesla meter² (Tm²)',
            'application': 'Fundamental in Faraday\'s law, used in electromagnetic induction',
            'example': 'If B = 0.5T, A = 0.01m², θ = 0°, then Φ_B = 0.5 × 0.01 × cos(0°) = 0.005 Wb',
          },
          {
            'name': 'Faraday\'s Law',
            'formula': 'ε = -dΦ_B/dt',
            'description': 'Induced EMF is equal to negative rate of change of magnetic flux.',
            'variables': 'ε = Induced EMF (V), Φ_B = Magnetic flux (Wb), t = Time (s)',
            'units': 'ε: Volt (V), Φ_B: Weber (Wb)',
            'application': 'Used in generators, transformers, and all electromagnetic induction devices',
            'example': 'If flux changes from 0.01Wb to 0.005Wb in 0.1s, ε = -(0.005-0.01)/0.1 = 0.05V',
          },
          {
            'name': 'Lenz\'s Law',
            'formula': 'ε = -N(dΦ_B/dt)',
            'description': 'Induced current opposes the change in magnetic flux that produces it (negative sign).',
            'variables': 'ε = Induced EMF (V), N = Number of turns, Φ_B = Magnetic flux (Wb), t = Time (s)',
            'units': 'ε: Volt (V)',
            'application': 'Determines direction of induced current, important in understanding electromagnetic induction',
            'example': 'For coil with N = 100 turns, if dΦ_B/dt = 0.01 Wb/s, then ε = -100 × 0.01 = -1V',
          },
        ];
      } else {
        // Default physics formulas
        return [
          {
            'name': 'Coulomb\'s Law',
            'formula': 'F = k(q₁q₂)/r²',
            'description': 'The force between two point charges is directly proportional to the product of charges and inversely proportional to the square of distance.',
            'variables': 'F = Force (N), k = 9×10⁹ Nm²/C², q₁, q₂ = Charges (C), r = Distance (m)',
            'units': 'F: N, q: C, r: m',
            'application': 'Fundamental law in electrostatics, used to calculate electric forces',
            'example': 'q₁ = 2μC, q₂ = 3μC, r = 0.1m → F = 5.4N',
          },
          {
            'name': 'Ohm\'s Law',
            'formula': 'V = IR',
            'description': 'Voltage is directly proportional to current, with resistance as constant.',
            'variables': 'V = Voltage (V), I = Current (A), R = Resistance (Ω)',
            'units': 'V: V, I: A, R: Ω',
            'application': 'Basic law for DC circuits',
            'example': 'V = 12V, R = 4Ω → I = 3A',
          },
          {
            'name': 'Electric Field',
            'formula': 'E = F/q = kq/r²',
            'description': 'Electric field is force per unit charge.',
            'variables': 'E = Electric field (N/C), F = Force (N), q = Charge (C)',
            'units': 'E: N/C or V/m',
            'application': 'Used to determine electric field strength',
            'example': 'q = 5μC, r = 0.2m → E = 1.125×10⁶ N/C',
          },
        ];
      }
    } else if (subjectId == 'chemistry') {
      if (chapterName.contains('solution') || chapterName.contains('solid')) {
        return [
          {
            'name': 'Molarity',
            'formula': 'M = n/V = (W/MW) × (1000/V_ml)',
            'description': 'Molarity is the number of moles of solute per liter of solution.',
            'variables': 'M = Molarity (mol/L), n = Moles (mol), V = Volume (L), W = Weight (g), MW = Molecular weight (g/mol)',
            'units': 'M: mol/L or M, n: mol, V: L',
            'application': 'Used to prepare solutions of known concentration, important in titrations and reactions',
            'example': 'If 5g NaOH (MW=40) in 250mL, M = (5/40) × (1000/250) = 0.5M',
          },
          {
            'name': 'Molality',
            'formula': 'm = n/W_solvent = (W_solute/MW) × (1000/W_solvent_g)',
            'description': 'Molality is moles of solute per kilogram of solvent.',
            'variables': 'm = Molality (mol/kg), n = Moles (mol), W_solvent = Weight of solvent (kg)',
            'units': 'm: mol/kg or m',
            'application': 'Used when temperature changes, as it doesn\'t depend on volume',
            'example': '5g urea (MW=60) in 500g water, m = (5/60) × (1000/500) = 0.167m',
          },
          {
            'name': 'Mole Fraction',
            'formula': 'X_A = n_A/(n_A + n_B + ...)',
            'description': 'Mole fraction is the ratio of moles of a component to total moles in solution.',
            'variables': 'X_A = Mole fraction of A, n_A = Moles of A, n_B = Moles of B',
            'units': 'Dimensionless (no units)',
            'application': 'Used in Raoult\'s law, colligative properties calculations',
            'example': 'If n_A = 2mol, n_B = 3mol, then X_A = 2/(2+3) = 0.4',
          },
          {
            'name': 'Raoult\'s Law',
            'formula': 'P = P°_A X_A + P°_B X_B',
            'description': 'Partial vapor pressure of each component equals its pure vapor pressure times mole fraction.',
            'variables': 'P = Total vapor pressure, P°_A, P°_B = Pure vapor pressures, X_A, X_B = Mole fractions',
            'units': 'P: atm or mmHg',
            'application': 'Used for ideal solutions, important in distillation and separation',
            'example': 'If P°_A = 100mmHg, X_A = 0.6, P°_B = 50mmHg, X_B = 0.4, then P = 100×0.6 + 50×0.4 = 80mmHg',
          },
          {
            'name': 'Henry\'s Law',
            'formula': 'P = K_H × C',
            'description': 'Partial pressure of gas is proportional to its concentration in solution.',
            'variables': 'P = Partial pressure (atm), K_H = Henry\'s constant, C = Concentration (mol/L)',
            'units': 'P: atm, K_H: L·atm/mol, C: mol/L',
            'application': 'Used for solubility of gases in liquids, important in carbonated drinks',
            'example': 'If K_H = 0.034 L·atm/mol, C = 0.1 mol/L, then P = 0.034 × 0.1 = 0.0034 atm',
          },
          {
            'name': 'Osmotic Pressure',
            'formula': 'π = CRT',
            'description': 'Osmotic pressure is proportional to molar concentration and temperature.',
            'variables': 'π = Osmotic pressure (atm), C = Molarity (mol/L), R = Gas constant (0.0821 L·atm/mol·K), T = Temperature (K)',
            'units': 'π: atm, C: mol/L, T: K',
            'application': 'Used in reverse osmosis, determining molecular weights, biological processes',
            'example': 'If C = 0.1M, T = 300K, then π = 0.1 × 0.0821 × 300 = 2.463 atm',
          },
        ];
      } else if (chapterName.contains('kinetic') || chapterName.contains('rate')) {
        return [
          {
            'name': 'Rate Law',
            'formula': 'Rate = k[A]ᵐ[B]ⁿ',
            'description': 'Rate of reaction is proportional to concentrations raised to their order powers.',
            'variables': 'Rate = Reaction rate (mol/L·s), k = Rate constant, [A], [B] = Concentrations (mol/L), m, n = Orders',
            'units': 'Rate: mol/L·s, k: depends on order, [A]: mol/L',
            'application': 'Used to determine reaction mechanism, predict reaction rates',
            'example': 'For Rate = k[A]², if [A] doubles, rate quadruples',
          },
          {
            'name': 'Arrhenius Equation',
            'formula': 'k = Ae^(-Ea/RT)',
            'description': 'Rate constant depends on temperature and activation energy.',
            'variables': 'k = Rate constant, A = Pre-exponential factor, Ea = Activation energy (J/mol), R = Gas constant (8.314 J/mol·K), T = Temperature (K)',
            'units': 'k: depends on order, Ea: J/mol, T: K',
            'application': 'Used to calculate rate constants at different temperatures, understand temperature dependence',
            'example': 'If Ea = 50000 J/mol, T = 300K, then k = A × e^(-50000/(8.314×300))',
          },
          {
            'name': 'Half-Life (First Order)',
            'formula': 't₁/₂ = 0.693/k',
            'description': 'Half-life for first-order reaction is constant and independent of initial concentration.',
            'variables': 't₁/₂ = Half-life (s), k = Rate constant (s⁻¹)',
            'units': 't₁/₂: s, k: s⁻¹',
            'application': 'Used in radioactive decay, drug elimination, first-order reactions',
            'example': 'If k = 0.01 s⁻¹, then t₁/₂ = 0.693/0.01 = 69.3s',
          },
          {
            'name': 'Half-Life (Second Order)',
            'formula': 't₁/₂ = 1/(k[A]₀)',
            'description': 'Half-life for second-order reaction depends on initial concentration.',
            'variables': 't₁/₂ = Half-life (s), k = Rate constant (L/mol·s), [A]₀ = Initial concentration (mol/L)',
            'units': 't₁/₂: s, k: L/mol·s',
            'application': 'Used for second-order reactions, determining reaction order',
            'example': 'If k = 0.1 L/mol·s, [A]₀ = 0.5 mol/L, then t₁/₂ = 1/(0.1×0.5) = 20s',
          },
        ];
      } else if (chapterName.contains('equilibrium')) {
        return [
          {
            'name': 'Equilibrium Constant (Kc)',
            'formula': 'Kc = [C]ᶜ[D]ᵈ / [A]ᵃ[B]ᵇ',
            'description': 'Equilibrium constant is ratio of product concentrations to reactant concentrations, each raised to their stoichiometric coefficients.',
            'variables': 'Kc = Equilibrium constant, [A], [B] = Reactant concentrations, [C], [D] = Product concentrations, a, b, c, d = Coefficients',
            'units': 'Kc: depends on reaction (may be dimensionless)',
            'application': 'Used to predict direction of reaction, calculate equilibrium concentrations',
            'example': 'For aA + bB ⇌ cC + dD, Kc = [C]ᶜ[D]ᵈ/[A]ᵃ[B]ᵇ',
          },
          {
            'name': 'Equilibrium Constant (Kp)',
            'formula': 'Kp = (P_C)ᶜ(P_D)ᵈ / (P_A)ᵃ(P_B)ᵇ',
            'description': 'Equilibrium constant in terms of partial pressures for gaseous reactions.',
            'variables': 'Kp = Equilibrium constant, P_A, P_B = Partial pressures of reactants, P_C, P_D = Partial pressures of products',
            'units': 'Kp: (atm)^Δn where Δn = change in moles',
            'application': 'Used for gas-phase reactions, related to Kc by Kp = Kc(RT)^Δn',
            'example': 'For N₂ + 3H₂ ⇌ 2NH₃, Kp = (P_NH₃)²/(P_N₂)(P_H₂)³',
          },
          {
            'name': 'Relationship Kp and Kc',
            'formula': 'Kp = Kc(RT)^Δn',
            'description': 'Relationship between pressure and concentration equilibrium constants.',
            'variables': 'Kp, Kc = Equilibrium constants, R = Gas constant (0.0821 L·atm/mol·K), T = Temperature (K), Δn = Change in moles',
            'units': 'Kp, Kc: as defined, R: L·atm/mol·K, T: K',
            'application': 'Converts between Kp and Kc, important when both are given',
            'example': 'If Kc = 10, Δn = -2, T = 300K, then Kp = 10 × (0.0821×300)⁻²',
          },
          {
            'name': 'Le Chatelier\'s Principle',
            'formula': 'System shifts to oppose change',
            'description': 'When equilibrium is disturbed, system shifts to minimize the effect of disturbance.',
            'variables': 'Applies to concentration, pressure, temperature changes',
            'units': 'Qualitative principle',
            'application': 'Predicts direction of equilibrium shift, important in industrial processes',
            'example': 'Increase pressure → shifts toward fewer moles, Increase temperature → shifts toward endothermic direction',
          },
        ];
      } else {
        // Default chemistry formulas
        return [
          {
            'name': 'Molarity',
            'formula': 'M = n/V',
            'description': 'Molarity is moles of solute per liter of solution.',
            'variables': 'M = Molarity (mol/L), n = Moles (mol), V = Volume (L)',
            'units': 'M: mol/L',
            'application': 'Used to prepare solutions, important in titrations',
            'example': '5g NaOH (MW=40) in 250mL → M = 0.5M',
          },
          {
            'name': 'Rate Law',
            'formula': 'Rate = k[A]ᵐ[B]ⁿ',
            'description': 'Rate depends on concentrations raised to order powers.',
            'variables': 'Rate = mol/L·s, k = Rate constant, [A], [B] = Concentrations',
            'units': 'Rate: mol/L·s',
            'application': 'Determines reaction mechanism',
            'example': 'Rate = k[A]² → doubling [A] quadruples rate',
          },
        ];
      }
    } else if (subjectId == 'mathematics') {
      if (chapterName.contains('derivative') || chapterName.contains('differentiation')) {
        return [
          {
            'name': 'Definition of Derivative',
            'formula': 'f\'(x) = lim(h→0) [f(x+h) - f(x)]/h',
            'description': 'Derivative is the instantaneous rate of change of a function, representing the slope of tangent line.',
            'variables': 'f\'(x) = Derivative, f(x) = Function, h = Small increment, x = Variable',
            'units': 'Dimensionless (slope)',
            'application': 'Used to find rates of change, optimization problems, curve sketching',
            'example': 'For f(x) = x², f\'(x) = 2x. At x = 3, f\'(3) = 6',
          },
          {
            'name': 'Power Rule',
            'formula': 'd/dx(xⁿ) = nxⁿ⁻¹',
            'description': 'Derivative of x raised to power n is n times x raised to (n-1).',
            'variables': 'n = Power (constant), x = Variable',
            'units': 'Dimensionless',
            'application': 'Most common differentiation rule, used for polynomial functions',
            'example': 'd/dx(x⁵) = 5x⁴, d/dx(x³) = 3x²',
          },
          {
            'name': 'Product Rule',
            'formula': 'd/dx(uv) = u\'v + uv\'',
            'description': 'Derivative of product of two functions is first times derivative of second plus second times derivative of first.',
            'variables': 'u, v = Functions, u\', v\' = Their derivatives',
            'units': 'Dimensionless',
            'application': 'Used when differentiating product of two functions',
            'example': 'For u = x², v = sin(x), d/dx(x²sin(x)) = 2x·sin(x) + x²·cos(x)',
          },
          {
            'name': 'Quotient Rule',
            'formula': 'd/dx(u/v) = (u\'v - uv\')/v²',
            'description': 'Derivative of quotient is (derivative of numerator times denominator minus numerator times derivative of denominator) divided by square of denominator.',
            'variables': 'u, v = Functions, u\', v\' = Their derivatives',
            'units': 'Dimensionless',
            'application': 'Used when differentiating quotient of two functions',
            'example': 'For u = x, v = x²+1, d/dx(x/(x²+1)) = (1·(x²+1) - x·2x)/(x²+1)² = (1-x²)/(x²+1)²',
          },
          {
            'name': 'Chain Rule',
            'formula': 'd/dx[f(g(x))] = f\'(g(x)) · g\'(x)',
            'description': 'Derivative of composite function is derivative of outer function evaluated at inner function times derivative of inner function.',
            'variables': 'f, g = Functions, f\', g\' = Their derivatives',
            'units': 'Dimensionless',
            'application': 'Used for composite functions, essential for complex differentiations',
            'example': 'For f(x) = sin(x²), f\'(x) = cos(x²) · 2x',
          },
          {
            'name': 'Derivative of Trigonometric Functions',
            'formula': 'd/dx(sin x) = cos x, d/dx(cos x) = -sin x, d/dx(tan x) = sec² x',
            'description': 'Standard derivatives of trigonometric functions.',
            'variables': 'x = Angle (radians)',
            'units': 'Dimensionless',
            'application': 'Used in problems involving trigonometric functions',
            'example': 'd/dx(sin(2x)) = cos(2x) · 2 = 2cos(2x)',
          },
        ];
      } else if (chapterName.contains('integral') || chapterName.contains('integration')) {
        return [
          {
            'name': 'Indefinite Integral',
            'formula': '∫f(x)dx = F(x) + C',
            'description': 'Indefinite integral is the antiderivative, where F\'(x) = f(x) and C is constant of integration.',
            'variables': 'f(x) = Function, F(x) = Antiderivative, C = Constant, dx = Differential',
            'units': 'Dimensionless',
            'application': 'Used to find antiderivatives, solve differential equations',
            'example': '∫2x dx = x² + C, since d/dx(x² + C) = 2x',
          },
          {
            'name': 'Definite Integral',
            'formula': '∫[a to b] f(x)dx = F(b) - F(a)',
            'description': 'Definite integral gives area under curve from a to b, evaluated using Fundamental Theorem.',
            'variables': 'f(x) = Function, F(x) = Antiderivative, a, b = Limits of integration',
            'units': 'Area units (depends on function)',
            'application': 'Used to calculate areas, volumes, work done, and many physical quantities',
            'example': '∫[0 to 2] x dx = [x²/2][0 to 2] = 2²/2 - 0²/2 = 2',
          },
          {
            'name': 'Power Rule for Integration',
            'formula': '∫xⁿ dx = xⁿ⁺¹/(n+1) + C (n ≠ -1)',
            'description': 'Integral of x to power n is x to (n+1) divided by (n+1), plus constant.',
            'variables': 'n = Power (constant, n ≠ -1), x = Variable, C = Constant',
            'units': 'Dimensionless',
            'application': 'Most common integration rule, used for polynomial functions',
            'example': '∫x³ dx = x⁴/4 + C, ∫x⁵ dx = x⁶/6 + C',
          },
          {
            'name': 'Integration by Parts',
            'formula': '∫u dv = uv - ∫v du',
            'description': 'Integration by parts formula, derived from product rule of differentiation.',
            'variables': 'u, v = Functions, du, dv = Their differentials',
            'units': 'Dimensionless',
            'application': 'Used when integrand is product of two functions',
            'example': '∫x·eˣ dx: Let u = x, dv = eˣ dx, then = xeˣ - ∫eˣ dx = xeˣ - eˣ + C',
          },
          {
            'name': 'Substitution Method',
            'formula': '∫f(g(x))g\'(x)dx = ∫f(u)du where u = g(x)',
            'description': 'Substitution method simplifies integration by changing variable.',
            'variables': 'f, g = Functions, u = Substitution variable',
            'units': 'Dimensionless',
            'application': 'Used for composite functions, simplifies complex integrals',
            'example': '∫2x·e^(x²) dx: Let u = x², du = 2x dx, then = ∫eᵘ du = eᵘ + C = e^(x²) + C',
          },
        ];
      } else {
        // Default mathematics formulas
        return [
          {
            'name': 'Derivative',
            'formula': 'd/dx[f(x)] = lim(h→0) [f(x+h)-f(x)]/h',
            'description': 'Derivative represents instantaneous rate of change.',
            'variables': 'f\'(x) = Derivative, f(x) = Function',
            'units': 'Dimensionless',
            'application': 'Used to find rates of change, optimization',
            'example': 'd/dx(x²) = 2x',
          },
          {
            'name': 'Integration',
            'formula': '∫f(x)dx = F(x) + C',
            'description': 'Integration is the reverse process of differentiation.',
            'variables': 'f(x) = Function, F(x) = Antiderivative, C = Constant',
            'units': 'Dimensionless',
            'application': 'Used to find areas, antiderivatives',
            'example': '∫2x dx = x² + C',
          },
        ];
      }
    } else {
      // Biology formulas
      return [
        {
          'name': 'Exponential Growth',
          'formula': 'N(t) = N₀e^(rt)',
          'description': 'Population size at time t with initial size N₀ and growth rate r.',
          'variables': 'N(t) = Population at time t, N₀ = Initial population, r = Growth rate, t = Time',
          'units': 'N: individuals, r: per unit time, t: time units',
          'application': 'Used in population ecology, bacterial growth, compound interest',
          'example': 'If N₀ = 100, r = 0.05/day, t = 10 days, then N = 100×e^(0.5) ≈ 165',
        },
        {
          'name': 'Logistic Growth',
          'formula': 'N(t) = K/(1 + [(K-N₀)/N₀]e^(-rt))',
          'description': 'Population growth with carrying capacity K, showing S-shaped curve.',
          'variables': 'N(t) = Population at time t, K = Carrying capacity, N₀ = Initial population, r = Growth rate, t = Time',
          'units': 'N, K: individuals, r: per unit time',
          'application': 'Used for realistic population growth models with limiting factors',
          'example': 'K = 1000, N₀ = 100, r = 0.1, t = 20 → N ≈ 731',
        },
        {
          'name': 'Hardy-Weinberg Equilibrium',
            'formula': 'p² + 2pq + q² = 1',
            'description': 'Allele and genotype frequencies remain constant in ideal population.',
            'variables': 'p = Frequency of dominant allele, q = Frequency of recessive allele, p² = AA frequency, 2pq = Aa frequency, q² = aa frequency',
            'units': 'Frequencies (dimensionless, sum to 1)',
            'application': 'Used in population genetics, evolutionary biology, genetic counseling',
            'example': 'If p = 0.7, q = 0.3, then p² = 0.49, 2pq = 0.42, q² = 0.09',
        },
      ];
    }
  }

  String _getNCERTSummary() {
    return 'This chapter covers the fundamental concepts of ${widget.chapter.name}. '
        'It includes detailed explanations of key topics, important definitions, '
        'theoretical foundations, and practical applications. The content is designed '
        'to help students understand the core principles and develop problem-solving skills. '
        'Each section builds upon previous knowledge and prepares students for advanced topics.';
  }

  List<Map<String, String>> _getNCERTQuestions() {
    return [
      {
        'question': 'Explain the main concept covered in this chapter.',
        'answer': 'The main concept involves understanding the fundamental principles, '
            'their applications, and the relationships between different aspects of the topic.',
      },
      {
        'question': 'What are the key points students should remember?',
        'answer': 'Key points include: (1) Understanding definitions and terminology, '
            '(2) Grasping the underlying principles, (3) Recognizing applications, '
            'and (4) Solving related problems effectively.',
      },
      {
        'question': 'How does this chapter relate to previous topics?',
        'answer': 'This chapter builds upon concepts learned earlier and introduces '
            'new ideas that extend and deepen understanding of the subject matter.',
      },
    ];
  }

  int _getMCQCount() {
    return 70; // 7 sets × 10 questions = 70 questions
  }

  IconData _getResourceIcon(String type) {
    switch (type) {
      case 'Revision':
        return Icons.library_books;
      case 'Formula':
        return Icons.straighten;
      case 'NCERT':
        return Icons.book;
      case 'MCQ':
        return Icons.quiz;
      default:
        return Icons.description;
    }
  }

  Color _getResourceColor(String type) {
    switch (type) {
      case 'Revision':
        return Colors.red;
      case 'Formula':
        return Colors.orange;
      case 'NCERT':
        return Colors.purple;
      case 'MCQ':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }
}
