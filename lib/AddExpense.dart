import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';


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

  @override
  void initState() {
    // TODO: implement initState
    // getUserFriend();
    getUserFriend().then((value) => setState((){}));
    print("Over here");
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
                Center(
                  child: Column(
                    children:[
                      Container(
                        width: 250,
                          // decoration: BoxDecoration(
                          //   color: Colors.grey[200],
                          //   border: Border.all(color: Colors.white),
                          //   borderRadius: BorderRadius.circular(12),
                          // ),
                          child: TextField(
                              controller: _expenseController,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                hintText: 'Expense Name',
                              ),
                            ),
                      ),
                      SizedBox(height: 10),
                      Container(
                          width: 250,
                          // decoration: BoxDecoration(
                          //   color: Colors.grey[200],
                          //   border: Border.all(color: Colors.white),
                          //   borderRadius: BorderRadius.circular(12),
                          // ),
                          child:  TextField(
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

                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                          onPressed: () {
                            final toBeAdded = [];
                            for(int i=0;i<friends.length;i++){
                              if(checked[i]==true){
                                toBeAdded.add(friends[i]);
                              }
                            }
                            int date = DateTime.now().microsecondsSinceEpoch;
                            db.collection('${FirebaseAuth.instance.currentUser!.uid}').doc("user-expenses").collection('expenses').doc('$date').set({
                              "exp_name" : _expenseController.text,
                              "amount" : double.parse(_amountController.text),
                              "date" : date,
                              "userId" : FirebaseAuth.instance.currentUser!.uid,
                              "userAmong" : toBeAdded
                            }).then((value) => print("Expense was added"));
                            Navigator.pop(context);

                          },
                          child:Text("Add expense")
                      ),
                      ListView.builder(
                            shrinkWrap: true,
                              itemCount: friends.length,
                              itemBuilder: (context,index){
                                return FriendsCheckBox(checked[index], friends[index], index);
                      })
                    ],
                  ),
                )

          ],
        )
      ),


    );
  }

  Widget FriendsCheckBox(bool value_bool,String name, int index){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            child: Text(name),
            width: 200,
          ),
          Checkbox(
            onChanged: (bool? value) {
              if(value_bool==true){
                checked[index] = false;
              }else {
                checked[index] = true;
              }
              setState((){});
            },
            value: checked[index],

          ),
        ],
      )
    );
  }


  Future getUserFriend() async {
    friends = [];
    checked = [];
    both = [];
    QuerySnapshot qs = await db.collection(FirebaseAuth.instance.currentUser!.uid).get();
    List tobeupdated = qs.docs.map((e) => e.data()).toList();
    friends = tobeupdated[0]['userFriend'];
    for(var i=0;i<friends.length;i++){
      checked.add(false);
    }

  }
}
