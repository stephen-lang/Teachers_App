 import 'package:fpdart/fpdart.dart';
import 'package:teacherapp_cleanarchitect/core/error/exceptions.dart';
import 'package:teacherapp_cleanarchitect/core/error/failure.dart';
import 'package:teacherapp_cleanarchitect/features/notes/data/datasources/notes_remote_data_sources.dart';
import 'package:teacherapp_cleanarchitect/features/notes/data/models/notes_model.dart';
import 'package:teacherapp_cleanarchitect/features/notes/domain/entities/notesEntity.dart';
import 'package:teacherapp_cleanarchitect/features/notes/domain/repository/notes_repository.dart';

class NotesRepositoryImpl implements NotesRepository {
  final  NotesRemoteDataSources remoteDataSource;

  NotesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Notesentity>>> downloadNotes({required String posterId}) async {
    try {
      final notesList = await remoteDataSource.downloadNotes(posterId);
      return Right(notesList);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }
  
  @override
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
     lessonNote, })async{
    try {
     NotesModel notesentity = NotesModel(
      noteId: noteId,
      grade: grade, 
      indicators: indicators,
      contentStandard: contentStandard,
      substrand: substrand,
      strand: strand,
      classSize: classSize,
      Subject: Subject,
      posterId: posterId,
      updatedAt: DateTime.now(),
      lessonNote: lessonNote,
      );
       final notesUpload = await remoteDataSource.uploadNotes(notesentity);
      return Right(notesUpload);
    } catch (e) {
      throw Exception("Failed to upload notes: $e");
    }
  }

  }
  
 
  

  
  
