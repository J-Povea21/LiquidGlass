import 'package:flutter/material.dart';
import '../../../../shared/widgets/staggered_list.dart';
import '../viewmodels/assessment_controller.dart';
import 'assessment_detail_screen.dart';

/// Tab 1 — Lista de evaluaciones pendientes.
/// Antes esta pantalla no existía; por eso la pestaña no hacía nada.
class EvaluationsTab extends StatelessWidget {
  final AssessmentController controller;

  const EvaluationsTab({super.key, required this.controller});

  void _openDetail(BuildContext context, String courseId, String assessmentId) {
    final assessment =
        controller.assessments.where((a) => a.id == assessmentId).firstOrNull;
    if (assessment == null) return;

    controller.selectAssessment(assessment);
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AssessmentDetailScreen(
              controller: controller,
              courseId: courseId,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide = Tween<Offset>(
            begin: const Offset(1.0, 0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubicEmphasized,
            ),
          );
          final fade = CurvedAnimation(
            parent: animation,
            curve: const Interval(0.0, 0.5),
          );
          return SlideTransition(
            position: slide,
            child: FadeTransition(opacity: fade, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 450),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final assessments = controller.assessments;
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Evaluaciones pendientes',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        if (assessments.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 48),
              child: Column(
                children: [
                  Icon(
                    Icons.assignment_turned_in_outlined,
                    size: 64,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay evaluaciones pendientes',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          )
        else
          StaggeredList(
            children: assessments.map((assessment) {
              final course = controller.courses
                  .where((c) => c.id == assessment.courseId)
                  .firstOrNull;
              final daysLeft =
                  assessment.deadline.difference(DateTime.now()).inDays;
              final isUrgent = daysLeft <= 7;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  color: colorScheme.surfaceContainerHighest,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _openDetail(
                        context, assessment.courseId, assessment.id),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  assessment.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              if (isUrgent)
                                Chip(
                                  label: const Text('Urgente'),
                                  backgroundColor: colorScheme.errorContainer,
                                  labelStyle: TextStyle(
                                    color: colorScheme.onErrorContainer,
                                    fontSize: 11,
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                            ],
                          ),
                          if (course != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              course.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: colorScheme.onSurfaceVariant),
                            ),
                          ],
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 14,
                                color: isUrgent
                                    ? colorScheme.error
                                    : colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                daysLeft > 0
                                    ? 'Vence en $daysLeft días'
                                    : 'Vencida',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: isUrgent
                                          ? colorScheme.error
                                          : colorScheme.onSurfaceVariant,
                                      fontWeight:
                                          isUrgent ? FontWeight.bold : null,
                                    ),
                              ),
                              const Spacer(),
                              Text(
                                '${assessment.criteriaIds.length} criterios',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: colorScheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
