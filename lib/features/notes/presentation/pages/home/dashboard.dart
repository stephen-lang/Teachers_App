import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacherapp_cleanarchitect/core/common/cubits/app_user/app_user_cubit_cubit.dart';
import 'package:teacherapp_cleanarchitect/features/notes/presentation/bloc/note_bloc.dart';
import 'package:teacherapp_cleanarchitect/features/notes/presentation/pages/home/icons.dart';

class Dash extends StatefulWidget {
  const Dash({super.key});
  static String routeName = '/dashboard';

  @override
  State<Dash> createState() => _DashState();
  
}



class _DashState extends State<Dash> {
  @override
  void initState(){
  super.initState();
  final posterId =(context.read<AppUserCubit>().state as AppUserLoggedIn).loggedInUserCred.uid;
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
                        /*   context.read<SignInBloc>().add(SignOutRequired());
                        // Navigate to WelcomeScreen
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const WelcomeScreen()),
                        );*/
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.only(left: 3, bottom: 15),
                  child: Text(
                    "Hi User",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                      wordSpacing: 2,
                      color: Colors.white,
                    ),
                  ),
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
                  top: 20,
                  left: 20,
                  right: 20,
                ),
                child: Column(
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
                        return Column(
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
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Lessons",
                          style: TextStyle(
                            fontSize: 23,
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
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        10,
                        10,
                        10,
                        10,
                      ),
                      child: BlocBuilder<NoteBloc, NoteState>(
                        builder: (context, state) {
                          if (state is NoteLoading) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (state is NoteDisplaySuccess) {
                           
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: ListView.builder(
                                itemCount: state.notes.length,
                                itemBuilder: (context, index) {
                                  final note = state.notes[index];
                                  return Card(
                                    // color: note.subjectColor.withOpacity(0.2),
                                    child: ListTile(
                                      //title: Text(note.grade as String),
                                      subtitle: Text(note.indicators),
                                      trailing: CircleAvatar(
                                        backgroundColor: note.noteId == 23
                                            ? Colors.yellow
                                            : Colors.red,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }  else {
                            return const Center(
                              child: Text("An error has occourred"),
                            );
                          }
                        },
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
