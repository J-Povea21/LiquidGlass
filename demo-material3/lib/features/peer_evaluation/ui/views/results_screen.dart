import 'package:flutter/material.dart';
import '../../../../app_theme.dart';
import '../../../../shared/widgets/criteria_bar.dart';
import '../viewmodels/assessment_controller.dart';
import '../../domain/models/assessment.dart';
import '../../domain/models/member_result.dart';

class ResultsScreen extends StatefulWidget {
  final AssessmentController controller;

  /// When [showAsPage] is true the widget wraps itself in a [Scaffold] with an
  /// [AppBar] so it can be used as a standalone route pushed via
  /// [Navigator.push].  When false (the default) it returns the bare [ListView]
  /// so it can be embedded directly inside another [Scaffold]'s body (e.g. a
  /// bottom-navigation tab in [HomeScreen]).
  final bool showAsPage;

  const ResultsScreen({
    super.key,
    required this.controller,
    this.showAsPage = false,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  Assessment? _selectedAssessment;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_rebuild);
    _selectedAssessment = widget.controller.assessments.isNotEmpty
        ? widget.controller.assessments.first
        : null;
  }

  @override
  void dispose() {
    widget.controller.removeListener(_rebuild);
    super.dispose();
  }

  // Fix 1: Re-anchor _selectedAssessment to the fresh object after reload
  void _rebuild() {
    if (!mounted) return;
    setState(() {
      final assessments = widget.controller.assessments;
      if (_selectedAssessment == null) {
        _selectedAssessment = assessments.isNotEmpty ? assessments.first : null;
      } else {
        final stillExists = assessments.any((a) => a.id == _selectedAssessment!.id);
        if (stillExists) {
          _selectedAssessment = assessments.firstWhere((a) => a.id == _selectedAssessment!.id);
        } else {
          _selectedAssessment = assessments.isNotEmpty ? assessments.first : null;
        }
      }
    });
  }

  // Fix 2: Fallback to all memberResults when peerIds is empty
  List<MemberResult> get _filteredResults {
    if (_selectedAssessment == null) return [];
    final peerIds = _selectedAssessment!.peerIds;
    if (peerIds.isEmpty) return widget.controller.memberResults;
    return widget.controller.memberResults
        .where((r) => peerIds.contains(r.peer.id))
        .toList();
  }

  // Fix 5: Add max-length cap to _shortTitle
  String _shortTitle(String title) {
    const maxLen = 20;
    final base = title.contains(' — ') ? title.split(' — ').first : title;
    return base.length > maxLen ? '${base.substring(0, maxLen)}…' : base;
  }

  Color _rankColor(int rank, ColorScheme colorScheme) {
    switch (rank) {
      case 1:
        return AppTheme.rankGold;
      case 2:
        return AppTheme.rankSilver;
      case 3:
        return AppTheme.rankBronze;
      default:
        return colorScheme.onSurfaceVariant;
    }
  }

  Color _scoreColor(double average, ColorScheme colorScheme) {
    if (average >= 4.5) return AppTheme.scoreHigh;
    if (average >= 3.5) return colorScheme.primary;
    return AppTheme.scoreMid;
  }

  // Fix 6: Extract buildTopPerformerCard as a private method
  Widget _buildTopPerformerCard(BuildContext context, MemberResult result) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      color: colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.emoji_events, color: Colors.amber, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    result.peer.name,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
                Text(
                  result.average.toStringAsFixed(1),
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Mejor evaluado',
              style: textTheme.bodySmall?.copyWith(
                color: Colors.amber.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            ...result.scores.entries.map(
              (e) => CriteriaBar(label: e.key, score: e.value),
            ),
          ],
        ),
      ),
    );
  }

  // Fix 6: Extract buildRankedRow as a private method
  Widget _buildRankedRow(BuildContext context, MemberResult result, int rank) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final rankColor = _rankColor(rank, colorScheme);
    final scoreColor = _scoreColor(result.average, colorScheme);
    final initials = result.peer.name
        .split(' ')
        .where((s) => s.isNotEmpty)
        .take(2)
        .map((s) => s[0].toUpperCase())
        .join();

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              child: Text(
                '$rank',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: rankColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 12),
            CircleAvatar(
              backgroundColor: colorScheme.primaryContainer,
              child: Text(
                initials,
                style: TextStyle(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                result.peer.name,
                style: textTheme.bodyLarge,
              ),
            ),
            Text(
              result.average.toStringAsFixed(1),
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: scoreColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final assessments = controller.assessments;

    // Fix 3: Guarantee _selectedAssessment is non-null when assessments is non-empty
    if (_selectedAssessment == null && assessments.isNotEmpty) {
      _selectedAssessment = assessments.first;
    }

    // Sorted results — highest average first
    final sorted = List<MemberResult>.from(_filteredResults)
      ..sort((a, b) => b.average.compareTo(a.average));

    final topPerformer = sorted.isNotEmpty ? sorted.first : null;

    Widget buildSegmentedButton() {
      if (assessments.isEmpty) return const SizedBox.shrink();
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SegmentedButton<String>(
          segments: assessments
              .map(
                (a) => ButtonSegment<String>(
                  value: a.id,
                  label: Text(_shortTitle(a.title)),
                ),
              )
              .toList(),
          // Fix 3: _selectedAssessment is guaranteed non-null here
          selected: {_selectedAssessment!.id},
          onSelectionChanged: (selected) {
            if (selected.isEmpty) return;
            setState(() {
              _selectedAssessment = assessments.firstWhere(
                (a) => a.id == selected.first,
              );
            });
          },
          multiSelectionEnabled: false,
        ),
      );
    }

    final listView = ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Assessment selector
        buildSegmentedButton(),
        const SizedBox(height: 20),

        // Section header
        Text(
          'Resultados de la evaluación',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (_selectedAssessment != null) ...[
          const SizedBox(height: 2),
          Text(
            _selectedAssessment!.title,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: 16),

        // Top performer card
        if (topPerformer != null) ...[
          _buildTopPerformerCard(context, topPerformer),
          const SizedBox(height: 16),
        ],

        // Ranked list
        if (sorted.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'Sin resultados',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          )
        else
          ...List.generate(
            sorted.length,
            (i) => _buildRankedRow(context, sorted[i], i + 1),
          ),
      ],
    );

    if (widget.showAsPage) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: const Text('Resultados'),
        ),
        body: listView,
      );
    }

    return listView;
  }
}
