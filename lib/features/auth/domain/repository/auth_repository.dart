// we create an interface repository for the principle of clean architecture
//create a base class for other class to inheret from (abstract interface) class
import 'package:fpdart/fpdart.dart';
import 'package:teacherapp_cleanarchitect/core/error/failure.dart';
import 'package:teacherapp_cleanarchitect/core/common/entities/user.dart';
 
//STEP 1 CREATE INTERFACE  BELOW
//
abstract interface class AuthRepository {
  //all classes implementing this interface will have the set of methods defined here
//signup with email and pass
//sign in with email and pass

// either returns a failure or success below
  Future <Either<Failure, User>> signUpWithEmailPassword({
    required String displayName,
    required String email,
    required String password,
  });

Future< Either<Failure, User>>loginWithEmailPassword({
    required String email,
    required String password,
  });

   Future<Either<Failure,User>> currentUser();
} 
