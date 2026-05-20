import SwiftUI

// NOTE: AppState is in the presentation layer.
// It holds a reference to AssessmentRepositoryProtocol (domain protocol).
// It NEVER imports the data layer directly — DI happens at the app entry point.
//
// @Observable requires iOS 17+. This app targets iOS 17 minimum.

@Observable
final class AppState {
    // MARK: - Injected dependency (domain protocol)
    private let repository: AssessmentRepositoryProtocol

    // MARK: - Navigation state
    var selectedCourse: Course?
    var selectedAssessment: Assessment?
    var selectedPeer: Peer?

    // MARK: - Tab selection
    var selectedTab: Int = 0

    // MARK: - Cached data (lazy-loaded)
    private(set) var courses: [Course] = []
    private(set) var assessments: [Assessment] = []
    private(set) var criteria: [Criteria] = []
    private(set) var peers: [Peer] = []

    // MARK: - Evaluation form state
    // Outer key: peer.id, inner key: criteria.id, value: score (2–5)
    var currentEvaluationScores: [String: [String: Int]] = [:]
    var currentPeerIndex: Int = 0

    // MARK: - Results
    private(set) var results: [MemberResult] = []

    // MARK: - Init
    init(repository: AssessmentRepositoryProtocol) {
        self.repository = repository
        loadData()
    }

    // MARK: - Data loading
    func loadData() {
        courses = repository.getCourses()
        assessments = repository.getAssessments()
        criteria = repository.getCriteria()
        peers = repository.getPeers()
    }

    func setScore(_ score: Int, forCriteria criteriaId: String, peer peerId: String) {
        if currentEvaluationScores[peerId] == nil {
            currentEvaluationScores[peerId] = [:]
        }
        currentEvaluationScores[peerId]![criteriaId] = score
    }

    func isComplete(for peerId: String) -> Bool {
        guard let scores = currentEvaluationScores[peerId] else { return false }
        return scores.count == criteria.count
    }

    func loadResults(for assessmentId: String) {
        // If the user has entered scores via the form, compute results from those.
        // Otherwise fall back to pre-computed hardcoded data (e.g. QuickResultsView tab).
        if currentEvaluationScores.isEmpty {
            results = repository.computeResults(for: assessmentId)
            return
        }

        guard let assessment = assessments.first(where: { $0.id == assessmentId }) else {
            results = []
            return
        }

        let evaluatedPeers = peers(for: assessment)

        results = evaluatedPeers.compactMap { peer in
            guard let peerScores = currentEvaluationScores[peer.id] else { return nil }
            // Map criteria.id -> criteria.name for the scores dictionary
            var criteriaScores: [String: Double] = [:]
            for crit in criteria {
                if let raw = peerScores[crit.id] {
                    criteriaScores[crit.name] = Double(raw)
                }
            }
            return MemberResult(peer: peer, scores: criteriaScores)
        }
        .sorted { $0.average > $1.average }
    }

    // MARK: - Helpers
    func assessments(for courseId: String) -> [Assessment] {
        assessments.filter { $0.courseId == courseId }
    }

    func peers(for assessment: Assessment) -> [Peer] {
        peers.filter { assessment.peerIds.contains($0.id) }
    }

    func resetEvaluationForm() {
        currentEvaluationScores = [:]
        currentPeerIndex = 0
    }
}
