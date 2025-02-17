
import 'package:fpdart/fpdart.dart';
import 'package:teacherapp_cleanarchitect/core/usecase/usecase.dart';

import '../../../../core/error/failure.dart';
 import '../repository/notes_repository.dart';

class DeleteNoteById implements UseCase<void,DeleteNotesParams> {
  final NotesRepository repository;
  DeleteNoteById(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteNotesParams params) async {
    return await repository.deleteNote(UniqueId: params.UniqueId);
  }
}


class DeleteNotesParams {
  final String UniqueId;
  DeleteNotesParams(
      {required this.UniqueId });
}