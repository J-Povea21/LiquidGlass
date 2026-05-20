import 'package:flutter/material.dart';
import '../../../../app_theme.dart';
import '../../../../shared/widgets/score_segment.dart';
import '../viewmodels/assessment_controller.dart';
import 'results_screen.dart';

class EvaluationFormScreen extends StatefulWidget {
  final AssessmentController controller;

  const EvaluationFormScreen({super.key, required this.controller});

  @override
  State<EvaluationFormScreen> createState() => _EvaluationFormScreenState();
}

class _EvaluationFormScreenState extends State<EvaluationFormScreen> {
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

  String _scoreLabel(int score) {
    switch (score) {
      case 2:
        return 'Por mejorar';
      case 3:
        return 'Cumple con lo esperado';
      case 4:
        return 'Supera las expectativas';
      case 5:
        return 'Excelente desempeño';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final peer = controller.selectedPeer;
    final criteria = controller.criteria;
    final scores = controller.currentScores;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final totalPeers = controller.evaluationPeers.length;
    final currentIndex = controller.currentPeerIndex;
    final progressValue = totalPeers == 0 ? 0.0 : currentIndex / totalPeers;
    final progressPercent = (progressValue * 100).toInt();

    final firstName = peer?.name.split(' ').first ?? '';

    // Button is enabled only when all criteria have a score
    final allScored = criteria.isNotEmpty &&
        criteria.every((c) => scores.containsKey(c.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Evaluación'),
      ),
      body: Column(
        children: [
          // Progress header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Compañero ${currentIndex + 1} de $totalPeers',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '$progressPercent%',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.brand,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progressValue,
                    minHeight: 6,
                    color: colorScheme.primary,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // Peer header card
                if (peer != null) ...[
                  Card(
                    color: colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            radius: 36,
                            child: Text(
                              peer.initials,
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            peer.name,
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Evalúa el desempeño de $firstName',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onPrimaryContainer
                                  .withValues(alpha: 0.75),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Criteria cards
                ...List.generate(criteria.length, (index) {
                  final c = criteria[index];
                  final criteriaColor = AppTheme.criteriaColors[index % AppTheme.criteriaColors.length];
                  final score = scores[c.id] ?? 3;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Card(
                        color: colorScheme.surface,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Criteria name row
                              Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: criteriaColor,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      c.label,
                                      style: textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${(c.weight * 100).toInt()}%',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              // Description
                              Text(
                                c.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Score selector
                              Center(
                                child: ScoreSegment(
                                  selected: score,
                                  onChanged: (val) =>
                                      controller.setScore(c.id, val),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Score label
                              Center(
                                child: Text(
                                  _scoreLabel(score),
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // Bottom action button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: Icon(
                  controller.isLastPeer
                      ? Icons.bar_chart_rounded
                      : Icons.arrow_forward,
                ),
                label: Text(
                  controller.isLastPeer
                      ? 'Ver Resultados'
                      : 'Siguiente compañero →',
                ),
                onPressed: allScored
                    ? () {
                        if (controller.isLastPeer) {
                          controller.finishEvaluation();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ResultsScreen(
                                controller: controller,
                                showAsPage: true,
                              ),
                            ),
                          );
                        } else {
                          controller.advanceToNextPeer();
                        }
                      }
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
