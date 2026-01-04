import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/mindmap_node.dart';
import '../services/mindmap_service.dart';
import '../services/data_service.dart';
import '../services/roadmap_service.dart';

class MindMapScreen extends StatefulWidget {
  final String subjectId;
  final String chapterId;

  const MindMapScreen({
    super.key,
    required this.subjectId,
    required this.chapterId,
  });

  @override
  State<MindMapScreen> createState() => _MindMapScreenState();
}

class _MindMapScreenState extends State<MindMapScreen> {
  List<MindMapNode> _nodes = [];
  bool _isLoading = true;
  double _scale = 1.0;
  Offset _panOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _loadMindMap();
  }

  void _loadMindMap() {
    setState(() {
      _isLoading = true;
    });

    final nodes = MindMapService.generateMindMapForChapter(
      widget.subjectId,
      widget.chapterId,
    );

    setState(() {
      _nodes = nodes;
      _isLoading = false;
    });
  }

  Color _hexToColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  }

  @override
  Widget build(BuildContext context) {
    final chapter = DataService.getChapterById(widget.subjectId, widget.chapterId);
    final subject = DataService.getSubjectById(widget.subjectId);

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
              _buildHeader(chapter, subject),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : _nodes.isEmpty
                        ? const Center(
                            child: Text(
                              'No mind map available',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : _buildMindMapView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(chapter, subject) {
    int chapterIndex = 0;
    if (subject != null && chapter != null) {
      final index = subject.chapters.indexWhere((ch) => ch.id == widget.chapterId);
      chapterIndex = index >= 0 ? index : 0;
    }

    final avenger = RoadmapService.getChapterAvenger(chapterIndex);
    final avengerName = avenger['name'] ?? 'Avenger';
    final avengerColor = avenger['color'] ?? '#7B68EE';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _hexToColor(avengerColor),
            _hexToColor(avengerColor).withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: _hexToColor(avengerColor).withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      avengerName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '🧠',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                if (chapter != null)
                  Text(
                    '${chapter.name} - Mind Map',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.zoom_in, color: Colors.white),
            onPressed: () {
              setState(() {
                _scale = (_scale * 1.2).clamp(0.5, 3.0);
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.zoom_out, color: Colors.white),
            onPressed: () {
              setState(() {
                _scale = (_scale / 1.2).clamp(0.5, 3.0);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMindMapView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return InteractiveViewer(
          minScale: 0.5,
          maxScale: 3.0,
          child: SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: Stack(
              children: [
                // Draw connections
                CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: MindMapPainter(nodes: _nodes),
                ),
                // Draw nodes
                ..._nodes.map((node) {
                  return Positioned(
                    left: node.x * constraints.maxWidth - (node.level == 0 ? 50 : node.level == 1 ? 40 : 30),
                    top: node.y * constraints.maxHeight - (node.level == 0 ? 50 : node.level == 1 ? 40 : 30),
                    child: _buildNode(node),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNode(MindMapNode node) {
    final color = _hexToColor(node.avengerColor);
    final size = node.level == 0 ? 100.0 : node.level == 1 ? 80.0 : 60.0;

    return GestureDetector(
      onTap: () => _showNodeDetail(node),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withOpacity(0.3),
          shape: BoxShape.circle,
          border: Border.all(
            color: color,
            width: node.level == 0 ? 4 : 3,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              node.avengerIcon,
              style: TextStyle(
                fontSize: node.level == 0 ? 40 : node.level == 1 ? 30 : 20,
              ),
            ),
            if (node.level <= 1) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  node.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: node.level == 0 ? 12 : 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showNodeDetail(MindMapNode node) {
    final color = _hexToColor(node.avengerColor);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1a1a2e),
              Colors.black,
            ],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.3),
                      shape: BoxShape.circle,
                      border: Border.all(color: color, width: 3),
                    ),
                    child: Center(
                      child: Text(
                        node.avengerIcon,
                        style: const TextStyle(fontSize: 35),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          node.avengerName,
                          style: TextStyle(
                            color: color,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          node.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
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
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: color.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    node.description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MindMapPainter extends CustomPainter {
  final List<MindMapNode> nodes;
  final Function(MindMapNode)? onNodeTap;

  MindMapPainter({
    required this.nodes,
    this.onNodeTap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw connections between nodes
    for (final node in nodes) {
      if (node.level == 0) {
        // Draw lines from center to children
        for (final childId in node.childIds) {
          final child = nodes.firstWhere(
            (n) => n.id == childId,
            orElse: () => node,
          );
          _drawConnection(canvas, size, node, child);
        }
      } else if (node.level == 1) {
        // Draw lines from concept to sub-concepts
        for (final childId in node.childIds) {
          final child = nodes.firstWhere(
            (n) => n.id == childId,
            orElse: () => node,
          );
          _drawConnection(canvas, size, node, child);
        }
      }
    }
  }

  void _drawConnection(Canvas canvas, Size size, MindMapNode from, MindMapNode to) {
    final fromColor = Color(int.parse(from.avengerColor.replaceFirst('#', '0xFF')));
    final paint = Paint()
      ..color = fromColor.withOpacity(0.4)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fromX = from.x * size.width;
    final fromY = from.y * size.height;
    final toX = to.x * size.width;
    final toY = to.y * size.height;

    canvas.drawLine(
      Offset(fromX, fromY),
      Offset(toX, toY),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

