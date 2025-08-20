// domain/repositories/school_repository.dart
 
import 'package:fpdart/fpdart.dart';

import '../entities/school.dart';
import '../../../../core/error/failure.dart';
 
abstract interface class SchoolRepository {
  Future<Either<Failure, School>> getSchoolById(String schoolId);
}
