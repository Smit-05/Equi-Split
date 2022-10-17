import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';

class AddExpense extends StatefulWidget {
  AddExpense({Key? key}) : super(key: key);

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final _expenseController = TextEditingController();
  final _amountController = TextEditingController();

  final _dbref = FirebaseDatabase.instance.ref();

  @override
  void dispose(){
    _expenseController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final expenses = _dbref.child("users/${user.uid}/expenses/${DateTime.now().millisecondsSinceEpoch}");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent[400],
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
                        onPressed: () async {

                          await expenses.set({
                            "exp_name": _expenseController.text,
                            "amount" : double.parse(_amountController.text)
                          }).then((value) => print("Data was written"))
                          .catchError((onError) => print("Error generated $onError"));
                          // print(expenseController.text);
                          Navigator.pop(context);
                        },
                        child:Text("Add expense"))
                  ],
                )
              ],
            )

          ],
        )
      ),


    );
  }
}
