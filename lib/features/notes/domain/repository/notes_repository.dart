
import 'package:fpdart/fpdart.dart';
import 'package:teacherapp_cleanarchitect/core/error/failure.dart';
import 'package:teacherapp_cleanarchitect/features/notes/domain/entities/notesEntity.dart';
import 'package:teacherapp_cleanarchitect/features/notes/domain/entities/notespdfEntity.dart';

import '../../data/models/notes_model.dart';
import '../../data/models/notes_pdfModel.dart';

abstract interface class NotesRepository {
  Future<Either<Failure, List<Notesentity>>> downloadNotes(
      {required String posterId});
  Future<Either<Failure, NotesModel>> uploadNotes({
    required noteId,
    required grade,
    required indicators,
    required contentStandard,
    required substrand,
    required strand,
    required classSize,
    required Subject,
    required posterId,
    required updatedAt,
    lessonNote,
  });

   Future<Either<Failure,void>> deleteNote({required String UniqueId});
    Future<Either<Failure, Notespdfmodel>> uploadpdfNotes({
    required Pdfid,
    required posterId,
    required fileName,
    required lessonplanUpload,
    required  generatedAt,
    });
Future<Either<Failure, List< notespdfEntity>>> downloadPDFNotes(
      {required String posterId});
}
