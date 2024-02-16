import 'package:flutter/material.dart';
import 'package:timeline/screens/events_screen.dart';
import 'package:timeline/screens/home_screen.dart';
import 'package:timeline/screens/map_screen.dart';

List<Widget> homeScreenItems = [
  const MapScreen(),
  const HomeScreen(),
  const EventScreen(),
];

Color orange = const Color.fromARGB(255, 203, 123, 3);
Color purple = const Color.fromARGB(255, 54, 23, 146);
Color deepBlue = Color.fromARGB(255, 31, 64, 131);
