
class Notesentity {
  String noteId;
  int grade;
  String indicators;
  String contentStandard;
  String substrand;
  String strand;
  int classSize;
  String Subject;
  String posterId;
  DateTime updatedAt;
  String? lessonNote;
  String schoolId;

  Notesentity({
    required this.noteId,
    required this.grade,
    required this.indicators,
    required this.contentStandard,
    required this.substrand,
    required this.strand,
    required this.classSize,
    required this.Subject,
    required this.posterId,
    required this.updatedAt,
    required this.schoolId,
    this.lessonNote,
  });
}
