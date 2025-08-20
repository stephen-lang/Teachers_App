// core/common/entities/user.dart

class AppUser {
  final String uid;
  final String email;
  final String displayName;
  final String role;
  final String? schoolId;
  final String? schoolName;

  AppUser({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.role,
    this.schoolId,
    this.schoolName,
  });
}
