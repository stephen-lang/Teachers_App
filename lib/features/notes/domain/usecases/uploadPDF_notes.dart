import 'package:teacherapp_cleanarchitect/core/error/failure.dart';
import 'package:teacherapp_cleanarchitect/core/usecase/usecase.dart';
import 'package:teacherapp_cleanarchitect/features/notes/domain/entities/notespdfEntity.dart';
import 'package:teacherapp_cleanarchitect/features/notes/domain/repository/notes_repository.dart';
import 'package:fpdart/fpdart.dart';
  
class UploadPDFNotes implements UseCase<notespdfEntity,UploadpdfNotesParam> {
 final NotesRepository notesRepository;
       UploadPDFNotes(this.notesRepository);

  @override
  Future<Either<Failure, notespdfEntity>> call(UploadpdfNotesParam params) async {
    return await notesRepository.uploadpdfNotes(Pdfid: params.Pdfid,  lessonplanUpload:params.lessonplanUpload, posterId: params.posterId, fileName:  params.fileName, schoolId:params.schoolId, generatedAt: params.generatedAt);
  }
 
}

class UploadpdfNotesParam {
  final  String Pdfid;
  final  String posterId;
  final  String fileName;
  final String lessonplanUpload;
  final   DateTime generatedAt;
  final String schoolId;
  UploadpdfNotesParam({required this.Pdfid, required this.posterId, required this.schoolId, required this.lessonplanUpload, required this.fileName, required this.generatedAt});

}