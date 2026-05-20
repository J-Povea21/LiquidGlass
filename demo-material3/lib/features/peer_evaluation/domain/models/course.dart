// Pure Dart — NO Flutter imports
class Course {
  final String id;
  final String name;
  final String semester;
  final String enrollmentCode;
  final int studentCount;

  const Course({
    required this.id,
    required this.name,
    required this.semester,
    required this.enrollmentCode,
    required this.studentCount,
  });
}
