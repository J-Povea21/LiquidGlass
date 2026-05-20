// domain/models/Criteria.swift
// Pure Swift struct — NO SwiftUI, NO Foundation imports

public struct Criteria: Identifiable, Equatable {
    public let id: String
    public let name: String
    public let weight: Double
    public let description: String

    public init(id: String, name: String, weight: Double, description: String) {
        self.id = id
        self.name = name
        self.weight = weight
        self.description = description
    }
}

public extension Criteria {
    /// Standard PeerAssess rubric — 4 criteria, weights sum to 1.0
    static let standard: [Criteria] = [
        Criteria(
            id: "crit-1",
            name: "Puntualidad",
            weight: 0.25,
            description: "Llega puntual a las reuniones del equipo"
        ),
        Criteria(
            id: "crit-2",
            name: "Contribuciones",
            weight: 0.30,
            description: "Aporta ideas y trabajo de calidad al proyecto"
        ),
        Criteria(
            id: "crit-3",
            name: "Compromiso",
            weight: 0.25,
            description: "Cumple con los entregables acordados en el tiempo establecido"
        ),
        Criteria(
            id: "crit-4",
            name: "Actitud",
            weight: 0.20,
            description: "Mantiene una actitud positiva y constructiva"
        ),
    ]
}
