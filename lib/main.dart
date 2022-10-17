import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:splitwise_sdp/HomePage.dart';
import 'package:splitwise_sdp/AuthPage.dart';

import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      // home: Body(),
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => HomePage()
      // },
      home: MainPage(),

    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            }else if(snapshot.hasError){
              return Center(child: Text("Something went wrong"));
            } else if (snapshot.hasData) {
              return HomePage();
            } else {
              return AuthPage();
            }
          },
        ),
      );
}
