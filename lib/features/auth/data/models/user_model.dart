import 'package:teacherapp_cleanarchitect/core/common/entities/user.dart';

// make sure u are inporting from the domain layer because of clean
//architecture
//2:41;16

//now we have to change the return from String to User model because
// we now going to use the from JSON in the user model to retrieve and send data
//from firebase
// for reuse purposes
class UserModel extends AppUser {
  UserModel(  
      {required super.displayName, required super.email, required super.uid, required super.role , required super.schoolId ,super.schoolName});
  Map<String, Object?> toDocument() {
    return {
      'id': uid,
      'email': email,
      'displayName': displayName,
      'role': role,
      'schoolId':schoolId,
      'schoolName':schoolName,
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? role,
    String? schoolId,
    String? schoolName,

  }) {
    return UserModel(
      displayName: displayName ?? this.displayName,
      email: email?? this.email,
      uid:   uid?? this.uid,
      role: role?? this.role,
      schoolId :schoolId??this.schoolId,
      schoolName: schoolName??this.schoolName,
    );
  }

  //from document or from Json
  static UserModel fromDocument(Map<String, dynamic> doc) {
    return UserModel(
      displayName: doc['displayName '] ?? '',
      email: doc['email'] ?? '',
      uid: doc['uid'] ?? '',
      role: doc['role'] ??'',
      schoolId: doc['schoolId']??'',
      schoolName: doc['schoolName']??'',
    );

  }

  static UserModel fromEntity( entity) {
  return UserModel(
    uid: entity.uid ?? 'No email uid provided------',
    email: entity.email ?? 'No email provided------',
    displayName: entity.displayName ?? 'No display name------',
    role: '', // Set it to empty or provide it later using .copyWith()
    schoolId: '',
    schoolName: '',
  );
}


  factory UserModel.fromEntityCurrentUser(Map<String, dynamic>? data) {
    // Make sure the data isn't null before accessing it
    if (data == null) {
      throw Exception('User data is null');
    }

    return UserModel(
      displayName: data['displayName'] ??   'Unknown', // default value if name is not provided
      email: data['email'] ?? 'No email', // default value if email is missing
      uid: data['uid'] ?? '', 
      role: data['role'] ?? '',
      schoolId:data['schoolId']??'', 
      schoolName: data['schoolName']??'',
    );
  }

  UserModel toEntity() {
    return UserModel(
      uid: uid,
      email: email,
      displayName: displayName,
      role: role, 
      schoolId:schoolId,
      schoolName: schoolName,
    );
  }
}
