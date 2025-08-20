// features/school/domain/usecases/get_school_by_id.dart

import 'package:fpdart/fpdart.dart';
import 'package:teacherapp_cleanarchitect/features/notes/domain/repository/school_repository.dart';

import '../../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/school.dart';

class GetSchoolById implements UseCase<School, String> {
  final SchoolRepository repository;

  GetSchoolById(this.repository);

  @override
  Future<Either<Failure, School>> call(String schoolId) {
    return repository.getSchoolById(schoolId);
  }
}
