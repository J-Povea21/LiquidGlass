// domain/models/MemberResult.swift
// Pure Swift struct — NO SwiftUI, NO Foundation imports

/// Aggregated evaluation result for a single peer across all evaluators.
public struct MemberResult: Identifiable, Equatable {
    public let id: String
    public let peer: Peer
    /// key: criteria name, value: average score across all evaluators
    public let scores: [String: Double]

    public init(peer: Peer, scores: [String: Double]) {
        self.id = peer.id
        self.peer = peer
        self.scores = scores
    }

    /// Overall average score across all criteria.
    public var average: Double {
        guard !scores.isEmpty else { return 0.0 }
        let total = scores.values.reduce(0.0, +)
        return total / Double(scores.count)
    }
}
