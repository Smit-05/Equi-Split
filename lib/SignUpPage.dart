import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:splitwise_sdp/main.dart';

class SignUpPage extends StatefulWidget {
  final Function() onClickedSignIn;

  const SignUpPage({
    Key? key,
    required this.onClickedSignIn,
  }) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _dbref = FirebaseDatabase.instance.ref();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.android,
                  size: 70,
                ),
                SizedBox(height: 10),
                Text("Hello There!!",
                    style: GoogleFonts.bebasNeue(
                      fontSize: 52,
                    )),
                SizedBox(height: 10),
                Text(
                  "Welcome Back, Let's start the party 🚀",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Email',
                          ),
                        ),
                      )),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Password',
                          ),
                        ),
                      )),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Confirm Password',
                          ),
                        ),
                      )),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                      padding: EdgeInsets.all(20),
                      child: ElevatedButton.icon(
                        onPressed: signUp,
                        icon: Icon(Icons.lock_open_sharp),
                        label: Center(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        // child: Center(
                        //   child: Text("Sign in",
                        //     style: TextStyle(
                        //       color: Colors.white,
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: 18,
                        //     ),
                        //   ),
                        // )
                      )),
                ),
                SizedBox(height: 25),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  RichText(
                      text: TextSpan(
                          style: TextStyle(fontWeight: FontWeight.bold,
                              color: Colors.black),
                          text: "Already a Member? ",
                          children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = widget.onClickedSignIn,
                              text: "Login Here",
                              style: TextStyle(
                                  color: Colors.blue, fontWeight: FontWeight
                                  .bold),
                            )
                          ]
                      )
                  ),
                ]),
              ],
            ),
          ),
        ));
  }

  Future signUp() async {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()));

    try {
      if (_passwordController.text.trim() ==
          _confirmPasswordController.text.trim()) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim()
        );
        final user = FirebaseAuth.instance.currentUser!;
        final users = _dbref.child("users/${user.uid}");
        await users.set({
          "email" : user.email,
        });

      } else {
        print("Password didn't match");
      }
    } on Exception catch (e) {
      print(e);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
