 
 
import 'package:fpdart/fpdart.dart';
import 'package:teacherapp_cleanarchitect/core/error/failure.dart';
import 'package:teacherapp_cleanarchitect/core/usecase/usecase.dart';
import 'package:teacherapp_cleanarchitect/features/auth/domain/repository/auth_repository.dart';

import '../../../../core/common/entities/user.dart';

class UserLogin implements UseCase <User,UserLoginParams>{
  //we are directly talking to our NetworkInterface
  final AuthRepository authRepository;
    const UserLogin(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserLoginParams params) async {
      return await authRepository.loginWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
  

  
}

class UserLoginParams {
  final String email;
  final String password;
 

  UserLoginParams(
      {required this.email, required this.password,});
}
