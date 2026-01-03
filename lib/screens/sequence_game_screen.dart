import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/subject.dart';

class SequenceGameScreen extends StatefulWidget {
  final Subject subject;

  const SequenceGameScreen({super.key, required this.subject});

  @override
  State<SequenceGameScreen> createState() => _SequenceGameScreenState();
}

class _SequenceGameScreenState extends State<SequenceGameScreen> {
  List<String> _items = [];
  List<String> _selectedOrder = [];
  List<String> _correctOrder = [];
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    final sequence = _getSubjectSequence();
    _correctOrder = List.from(sequence);
    _items = List.from(sequence)..shuffle(Random());
    _selectedOrder = [];
    _isComplete = false;
    setState(() {});
  }

  List<String> _getSubjectSequence() {
    final subjectId = widget.subject.id;
    
    if (subjectId == 'physics') {
      return [
        'Electric Charge',
        'Electric Field',
        'Electric Potential',
        'Current',
        'Resistance',
        'Magnetic Field',
      ];
    } else if (subjectId == 'chemistry') {
      return [
        'Reactants',
        'Activation Energy',
        'Transition State',
        'Products',
        'Equilibrium',
        'Rate Constant',
      ];
    } else if (subjectId == 'mathematics') {
      return [
        'Function',
        'Limit',
        'Derivative',
        'Integration',
        'Application',
        'Solution',
      ];
    } else {
      return [
        'DNA',
        'Transcription',
        'RNA',
        'Translation',
        'Protein',
        'Function',
      ];
    }
  }

  void _onItemTap(String item) {
    if (_isComplete) return;
    
    setState(() {
      if (_selectedOrder.contains(item)) {
        _selectedOrder.remove(item);
      } else {
        _selectedOrder.add(item);
      }
      
      _checkSequence();
    });
  }

  void _checkSequence() {
    if (_selectedOrder.length == _correctOrder.length) {
      bool isCorrect = true;
      for (int i = 0; i < _selectedOrder.length; i++) {
        if (_selectedOrder[i] != _correctOrder[i]) {
          isCorrect = false;
          break;
        }
      }
      
      if (isCorrect) {
        setState(() {
          _isComplete = true;
        });
        HapticFeedback.heavyImpact();
        _showCompletionDialog();
      }
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('🎉 Perfect Sequence!'),
        content: const Text('You arranged everything in the correct order!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Back'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _initializeGame();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.purple.shade50, Colors.pink.shade50],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Arrange in Correct Sequence',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _selectedOrder.asMap().entries.map((entry) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade400,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${entry.key + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              entry.value,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
              ),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                final isSelected = _selectedOrder.contains(item);
                final position = _selectedOrder.indexOf(item);
                
                return InkWell(
                  onTap: () => _onItemTap(item),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                              colors: [
                                Colors.purple.shade400,
                                Colors.purple.shade600,
                              ],
                            )
                          : null,
                      color: isSelected ? null : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.purple : Colors.grey[300]!,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isSelected)
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${position + 1}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple.shade700,
                                ),
                              ),
                            ),
                          ),
                        if (isSelected) const SizedBox(height: 8),
                        Text(
                          item,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isComplete)
            Container(
              padding: const EdgeInsets.all(16),
              child: const Text(
                '✅ Correct Sequence!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

