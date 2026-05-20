// Pure Dart — NO Flutter imports
class Assessment {
  final String id;
  final String courseId;
  final String title;
  final DateTime deadline;
  final List<String> criteriaIds;
  final List<String> peerIds;

  const Assessment({
    required this.id,
    required this.courseId,
    required this.title,
    required this.deadline,
    required this.criteriaIds,
    required this.peerIds,
  });
}
