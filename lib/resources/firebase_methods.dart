import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<String> createUser({
    required String email,
    required String password,
    required String username,
  }) async {
    String result = "Error while sign up occured";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        //user sign up
        UserCredential user = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        //saving user details
        _fireStore.collection("users").doc(user.user!.uid).set({
          "email": email,
          "username": username,
        });
        result = "User successfuly created";
      }
    } catch (error) {
      result = error.toString();
    }
    return result;
  }

  Future<String> logInUser({
    required String email,
    required String password,
  }) async {
    String result = "Error while log in occured";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        result = "User successfuly logged in";
      }
    } catch (error) {
      result = error.toString();
    }
    return result;
  }

  Future<void> signOutUser() async {
    await _auth.signOut();
    SystemNavigator.pop();
  }

  Future<String> createNewEvent({
    required String userUid,
    required DateTime dateTime,
    required TimeOfDay timeOfDay,
    required String name,
    required String group,
  }) async {
    String result = "Error while making event";
    try {
      String eventID = const Uuid().v1();
      if (userUid.isNotEmpty &&
          dateTime != DateTime(0) &&
          name.isNotEmpty &&
          group.isNotEmpty) {
        _fireStore
            .collection("users")
            .doc(userUid)
            .collection("events")
            .doc(eventID)
            .set({
          "event": name,
          "date": dateTime.toString(),
          "time": timeOfDay.toString().substring(
              timeOfDay.toString().indexOf("(") + 1,
              timeOfDay.toString().indexOf(")")),
          "group": group,
        });
        if (group == "public") {
          _fireStore.collection("publicEvents").doc(eventID).set({
            "event": name,
            "date": dateTime.toString(),
            "time": timeOfDay.toString().substring(
                timeOfDay.toString().indexOf("(") + 1,
                timeOfDay.toString().indexOf(")")),
            "group": group,
          });
        }
        result = "Event successfully created";
      }
    } catch (error) {
      result = error.toString();
    }
    return result;
  }
}
