import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    num count=0;
    return Scaffold(
      backgroundColor: Colors.grey[350],
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.greenAccent[400],
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 40,horizontal: 30),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                child: CircleAvatar(
                  backgroundImage: AssetImage('images/profile.jpg'),
                  backgroundColor: Colors.greenAccent[400],
                  radius: 70,
                ),
                radius: 75,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'NAME',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  color: Colors.grey[800],
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(height: 10),
              Text(
                user.email!,
                style: TextStyle(
                  color: Colors.indigo[500],
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w900,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 40),
              Text(
                'AGE',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  color: Colors.grey[800],
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '20',
                style: TextStyle(
                  color: Colors.indigo[500],
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w900,
                  fontSize: 20.0,
                ),
              ),
              ElevatedButton.icon(
                  onPressed: signOut,
                  icon: Icon(Icons.logout_sharp),
                  label: Text("Sign Out"))
            ],
          ),
        ),
      ),
    );

  
}

  void signOut(){
    FirebaseAuth.instance.signOut();
    Navigator.pop(context);
  }
}