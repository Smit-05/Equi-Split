import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:splitwise_sdp/models/Expenses.dart';
import 'package:splitwise_sdp/models/Users.dart';


class AddExpense extends StatefulWidget {
  AddExpense(this.uid,{Key? key}) : super(key: key);
  String? uid;
  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final _expenseController = TextEditingController();
  final _amountController = TextEditingController();

  final db = FirebaseFirestore.instance;

  late List<bool> checked ;
  late List friends;
  late List both;

  _AddExpenseState() {

    print("Constructor");
  }

  @override
  void initState() {
    // TODO: implement initState
    // getUserFriend();
    getUserFriend();
    super.initState();
  }

  @override
  void dispose(){
    _expenseController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Row(
          children: [
            // Icon(
            //   Icons.account_balance_wallet,
            //   color: Colors.black54,
            //   size: 25,
            // ),
            Container(
              margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: Text("Add Expense",
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
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10 ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children:[
                    Container(
                      width: 250,
                        // decoration: BoxDecoration(
                        //   color: Colors.grey[200],
                        //   border: Border.all(color: Colors.white),
                        //   borderRadius: BorderRadius.circular(12),
                        // ),
                        child: Padding(padding: const EdgeInsets.only(left: 20.0),
                          child: TextField(
                            controller: _expenseController,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              hintText: 'Expense Name',
                            ),
                          ),
                        )
                    ),
                    SizedBox(height: 10),
                    Container(
                        width: 250,
                        // decoration: BoxDecoration(
                        //   color: Colors.grey[200],
                        //   border: Border.all(color: Colors.white),
                        //   borderRadius: BorderRadius.circular(12),
                        // ),
                        child: Padding(padding: const EdgeInsets.only(left: 20.0),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: _amountController,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              hintText: 'Amount',
                            ),
                          ),
                        )
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                        onPressed: () {
                          int date = DateTime.now().microsecondsSinceEpoch;
                          db.collection('${FirebaseAuth.instance.currentUser!.uid}').doc("user-expenses").collection('expenses').doc('$date').set({
                            "exp_name" : _expenseController.text,
                            "amount" : double.parse(_amountController.text),
                            "date" : date,
                            "userId" : FirebaseAuth.instance.currentUser!.uid,
                            "userAmong" : []
                          }).then((value) => print("Expense was added"));
                          Navigator.pop(context);

                        },
                        child:Text("Add expense")
                    ),

                    for(var i=1;i<friends.length;i++)
                      FriendsCheckBox(checked[i], friends[i], i),

                  ],
                )
              ],
            )

          ],
        )
      ),


    );
  }

  Widget FriendsCheckBox(bool value,String name, int index){
    return Container(
      child: Checkbox(
        onChanged: (bool? value) {

        }, value: value,
        
      ),
    );
  }


  Future getUserFriend() async {
    friends = [];
    checked = [];
    both = [];
    QuerySnapshot qs = await db.collection(FirebaseAuth.instance.currentUser!.uid).get();
    List tobeupdated = qs.docs.map((e) => e.data()).toList();
    print(tobeupdated);
    friends = tobeupdated[0]['userFriend'];
    // print(tobeupdated[0]['userFriend']);
    for(var i=0;i<friends.length;i++){
      checked.add(false);
    }
    for(int i=1;i<friends.length;i++){
      both.add({friends[i]:checked[i]});
    }
    setState((){});
    print(checked);
    print(friends);
    print(both);

    // print("Hello");
  }
}
