import '../../domain/models/assessment.dart';
import '../../domain/models/course.dart';
import '../../domain/models/criteria.dart';
import '../../domain/models/member_result.dart';
import '../../domain/models/peer.dart';
import '../../domain/repositories/i_assessment_repository.dart';
import '../datasources/i_assessment_source.dart';

class AssessmentRepository implements IAssessmentRepository {
  final IAssessmentSource source;

  AssessmentRepository({required this.source});

  @override
  Future<List<Assessment>> getAssessments() async =>
      source.getAssessments();

  @override
  Future<List<Criteria>> getCriteria() async => source.getCriteria();

  @override
  Future<List<Course>> getCourses() async => source.getCourses();

  @override
  Future<List<Peer>> getPeers() async => source.getPeers();

  @override
  Future<List<MemberResult>> getMemberResults() async {
    final peers = source.getPeers();

    // Fixed scores per peer id matching iOS evaluation data for assess-1 peers
    const Map<String, Map<String, double>> iosScores = {
      'peer-1': {'Puntualidad': 4.5, 'Contribuciones': 3.5, 'Compromiso': 3.5, 'Actitud': 4.0},
      'peer-2': {'Puntualidad': 4.0, 'Contribuciones': 4.7, 'Compromiso': 4.3, 'Actitud': 4.7},
      'peer-3': {'Puntualidad': 3.5, 'Contribuciones': 4.0, 'Compromiso': 3.8, 'Actitud': 3.5},
      'peer-4': {'Puntualidad': 4.2, 'Contribuciones': 3.8, 'Compromiso': 4.0, 'Actitud': 4.5},
    };

    // Only include peers that have fixed iOS scores (assess-1 peers)
    return peers
        .where((peer) => iosScores.containsKey(peer.id))
        .map((peer) => MemberResult(peer: peer, scores: iosScores[peer.id]!))
        .toList();
  }
}
