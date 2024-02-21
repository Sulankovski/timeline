import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeline/global_variables.dart';
import 'package:timeline/resources/firebase_methods.dart';
import 'package:timeline/screens/log_in_screen.dart';
import 'package:timeline/widgets/stats.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({
    super.key,
    required this.uid,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseMethods firebase = FirebaseMethods.instance;
  String? username;
  int publicEvents = 0;
  int privateEvents = 0;
  int groupEvents = 0;

  getData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .get();
      var userPublicPosts = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .collection("events")
          .where("group", isEqualTo: "public")
          .get();
      var userPrivatePosts = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .collection("events")
          .where("group", isEqualTo: "private")
          .get();
      var userGrouPosts = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .collection("events")
          .where("group", isEqualTo: "group")
          .get();
      setState(() {
        username = userSnap.data()!["username"];
        publicEvents = userPublicPosts.docs.length;
        privateEvents = userPrivatePosts.docs.length;
        groupEvents = userGrouPosts.docs.length;
      });
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              deepBlue,
              Colors.lightBlueAccent,
            ],
          ),
        ),
        child: username == null
            ? Center(
                child: CircularProgressIndicator(
                  color: deepBlue,
                ),
              )
            : Center(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: 400,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          username!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Stats(
                          name: "Public Events",
                          size: publicEvents,
                        ),
                        Stats(
                          name: "Private Events",
                          size: privateEvents,
                        ),
                        Stats(
                          name: "Group Events",
                          size: groupEvents,
                        ),
                        GestureDetector(
                          onTap: () async {
                            await firebase.signOutUser();
                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LogInScreen(),
                              ),
                            );
                          },
                          child: const Column(
                            children: [
                              Text(
                                "Sign Out",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
