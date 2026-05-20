// domain/repositories/AssessmentRepositoryProtocol.swift
// Protocol only — no implementation details, no framework imports

public protocol AssessmentRepositoryProtocol {
    func getCourses() -> [Course]
    func getAssessments() -> [Assessment]
    func getCriteria() -> [Criteria]
    func getPeers() -> [Peer]
    func getEvaluations(for assessmentId: String) -> [Evaluation]
    func computeResults(for assessmentId: String) -> [MemberResult]
}
