import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../services/roadmap_service.dart';
import '../services/ai_content_service.dart';
import 'chapter_visual_content_screen.dart';

class RoadmapNavigationScreen extends StatefulWidget {
  const RoadmapNavigationScreen({super.key});

  @override
  State<RoadmapNavigationScreen> createState() => _RoadmapNavigationScreenState();
}

class _RoadmapNavigationScreenState extends State<RoadmapNavigationScreen> {
  String? _selectedSubjectId;
  String? _selectedChapterId;

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
              _buildHeader(),
              Expanded(
                child: _selectedSubjectId == null
                    ? _buildSubjectSelection(subjects)
                    : _selectedChapterId == null
                        ? _buildChapterSelection(_selectedSubjectId!)
                        : _buildConfirmationView(),
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
            color: const Color(0xFFC41E3A).withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              if (_selectedChapterId != null) {
                setState(() {
                  _selectedChapterId = null;
                });
              } else if (_selectedSubjectId != null) {
                setState(() {
                  _selectedSubjectId = null;
                });
              } else {
                Navigator.pop(context);
              }
            },
          ),
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
                  _selectedSubjectId == null
                      ? 'Select Subject'
                      : _selectedChapterId == null
                          ? 'Select Chapter'
                          : 'Chapter Overview',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          const Text(
            '🦸',
            style: TextStyle(fontSize: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectSelection(List subjects) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choose Your Subject',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select a subject to view its chapters',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              final subject = subjects[index];
              final avengerName = RoadmapService.getSubjectAvengerName(subject.id);
              final avengerColor = RoadmapService.getSubjectAvengerColor(subject.id);
              final avengerIcon = RoadmapService.getSubjectAvengerIcon(subject.id);
              final color = _hexToColor(avengerColor);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSubjectId = subject.id;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color.withOpacity(0.4),
                        color.withOpacity(0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: color.withOpacity(0.6),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        avengerIcon,
                        style: const TextStyle(fontSize: 40),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        avengerName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subject.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${subject.chapters.length} Chapters',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChapterSelection(String subjectId) {
    final subject = DataService.getSubjectById(subjectId);
    if (subject == null) return const SizedBox();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                RoadmapService.getSubjectAvengerIcon(subjectId),
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      RoadmapService.getSubjectAvengerName(subjectId),
                      style: TextStyle(
                        color: _hexToColor(RoadmapService.getSubjectAvengerColor(subjectId)),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      subject.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Select Chapter for Mind Map',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose a chapter to view its overview mind map',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          ...subject.chapters.asMap().entries.map((entry) {
            final index = entry.key;
            final chapter = entry.value;
            final avenger = RoadmapService.getChapterAvenger(index);
            final color = _hexToColor(avenger['color']!);

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withOpacity(0.3),
                    color.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: color.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedChapterId = chapter.id;
                    });
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.3),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: color,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              avenger['icon']!,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                avenger['name']!,
                                style: TextStyle(
                                  color: color,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                chapter.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (chapter.description.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  chapter.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: color,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildConfirmationView() {
    final subject = DataService.getSubjectById(_selectedSubjectId!);
    final chapter = subject?.chapters.firstWhere(
      (ch) => ch.id == _selectedChapterId,
      orElse: () => subject!.chapters.first,
    );

    if (subject == null || chapter == null) return const SizedBox();

    final chapterIndex = subject.chapters.indexWhere((ch) => ch.id == _selectedChapterId);
    final avenger = RoadmapService.getChapterAvenger(chapterIndex >= 0 ? chapterIndex : 0);
    final color = _hexToColor(avenger['color']!);
    
    // Generate AI content
    final aiContent = AIContentService.generateChapterContent(_selectedSubjectId!, _selectedChapterId!);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chapter Info Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withOpacity(0.4),
                  color.withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: color.withOpacity(0.6),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.3),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color,
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      avenger['icon']!,
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  avenger['name']!,
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  chapter.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Info Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: color.withOpacity(0.3),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Learn with Avengers!',
                        style: TextStyle(
                          color: color,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Tap below to see visual explanations with Avengers characters explaining concepts through flowcharts and diagrams!',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Action Button - View Visual Content
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChapterVisualContentScreen(
                          subjectId: _selectedSubjectId!,
                          chapterId: _selectedChapterId!,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.visibility),
                  label: const Text('View Visual Content'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedChapterId = null;
              });
            },
            child: const Text(
              'Choose Different Chapter',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }


  Color _hexToColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  }
}

