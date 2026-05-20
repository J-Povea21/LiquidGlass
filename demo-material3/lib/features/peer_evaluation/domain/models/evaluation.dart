// Pure Dart — NO Flutter imports
class Evaluation {
  final String id;
  final String evaluatorId;
  final String peerId;
  final String assessmentId;
  /// criteriaId → score (2, 3, 4, or 5)
  final Map<String, int> scores;

  const Evaluation({
    required this.id,
    required this.evaluatorId,
    required this.peerId,
    required this.assessmentId,
    required this.scores,
  });
}
