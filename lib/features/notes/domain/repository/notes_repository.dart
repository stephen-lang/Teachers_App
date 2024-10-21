import 'package:fpdart/fpdart.dart';
import 'package:teacherapp_cleanarchitect/core/error/failure.dart';
import 'package:teacherapp_cleanarchitect/features/notes/domain/entities/notesEntity.dart';

abstract interface class NotesRepository {
   Future <Either<Failure,List<Notesentity>>> downloadNotes({required String posterId});
}