import 'package:flutter/material.dart';

/// M3-styled SegmentedButton with a brief pulse/scale feedback
/// when the selected value changes.
class ScoreSegment extends StatefulWidget {
  final int selected;
  final ValueChanged<int> onChanged;

  const ScoreSegment({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  State<ScoreSegment> createState() => _ScoreSegmentState();
}

class _ScoreSegmentState extends State<ScoreSegment>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.08),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.08, end: 1.0),
        weight: 50,
      ),
    ]).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _handleChange(int value) {
    if (value != widget.selected) {
      _pulseController.forward(from: 0);
    }
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: SegmentedButton<int>(
        segments: const [
          ButtonSegment(value: 2, label: Text('2')),
          ButtonSegment(value: 3, label: Text('3')),
          ButtonSegment(value: 4, label: Text('4')),
          ButtonSegment(value: 5, label: Text('5')),
        ],
        selected: {widget.selected},
        onSelectionChanged: (val) => _handleChange(val.first),
      ),
    );
  }
}
