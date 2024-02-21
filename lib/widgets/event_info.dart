import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeline/widgets/event.dart';

class EventInfo {
  Future<String> _getName(String uuid) async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection("users").doc(uuid).get();
    return snap["username"];
  }

  void showEventInfoPopup(BuildContext context, Event event, String host,
      List participants, String photo) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              event.eventName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Center(
            heightFactor: 1.5,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(photo),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 7,
                      ),
                      child: Text("Created by: $host"),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10,
                      ),
                      child:
                          Text("${event.time} - ${event.date.split(" ")[0]}"),
                    ),
                  ),
                  const Center(
                    child: Text(
                      "Participants:",
                    ),
                  ),
                  Center(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: participants.map((participant) {
                          return FutureBuilder<String>(
                            future: _getName(participant),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else {
                                if (snapshot.hasData) {
                                  return Text(snapshot.data!);
                                } else {
                                  return const Text(
                                    "Participant not found",
                                  );
                                }
                              }
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
