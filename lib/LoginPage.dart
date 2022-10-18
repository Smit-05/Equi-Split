import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:splitwise_sdp/main.dart';

class LoginPage extends StatefulWidget {

  final VoidCallback onClickedSignUp;
  const LoginPage({Key? key,
    required this.onClickedSignUp,}
      ):super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /// TextEditingController takes the input value from TextFields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  /// dispose() is used to clear the data once user leaves the screen
  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();

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

            Text(
                "Hello There!!",
                style: GoogleFonts.bebasNeue(
                  fontSize: 52,
                )
            ),
            SizedBox(height: 10),

            Text(
              "Welcome Back, Let's start the party 🚀",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 50),

            Padding(padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                      ),
                    ),
                  )
              ),
            ),

            SizedBox(height: 10),

            Padding(padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
                      ),
                    ),
                  )
              ),
            ),

            SizedBox(height: 10),

            Padding(padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                  padding: EdgeInsets.all(20),
                  child: ElevatedButton.icon(
                    onPressed: signIn,
                    icon: Icon(Icons.lock_open_sharp),
                    label: Center(
                      child: Text("Sign In",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  )
              ),
            ),

              SizedBox(height: 25),

              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    RichText(
                      text: TextSpan(
                          style: TextStyle(fontWeight: FontWeight.bold,
                          color: Colors.black),
                          text: "Not a Member? ",
                          children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = widget.onClickedSignUp,
                          text: "Register Here",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        )
                      ]
                      )
                    ),
                  ]
              ),

              ],
            ),
          ),
        )
    );
  }
  /// Reads input data from the user for signin
  Future signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child:CircularProgressIndicator())
    );
    try {
      /// Checks whether the user is present
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email:emailController.text.trim(),
        password: passwordController.text.trim()
      );

    } on Exception catch (e) {
      print(e);
    }
    navigatorKey.currentState!.popUntil((route)=>route.isFirst);
  }
}