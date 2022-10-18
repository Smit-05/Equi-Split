
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:splitwise_sdp/Profile.dart';
import 'package:splitwise_sdp/AddExpense.dart';
import 'package:splitwise_sdp/main.dart';

class HomePage extends StatefulWidget {
HomePage({Key? key}) : super(key: key);

@override
State<HomePage> createState() => _BodyState();
}

class _BodyState extends State<HomePage> {
final TextEditingController _textFieldController = TextEditingController();
final friendController = TextEditingController();
final db = FirebaseFirestore.instance;
final nf = NumberFormat();
late List friends;


  @override
  void dispose() {
    friendController.dispose();
    super.dispose();
    print("dispose called");
  }


@override
Widget build(BuildContext context) {
  nf.maximumFractionDigits = 2;
  nf.minimumFractionDigits = 0;
  return Scaffold(
    backgroundColor: Colors.grey[350],
    appBar: AppBar(
      backgroundColor: Colors.black54,
      title: Row(
        children: [
          Icon(
            Icons.account_balance_wallet,
            color: Colors.white54,
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
          /// Renders the ListView according to the stream
          StreamBuilder(
              stream: db.collection('${FirebaseAuth.instance.currentUser!.uid}').doc('user-expenses').collection('expenses').orderBy('date',descending: true).snapshots(),
              builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.hasData){

                return Expanded(child:
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: ( context ,index) {
                      final DocumentSnapshot docsnap = snapshot.data!.docs[index];
                      return ListCards(docsnap['exp_name'], docsnap['amount'],docsnap['date'],context);
                    }
                ));
              }else{
                return Center(child: CircularProgressIndicator());
              }
          }),

        ],
      ),
    ),


    floatingActionButton: FloatingActionButton.extended(
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddExpense(FirebaseAuth.instance.currentUser!.uid)));
      },
      label: Text("Add Expense"),
      icon: Icon(Icons.document_scanner_sharp),
      backgroundColor: Colors.blueAccent[400],
      elevation: 10,

    ),
    bottomNavigationBar:

    BottomAppBar(
      color: Colors.black54,
      elevation: 1,
      child: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: [
            IconButton(
              onPressed: (){},
              icon: Icon(Icons.home,
                size: 30),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))
                      ),
                      title: Text("Add Friend's Name",
                      style: GoogleFonts.acme(
                        fontSize: 25
                      ),),
                      content: Container(
                      height: MediaQuery.of(context).size.height/5,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          TextField(
                            controller: friendController,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              hintText: 'Name',
                            ),
                          ),
                          SizedBox(height: 35),
                          Material(
                            color: Colors.deepOrangeAccent,
                            borderRadius: BorderRadius.circular(50),
                            child: InkWell(
                                onTap: () async {
                                  QuerySnapshot qs = await db.collection(FirebaseAuth.instance.currentUser!.uid).get();
                                  List tobeupdated = qs.docs.map((e) => e.data()).toList();
                                  List next = tobeupdated[0]['userFriend'];
                                  next.add(friendController.text);

                                  /// Updates specified value
                                  db.collection(FirebaseAuth.instance.currentUser!.uid).doc('user-details')
                                      .update({"userFriend" : next}).then((value) => print("Friend was added"));

                                  navigatorKey.currentState!.popUntil((route)=>route.isFirst);
                                  },
                                borderRadius: BorderRadius.circular(50),
                                child: Container(
                                    width: 200,
                                    height: 45,
                                    alignment: Alignment.center,
                                    child: Text('Add Friend',),
                                    ),
                                ),
                          ),

                        ],
                      ),
                    ),
                    );
                  },

                );
              },
              icon: Icon(Icons.person_add_alt_1_sharp,
                  size: 30),
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
    ),
  );
}



Widget ListCards(String exp_name,double amount,int date, BuildContext context){
  return InkWell(
    onTap: () {
      getUserAmong(date).then((value) => showDialog(context: context, builder: (context) {
        return AlertDialog(
          // content: Text(exp_name),
          title: Text(exp_name,
            style: GoogleFonts.acme(
                fontSize: 25
            ),
          ),
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20),
          backgroundColor: Colors.greenAccent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          content: Container(
            // height: MediaQuery.of(context).size.height*0.25,
              child:
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Amount : $amount",
                    style: GoogleFonts.acme(
                        fontSize: 17
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text('${DateFormat.yMMMMd('en_US').format(DateTime.fromMicrosecondsSinceEpoch(date))}',
                    style: GoogleFonts.acme(
                        fontSize: 17
                    ),
                  ),
                  SizedBox(height: 35,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("People",
                            style: GoogleFonts.acme(

                            ),
                          ),
                          SizedBox(width: 20,),
                          Text('Amount',
                            style: GoogleFonts.acme(

                            ),
                          ),
                          SizedBox(height: 20,),
                        ],
                      )
                    ],
                  ),
                  for(var i=0;i<friends.length;i++)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(friends[i],
                              style: GoogleFonts.acme(
                              ),
                            ),
                            SizedBox(width: 20,),
                            Text('${nf.format(amount / (friends.length + 1))}',
                              style: GoogleFonts.acme(
                              ),
                            ),
                            SizedBox(height: 20,),
                          ],
                        )
                      ],
                    ),

                  SizedBox(height: 20,),
                  FloatingActionButton.extended(
                    onPressed: () async {
                      await db.collection(FirebaseAuth.instance.currentUser!.uid).doc('user-expenses').collection('expenses').doc('$date').delete().then((value) => print("Deleted"));
                      navigatorKey.currentState!.popUntil((route)=>route.isFirst);
                    },
                    icon: Icon(
                        FontAwesomeIcons.trash
                    ),
                    label: Text("Delete"),
                    backgroundColor: Colors.red,
                  ),

                ],

              )
          ),
        );
      }));
    },
    child: Card(
      elevation: 10,
      child: SizedBox(
        width: MediaQuery.of(context).size.width-30,
        height: 100,
        child: Stack(
          children: [
            Positioned(
                top: 25,
                left: 10,
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.tealAccent,
                  child: Icon(FontAwesomeIcons.fileInvoiceDollar,
                    size: 30,
                    color: Colors.red,),
                )
            ),
            Positioned(
                top: 25,
                left: 80,
                child: Text(exp_name,
                  style: GoogleFonts.acme(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1),)
            ),
            Positioned(
                top: 25,
                right: 45,
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.indianRupeeSign,
                      size: 17,
                    ),
                    Text(amount.toString(),
                      style: GoogleFonts.acme(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1),
                    )
                  ],
                )
            ),
          ],
        ),

      ),
    ),
  );
}
  /// Finds the splitting partners of expense
  Future getUserAmong(int date) async {
    friends = [];
    await db.collection(FirebaseAuth.instance.currentUser!.uid).doc('user-expenses').collection('expenses').doc('$date')
        .get().then((value){
            friends = value.data()!['userAmong'];
    }
    );
    setState((){});
  }
}



