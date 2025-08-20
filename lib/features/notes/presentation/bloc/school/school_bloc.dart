// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:teacherapp_cleanarchitect/features/notes/domain/usecases/get_school_by_id.dart';
import 'package:teacherapp_cleanarchitect/features/notes/presentation/bloc/school/school_event.dart';
import 'package:teacherapp_cleanarchitect/features/notes/presentation/bloc/school/school_state.dart';

class SchoolBloc extends Bloc<SchoolEvent, SchoolState> {
  final GetSchoolById _getSchoolById;

  SchoolBloc({required GetSchoolById getSchoolById})
      : _getSchoolById = getSchoolById,
        super(SchoolInitial()) {
    on<SchoolFetchByIdRequested>(_onFetchSchoolById);
  }

  Future<void> _onFetchSchoolById(
    SchoolFetchByIdRequested event,
    Emitter<SchoolState> emit,
  ) async {
    emit(SchoolLoading());

    final result = await _getSchoolById(event.schoolId);

    result.fold(
      (failure) => emit(SchoolFailure(message: failure.message)),
      (school) => emit(SchoolLoadByIdSuccess(school: school)),
    );
  }
}
