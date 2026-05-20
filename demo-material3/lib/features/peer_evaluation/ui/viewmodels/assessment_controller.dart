import 'package:flutter/foundation.dart';
import '../../domain/models/assessment.dart';
import '../../domain/models/course.dart';
import '../../domain/models/criteria.dart';
import '../../domain/models/member_result.dart';
import '../../domain/models/peer.dart';
import '../../domain/repositories/i_assessment_repository.dart';

enum ControllerState { idle, loading, ready, error }

class AssessmentController extends ChangeNotifier {
  final IAssessmentRepository _repository;

  AssessmentController({required IAssessmentRepository repository})
      : _repository = repository;

  ControllerState _state = ControllerState.idle;
  ControllerState get state => _state;

  List<Course> _courses = [];
  List<Course> get courses => _courses;

  List<Assessment> _assessments = [];
  List<Assessment> get assessments => _assessments;

  List<Criteria> _criteria = [];
  List<Criteria> get criteria => _criteria;

  List<Peer> _peers = [];
  List<Peer> get peers => _peers;

  List<MemberResult> _memberResults = [];
  List<MemberResult> get memberResults => _memberResults;

  Assessment? _selectedAssessment;
  Assessment? get selectedAssessment => _selectedAssessment;

  Peer? _selectedPeer;
  Peer? get selectedPeer => _selectedPeer;

  /// criteriaId → selected score (2/3/4/5)
  final Map<String, int> _currentScores = {};
  Map<String, int> get currentScores => Map.unmodifiable(_currentScores);

  // Ordered list of peers to evaluate for the current assessment
  List<Peer> _evaluationPeers = [];
  int _currentPeerIndex = 0;

  int get currentPeerIndex => _currentPeerIndex;
  List<Peer> get evaluationPeers => _evaluationPeers;
  bool get isLastPeer => _currentPeerIndex >= _evaluationPeers.length - 1;

  // Per-peer scores: peerId → criteriaId → score
  final Map<String, Map<String, int>> _allEvaluationScores = {};
  Map<String, Map<String, int>> get allEvaluationScores =>
      Map.unmodifiable(_allEvaluationScores);

  Future<void> init() async {
    _state = ControllerState.loading;
    notifyListeners();

    try {
      _courses = await _repository.getCourses();
      _assessments = await _repository.getAssessments();
      _criteria = await _repository.getCriteria();
      _peers = await _repository.getPeers();
      _memberResults = await _repository.getMemberResults();
      _state = ControllerState.ready;
    } catch (_) {
      _state = ControllerState.error;
    }

    notifyListeners();
  }

  List<Peer> peersForAssessment(Assessment assessment) {
    return _peers.where((p) => assessment.peerIds.contains(p.id)).toList();
  }

  void selectAssessment(Assessment assessment) {
    _selectedAssessment = assessment;
    _currentScores.clear();
    notifyListeners();
  }

  void selectPeer(Peer peer) {
    _selectedPeer = peer;
    _currentScores.clear();
    for (final c in _criteria) {
      _currentScores[c.id] = 3;
    }
    notifyListeners();
  }

  void setScore(String criteriaId, int score) {
    assert(score >= 2 && score <= 5, 'Score must be between 2 and 5');
    _currentScores[criteriaId] = score;
    notifyListeners();
  }

  bool get isEvaluationComplete =>
      _criteria.isNotEmpty &&
      _currentScores.length == _criteria.length;

  void startEvaluation(List<Peer> peersToEvaluate) {
    _evaluationPeers = List.from(peersToEvaluate);
    _currentPeerIndex = 0;
    _allEvaluationScores.clear();
    _currentScores.clear();
    if (_evaluationPeers.isNotEmpty) {
      _selectedPeer = _evaluationPeers.first;
      // pre-fill defaults
      for (final c in _criteria) {
        _currentScores[c.id] = 3;
      }
    }
    notifyListeners();
  }

  void advanceToNextPeer() {
    if (_selectedPeer != null) {
      _allEvaluationScores[_selectedPeer!.id] = Map.from(_currentScores);
    }
    if (!isLastPeer) {
      _currentPeerIndex++;
      _selectedPeer = _evaluationPeers[_currentPeerIndex];
      _currentScores.clear();
      for (final c in _criteria) {
        _currentScores[c.id] = 3;
      }
      notifyListeners();
    }
  }

  void finishEvaluation() {
    if (_selectedPeer != null) {
      _allEvaluationScores[_selectedPeer!.id] = Map.from(_currentScores);
    }
    notifyListeners();
  }
}
