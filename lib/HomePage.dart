import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:splitwise_sdp/Profile.dart';
import 'package:splitwise_sdp/AddExpense.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _BodyState();
}

class _BodyState extends State<HomePage> {
  final TextEditingController _textFieldController = TextEditingController();
  final _dbref = FirebaseDatabase.instance.ref();

  late Map<String,dynamic> data;

  _BodyState(){
    getUserData();
  }

  @override
  initState(){
    getUserData();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[350],
      appBar: AppBar(
        backgroundColor: Colors.greenAccent[400],
        title: Row(
          children: [
            Icon(
              Icons.account_balance_wallet,
              color: Colors.black54,
              size: 25,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: Text("Equi-Split",
                  style: GoogleFonts.acme(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1)),
            ),
          ],
        ),
        elevation: 10,
        foregroundColor: Colors.white,
      ),
      body: Container(
        child: Column(
          children: [
            // for(var value)
            // data.forEach((key, value) => Text(value)
              Text(data['email'])
          ],
        ),
      ),


      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddExpense()));
        },
        label: Text("Add Expense"),
        icon: Icon(Icons.document_scanner_sharp),
        backgroundColor: Colors.blueAccent[400],
        elevation: 10,

      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: getUserData,
                icon: Icon(Icons.home,
                  size: 30,),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Profile()),
                  );
                },
                icon: Icon(Icons.person,
                  size: 30,),
              ),
            ],
          ),
        ),
        color: Colors.greenAccent[400],
        elevation: 1,
      ),
    );
  }

  void getUserData() async {
    final user = FirebaseAuth.instance.currentUser!;
    final snapshot = await _dbref.child("users/${user.uid}").get();
    print(snapshot.value);
    data = snapshot.value as Map<String, dynamic>;

  }


}

