import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacherapp_cleanarchitect/core/common/cubits/app_user/app_user_cubit_cubit.dart';
import 'package:teacherapp_cleanarchitect/core/common/entities/user.dart';

class HeadmasterDashboard extends StatefulWidget {
  final AppUser? user; // Optional: in case you still pass from SignInScreen

  const HeadmasterDashboard({super.key, this.user});

  @override
  State<HeadmasterDashboard> createState() => _HeadmasterDashboardState();
}

class _HeadmasterDashboardState extends State<HeadmasterDashboard> {
  late AppUser headmaster;

  @override
  void initState() {
    super.initState();
    headmaster = (context.read<AppUserCubit>().state as AppUserLoggedIn).loggedInUserCred;

    print("${headmaster.uid} from heady");
    print("${headmaster.schoolId} is the school ID");
  }

  void _logout() {
   // context.read<AppUserCubit>().logout(); // make sure you implemented logout in your cubit
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = widget.user ?? headmaster;

    return Scaffold(
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
        child: currentUser == null
            ? const Center(child: Text("No user data found"))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Card
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
                                Text("School ID: ${currentUser.schoolId ?? 'N/A'}"),
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

                  // Quick Actions
                  const Text(
                    "Quick Actions",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: [
                      _buildActionCard(
                        icon: Icons.people,
                        label: "Manage Teachers",
                        color: Colors.orange,
                        onTap: () {
                          // Navigate to Manage Teachers page
                        },
                      ),
                      _buildActionCard(
                        icon: Icons.note,
                        label: "Lesson Approvals",
                        color: Colors.green,
                        onTap: () {
                          // Navigate to approvals page
                        },
                      ),
                      _buildActionCard(
                        icon: Icons.analytics,
                        label: "Reports",
                        color: Colors.blue,
                        onTap: () {
                          // Navigate to reports
                        },
                      ),
                      _buildActionCard(
                        icon: Icons.settings,
                        label: "Settings",
                        color: Colors.purple,
                        onTap: () {
                          // Navigate to settings
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout),
                      label: const Text("Logout"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 3,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
