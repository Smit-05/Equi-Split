import 'package:flutter/material.dart';
import 'package:splitwise_sdp/LoginPage.dart';
import 'package:splitwise_sdp/SignUpPage.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

/// This class helps to toggle between LoginPage and SignupPage
class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? LoginPage(
          onClickedSignUp: toggle,
        )
      : SignUpPage(
          onClickedSignIn: toggle
        );

  void toggle() => setState(() => isLogin=!isLogin);
}
