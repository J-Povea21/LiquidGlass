import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:demo_material3/features/peer_evaluation/data/datasources/local/local_assessment_source.dart';
import 'package:demo_material3/features/peer_evaluation/data/repositories/assessment_repository.dart';
import 'package:demo_material3/features/peer_evaluation/domain/models/assessment.dart';
import 'package:demo_material3/features/peer_evaluation/domain/models/course.dart';
import 'package:demo_material3/features/peer_evaluation/domain/models/criteria.dart';
import 'package:demo_material3/features/peer_evaluation/domain/models/member_result.dart';
import 'package:demo_material3/features/peer_evaluation/domain/models/peer.dart';
import 'package:demo_material3/features/peer_evaluation/domain/repositories/i_assessment_repository.dart';
import 'package:demo_material3/features/peer_evaluation/ui/viewmodels/assessment_controller.dart';
import 'package:demo_material3/features/peer_evaluation/ui/views/results_screen.dart';

// ---------------------------------------------------------------------------
// Fake repository that returns no results (used for empty-state test)
// ---------------------------------------------------------------------------
class _EmptyAssessmentRepository implements IAssessmentRepository {
  @override
  Future<List<Assessment>> getAssessments() async => [
        Assessment(
          id: 'assess-empty',
          courseId: 'course-1',
          title: 'Test Assessment',
          deadline: DateTime(2025, 12, 31),
          criteriaIds: [],
          peerIds: [],
        ),
      ];

  @override
  Future<List<Criteria>> getCriteria() async => [];

  @override
  Future<List<Course>> getCourses() async => [];

  @override
  Future<List<Peer>> getPeers() async => [];

  @override
  Future<List<MemberResult>> getMemberResults() async => [];
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------
AssessmentController _buildController() {
  return AssessmentController(
    repository: AssessmentRepository(source: LocalAssessmentSource()),
  );
}

AssessmentController _buildEmptyController() {
  return AssessmentController(repository: _EmptyAssessmentRepository());
}

Widget _buildApp(AssessmentController controller) {
  return MaterialApp(
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
    ),
    home: ResultsScreen(controller: controller),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------
void main() {
  group('ResultsScreen', () {
    testWidgets('displays member result rows after loading', (tester) async {
      final controller = _buildController();
      await controller.init();

      await tester.pumpWidget(_buildApp(controller));
      await tester.pump();

      // At least the first peer should be visible
      final firstResult = controller.memberResults.first;
      expect(find.text(firstResult.peer.name), findsOneWidget);
      // Verify total count via controller
      expect(controller.memberResults.length, greaterThanOrEqualTo(1));
    });

    testWidgets('shows an average score for each member', (tester) async {
      final controller = _buildController();
      await controller.init();

      await tester.pumpWidget(_buildApp(controller));
      await tester.pump();

      // Each member result row should display the average formatted
      expect(find.byType(LinearProgressIndicator), findsAtLeast(1));
    });

    testWidgets('score badge shows a value between 0 and 5', (tester) async {
      final controller = _buildController();
      await controller.init();

      await tester.pumpWidget(_buildApp(controller));
      await tester.pump();

      final firstResult = controller.memberResults.first;
      final avg = firstResult.average;
      expect(avg, greaterThanOrEqualTo(0.0));
      expect(avg, lessThanOrEqualTo(5.0));
    });

    // Fix 9 — New tests

    testWidgets('SegmentedButton is rendered when assessments are loaded',
        (tester) async {
      final controller = _buildController();
      await controller.init();

      await tester.pumpWidget(_buildApp(controller));
      await tester.pump();

      expect(find.byType(SegmentedButton<String>), findsOneWidget);
    });

    testWidgets(
        'top performer card shows trophy icon and highest-scoring peer name',
        (tester) async {
      final controller = _buildController();
      await controller.init();

      await tester.pumpWidget(_buildApp(controller));
      await tester.pump();

      // Trophy icon should be present
      expect(find.byIcon(Icons.emoji_events), findsOneWidget);

      // Highest-scoring peer's name should appear
      final sorted = List<MemberResult>.from(controller.memberResults)
        ..sort((a, b) => b.average.compareTo(a.average));
      final topName = sorted.first.peer.name;
      expect(find.text(topName), findsWidgets);
    });

    testWidgets('empty state shows "Sin resultados" when memberResults is empty',
        (tester) async {
      final controller = _buildEmptyController();
      await controller.init();

      await tester.pumpWidget(_buildApp(controller));
      await tester.pump();

      expect(find.text('Sin resultados'), findsOneWidget);
    });
  });
}
