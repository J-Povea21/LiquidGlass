import 'package:flutter/material.dart';

/// Helper widget that animates a list of items with a staggered fade+slide
/// entrance. Uses a single AnimationController with Interval so no Timer
/// is created — safe for Flutter widget tests.
class StaggeredList extends StatefulWidget {
  final List<Widget> children;

  /// Duration of each individual item animation.
  final Duration itemDuration;

  /// Delay between consecutive item starts.
  final Duration staggerDelay;

  const StaggeredList({
    super.key,
    required this.children,
    this.itemDuration = const Duration(milliseconds: 400),
    this.staggerDelay = const Duration(milliseconds: 80),
  });

  @override
  State<StaggeredList> createState() => _StaggeredListState();
}

class _StaggeredListState extends State<StaggeredList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    final count = widget.children.length;
    final totalMs = count > 0
        ? widget.staggerDelay.inMilliseconds * (count - 1) +
            widget.itemDuration.inMilliseconds
        : widget.itemDuration.inMilliseconds;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: totalMs),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.children.length;
    final totalMs = count > 0
        ? widget.staggerDelay.inMilliseconds * (count - 1) +
            widget.itemDuration.inMilliseconds
        : widget.itemDuration.inMilliseconds;
    final totalDuration = totalMs.toDouble();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: widget.children.asMap().entries.map((entry) {
        final i = entry.key;
        final child = entry.value;

        final startMs = widget.staggerDelay.inMilliseconds * i;
        final endMs = startMs + widget.itemDuration.inMilliseconds;
        final start = (startMs / totalDuration).clamp(0.0, 1.0);
        final end = (endMs / totalDuration).clamp(0.0, 1.0);

        final interval =
            CurvedAnimation(parent: _controller, curve: Interval(start, end));

        final fade =
            CurvedAnimation(parent: interval, curve: Curves.easeOut);
        final slide = Tween<Offset>(
          begin: const Offset(0, 0.12),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: interval, curve: Curves.easeOutCubic),
        );

        return FadeTransition(
          opacity: fade,
          child: SlideTransition(position: slide, child: child),
        );
      }).toList(),
    );
  }
}
