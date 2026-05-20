// domain/models/Course.swift
// Pure Swift struct — NO SwiftUI, NO Foundation imports
// Dependency rule: domain layer has zero external framework dependencies

public struct Course: Identifiable, Equatable {
    public let id: String
    public let name: String
    public let semester: String
    public let enrollmentCode: String
    public let studentCount: Int

    public init(
        id: String,
        name: String,
        semester: String,
        enrollmentCode: String,
        studentCount: Int
    ) {
        self.id = id
        self.name = name
        self.semester = semester
        self.enrollmentCode = enrollmentCode
        self.studentCount = studentCount
    }
}
