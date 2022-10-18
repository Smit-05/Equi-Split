import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final size = MediaQuery.of(context).size;
    num count=0;
    return Scaffold(
      backgroundColor: Colors.grey[350],
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.black54,
        elevation: 0.0,
      ),

      body: Stack(
        children: [
          Positioned(
              top: size.height * 0.05,
              left: (size.width / 2) - 90,
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/img.png'),
                backgroundColor: Colors.black54,
                radius: 90,
              )
          ),
          Positioned(
              top: size.height*0.3,
              left: size.width*0.05,
              width: size.width-40,
              child: InfoCard()
          ),
          Positioned(
              top: size.height*0.67,
              left: (size.width / 2) - 90,
              width: 180,
              child: signOutButton()
          )
        ],
      ),

    );

}

  Widget InfoCard(){
    return Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Column(
          children: [
            StreamBuilder(
                stream: db.collection(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
                  if(snapshot.hasData){
                    final DocumentSnapshot docsnap = snapshot.data!.docs[0];
                    return Column(
                      children: [
                        showData(FontAwesomeIcons.user, docsnap['name']),
                        showData(FontAwesomeIcons.envelope, docsnap['email']),
                        showData(FontAwesomeIcons.phone, docsnap['mobile']),
                      ],
                    );
                  }else{
                    return Center(child: CircularProgressIndicator(),);
                  }

                })
            // showData(FontAwesomeIcons.user,
            //     "Anonymous User"),
            // showData(FontAwesomeIcons.envelope,
            //     "Anonymous Email"),
            // showData(FontAwesomeIcons.table,
            //     "Anonymous Sem" " sem"),
            // showData(FontAwesomeIcons.networkWired,
            //     "Anonymous department"),
          ],
        ),
        );
  }

  Widget showData(IconData ico, String s) => Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
      padding: EdgeInsets.all(20),
      child: Row(
          children: [
            Icon(
              ico,
              color: Color(0xff1976d2),
            ),
            SizedBox(
              width: 50,
            ),
            Text(
              s,
            ),
          ],
          ),
      );

  Widget signOutButton(){
    return FloatingActionButton.extended(
        onPressed: signOut,
        label: Text("Sign Out"),
        backgroundColor: Colors.red,
        icon: Icon(
          FontAwesomeIcons.rightToBracket,
        size: 20,

      ),


    );
  }


  void signOut(){
    FirebaseAuth.instance.signOut();
    Navigator.pop(context);
  }


}