import 'package:flutter/material.dart';
import '../../../../app_theme.dart';
import '../viewmodels/assessment_controller.dart';
import 'evaluation_form_screen.dart';

class AssessmentDetailScreen extends StatefulWidget {
  final AssessmentController controller;

  /// courseId is used for the Hero tag that connects CourseCard → this screen.
  final String? courseId;

  const AssessmentDetailScreen({
    super.key,
    required this.controller,
    this.courseId,
  });

  @override
  State<AssessmentDetailScreen> createState() => _AssessmentDetailScreenState();
}

class _AssessmentDetailScreenState extends State<AssessmentDetailScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_rebuild);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final assessment = controller.selectedAssessment;
    final colorScheme = Theme.of(context).colorScheme;

    Widget content = Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text(assessment?.title ?? 'Evaluación'),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Criterios de evaluación',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(controller.criteria.length, (index) {
                    final c = controller.criteria[index];
                    final criteriaColor = AppTheme.criteriaColors[index % AppTheme.criteriaColors.length];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: criteriaColor.withValues(alpha: 0.20),
                        child: Text(
                          '${(c.weight * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 12,
                            color: criteriaColor,
                          ),
                        ),
                      ),
                      title: Text(c.label),
                      subtitle: Text('${(c.weight * 100).toInt()}% del total'),
                    );
                  }),
                  const SizedBox(height: 24),
                  Text(
                    'Compañeros a evaluar',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 80,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: (assessment != null
                              ? controller.peersForAssessment(assessment)
                              : controller.peers)
                          .map(
                            (peer) => Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: colorScheme.primaryContainer,
                                    child: Text(
                                      peer.initials,
                                      style: TextStyle(
                                        color: colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    peer.name.split(' ').first,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      icon: const Icon(Icons.rate_review),
                      label: const Text('Iniciar evaluación'),
                      onPressed: () {
                        final peers = assessment != null
                            ? controller.peersForAssessment(assessment)
                            : controller.peers;
                        if (peers.isNotEmpty) {
                          controller.startEvaluation(peers);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EvaluationFormScreen(
                                controller: controller,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    // Wrap with Hero only when a courseId tag is provided
    if (widget.courseId != null) {
      return Hero(
        tag: 'course-card-${widget.courseId}',
        // Hero needs a Material ancestor to avoid visual glitches
        child: Material(
          type: MaterialType.transparency,
          child: content,
        ),
      );
    }

    return content;
  }
}
