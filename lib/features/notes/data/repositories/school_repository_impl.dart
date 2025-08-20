// data/repositories/school_repository_impl.dart

import 'package:fpdart/fpdart.dart';

import '../../domain/entities/school.dart';
import '../../domain/repository/school_repository.dart';
import '../datasources/school_remote_data_source.dart';
import '../../../../core/error/failure.dart';

class SchoolRepositoryImpl implements SchoolRepository {
  final SchoolRemoteDataSource schoolRemoteDataSource;

SchoolRepositoryImpl({required this.schoolRemoteDataSource});

  @override
  Future<Either<Failure, School>> getSchoolById(String schoolId) async {
    try {
      final school = await schoolRemoteDataSource.getSchoolById(schoolId);
      return Right(school);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
