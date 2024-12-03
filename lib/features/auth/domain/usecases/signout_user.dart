 import 'package:teacherapp_cleanarchitect/features/auth/domain/repository/auth_repository.dart';
import 'package:teacherapp_cleanarchitect/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:teacherapp_cleanarchitect/core/error/failure.dart';
class SignOutUseCase implements UseCase<void,Noparams>  {
  final AuthRepository authRepository;

  SignOutUseCase(this.authRepository);

 Future<Either<Failure, void>> call(Noparams params) async {
    return await authRepository.signOut();
  }
}