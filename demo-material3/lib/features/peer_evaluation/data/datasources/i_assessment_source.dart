import '../../domain/models/assessment.dart';
import '../../domain/models/course.dart';
import '../../domain/models/criteria.dart';
import '../../domain/models/peer.dart';

abstract interface class IAssessmentSource {
  List<Assessment> getAssessments();
  List<Criteria> getCriteria();
  List<Course> getCourses();
  List<Peer> getPeers();
}
