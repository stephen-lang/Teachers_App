abstract class SchoolEvent {}

class SchoolFetchByIdRequested extends SchoolEvent {
  final String schoolId;
  SchoolFetchByIdRequested({required this.schoolId});
}
