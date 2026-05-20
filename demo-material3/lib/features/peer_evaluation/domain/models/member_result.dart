// Pure Dart — NO Flutter imports
import 'peer.dart';

class MemberResult {
  final Peer peer;
  /// criteriaLabel → average score
  final Map<String, double> scores;

  const MemberResult({
    required this.peer,
    required this.scores,
  });

  double get average {
    if (scores.isEmpty) return 0.0;
    final total = scores.values.fold(0.0, (sum, s) => sum + s);
    return total / scores.length;
  }
}
