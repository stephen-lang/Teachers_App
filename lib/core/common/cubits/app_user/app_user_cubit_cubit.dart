import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:teacherapp_cleanarchitect/core/common/entities/user.dart';

part 'app_user_cubit_state.dart';

class AppUserCubit extends Cubit<AppUserCubitState> {
  AppUserCubit() : super(AppUserCubitInitial());

  void updateUser(AppUser? user){
    if(user== null){
      emit(AppUserCubitInitial());
    }else{
      emit(AppUserLoggedIn(loggedInUserCred:user));
    }
  }
}
