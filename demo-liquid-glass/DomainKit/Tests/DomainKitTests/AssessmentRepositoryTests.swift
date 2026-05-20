import XCTest
@testable import DomainKit

final class AssessmentRepositoryTests: XCTestCase {

    private var repository: AssessmentRepository!

    override func setUp() {
        super.setUp()
        let source = LocalAssessmentSource()
        repository = AssessmentRepository(source: source)
    }

    // MARK: - Assessments

    func test_getAssessments_returnsAtLeastOne() {
        let assessments = repository.getAssessments()

        XCTAssertGreaterThanOrEqual(assessments.count, 1,
                                    "Repository must provide at least 1 assessment")
    }

    func test_getAssessments_hasValidTitle() {
        let assessments = repository.getAssessments()

        for assessment in assessments {
            XCTAssertFalse(assessment.title.isEmpty, "Assessment title must not be empty")
        }
    }

    func test_getAssessments_hasAssociatedCriteria() {
        let assessments = repository.getAssessments()

        for assessment in assessments {
            XCTAssertFalse(assessment.criteriaIds.isEmpty,
                           "Assessment must reference at least one criteria")
        }
    }

    // MARK: - Criteria

    func test_getCriteria_returnsFour() {
        let criteria = repository.getCriteria()

        XCTAssertEqual(criteria.count, 4, "Standard PeerAssess rubric has exactly 4 criteria")
    }

    func test_getCriteria_allHaveNonZeroWeights() {
        let criteria = repository.getCriteria()

        for c in criteria {
            XCTAssertGreaterThan(c.weight, 0.0, "Criteria '\(c.name)' must have positive weight")
        }
    }

    // MARK: - Peers

    func test_getPeers_returnsAtLeastTwo() {
        let peers = repository.getPeers()

        XCTAssertGreaterThanOrEqual(peers.count, 2, "Need at least 2 peers for evaluation demo")
    }

    // MARK: - Courses

    func test_getCourses_returnsAtLeastOne() {
        let courses = repository.getCourses()

        XCTAssertGreaterThanOrEqual(courses.count, 1, "Repository must provide at least 1 course")
    }

    // MARK: - Results

    func test_computeResults_averageIsWithinValidRange() {
        let peers = repository.getPeers()
        let criteria = repository.getCriteria()

        guard let peer = peers.first else { return }

        let scores = Dictionary(uniqueKeysWithValues: criteria.map { ($0.name, Double.random(in: 2...5)) })
        let result = MemberResult(peer: peer, scores: scores)

        XCTAssertTrue(result.average >= 2.0 && result.average <= 5.0,
                      "Average should be within PeerAssess valid range [2, 5]")
    }
}
