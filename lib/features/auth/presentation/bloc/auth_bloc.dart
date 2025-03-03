import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacherapp_cleanarchitect/core/common/cubits/app_user/app_user_cubit_cubit.dart';
import 'package:teacherapp_cleanarchitect/core/common/entities/user.dart';
import 'package:teacherapp_cleanarchitect/core/usecase/usecase.dart';
import 'package:teacherapp_cleanarchitect/features/auth/domain/usecases/current_user.dart';
import 'package:teacherapp_cleanarchitect/features/auth/domain/usecases/signout_user.dart';
import 'package:teacherapp_cleanarchitect/features/auth/domain/usecases/user_login.dart';
import 'package:teacherapp_cleanarchitect/features/auth/domain/usecases/user_sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // we create a private variable
  // we connect the use case from the authrepository
  // to the bloc
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  final SignOutUseCase _signOutUseCase;

  //set the usersignup variable another variable for claean architecture

  // the bloc is called using Authbloc an AuthSignin or up is used
  AuthBloc(
      {required UserSignUp userSignUp,
      required SignOutUseCase signout_user,
      required UserLogin userLogin,
      required CurrentUser currentUser,
      required AppUserCubit appUserCubit})
      : _userSignUp = userSignUp,
        _signOutUseCase = signout_user,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    // Call the super constructor here
    // Registering the event handlers
    on<AuthEvent>((event, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignup);
    on<AuthLogin>(_onAuthLogin);
    on<AuthSignOut>(_onAuthSignout);
    on<AuthIsUserLoggedIn>(_onAuthIsUserLoggedIn);
  }

  void _onAuthSignup(AuthSignUp event, Emitter<AuthState> emit) async {
    final res = await _userSignUp.call(
      UserSignUpParams(
        email: event.email,
        password: event.password,
        displayName: event.displayName,
      ),
    );
    res.fold(
      (failure) => {
        emit(
          AuthFailure(message: failure.message),
        ),
      },
      (user) =>
          {print(user.uid), print(user.email), _emitAuthSignUpSuccess(user, emit)},
    );
  }

  void _onAuthSignout(AuthSignOut event, Emitter<AuthState> emit) async {
    final res = await _signOutUseCase.call(
      Noparams(),
    );
    res.fold((failure) {
      // Emit an AuthFailure state with the error message if sign-out fails
      emit(AuthFailure(message: failure.message));
    }, (_) {
      // Emit an AuthSignedOut state on successful sign-out
      emit(AuthSignedOut()); // You may want to define this state
      // Optional: Navigate to login or home screen if necessary
      // This can be handled outside of the Bloc
    });
  }

  void _onAuthIsUserLoggedIn(
      AuthIsUserLoggedIn event, Emitter<AuthState> emit) async {
    final res = await _currentUser.call(
      Noparams(),
    );
    res.fold(
      (failure) => {
        emit(
          AuthFailure(message: failure.message),
        ),
      },
      (user) =>
          {print(user.uid), print(user.email), _emitAuthSuccess(user, emit)},
    );
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    final res = await _userLogin.call(
      UserLoginParams(
        email: event.email,
        password: event.password,
      ),
    );
    res.fold(
        (failure) => {
              emit(
                AuthFailure(message: failure.message),
              ),
            },
        (user) =>
            {print(user.uid), print(user.email), _emitAuthSuccess(user, emit)});
  }

void _emitAuthSignUpSuccess(User user, Emitter<AuthState> emit) {
  _appUserCubit.updateUser(user);
  emit(AuthSignUpSuccess(userme: user)); // Emit the new state
}

  void _emitAuthSuccess(
    User user,
    Emitter<AuthState> emit,
  ) {
//uses are been update in the app user cubit here below

    _appUserCubit.updateUser(user);
    emit(AuthSuccess(userme: user));
  }
}
