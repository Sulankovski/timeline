import 'package:flutter/material.dart';

class Stats extends StatelessWidget {
  final String name;
  final int size;

  const Stats({
    super.key,
    required this.name,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          "$size",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}
