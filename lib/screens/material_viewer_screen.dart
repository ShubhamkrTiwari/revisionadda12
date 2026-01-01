import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../utils/constants.dart';

class MaterialViewerScreen extends StatelessWidget {
  final StudyMaterial material;

  const MaterialViewerScreen({
    super.key,
    required this.material,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(material.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              // TODO: Implement bookmark
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implement share
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Material Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: _getColorForType(material.type),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _getIconForType(material.type),
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                material.title,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _getTypeLabel(material.type),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        if (material.isPremium)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'PRO',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                      ],
                    ),
                    if (material.description != null && material.description!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(
                        material.description!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Action Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _handleMaterialAction(context);
                },
                icon: const Icon(Icons.open_in_new),
                label: Text(_getActionLabel(material.type)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Placeholder for content
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    _getIconForType(material.type),
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Material content will be displayed here',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleMaterialAction(BuildContext context) {
    switch (material.type) {
      case AppConstants.materialTypePdf:
        // TODO: Open PDF viewer
        _showComingSoon(context);
        break;
      case AppConstants.materialTypeNotes:
        // TODO: Open notes viewer
        _showComingSoon(context);
        break;
      case AppConstants.materialTypeVideo:
        // TODO: Open video player
        _showComingSoon(context);
        break;
      case AppConstants.materialTypeQuiz:
        // TODO: Open quiz
        _showComingSoon(context);
        break;
    }
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Feature coming soon!'),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case AppConstants.materialTypePdf:
        return Icons.picture_as_pdf;
      case AppConstants.materialTypeNotes:
        return Icons.note;
      case AppConstants.materialTypeVideo:
        return Icons.video_library;
      case AppConstants.materialTypeQuiz:
        return Icons.quiz;
      default:
        return Icons.description;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case AppConstants.materialTypePdf:
        return Colors.red;
      case AppConstants.materialTypeNotes:
        return Colors.blue;
      case AppConstants.materialTypeVideo:
        return Colors.purple;
      case AppConstants.materialTypeQuiz:
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case AppConstants.materialTypePdf:
        return 'PDF Document';
      case AppConstants.materialTypeNotes:
        return 'Study Notes';
      case AppConstants.materialTypeVideo:
        return 'Video Lesson';
      case AppConstants.materialTypeQuiz:
        return 'Practice Quiz';
      default:
        return 'Material';
    }
  }

  String _getActionLabel(String type) {
    switch (type) {
      case AppConstants.materialTypePdf:
        return 'Open PDF';
      case AppConstants.materialTypeNotes:
        return 'View Notes';
      case AppConstants.materialTypeVideo:
        return 'Play Video';
      case AppConstants.materialTypeQuiz:
        return 'Start Quiz';
      default:
        return 'Open';
    }
  }
}

