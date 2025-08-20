 
import 'package:teacherapp_cleanarchitect/core/error/failure.dart';
import 'package:teacherapp_cleanarchitect/core/usecase/usecase.dart';
import 'package:teacherapp_cleanarchitect/core/common/entities/user.dart';
import 'package:teacherapp_cleanarchitect/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
//usecases is a single file that does one job
//they should have a particular stucture
// it should return params
// Now we use the Usecase interface here for user sign up
class UserSignUp implements UseCase<AppUser, UserSignUpParams> {
  final AuthRepository authRepository;
  const UserSignUp(this.authRepository);

  //the function returns either failure or string when success
  @override
  Future<Either<Failure, AppUser>> call(UserSignUpParams params) async {
   return await authRepository.signUpWithEmailPassword(
      displayName: params.displayName,
      email: params.email,
      password: params.password, 
      role: params.role, 
      schoolId: params.schoolId, 
      schoolName: params.schoolName,
    );
  }
}

// we have to create 3 parameters bcs we cant pass them
// so we create a class Usersignupparams with 3 variables
// and call them in the Usersignup class

class UserSignUpParams {
  final String email;
  final String password;
  final String displayName ;
  final String role;
  final String schoolId;
  final String schoolName;
//  final String role;

  UserSignUpParams( 
      {required this.email, required this.password, required this.displayName, required this.schoolName, required this.role, required this.schoolId});
}
