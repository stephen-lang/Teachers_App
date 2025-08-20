import 'package:teacherapp_cleanarchitect/features/notes/domain/entities/school.dart';

abstract class SchoolState {}

class SchoolInitial extends SchoolState {}

class SchoolLoading extends SchoolState {}

class SchoolFailure extends SchoolState {
  final String message;
  SchoolFailure({required this.message});
}

class SchoolLoadByIdSuccess extends SchoolState {
  final School school;
  SchoolLoadByIdSuccess({required this.school});
}
