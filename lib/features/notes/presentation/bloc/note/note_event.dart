part of 'note_bloc.dart';

@immutable
sealed class NoteEvent {}
final class NotesFetchAllNotes extends NoteEvent {
final String posterId;

  NotesFetchAllNotes({required this.posterId});

}
final class NotesFetchPDFNotes extends NoteEvent {
final String posterId;

  NotesFetchPDFNotes({required this.posterId});

}
final class NotesUploadNotes extends NoteEvent {
 final String posterId;
  final  String noteId;
  final   int grade;
  final  String indicators;
  final  String contentStandard;
  final  String substrand;
  final  String strand;
  final  int classSize;
  final  String Subject;
  final  DateTime updatedAt;
  final  String? lessonNote;
  final  String schoolId;

  NotesUploadNotes({required this.posterId, required this.schoolId,required this.noteId, required this.grade, required this.indicators, required this.contentStandard, required this.substrand, required this.strand, required this.classSize, required this.Subject,   required this.updatedAt, required this.lessonNote});


}
final class NoteDeleteNotes extends NoteEvent{
  final String UniqueId;

  NoteDeleteNotes({required this.UniqueId});
}

final class NotesUploadPDFNotes extends NoteEvent {
   final  String Pdfid;
  final  String  posterId;
  final  String fileName;
  final String lessonplanUpload;
  final  DateTime generatedAt;
  final String schoolId;

  NotesUploadPDFNotes({required this.Pdfid, required this.schoolId, required this.lessonplanUpload, required this.posterId, required this.fileName, required this.generatedAt});
}