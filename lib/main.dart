import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:teacherapp_cleanarchitect/Constants/const.dart';
import 'package:teacherapp_cleanarchitect/core/common/cubits/app_user/app_user_cubit_cubit.dart';
import 'package:teacherapp_cleanarchitect/features/auth/presentation/bloc/auth_bloc.dart';
//import 'package:teacherapp_cleanarchitect/features/auth/presentation/pages/SignIn_Page.dart';
import 'package:teacherapp_cleanarchitect/features/auth/presentation/pages/WelcomeScreen.dart';
import 'package:teacherapp_cleanarchitect/features/notes/presentation/bloc/note_bloc.dart';
//import 'package:teacherapp_cleanarchitect/features/notes/presentation/pages/home/dashboard.dart';
import 'package:teacherapp_cleanarchitect/init_dependencies.dart';

import 'features/notes/presentation/controllers/auth_controller.dart';
import 'features/notes/presentation/pages/nav/nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependecies();
  Get.put(AuthController());
  Gemini.init(apiKey: GEMINI_API_KEY, enableDebugging: true);

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => serviceLocator<AppUserCubit>(),
      ),
      BlocProvider(
        create: (context) => serviceLocator<AuthBloc>(),
      ),
       BlocProvider(
        create: (context) => serviceLocator<NoteBloc>(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      // we register the block here
      // and add more blocks
      home: BlocSelector<AppUserCubit, AppUserCubitState, String?>(
       selector: (state) {
    if (state is AppUserLoggedIn) {
      return state.loggedInUserCred.displayName; // Assuming userName is a field in AppUserLoggedIn state
    }
    return null;
  },
  builder: (context, userName) {
    if (userName != null) {
 return const NavigationMenu(); 
     // return Dash(userName: userName);  // Pass the username to Dash
    }
    return const WelcomeScreen();
  },
      ),
    );
  }
}

/*
Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      // we register the block here
      // and add more blocks
      home: BlocSelector<AppUserCubit, AppUserCubitState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, AuthIsUserLoggedIn) {
          if ( AuthIsUserLoggedIn) {
            
            return const Dash()  ;
          }
          return const WelcomeScreen();
        },
      ),
    );
  }
  */