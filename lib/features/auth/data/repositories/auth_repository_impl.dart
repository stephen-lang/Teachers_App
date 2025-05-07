//remove import below and import the enthier fp.dart package
//import 'package:fpdart/src/either.dart';
import 'package:fpdart/fpdart.dart';
import 'package:teacherapp_cleanarchitect/core/error/exceptions.dart';
import 'package:teacherapp_cleanarchitect/core/error/failure.dart';
import 'package:teacherapp_cleanarchitect/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:teacherapp_cleanarchitect/core/common/entities/user.dart';
import 'package:teacherapp_cleanarchitect/features/auth/domain/repository/auth_repository.dart';
 
//now we create a repository in the data layer to implement
//the domain layer
class AuthRepositoryImpl implements AuthRepository {
  //we rather use AuthRemoteDataSource instead of AuthRemoteDataSourceImpl
  // we just want to depend on the abstract interface not the implementation
  /*
In your AuthRepositoryImpl class, you're correctly
 depending on the interface AuthRemoteDataSource 
 rather than the implementation AuthRemoteDataSourceImpl. 
 This follows the Dependency Inversion Principle (DIP) from 
 SOLID principles, which states that high-level modules s
 hould not depend on low-level modules. Both should depend 
 on abstractions (interfaces).
  */

  final AuthRemoteDataSource remoteDataSource;
  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AppUser>> loginWithEmailPassword(
      {required String email, required String password}) async {
    try {
      final Loginuser = await remoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      );

      return right(Loginuser);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }

  
  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return right(null); // Sign-out successful, return void
    } on ServerException catch (e) {
      // Handle specific exceptions from the remote data source
      return left(Failure(message: e.message)); // Return failure with message
    } catch (e) {
      // Handle any other exceptions
      return left(Failure(message: 'An unexpected error occurred'));
    }
  } 

  @override
  Future<Either<Failure, AppUser>> signUpWithEmailPassword(
      {required String displayName,
      required String email,
      required String password,
      required String role,
     }) async {
    // TODO: implement signUpWithEmailPassword

    try {
      final SignUpuser = await remoteDataSource.signUpWithEmailPassword(
        displayName : displayName,
        email: email,
        password: password,
        role: role,
      );
      //below is the fpdart package
      // returns the right thing if successful
      return right(SignUpuser);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, AppUser>> currentUser() async {
    try {
      final Currnuser = await remoteDataSource.getCurrentUserData();
      if (Currnuser == null) {
        return left(Failure(message: "user is not logged in"));
      }
      return right(Currnuser);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
  }
}
}