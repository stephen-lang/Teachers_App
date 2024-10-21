// auth remote datasource for firebase which demonstrate what should be done

//this class only gets the return type of string from the datasource(firebase)
//which is the best thing in  clean architecture we dnt want any
//packages added or dependency

import 'package:firebase_auth/firebase_auth.dart';
import 'package:teacherapp_cleanarchitect/core/error/exceptions.dart';
import 'package:teacherapp_cleanarchitect/features/auth/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add Firestore dependency

abstract interface class AuthRemoteDataSource {
  Future<UserModel> signUpWithEmailPassword({
    required String displayName,
    required String email,
    required String password,
  });
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });

  void initializeAuthListener();

  get currentUserSession;
  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  //dependency injections below
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  AuthRemoteDataSourceImpl(this._firebaseAuth, this._firestore) {
    // Initialize the auth listener in the constructor
  }

// functions return usermodels (maps)
  @override
  Future<UserModel> loginWithEmailPassword(
      {required String email, required String password}) async {
    try {
      final response = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (response.user == null) {
        throw const ServerException(message: 'User is null!!-----');
      }
      return UserModel.fromEntity(response.user!).copyWith(
        email: response.user!.email,
        displayName: response.user!.displayName,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword(
      {required String displayName,
      required String email,
      required String password}) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('users')
          .where("e-mail", isEqualTo: email)
          .get();
      if (query.docs.isNotEmpty) {
        throw const ServerException(message: 'The email is already in use.');
      }
      // After sign-up, update the user's display name
      await userCredential.user?.updateDisplayName(displayName);
      await userCredential.user?.reload();

      // Get the updated user object
      final User? updatedUser = _firebaseAuth.currentUser;
      // Return success message

      if (updatedUser == null) {
        throw ServerException(message: 'User is null!!-----');
      }
      await _saveUserData(updatedUser);

      return UserModel.fromEntity(userCredential.user!).copyWith(
        email: userCredential.user!.email,
      );
      /* return  UserModel(
      name: userCredential.user!.displayName ?? '', // Firebase may not always return displayName
      email:userCredential.user!.email ?? '', 
      id: userCredential.user!.uid, // Firebase UID as unique identifier
     );//userCredential.user!.toString();
     */
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw const ServerException(
            message: 'The email address is already in use by another account.');
      } else {
        throw ServerException(message: e.toString());
      }
    }
  }

  Future<void> _saveUserData(User user) async {
    final userDoc = _firestore.collection('users').doc(user.uid);

    // Prepare user data to save
    final userData = {
      'displayName': user.displayName ?? '',
      'email': user.email ?? '',
      'uid': user.uid,
    };

    await userDoc.set(
        userData, SetOptions(merge: true)); // Merge updates with existing data
  }

  @override
  void initializeAuthListener() {
    _firebaseAuth.authStateChanges().listen((User? user) {
      if (user != null) {
        // User is signed in, save to Firestore
        _saveUserData(user);
      }
    });
  }

  @override
  get currentUserSession => _firebaseAuth.currentUser;

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        // Access the Firestore collection 'users' and get the document with the uid
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(currentUserSession!.uid)
            .get();

        if (userDoc.exists) {
          UserModel user = UserModel.fromEntityCurrentUser(
                  userDoc.data() as Map<String, dynamic>)
              .copyWith(email: currentUserSession!.email);
          print(user.displayName);
          return user;
        } else {
          // If the document doesn't exist, return null
          print('No user data found for uid');
          return null;
        }
      } else {
        // No user is logged in
        print('No user is logged in');
        return null;
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
