import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:timeline/widgets/event.dart';
import 'package:timeline/widgets/event_info.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // ignore: prefer_final_fields
  Set<LatLng> _points = {};
  // ignore: prefer_final_fields
  Map<LatLng, Event> _pointsEvent = {};

  Future<void> fetchPoints() async {
    var snapshots = await _firestore
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .collection("events")
        .get();
    for (var doc in snapshots.docs) {
      String coordinates = doc["location"];
      LatLng point = LatLng(
        double.parse(coordinates.split(" ")[0]),
        double.parse(coordinates.split(" ")[1]),
      );
      Event event = Event(
        type: doc["group"],
        time: doc["time"],
        eventName: doc["event"],
        date: doc["date"],
        host: doc["creator"],
        participants: doc["participants"],
        photo: doc["ppURL"],
      );
      setState(() {
        _points.add(point);
        _pointsEvent[point] = event;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPoints();
  }

  static const LatLng _startPos = LatLng(
    42.01337147247476,
    21.45954110749342,
  );

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: _startPos,
        zoom: 13,
      ),
      markers: {
        Marker(
          markerId: const MarkerId("Starting Pos"),
          icon: BitmapDescriptor.defaultMarker,
          position: _startPos,
          onTap: () {},
        ),
        for (LatLng point in _points)
          Marker(
            markerId: MarkerId(point.toString()),
            position: point,
            onTap: () => EventInfo().showEventInfoPopup(
              context,
              _pointsEvent[point]!,
              _pointsEvent[point]!.host,
              _pointsEvent[point]!.participants,
              _pointsEvent[point]!.photo,
            ),
          ),
      },
    );
  }
}
