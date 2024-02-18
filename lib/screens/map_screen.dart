import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
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
      },
    );
  }
}
