import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Private constructor for Singleton design pattern
  FirebaseMethods._privateConstructor();

  static final FirebaseMethods _instance =
      FirebaseMethods._privateConstructor();

  // Getter to access the instance
  static FirebaseMethods get instance => _instance;

  Future<String> createUser({
    required String email,
    required String password,
    required String username,
  }) async {
    String result = "Error while sign up occurred";
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
    String result = "Something went wrong";
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

  Future<String> uploadImageToStorage(Uint8List file, String eventId) async {
    Reference ref = _storage.ref().child("eventsProfilePics").child(eventId);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snap = await uploadTask;
    String downloadURL = await snap.ref.getDownloadURL();
    return downloadURL;
  }

  Future<String> createNewEvent({
    required DateTime dateTime,
    required TimeOfDay timeOfDay,
    required String name,
    required String group,
    required String location,
    required Uint8List file,
  }) async {
    String eventID = const Uuid().v1();
    String result = "Error while making event";
    DocumentSnapshot user =
        await _fireStore.collection("users").doc(_auth.currentUser!.uid).get();
    String photoURL = await uploadImageToStorage(file, eventID);
    try {
      if (_auth.currentUser!.uid.isNotEmpty &&
          dateTime != DateTime(0) &&
          name.isNotEmpty &&
          group.isNotEmpty) {
        _fireStore
            .collection("users")
            .doc(_auth.currentUser!.uid)
            .collection("events")
            .doc(eventID)
            .set({
          "id": eventID,
          "event": name,
          "date": dateTime.toString(),
          "time": timeOfDay.toString().substring(
              timeOfDay.toString().indexOf("(") + 1,
              timeOfDay.toString().indexOf(")")),
          "group": group,
          "location": location,
          "participants": [],
          "creator": user["username"],
          "ppURL": photoURL,
        });
        if (group == "public") {
          _fireStore.collection("publicEvents").doc(eventID).set({
            "id": eventID,
            "event": name,
            "date": dateTime.toString(),
            "time": timeOfDay.toString().substring(
                timeOfDay.toString().indexOf("(") + 1,
                timeOfDay.toString().indexOf(")")),
            "group": group,
            "location": location,
            "participants": [],
            "creator": user["username"],
            "ppURL": photoURL,
          });
        }
        result = "Event successfully created";
      }
    } catch (error) {
      result = error.toString();
    }
    return result;
  }

  Future<String> likeEvent({
    required String eventId,
    required String useruid,
  }) async {
    String result = "Error while liking event";
    try {
      if (eventId.isNotEmpty && useruid.isNotEmpty) {
        DocumentSnapshot snap =
            await _fireStore.collection("publicEvents").doc(eventId).get();
        if (snap["participants"].contains(useruid)) {
          _fireStore.collection("publicEvents").doc(eventId).update({
            "participants": FieldValue.arrayRemove([useruid]),
          });
          _fireStore
              .collection("users")
              .doc(useruid)
              .collection("events")
              .doc(eventId)
              .update({
            "participants": FieldValue.arrayRemove([useruid]),
          });
          result = "Event successfully disliked";
        } else {
          _fireStore.collection("publicEvents").doc(eventId).update({
            "participants": FieldValue.arrayUnion([useruid]),
          });
          _fireStore
              .collection("users")
              .doc(useruid)
              .collection("events")
              .doc(eventId)
              .update({
            "participants": FieldValue.arrayUnion([useruid]),
          });
          result = "Event successfully liked";
        }
      }
    } catch (error) {
      result = error.toString();
    }
    return result;
  }
}
