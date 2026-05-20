// data/repositories/AssessmentRepository.swift
// Concrete implementation of AssessmentRepositoryProtocol
// Depends on LocalAssessmentSource (data layer) — never on presentation

public final class AssessmentRepository: AssessmentRepositoryProtocol {
    private let source: LocalAssessmentSource

    public init(source: LocalAssessmentSource) {
        self.source = source
    }

    public func getCourses() -> [Course] {
        source.fetchCourses()
    }

    public func getAssessments() -> [Assessment] {
        source.fetchAssessments()
    }

    public func getCriteria() -> [Criteria] {
        source.fetchCriteria()
    }

    public func getPeers() -> [Peer] {
        source.fetchPeers()
    }

    public func getEvaluations(for assessmentId: String) -> [Evaluation] {
        source.fetchEvaluations(for: assessmentId)
    }

    /// Aggregates all evaluations for an assessment into per-peer MemberResult values.
    public func computeResults(for assessmentId: String) -> [MemberResult] {
        let evaluations = source.fetchEvaluations(for: assessmentId)
        let allPeers = source.fetchPeers()
        let criteria = source.fetchCriteria()

        // Group evaluations by peerId
        let grouped = Dictionary(grouping: evaluations, by: { $0.peerId })

        return grouped.compactMap { (peerId, peerEvaluations) -> MemberResult? in
            guard let peer = allPeers.first(where: { $0.id == peerId }) else { return nil }

            // Compute average per criteria across all evaluators
            var criteriaAverages: [String: Double] = [:]
            for crit in criteria {
                let critScores = peerEvaluations.compactMap { eval -> Double? in
                    guard let score = eval.scores[crit.id] else { return nil }
                    return Double(score)
                }
                if !critScores.isEmpty {
                    criteriaAverages[crit.name] = critScores.reduce(0, +) / Double(critScores.count)
                }
            }

            return MemberResult(peer: peer, scores: criteriaAverages)
        }
        .sorted { $0.average > $1.average }
    }
}
