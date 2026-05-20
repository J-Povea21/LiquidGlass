// domain/models/Evaluation.swift
// Pure Swift struct — NO SwiftUI, NO Foundation imports

/// One student's evaluation of one peer, scored per-criteria.
/// Valid scores are 2, 3, 4, or 5 (PeerAssess scale).
public struct Evaluation: Identifiable, Equatable {
    public let id: String
    public let assessmentId: String
    public let evaluatorId: String
    public let peerId: String
    /// key: criteriaId, value: score in {2, 3, 4, 5}
    public let scores: [String: Int]

    public init(
        id: String,
        assessmentId: String,
        evaluatorId: String,
        peerId: String,
        scores: [String: Int]
    ) {
        self.id = id
        self.assessmentId = assessmentId
        self.evaluatorId = evaluatorId
        self.peerId = peerId
        self.scores = scores
    }
}
