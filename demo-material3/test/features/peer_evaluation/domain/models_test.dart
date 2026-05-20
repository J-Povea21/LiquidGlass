import 'package:flutter_test/flutter_test.dart';
import 'package:demo_material3/features/peer_evaluation/domain/models/criteria.dart';
import 'package:demo_material3/features/peer_evaluation/domain/models/member_result.dart';
import 'package:demo_material3/features/peer_evaluation/domain/models/peer.dart';

void main() {
  group('MemberResult', () {
    test('average is the arithmetic mean of per-criteria scores', () {
      final result = MemberResult(
        peer: const Peer(id: 'p1', name: 'Ana Gómez', initials: 'AG'),
        scores: const {'Puntualidad': 4.0, 'Contribuciones': 5.0, 'Compromiso': 3.0, 'Actitud': 4.0},
      );

      expect(result.average, closeTo(4.0, 0.001));
    });

    test('average returns 0 when scores map is empty', () {
      final result = MemberResult(
        peer: const Peer(id: 'p2', name: 'Carlos Díaz', initials: 'CD'),
        scores: const {},
      );

      expect(result.average, 0.0);
    });

    test('average handles a single score', () {
      final result = MemberResult(
        peer: const Peer(id: 'p3', name: 'María López', initials: 'ML'),
        scores: const {'Puntualidad': 3.5},
      );

      expect(result.average, closeTo(3.5, 0.001));
    });
  });

  group('Criteria', () {
    test('weight is a positive double', () {
      const c = Criteria(id: 'c1', label: 'Puntualidad', description: 'Test description', weight: 0.25);
      expect(c.weight, greaterThan(0));
    });

    test('criteria has a non-empty label', () {
      const c = Criteria(id: 'c2', label: 'Contribuciones', description: 'Test description', weight: 0.25);
      expect(c.label, isNotEmpty);
    });

    test('criteria has a non-empty description', () {
      const c = Criteria(id: 'c3', label: 'Compromiso', description: 'Test description', weight: 0.25);
      expect(c.description, isNotEmpty);
    });
  });
}
