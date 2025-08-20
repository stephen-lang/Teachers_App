// lib/features/auth/domain/usecases/create_school_usecase.dart

import 'package:fpdart/fpdart.dart';
import 'package:teacherapp_cleanarchitect/core/error/failure.dart';

import '../../../../core/usecase/usecase.dart';
import '../repository/auth_repository.dart';
 
class CreateSchoolUseCase implements UseCase<String, CreateSchoolParams> {
  final AuthRepository repository;

  CreateSchoolUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(CreateSchoolParams params) {
    return repository.createSchool(
      schoolName: params.schoolName,
      createdBy: params.createdBy,
    );
  }
}

class CreateSchoolParams {
  final String schoolName;
  final String createdBy;

  CreateSchoolParams({
    required this.schoolName,
    required this.createdBy,
  });
}
