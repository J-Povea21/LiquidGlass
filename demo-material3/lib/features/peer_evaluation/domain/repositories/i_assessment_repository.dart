import '../models/assessment.dart';
import '../models/course.dart';
import '../models/criteria.dart';
import '../models/member_result.dart';
import '../models/peer.dart';

abstract interface class IAssessmentRepository {
  Future<List<Assessment>> getAssessments();
  Future<List<Criteria>> getCriteria();
  Future<List<Course>> getCourses();
  Future<List<Peer>> getPeers();
  Future<List<MemberResult>> getMemberResults();
}
