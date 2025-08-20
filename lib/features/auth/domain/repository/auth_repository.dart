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
  Future <Either<Failure, AppUser>> signUpWithEmailPassword({
    required String displayName,
    required String email,
    required String password,
    required String role,
    required String schoolId,
    required String schoolName,
  });

Future< Either<Failure, AppUser>>loginWithEmailPassword({
    required String email,
    required String password,
  });

   Future<Either<Failure,AppUser>> currentUser();
  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, String>> createSchool({
    required  String schoolName,
    required  String createdBy});

  Future<Either<Failure, String>> validateSchoolCode({ required String schoolId});


} 
