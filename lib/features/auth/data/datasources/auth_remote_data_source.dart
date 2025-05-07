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
    required String role,
  });
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });

 // void initializeAuthListener();

   
  Future<UserModel?> getCurrentUserData();

  Future<void> signOut();
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
Future<UserModel> loginWithEmailPassword({
  required String email,
  required String password,
}) async {
  try {
    final response = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw const ServerException(message: 'User is null!!-----');
    }

    final uid = response.user!.uid;
    final userDoc = await _firestore.collection('users').doc(uid).get();

    if (!userDoc.exists) {
      throw const ServerException(message: 'User document not found!');
    }

    final userMap = userDoc.data() as Map<String, dynamic>;
    final role = userMap['role'] ?? 'teacher';

    return UserModel.fromEntity(response.user!).copyWith(
      email: response.user!.email,
      displayName: response.user!.displayName,
      role: role, // ✅ Now role is included
    );
  } catch (e) {
    throw ServerException(message: e.toString());
  }
}


  @override
  Future<UserModel> signUpWithEmailPassword(
      {required String displayName,
      required String email,
      required String password,
      required String role}) async {
     try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('users')
          .where("email", isEqualTo: email)
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
        throw const ServerException(message: 'User is null!!-----');
      }
      print("Role of account below---------------");
      print(role);
      await _saveUserData(updatedUser, role); // ✅ pass the role explicitly

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

Future<void> _saveUserData(User fireUser, String role) async {
  final userDoc = _firestore.collection('users').doc(fireUser.uid);

 final userData = {
  'displayName': fireUser.displayName ?? '',
  'email': fireUser.email ?? '',
  'uid': fireUser.uid,
  'role': role, // ✅ Include role directly here
};
await userDoc.set(userData, SetOptions(merge: true));

}
/*
  @override
  void initializeAuthListener() {
  _firebaseAuth.authStateChanges().listen((User? InitializeAuth) async {
    if (InitializeAuth != null) {
      try {
        final doc = await _firestore.collection('users').doc(InitializeAuth.uid).get();
        if (doc.exists) {
          final role = doc.data()?['role'] ?? 'teacher';
          print(role);
          await _saveUserData(InitializeAuth, role);
        }
      } catch (e) {
        print('Failed to fetch role: $e');
      }
    }
  });
}
*/

  @override
Future<UserModel?> getCurrentUserData() async {
  try {
    final currentUser = _firebaseAuth.currentUser;

    if (currentUser != null) {
      // 1️⃣ Get base user info from the 'users' collection
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();

      final userMap = userDoc.data() as Map<String, dynamic>;
      final role = userMap['role'] ?? 'teacher';


      if (userDoc.exists) {
        // 4️⃣ Merge the role into the model
        final userMap = userDoc.data() as Map<String, dynamic>;

        UserModel userfromentity = UserModel.fromEntityCurrentUser(userMap).copyWith(
          email: currentUser.email,
          role: role, // Include role from the new collection
        );

        print("Fetched user with role: ${userfromentity.role}");
        return userfromentity;
      } else {
        print('No user data found for uid');
        return null;
      }
    } else {
      print('No user is logged in');
      return null;
    }
  } catch (e) {
    throw ServerException(message: e.toString());
  }
}


  @override
  Future<void> signOut() async {
    // Implement your sign-out logic here
    // For example, if using Firebase:
    await _firebaseAuth.signOut();
  }
}
