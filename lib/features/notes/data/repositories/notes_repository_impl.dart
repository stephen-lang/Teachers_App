 import 'package:fpdart/fpdart.dart';
import 'package:teacherapp_cleanarchitect/core/error/exceptions.dart';
import 'package:teacherapp_cleanarchitect/core/error/failure.dart';
import 'package:teacherapp_cleanarchitect/features/notes/data/datasources/notes_remote_data_sources.dart';
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
}
  
  
