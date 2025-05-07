 
import 'package:fpdart/fpdart.dart';
import 'package:teacherapp_cleanarchitect/core/common/entities/user.dart';
import 'package:teacherapp_cleanarchitect/core/error/failure.dart';
import 'package:teacherapp_cleanarchitect/core/usecase/usecase.dart';
import 'package:teacherapp_cleanarchitect/features/auth/domain/repository/auth_repository.dart';

class CurrentUser implements UseCase<AppUser,Noparams> {
  final AuthRepository authRepository;
    const CurrentUser(this.authRepository);

  @override
  Future<Either<Failure, AppUser>> call(Noparams params) async{
    return await authRepository.currentUser();
  }
  
}