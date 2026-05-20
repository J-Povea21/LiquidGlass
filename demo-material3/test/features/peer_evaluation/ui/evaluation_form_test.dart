import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:demo_material3/features/peer_evaluation/data/datasources/local/local_assessment_source.dart';
import 'package:demo_material3/features/peer_evaluation/data/repositories/assessment_repository.dart';
import 'package:demo_material3/features/peer_evaluation/ui/viewmodels/assessment_controller.dart';
import 'package:demo_material3/features/peer_evaluation/ui/views/evaluation_form_screen.dart';

AssessmentController _buildController() {
  return AssessmentController(
    repository: AssessmentRepository(source: LocalAssessmentSource()),
  );
}

Widget _buildApp(AssessmentController controller) {
  return MaterialApp(
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
    ),
    home: EvaluationFormScreen(controller: controller),
  );
}

void main() {
  group('EvaluationFormScreen', () {
    testWidgets('renders a SegmentedButton for score selection',
        (tester) async {
      final controller = _buildController();
      await controller.init();
      controller.selectAssessment(controller.assessments.first);
      controller.selectPeer(controller.peers.first);

      await tester.pumpWidget(_buildApp(controller));
      await tester.pump();

      expect(find.byType(SegmentedButton<int>), findsAtLeast(1));
    });

    testWidgets('selecting a score updates controller', (tester) async {
      final controller = _buildController();
      await controller.init();
      controller.selectAssessment(controller.assessments.first);
      controller.selectPeer(controller.peers.first);

      await tester.pumpWidget(_buildApp(controller));
      await tester.pump();

      // Tap score "5" in the first SegmentedButton
      final score5 = find.text('5').first;
      await tester.tap(score5);
      await tester.pump();

      expect(controller.currentScores.isNotEmpty, isTrue);
    });

    testWidgets('shows a LinearProgressIndicator for progress', (tester) async {
      final controller = _buildController();
      await controller.init();
      controller.selectAssessment(controller.assessments.first);
      controller.selectPeer(controller.peers.first);

      await tester.pumpWidget(_buildApp(controller));
      await tester.pump();

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });
  });
}
