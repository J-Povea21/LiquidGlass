import XCTest
@testable import DemoLiquidGlass

final class MemberResultTests: XCTestCase {

    func test_average_isCorrect_whenMultipleScores() {
        // Given
        let scores: [String: Double] = [
            "Puntualidad": 4.0,
            "Contribuciones": 3.0,
            "Compromiso": 5.0,
            "Actitud": 4.0
        ]
        let peer = Peer(id: "p1", name: "Juan Perez", initials: "JP")
        let result = MemberResult(peer: peer, scores: scores)

        // When
        let average = result.average

        // Then — (4 + 3 + 5 + 4) / 4 = 4.0
        XCTAssertEqual(average, 4.0, accuracy: 0.001)
    }

    func test_average_isZero_whenNoScores() {
        let peer = Peer(id: "p2", name: "Ana Lopez", initials: "AL")
        let result = MemberResult(peer: peer, scores: [:])

        XCTAssertEqual(result.average, 0.0)
    }

    func test_average_isSingleValue_whenOneScore() {
        let peer = Peer(id: "p3", name: "Carlos R", initials: "CR")
        let result = MemberResult(peer: peer, scores: ["Puntualidad": 5.0])

        XCTAssertEqual(result.average, 5.0, accuracy: 0.001)
    }
}
