import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teacherapp_cleanarchitect/core/common/cubits/app_user/app_user_cubit_cubit.dart';
import 'package:teacherapp_cleanarchitect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:teacherapp_cleanarchitect/features/auth/presentation/pages/WelcomeScreen.dart';
import 'package:teacherapp_cleanarchitect/features/notes/presentation/bloc/note_bloc.dart';
import 'package:teacherapp_cleanarchitect/features/notes/presentation/pages/home/icons.dart';

import '../../controllers/auth_controller.dart';

class Dash extends StatefulWidget {
  final String userName;

  const Dash({super.key, required this.userName});
  @override
  State<Dash> createState() => _DashState();
}

class _DashState extends State<Dash> {
  final Map<String, Color> _subjectColors = {}; // Store each subject's color
  final Random _random = Random();
  Color _getColorForSubject(String subject) {
    // ignore: unnecessary_null_comparison
    if (subject == null || subject.isEmpty) subject = "Default";
    // Check if the color already exists in the map, if not, create and store it
    if (!_subjectColors.containsKey(subject)) {
      _subjectColors[subject] = Color.fromARGB(
        255,
        _random.nextInt(256),
        _random.nextInt(256),
        _random.nextInt(256),
      );
    }
    return _subjectColors[subject]!;
  }

  @override
  void initState() {
    super.initState();
    final posterId = (context.read<AppUserCubit>().state as AppUserLoggedIn)
        .loggedInUserCred
        .uid;
    print(posterId);
    context.read<NoteBloc>().add(NotesFetchAllNotes(posterId: posterId));
  }

  @override
  Widget build(BuildContext context) {
    return // Wrap the entire dashboard inside AppNavBar
        Scaffold(
      // Use 'child' instead of 'body'
      body: Column(
        children: [
          // Fixed Header Container
          Container(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.dashboard,
                      size: 30,
                      color: Colors.white,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.logout,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // Logout logic here
                         context.read<AuthBloc>().add(AuthSignOut());
                        // Navigate to WelcomeScreen
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const WelcomeScreen()),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              Padding(
                  padding: const EdgeInsets.only(left: 3, bottom: 15),
                  child: Obx(() {
                    final userName = Get.find<AuthController>().userName.value;
                    return Text(
                      "Hi $userName", // Reactive username
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        wordSpacing: 2,
                        color: Colors.white,
                      ),
                    );
                  }),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 20),
                  width: MediaQuery.of(context).size.width,
                  height: 55,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search here .....",
                      hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 10,
                  right: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GridView.builder(
                      itemCount: catNames.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.1,
                      ),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Column(
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: catcolors[index],
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: caticons[index],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                catNames[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 300,
                      margin: EdgeInsets.all(16),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 162, 167, 172),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row for Lessons and See All alignment
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Lessons",
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 7, 7, 7),
                                ),
                              ),
                              Text(
                                "See All",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // BlocBuilder for loading and displaying notes
                          BlocBuilder<NoteBloc, NoteState>(
                            builder: (context, state) {
                   if (state is NoteLoading) {
  return const Center(child: CircularProgressIndicator());
} else if (state is NoteDisplaySuccess) {
  if (state.notes.isEmpty) {
    // Case: No notes available for the user
    return const Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.note_add,
              size: 50,
              color: Colors.black,
            ),
            SizedBox(height: 8),
            Text(
              "No notes found. Start creating your first note!",
              style: TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Case: Notes available
  return Expanded(
    child: SingleChildScrollView(
      child: Column(
        children: [
          Scrollbar(
            thickness: 8.0,
            radius: Radius.circular(10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: state.notes.map((note) {
                  final color = _getColorForSubject(note.Subject);
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TweenAnimationBuilder(
                      tween: ColorTween(
                        begin: Colors.grey.shade300,
                        end: color,
                      ),
                      duration: const Duration(milliseconds: 800),
                      builder: (context, Color? animatedColor, child) {
                        return Chip(
                          label: Text(note.Subject),
                          backgroundColor: Colors.white,
                          shape: StadiumBorder(
                            side: BorderSide(
                              color: animatedColor!,
                              width: 2,
                            ),
                          ),
                          avatar: CircleAvatar(
                            backgroundColor: animatedColor,
                            radius: 8,
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Scrollbar(
            thickness: 8.0,
            radius: Radius.circular(10),
            child: SizedBox(
              height: 220,
              child: ListView.builder(
                itemCount: state.notes.length,
                itemBuilder: (context, index) {
                  final note = state.notes[index];
                  final color = _getColorForSubject(note.Subject);
                  return TweenAnimationBuilder(
                    tween: ColorTween(
                      begin: Colors.grey.shade300,
                      end: color.withOpacity(0.2),
                    ),
                    duration: const Duration(milliseconds: 800),
                    builder: (context, Color? tileColor, child) {
                      return AnimatedOpacity(
                        duration: const Duration(milliseconds: 800),
                        opacity: 1.0,
                        child: Card(
                          child: ListTile(
                            title: Text(note.Subject),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(note.indicators),
                                const SizedBox(height: 10),
                                Text(
                                  "${DateFormat("d MMM, yyyy").format(note.updatedAt)}",
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            tileColor: tileColor,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    ),
  );
} else {
  return const Center(child: Text("An error has occurred"));
}

                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
