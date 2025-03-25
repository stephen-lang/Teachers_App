
import 'package:fpdart/fpdart.dart';
import 'package:teacherapp_cleanarchitect/core/error/failure.dart';
import 'package:teacherapp_cleanarchitect/core/usecase/usecase.dart';
import 'package:teacherapp_cleanarchitect/features/notes/domain/entities/notespdfEntity.dart';
import 'package:teacherapp_cleanarchitect/features/notes/domain/repository/notes_repository.dart';

class GetPDFNotes implements UseCase<List<notespdfEntity>,downloadPDFNotesParams> {
  final NotesRepository notesRepository;
      GetPDFNotes(this.notesRepository);

  @override
  Future<Either<Failure, List<notespdfEntity>>> call(downloadPDFNotesParams params) async{
    return await notesRepository.downloadPDFNotes(posterId: params.posterId);
  }
}

class downloadPDFNotesParams {
  final String posterId;
  downloadPDFNotesParams(
      {required this.posterId });
}