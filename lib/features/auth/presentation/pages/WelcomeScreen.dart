import 'package:flutter/material.dart';
import 'package:teacherapp_cleanarchitect/features/auth/presentation/pages/SignIn_Page.dart';
import 'package:teacherapp_cleanarchitect/features/auth/presentation/pages/signup_page.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  static String routeName = '/welcome';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose(); // ✅ Dispose controller
    super.dispose();
  }

 @override
Widget build(BuildContext context) {
  return DefaultTabController( // ✅ Add this
    length: 2,
    child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 1.8,
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0),
                        child: TabBar(
                          unselectedLabelColor: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.5),
                          labelColor: Theme.of(context).colorScheme.onSurface,
                          tabs: const [
                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Expanded(
                          child: TabBarView(
                              children: [SignInScreen(), SignUpScreen()])),
                    ]),
                  )),
            ],
          ),
        ),
      ),
    ),
  );
}

}
