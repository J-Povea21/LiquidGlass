// data/datasources/local/LocalAssessmentSource.swift
// Provides hardcoded demo data — simulates what a real network/database source would return

public final class LocalAssessmentSource {
    public init() {}

    public func fetchCourses() -> [Course] {
        [
            Course(
                id: "course-1",
                name: "Desarrollo de Software",
                semester: "2025-1",
                enrollmentCode: "DS-2025A",
                studentCount: 28
            ),
            Course(
                id: "course-2",
                name: "Ingeniería de Requisitos",
                semester: "2025-1",
                enrollmentCode: "IR-2025A",
                studentCount: 24
            ),
            Course(
                id: "course-3",
                name: "Arquitecturas de Software",
                semester: "2025-1",
                enrollmentCode: "AS-2025A",
                studentCount: 20
            ),
        ]
    }

    public func fetchAssessments() -> [Assessment] {
        [
            Assessment(
                id: "assess-1",
                title: "Evaluación Parcial — Sprint 2",
                courseId: "course-1",
                deadline: "2025-04-15",
                criteriaIds: ["crit-1", "crit-2", "crit-3", "crit-4"],
                peerIds: ["peer-1", "peer-2", "peer-3", "peer-4"]
            ),
            Assessment(
                id: "assess-2",
                title: "Evaluación Final — Sprint 4",
                courseId: "course-1",
                deadline: "2025-06-10",
                criteriaIds: ["crit-1", "crit-2", "crit-3", "crit-4"],
                peerIds: ["peer-1", "peer-2", "peer-3", "peer-4"]
            ),
            Assessment(
                id: "assess-3",
                title: "Evaluación Midterm",
                courseId: "course-2",
                deadline: "2025-05-01",
                criteriaIds: ["crit-1", "crit-2", "crit-3", "crit-4"],
                peerIds: ["peer-5", "peer-6"]
            ),
        ]
    }

    public func fetchCriteria() -> [Criteria] {
        Criteria.standard
    }

    public func fetchPeers() -> [Peer] {
        [
            Peer(id: "peer-1", name: "María García", initials: "MG"),
            Peer(id: "peer-2", name: "Carlos López", initials: "CL"),
            Peer(id: "peer-3", name: "Ana Martínez", initials: "AM"),
            Peer(id: "peer-4", name: "Julián Torres", initials: "JT"),
            Peer(id: "peer-5", name: "Laura Ríos", initials: "LR"),
            Peer(id: "peer-6", name: "Diego Vargas", initials: "DV"),
        ]
    }

    public func fetchEvaluations(for assessmentId: String) -> [Evaluation] {
        guard assessmentId == "assess-1" else { return [] }
        return [
            Evaluation(
                id: "eval-1",
                assessmentId: "assess-1",
                evaluatorId: "peer-1",
                peerId: "peer-2",
                scores: ["crit-1": 4, "crit-2": 5, "crit-3": 4, "crit-4": 5]
            ),
            Evaluation(
                id: "eval-2",
                assessmentId: "assess-1",
                evaluatorId: "peer-3",
                peerId: "peer-2",
                scores: ["crit-1": 3, "crit-2": 4, "crit-3": 5, "crit-4": 4]
            ),
            Evaluation(
                id: "eval-3",
                assessmentId: "assess-1",
                evaluatorId: "peer-4",
                peerId: "peer-2",
                scores: ["crit-1": 5, "crit-2": 5, "crit-3": 4, "crit-4": 5]
            ),
            Evaluation(
                id: "eval-4",
                assessmentId: "assess-1",
                evaluatorId: "peer-2",
                peerId: "peer-1",
                scores: ["crit-1": 4, "crit-2": 3, "crit-3": 4, "crit-4": 4]
            ),
            Evaluation(
                id: "eval-5",
                assessmentId: "assess-1",
                evaluatorId: "peer-3",
                peerId: "peer-1",
                scores: ["crit-1": 5, "crit-2": 4, "crit-3": 3, "crit-4": 4]
            ),
        ]
    }
}
