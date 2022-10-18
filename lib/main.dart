///
///  Equi-Split is an bill splitting application used for splitting bills
///
/// @author Smit Padaliya
/// @author Jeet Savsani
///


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splitwise_sdp/HomePage.dart';
import 'package:splitwise_sdp/AuthPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

/// Application starts here
void main() async {

  /// This method is used for widget bindings
  WidgetsFlutterBinding.ensureInitialized();

  /// initializeApp allows our app to connect with Firebase
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
      home: MainPage(),

    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        /// It allows us to show screen according to the condition of stream
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
