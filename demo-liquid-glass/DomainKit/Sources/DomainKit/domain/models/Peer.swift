// domain/models/Peer.swift
// Pure Swift struct — NO SwiftUI, NO Foundation imports

public struct Peer: Identifiable, Equatable {
    public let id: String
    public let name: String
    public let initials: String

    public init(id: String, name: String, initials: String) {
        self.id = id
        self.name = name
        self.initials = initials
    }
}
