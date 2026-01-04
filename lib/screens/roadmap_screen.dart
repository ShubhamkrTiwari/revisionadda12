import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../services/roadmap_service.dart';
import '../models/roadmap_item.dart';
import '../models/subject.dart';
import 'subject_detail_screen_v2.dart';
import 'chapter_concepts_screen.dart';

class RoadmapScreen extends StatefulWidget {
  final String? subjectId;

  const RoadmapScreen({super.key, this.subjectId});

  @override
  State<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen> {
  String? _selectedSubjectId;
  List<RoadmapItem> _roadmapItems = [];

  @override
  void initState() {
    super.initState();
    _selectedSubjectId = widget.subjectId;
    _loadRoadmap();
  }

  void _loadRoadmap() {
    if (_selectedSubjectId != null) {
      _roadmapItems = RoadmapService.generateRoadmapForSubject(_selectedSubjectId!);
    } else {
      _roadmapItems = RoadmapService.generateCompleteRoadmap();
    }
    setState(() {});
  }

  void _onSubjectChanged(String? subjectId) {
    setState(() {
      _selectedSubjectId = subjectId;
    });
    _loadRoadmap();
  }

  Color _hexToColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  }

  @override
  Widget build(BuildContext context) {
    final subjects = DataService.getSubjects();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              const Color(0xFF1a1a2e),
              const Color(0xFF16213e),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Marvel Avengers Header
              _buildHeader(),
              
              // Subject Filter
              if (widget.subjectId == null) _buildSubjectFilter(subjects),
              
              // Roadmap Content
              Expanded(
                child: _roadmapItems.isEmpty
                    ? const Center(
                        child: Text(
                          'No roadmap available',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: _roadmapItems.length,
                        itemBuilder: (context, index) {
                          return _buildRoadmapItem(_roadmapItems[index], index);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFC41E3A), // Marvel red
            const Color(0xFFED1C24),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              '🦸',
              style: TextStyle(fontSize: 32),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AVENGERS ROADMAP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.subjectId != null
                      ? '${RoadmapService.getSubjectAvengerName(widget.subjectId!)} Mission'
                      : 'Complete Learning Journey',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectFilter(List<Subject> subjects) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: Colors.black.withOpacity(0.3),
      child: Row(
        children: [
          const Icon(Icons.filter_list, color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedSubjectId,
                isExpanded: true,
                dropdownColor: const Color(0xFF1a1a2e),
                style: const TextStyle(color: Colors.white),
                hint: const Text(
                  'All Subjects',
                  style: TextStyle(color: Colors.white70),
                ),
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('All Subjects'),
                  ),
                  ...subjects.map((subject) {
                    final avengerName = RoadmapService.getSubjectAvengerName(subject.id);
                    return DropdownMenuItem<String>(
                      value: subject.id,
                      child: Row(
                        children: [
                          Text(
                            RoadmapService.getSubjectAvengerIcon(subject.id),
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 8),
                          Text('$avengerName - ${subject.name}'),
                        ],
                      ),
                    );
                  }),
                ],
                onChanged: _onSubjectChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoadmapItem(RoadmapItem item, int index) {
    final color = _hexToColor(item.avengerColor);
    final isLocked = item.isLocked && !item.isCompleted;
    final subject = DataService.getSubjectById(item.subjectId);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Stack(
        children: [
          // Main Card
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withOpacity(0.3),
                  color.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isLocked
                    ? Colors.grey.withOpacity(0.3)
                    : color.withOpacity(0.5),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isLocked
                      ? Colors.transparent
                      : color.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isLocked
                    ? null
                    : () {
                        // Navigate to chapter concepts screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChapterConceptsScreen(
                              subjectId: item.subjectId,
                              chapterId: item.chapterId,
                            ),
                          ),
                        );
                      },
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      // Avenger Icon/Emoji
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: isLocked
                              ? Colors.grey.withOpacity(0.2)
                              : color.withOpacity(0.3),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isLocked
                                ? Colors.grey
                                : color,
                            width: 3,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            RoadmapService.getChapterAvenger(item.order)['icon'] ?? '🦸',
                            style: TextStyle(
                              fontSize: 32,
                              color: isLocked
                                  ? Colors.grey
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.avengerName,
                                    style: TextStyle(
                                      color: isLocked
                                          ? Colors.grey
                                          : color,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                                if (item.isCompleted)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      '✓',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                if (isLocked)
                                  const Icon(
                                    Icons.lock,
                                    color: Colors.grey,
                                    size: 16,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.name,
                              style: TextStyle(
                                color: isLocked
                                    ? Colors.grey
                                    : Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isLocked
                                    ? Colors.grey.withOpacity(0.7)
                                    : Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            if (subject != null) ...[
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.school,
                                    size: 14,
                                    color: isLocked
                                        ? Colors.grey
                                        : color,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    subject.name,
                                    style: TextStyle(
                                      color: isLocked
                                          ? Colors.grey
                                          : color,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      // Arrow
                      Icon(
                        isLocked
                            ? Icons.lock_outline
                            : Icons.arrow_forward_ios,
                        color: isLocked
                            ? Colors.grey
                            : color,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Connection Line (if not last item)
          if (index < _roadmapItems.length - 1)
            Positioned(
              left: 35,
              top: 90,
              child: Container(
                width: 2,
                height: 16,
                color: _roadmapItems[index + 1].isLocked
                    ? Colors.grey.withOpacity(0.3)
                    : _hexToColor(_roadmapItems[index + 1].avengerColor)
                        .withOpacity(0.5),
              ),
            ),
        ],
      ),
    );
  }
}

