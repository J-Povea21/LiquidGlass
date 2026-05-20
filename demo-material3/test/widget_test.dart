import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:demo_material3/main.dart';
import 'package:demo_material3/features/peer_evaluation/data/datasources/local/local_assessment_source.dart';
import 'package:demo_material3/features/peer_evaluation/data/repositories/assessment_repository.dart';
import 'package:demo_material3/features/peer_evaluation/ui/viewmodels/assessment_controller.dart';

void main() {
  testWidgets('App smoke test — renders without crashing', (WidgetTester tester) async {
    final controller = AssessmentController(
      repository: AssessmentRepository(source: LocalAssessmentSource()),
    );
    await tester.pumpWidget(DemoMaterial3App(controller: controller));
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
