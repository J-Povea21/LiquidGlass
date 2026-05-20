import 'package:flutter/material.dart';
import '../../../../shared/widgets/course_card.dart';
import '../../../../shared/widgets/staggered_list.dart';
import '../viewmodels/assessment_controller.dart';
import 'assessment_detail_screen.dart';
import 'results_screen.dart';
import 'evaluations_tab.dart';

class HomeScreen extends StatefulWidget {
  final AssessmentController controller;

  const HomeScreen({super.key, required this.controller});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChange);
    if (widget.controller.state == ControllerState.idle) {
      widget.controller.init();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChange);
    super.dispose();
  }

  void _onControllerChange() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PeerAssess M3'),
        centerTitle: false,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          // M3 Fade Through: fade + subtle scale
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.96, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey<int>(_selectedIndex),
          child: _buildTab(controller),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'Evaluaciones',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Resultados',
          ),
        ],
      ),
    );
  }

  Widget _buildTab(AssessmentController controller) {
    if (controller.state == ControllerState.loading ||
        controller.state == ControllerState.idle) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.state == ControllerState.error) {
      return const Center(child: Text('Error cargando datos'));
    }

    switch (_selectedIndex) {
      case 0:
        return _CoursesTab(controller: controller);
      case 1:
        return EvaluationsTab(controller: controller);
      case 2:
        return ResultsScreen(controller: controller);
      default:
        return _CoursesTab(controller: controller);
    }
  }
}

// ─── Tab 0: Cursos con staggered entry animation ──────────────────────────────

class _CoursesTab extends StatelessWidget {
  final AssessmentController controller;

  const _CoursesTab({required this.controller});

  void _openDetail(BuildContext context, String courseId) {
    final assessment = controller.assessments
        .where((a) => a.courseId == courseId)
        .firstOrNull;
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
          // M3 Shared Axis — horizontal slide + fade
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
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Mis cursos',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        StaggeredList(
          children: controller.courses
              .map(
                (course) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Hero(
                    tag: 'course-card-${course.id}',
                    child: CourseCard(
                      course: course,
                      onTap: () => _openDetail(context, course.id),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
