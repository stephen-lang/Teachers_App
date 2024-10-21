import 'package:fpdart/fpdart.dart';
import 'package:teacherapp_cleanarchitect/core/error/failure.dart';

// below is a usecase interface
// every use case should have one function
// because they are supposed to perform one task
// the successtype is dynamic for whether signup or sign in
// every usecase should have a parameter (params)
abstract interface class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

class Noparams {}
