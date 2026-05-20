import '../../../domain/models/assessment.dart';
import '../../../domain/models/course.dart';
import '../../../domain/models/criteria.dart';
import '../../../domain/models/peer.dart';
import '../i_assessment_source.dart';

class LocalAssessmentSource implements IAssessmentSource {
  @override
  List<Criteria> getCriteria() => const [
        Criteria(id: 'crit-1', label: 'Puntualidad',    description: 'Llega puntual a las reuniones del equipo',                     weight: 0.25),
        Criteria(id: 'crit-2', label: 'Contribuciones', description: 'Aporta ideas y trabajo de calidad al proyecto',                 weight: 0.30),
        Criteria(id: 'crit-3', label: 'Compromiso',     description: 'Cumple con los entregables acordados en el tiempo establecido', weight: 0.25),
        Criteria(id: 'crit-4', label: 'Actitud',        description: 'Mantiene una actitud positiva y constructiva',                  weight: 0.20),
      ];

  @override
  List<Course> getCourses() => [
        Course(
          id: 'course-1',
          name: 'Desarrollo de Software',
          semester: '2025-1',
          enrollmentCode: 'DS-2025A',
          studentCount: 28,
        ),
        Course(
          id: 'course-2',
          name: 'Ingeniería de Requisitos',
          semester: '2025-1',
          enrollmentCode: 'IR-2025A',
          studentCount: 24,
        ),
        Course(
          id: 'course-3',
          name: 'Arquitecturas de Software',
          semester: '2025-1',
          enrollmentCode: 'AS-2025A',
          studentCount: 20,
        ),
      ];

  @override
  List<Assessment> getAssessments() => [
        Assessment(
          id: 'assess-1',
          courseId: 'course-1',
          title: 'Evaluación Parcial — Sprint 2',
          deadline: DateTime(2025, 4, 15),
          criteriaIds: ['crit-1', 'crit-2', 'crit-3', 'crit-4'],
          peerIds: ['peer-1', 'peer-2', 'peer-3', 'peer-4'],
        ),
        Assessment(
          id: 'assess-2',
          courseId: 'course-1',
          title: 'Evaluación Final — Sprint 4',
          deadline: DateTime(2025, 6, 10),
          criteriaIds: ['crit-1', 'crit-2', 'crit-3', 'crit-4'],
          peerIds: ['peer-1', 'peer-2', 'peer-3', 'peer-4'],
        ),
        Assessment(
          id: 'assess-3',
          courseId: 'course-2',
          title: 'Evaluación Midterm',
          deadline: DateTime(2025, 5, 1),
          criteriaIds: ['crit-1', 'crit-2', 'crit-3', 'crit-4'],
          peerIds: ['peer-5', 'peer-6'],
        ),
      ];

  @override
  List<Peer> getPeers() => const [
        Peer(id: 'peer-1', name: 'María García',  initials: 'MG'),
        Peer(id: 'peer-2', name: 'Carlos López',  initials: 'CL'),
        Peer(id: 'peer-3', name: 'Ana Martínez',  initials: 'AM'),
        Peer(id: 'peer-4', name: 'Julián Torres', initials: 'JT'),
        Peer(id: 'peer-5', name: 'Laura Ríos',    initials: 'LR'),
        Peer(id: 'peer-6', name: 'Diego Vargas',  initials: 'DV'),
      ];
}
