import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeline/global_variables.dart';
import 'package:timeline/resources/firebase_methods.dart';
import 'package:timeline/widgets/event.dart';
import 'package:timeline/widgets/event_info.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

Future<bool> hasLiked(String eventId, String uuid) async {
  DocumentSnapshot snap = await FirebaseFirestore.instance
      .collection("publicEvents")
      .doc(eventId)
      .get();
  return snap["participants"].contains(uuid);
}

class _EventScreenState extends State<EventScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMethods _firebaseMethods = FirebaseMethods.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            // Color.fromARGB(255, 27, 10, 81),
            deepBlue,
            Colors.lightBlueAccent,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: const Text(
            "Public events",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: StreamBuilder(
          stream:
              _firestore.collection("publicEvents").orderBy("date").snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 6,
                        child: Center(
                          child: Text(
                            snapshot.data!.docs[index]["event"],
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 6,
                        child: Center(
                          child: Text(
                            snapshot.data!.docs[index]["date"].split(" ")[0],
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 6,
                        child: Center(
                          child: Text(
                            snapshot.data!.docs[index]["time"],
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 6,
                        child: Center(
                          child: GestureDetector(
                            onTap: () async {
                              await _firebaseMethods.likeEvent(
                                eventId: snapshot.data!.docs[index]["id"],
                                useruid: _auth.currentUser!.uid,
                              );
                            },
                            child: FutureBuilder<bool>(
                              future: hasLiked(snapshot.data!.docs[index]["id"],
                                  _auth.currentUser!.uid),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else {
                                  bool liked = snapshot.data ?? false;
                                  return Icon(
                                    liked
                                        ? Icons.thumb_up
                                        : Icons.thumb_up_off_alt_outlined,
                                    color: Colors.white,
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 6,
                        child: Center(
                          child: GestureDetector(
                            onTap: () => EventInfo().showEventInfoPopup(
                              context,
                              Event(
                                type: snapshot.data!.docs[index]["group"],
                                time: snapshot.data!.docs[index]["time"],
                                eventName: snapshot.data!.docs[index]["event"],
                                date: snapshot.data!.docs[index]["date"],
                                host: snapshot.data!.docs[index]["creator"],
                                participants: snapshot.data!.docs[index]
                                    ["participants"],
                                photo: snapshot.data!.docs[index]["ppURL"],
                              ),
                              snapshot.data!.docs[index]["creator"],
                              snapshot.data!.docs[index]["participants"],
                              snapshot.data!.docs[index]["ppURL"],
                            ),
                            child: const Icon(
                              Icons.group,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
