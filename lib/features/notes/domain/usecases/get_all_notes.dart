
import 'package:fpdart/fpdart.dart';
import 'package:teacherapp_cleanarchitect/core/error/failure.dart';
import 'package:teacherapp_cleanarchitect/core/usecase/usecase.dart';
import 'package:teacherapp_cleanarchitect/features/notes/domain/entities/notesEntity.dart';
import 'package:teacherapp_cleanarchitect/features/notes/domain/repository/notes_repository.dart';

class GetAllNotes implements UseCase<List<Notesentity>,downloadNotesParams> {
  final NotesRepository notesRepository;
      GetAllNotes(this.notesRepository);

  @override
  Future<Either<Failure, List<Notesentity>>> call(downloadNotesParams params) async{
    return await notesRepository.downloadNotes(posterId: params.posterId);
  }
}

class downloadNotesParams {
  final String posterId;
  downloadNotesParams(
      {required this.posterId });
}