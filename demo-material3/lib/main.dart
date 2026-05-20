import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'features/peer_evaluation/data/datasources/local/local_assessment_source.dart';
import 'features/peer_evaluation/data/repositories/assessment_repository.dart';
import 'features/peer_evaluation/ui/viewmodels/assessment_controller.dart';
import 'features/peer_evaluation/ui/views/home_screen.dart';

void main() {
  // Plain constructor injection — no GetX or service locator
  final source = LocalAssessmentSource();
  final repository = AssessmentRepository(source: source);
  final controller = AssessmentController(repository: repository);

  runApp(DemoMaterial3App(controller: controller));
}

class DemoMaterial3App extends StatelessWidget {
  final AssessmentController controller;

  const DemoMaterial3App({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PeerAssess — Material Design 3',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: HomeScreen(controller: controller),
    );
  }
}
