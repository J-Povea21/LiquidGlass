import 'package:flutter_test/flutter_test.dart';
import 'package:demo_material3/features/peer_evaluation/data/datasources/local/local_assessment_source.dart';
import 'package:demo_material3/features/peer_evaluation/data/repositories/assessment_repository.dart';

void main() {
  group('LocalAssessmentSource', () {
    late LocalAssessmentSource source;

    setUp(() {
      source = LocalAssessmentSource();
    });

    test('getCriteria returns exactly 4 criteria', () {
      final criteria = source.getCriteria();
      expect(criteria.length, 4);
    });

    test('getCriteria labels are non-empty', () {
      final criteria = source.getCriteria();
      for (final c in criteria) {
        expect(c.label, isNotEmpty);
      }
    });

    test('getCriteria weights sum to approximately 1.0', () {
      final criteria = source.getCriteria();
      final total = criteria.fold(0.0, (sum, c) => sum + c.weight);
      expect(total, closeTo(1.0, 0.001));
    });

    test('getAssessments returns at least 1 assessment', () {
      final assessments = source.getAssessments();
      expect(assessments.length, greaterThanOrEqualTo(1));
    });

    test('getCourses returns at least 1 course', () {
      final courses = source.getCourses();
      expect(courses.length, greaterThanOrEqualTo(1));
    });

    test('getPeers returns at least 2 peers', () {
      final peers = source.getPeers();
      expect(peers.length, greaterThanOrEqualTo(2));
    });
  });

  group('AssessmentRepository', () {
    late AssessmentRepository repository;

    setUp(() {
      repository = AssessmentRepository(source: LocalAssessmentSource());
    });

    test('getAssessments returns at least 1 assessment', () async {
      final assessments = await repository.getAssessments();
      expect(assessments.length, greaterThanOrEqualTo(1));
    });

    test('getCriteria returns exactly 4 criteria', () async {
      final criteria = await repository.getCriteria();
      expect(criteria.length, 4);
    });

    test('getCourses returns at least 1 course', () async {
      final courses = await repository.getCourses();
      expect(courses.length, greaterThanOrEqualTo(1));
    });

    test('getPeers returns at least 2 peers', () async {
      final peers = await repository.getPeers();
      expect(peers.length, greaterThanOrEqualTo(2));
    });

    test('getMemberResults returns at least 1 result', () async {
      final results = await repository.getMemberResults();
      expect(results.length, greaterThanOrEqualTo(1));
    });
  });
}
