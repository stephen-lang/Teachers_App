import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:teacherapp_cleanarchitect/Constants/const.dart';
import 'package:teacherapp_cleanarchitect/core/common/cubits/app_user/app_user_cubit_cubit.dart';
import 'package:teacherapp_cleanarchitect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:teacherapp_cleanarchitect/features/auth/presentation/pages/WelcomeScreen.dart';
import 'package:teacherapp_cleanarchitect/features/notes/presentation/bloc/note/note_bloc.dart';
import 'package:teacherapp_cleanarchitect/features/notes/presentation/pages/Headmaster/presentation/Headmaster_Page.dart';
import 'package:teacherapp_cleanarchitect/init_dependencies.dart';
import 'features/notes/presentation/controllers/auth_controller.dart';
import 'features/notes/presentation/pages/nav/nav_bar.dart';

// Define the global navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  });
    }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthSuccess) {
            final role = state.userme.role?.trim().toLowerCase(); 
             print('[main.dart] AuthSuccess - role = $role');

            if (role == 'headmaster') {
           return HeadmasterDashboard(user:state.userme); // 👈 pass user here
            } else {
              return const NavigationMenu();
            }
          }

          return const WelcomeScreen();
        },
      ),
    );
  }
  
}
