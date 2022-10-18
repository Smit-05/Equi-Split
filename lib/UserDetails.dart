import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splitwise_sdp/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({Key? key}) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Add Your Details'),
          backgroundColor: Colors.black54,
      ),
      body: new Container(
          padding: new EdgeInsets.all(20.0),
          child: new Form(
            key: this._formKey,
            child: new ListView(
              children: <Widget>[
                SizedBox(height: 10,),
                Text('Full-Name'),
                new TextFormField(
                  controller: _nameController,
                    keyboardType:
                    TextInputType.text, // Use email input type for emails.
                    decoration: new InputDecoration(
                        labelText: 'Enter Your FullName')),
                Text("\n"),
                Text('Mobial-No'),
                new TextFormField(
                    controller: _mobileController,
                    keyboardType:
                    TextInputType.number, // Use secure text for passwords.
                    decoration: new InputDecoration(
                        labelText: 'Enter Your Mobial-No')),
                Text("\n"),
                TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xff1a1e22)),
                      foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered))
                            return Colors.blue.withOpacity(0.04);
                          if (states.contains(MaterialState.focused) ||
                              states.contains(MaterialState.pressed))
                            return Colors.blue.withOpacity(0.12);
                          return null; // Defer to the widget's default.
                        },
                      ),
                    ),
                    onPressed: setUserInfo,
                    child: Text('Add Details')),
              ],
            ),
          )),
    );
  }

  Future setUserInfo() async {
    final db = FirebaseFirestore.instance;
    final userdetails = <String,dynamic>{
      "name" : _nameController.text,
      "email" : FirebaseAuth.instance.currentUser!.email,
      "mobile" : _mobileController.text
    };
    db.collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('user-details')
        .set(userdetails)
        .then((value) => print("User Info set"));

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
