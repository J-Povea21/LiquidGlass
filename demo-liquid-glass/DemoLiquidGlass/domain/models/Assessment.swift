// domain/models/Assessment.swift
// Pure Swift struct — NO SwiftUI, NO Foundation imports

public struct Assessment: Identifiable, Equatable, Hashable {
    public let id: String
    public let title: String
    public let courseId: String
    public let deadline: String       // ISO-8601 string — avoids Foundation.Date in domain
    public let criteriaIds: [String]
    public let peerIds: [String]

    public init(
        id: String,
        title: String,
        courseId: String,
        deadline: String,
        criteriaIds: [String],
        peerIds: [String]
    ) {
        self.id = id
        self.title = title
        self.courseId = courseId
        self.deadline = deadline
        self.criteriaIds = criteriaIds
        self.peerIds = peerIds
    }
}
