import 'package:flutter/material.dart';
import 'package:timeline/resources/firebase_methods.dart';
import 'package:timeline/screens/mobile_screen.dart';
import 'package:timeline/screens/sign_up_screen.dart';
import 'package:timeline/widgets/button.dart';
import 'package:timeline/widgets/input_box.dart';

import '../global_variables.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  // ignore: prefer_final_fields
  TextEditingController _mail = TextEditingController();

  // ignore: prefer_final_fields
  TextEditingController _pass = TextEditingController();
  final FirebaseMethods firebase = FirebaseMethods.instance;

  void logIn() async {
    String result =
        await firebase.logInUser(email: _mail.text, password: _pass.text);
    if (result == "User successfuly logged in") {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MobileScreen(),
        ),
      );
      _mail.clear();
      _pass.clear();
    }
    // ignore: avoid_print
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InputBox(
                  controller: _mail,
                  hitText: "Email",
                ),
                InputBox(
                  controller: _pass,
                  hitText: "Password",
                ),
                Button(
                  onsubmit: () => logIn(),
                  action: "Log In",
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ),
                  ),
                  child: const Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Sign Up",
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
    );
  }
}
