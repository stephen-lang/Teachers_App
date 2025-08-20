import 'package:teacherapp_cleanarchitect/core/error/failure.dart';
import 'package:teacherapp_cleanarchitect/core/usecase/usecase.dart';
import 'package:teacherapp_cleanarchitect/features/notes/domain/repository/notes_repository.dart';
import 'package:fpdart/fpdart.dart';
import '../entities/notesEntity.dart';
 
class UploadNotes implements UseCase<Notesentity,UploadNotesParam> {
 final NotesRepository notesRepository;
       UploadNotes(this.notesRepository);

  @override
  Future<Either<Failure, Notesentity>> call(UploadNotesParam params) async {
    return await notesRepository.uploadNotes(noteId: params.noteId, schoolId: params.schoolId, grade: params.grade, indicators:  params.indicators, contentStandard:  params.contentStandard, substrand:  params.substrand, strand:  params.strand, classSize:  params.classSize, Subject:  params.Subject, posterId:  params.posterId, updatedAt:  params.updatedAt, lessonNote: params.lessonNote);
  }
 
}

class UploadNotesParam {
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
  final String schoolId;

  UploadNotesParam({required this.posterId, required this.schoolId,required this.noteId, required this.grade, required this.indicators, required this.contentStandard, required this.substrand, required this.strand, required this.classSize, required this.Subject,   required this.updatedAt, required this.lessonNote});

}