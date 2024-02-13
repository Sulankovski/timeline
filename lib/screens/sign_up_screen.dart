import 'package:flutter/material.dart';
import 'package:timeline/resources/firebase_methods.dart';
import 'package:timeline/screens/log_in_screen.dart';
import 'package:timeline/screens/mobile_screen.dart';
import 'package:timeline/widgets/button.dart';
import 'package:timeline/widgets/input_box.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // ignore: prefer_final_fields
  TextEditingController _mail = TextEditingController();
  // ignore: prefer_final_fields
  TextEditingController _pass = TextEditingController();
  // ignore: prefer_final_fields
  TextEditingController _username = TextEditingController();

  void signUp() async {
    String result = await FirebaseMethods().createUser(
      email: _mail.text,
      password: _pass.text,
      username: _username.text,
    );
    if (result == "User successfuly created") {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MobileScreen(),
        ),
      );
      _mail.clear();
      _pass.clear();
      _username.clear();
    }
    // ignore: avoid_print
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                // Color.fromARGB(255, 27, 10, 81),
                Color.fromARGB(255, 54, 23, 146),
                Color.fromARGB(255, 203, 123, 3),
                Color.fromARGB(255, 54, 23, 146),
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
                InputBox(
                  controller: _username,
                  hitText: "User name",
                ),
                Button(
                  onsubmit: () => signUp(),
                  action: "Sign Up",
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LogInScreen(),
                    ),
                  ),
                  child: const Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Have an account?",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Log In",
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
