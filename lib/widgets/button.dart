import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final VoidCallback onsubmit;
  final String action;

  const Button({
    super.key,
    required this.action,
    required this.onsubmit,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onsubmit();
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 4,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          action,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
