import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../utils/constants.dart';

class MaterialCard extends StatelessWidget {
  final StudyMaterial material;
  final VoidCallback onTap;

  const MaterialCard({
    super.key,
    required this.material,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getColorForType(context, material.type),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getIconForType(material.type),
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            material.title,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        if (material.isPremium)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                      const SizedBox(height: 4),
                      Text(
                        material.description!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
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

  Color _getColorForType(BuildContext context, String type) {
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
        return Theme.of(context).colorScheme.primary;
    }
  }
}

