import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:teacherapp_cleanarchitect/core/common/cubits/app_user/app_user_cubit_cubit.dart';
import 'package:teacherapp_cleanarchitect/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:teacherapp_cleanarchitect/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:teacherapp_cleanarchitect/features/auth/domain/repository/auth_repository.dart';
import 'package:teacherapp_cleanarchitect/features/auth/domain/usecases/current_user.dart';
import 'package:teacherapp_cleanarchitect/features/auth/domain/usecases/signout_user.dart';
import 'package:teacherapp_cleanarchitect/features/auth/domain/usecases/user_login.dart';
import 'package:teacherapp_cleanarchitect/features/auth/domain/usecases/user_sign_up.dart';
import 'package:teacherapp_cleanarchitect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:teacherapp_cleanarchitect/features/notes/data/datasources/notes_remote_data_sources.dart';
import 'package:teacherapp_cleanarchitect/features/notes/data/repositories/notes_repository_impl.dart';
import 'package:teacherapp_cleanarchitect/features/notes/domain/repository/notes_repository.dart';
import 'package:teacherapp_cleanarchitect/features/notes/domain/usecases/get_all_notes.dart';
import 'package:teacherapp_cleanarchitect/features/notes/presentation/bloc/note_bloc.dart';

final serviceLocator = GetIt.instance;
Future<void> initDependecies() async {
  await Firebase.initializeApp();

  serviceLocator
      .registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  serviceLocator.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);
  initAuth();
  initNote();

  // core folder registering
  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void initAuth() {
  // Register AuthRemoteDataSource
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      serviceLocator<FirebaseAuth>(),
      serviceLocator<FirebaseFirestore>(),
    ),
  );

  // Initialize auth listener after the registration
  final authRemoteDataSource = serviceLocator<AuthRemoteDataSource>();
  authRemoteDataSource.initializeAuthListener();

  // Register AuthRepository - remove the duplicate registration
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: serviceLocator(),
    ),
  );

  // Register UserSignUp
  serviceLocator.registerFactory(
    () => UserSignUp(
      serviceLocator(),
    ),
  );
  // Register UserSignUp
  serviceLocator.registerFactory(
    () => UserLogin(
      serviceLocator(),
    ),
  );
  // Register IsUserLoggedin
  serviceLocator.registerFactory(
    () => CurrentUser(
      serviceLocator(),
    ),
  );
  // Signout uSER
  serviceLocator.registerCachedFactory(
    () => SignOutUseCase(
      serviceLocator(),
    ),
  );

  // Register AuthBloc
  serviceLocator.registerFactory(
    () => AuthBloc(
      userSignUp: serviceLocator(),
      userLogin: serviceLocator(),
      currentUser: serviceLocator(),
      appUserCubit: serviceLocator(),
      signout_user: serviceLocator(),
    ),
  );
}

void initNote() {
// remote datasource
  serviceLocator
    ..registerFactory<NotesRemoteDataSources>(
      () => NotesRemoteDataSourcesImpl(
        serviceLocator<FirebaseAuth>(),
        serviceLocator<FirebaseFirestore>(),
      ),
    )
    //repository
    ..registerFactory<NotesRepository>(
      () => NotesRepositoryImpl(
        remoteDataSource: serviceLocator(),
      ),
    )
    //use case
    ..registerFactory(
      () => GetAllNotes(
        serviceLocator(),
      ),
    )

    //bloc
    //we use regitster lazy singleton because we want to maintain the state passed in to our bloc
    ..registerLazySingleton(
      () => NoteBloc(
        getAllNotes: serviceLocator(),
      ),
    );
}
