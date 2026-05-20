import XCTest
@testable import DomainKit

final class CriteriaTests: XCTestCase {

    func test_criteria_weightsAreNonEmpty() {
        let criteria = Criteria(
            id: "c1",
            name: "Puntualidad",
            weight: 0.25,
            description: "Llega a tiempo a las reuniones"
        )

        XCTAssertGreaterThan(criteria.weight, 0.0)
    }

    func test_criteria_weightIsValidFraction() {
        let criteria = Criteria(id: "c2", name: "Contribuciones", weight: 0.30, description: "")

        XCTAssertTrue(criteria.weight > 0 && criteria.weight <= 1.0,
                      "Weight must be in (0, 1]")
    }

    func test_criteria_nameIsNotEmpty() {
        let criteria = Criteria(id: "c3", name: "Compromiso", weight: 0.25, description: "")

        XCTAssertFalse(criteria.name.isEmpty)
    }

    func test_standardCriteria_hasFourItems() {
        let criteria = Criteria.standard

        XCTAssertEqual(criteria.count, 4, "PeerAssess uses 4 standard criteria")
    }

    func test_standardCriteria_weightsSum_isApproximatelyOne() {
        let total = Criteria.standard.reduce(0.0) { $0 + $1.weight }

        XCTAssertEqual(total, 1.0, accuracy: 0.001,
                       "All weights should sum to 1.0")
    }
}
