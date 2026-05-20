import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:demo_material3/features/peer_evaluation/data/datasources/local/local_assessment_source.dart';
import 'package:demo_material3/features/peer_evaluation/data/repositories/assessment_repository.dart';
import 'package:demo_material3/features/peer_evaluation/ui/viewmodels/assessment_controller.dart';
import 'package:demo_material3/features/peer_evaluation/ui/views/home_screen.dart';

Widget _buildApp(AssessmentController controller) {
  return MaterialApp(
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
    ),
    home: HomeScreen(controller: controller),
  );
}

AssessmentController _buildController() {
  return AssessmentController(
    repository: AssessmentRepository(source: LocalAssessmentSource()),
  );
}

void main() {
  group('HomeScreen', () {
    testWidgets('renders a NavigationBar', (tester) async {
      final controller = _buildController();
      await tester.pumpWidget(_buildApp(controller));
      await controller.init();
      await tester.pump();

      expect(find.byType(NavigationBar), findsOneWidget);
    });

    testWidgets('renders at least one course card after loading',
        (tester) async {
      final controller = _buildController();
      await tester.pumpWidget(_buildApp(controller));
      await controller.init();
      await tester.pump();

      // HomeScreen should display cards for each course
      expect(find.byType(Card), findsAtLeast(1));
    });

    testWidgets('shows course names in the list', (tester) async {
      final controller = _buildController();
      await tester.pumpWidget(_buildApp(controller));
      await controller.init();
      await tester.pump();

      expect(find.text('Desarrollo de Software'), findsOneWidget);
    });
  });
}
