import 'package:fpdart/fpdart.dart';
import 'package:teacherapp_cleanarchitect/core/usecase/usecase.dart';

import '../../../../core/error/failure.dart';
import '../repository/auth_repository.dart';
 
class ValidateSchoolCodeUseCase implements UseCase<String, validateSchoolParams> {
  final AuthRepository repository;

  ValidateSchoolCodeUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(validateSchoolParams params) {
    return repository.validateSchoolCode(schoolId:params.schoolId);
  }
}
class validateSchoolParams {
  final String schoolId;
   

  validateSchoolParams({
    required this.schoolId,
   });
}