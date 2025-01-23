part of 'note_bloc.dart';

@immutable
sealed class NoteEvent {}
final class NotesFetchAllNotes extends NoteEvent {
final String posterId;

  NotesFetchAllNotes({required this.posterId});

}

final class NotesUploadNotes extends NoteEvent {
 final String posterId;
  final  int noteId;
  final   int grade;
  final  String indicators;
  final  String contentStandard;
  final  String substrand;
  final  String strand;
  final  int classSize;
  final  String Subject;
  final  DateTime updatedAt;
  final  String? lessonNote;

  NotesUploadNotes({required this.posterId, required this.noteId, required this.grade, required this.indicators, required this.contentStandard, required this.substrand, required this.strand, required this.classSize, required this.Subject,   required this.updatedAt, required this.lessonNote});


}