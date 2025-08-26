import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:teacherapp_cleanarchitect/features/auth/presentation/pages/WelcomeScreen.dart';
import '../../../../core/common/cubits/app_user/app_user_cubit_cubit.dart';
import '../../../../core/common/entities/user.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../notes/presentation/bloc/school/school_bloc.dart';
import '../../../notes/presentation/bloc/school/school_event.dart';
import 'lesson_notes_screen.dart';
import 'teachers_screen.dart';
import 'reports_screen.dart';
import 'school_info_screen.dart';
import 'settings_screen.dart';

class HeadmasterDashboard extends StatefulWidget {
  final AppUser? user;

  const HeadmasterDashboard({super.key, required this.user});

  @override
  State<HeadmasterDashboard> createState() => _HeadmasterDashboardState();
}

class _HeadmasterDashboardState extends State<HeadmasterDashboard> {
  late AppUser headmaster;

  @override
  void initState() {
    super.initState();
    headmaster =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).loggedInUserCred;

    print("${headmaster.uid} from heady");
    print("${headmaster.schoolId} is the school ID");
  }

  void _logout() {
    context.read<AuthBloc>().add(AuthSignOut());
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = widget.user ?? headmaster;

    return BlocProvider(
      create: (_) {
        final bloc = SchoolBloc(getSchoolById: GetIt.I());
        bloc.add(SchoolFetchByIdRequested(schoolId: currentUser.schoolId!));
        return bloc;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Headmaster Dashboard"),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: "Logout",
              onPressed: _logout,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Profile Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.blue.shade100,
                        child: const Icon(Icons.school,
                            size: 40, color: Colors.blue),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome, ${currentUser.displayName ?? "Headmaster"}",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text("Email: ${currentUser.email}"),
                            Text(
                                "School ID: ${currentUser.schoolId ?? 'N/A'}"),
                            const SizedBox(height: 4),
                            Chip(
                              label: Text(currentUser.role.toUpperCase()),
                              backgroundColor: Colors.green.shade100,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ✅ Dashboard Grid
              GridView.count(
                padding: const EdgeInsets.all(8),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                children: [
                  _DashboardCard(
                    title: "Lesson Notes",
                    icon: Icons.book,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const LessonNotesScreen()),
                    ),
                  ),
                  _DashboardCard(
                    title: "Teachers",
                    icon: Icons.people,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const TeachersScreen()),
                    ),
                  ),
                  _DashboardCard(
                    title: "Reports",
                    icon: Icons.bar_chart,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ReportsScreen()),
                    ),
                  ),
                  _DashboardCard(
                    title: "School Info",
                    icon: Icons.school,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SchoolInfoScreen()),
                    ),
                  ),
                  _DashboardCard(
                    title: "Settings",
                    icon: Icons.settings,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SettingsScreen()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 50, color: Colors.blueAccent),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
