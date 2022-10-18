import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splitwise_sdp/models/Expenses.dart';
import 'package:splitwise_sdp/models/Users.dart';

class Expenses{
  String? exp_name;
  double? amount;
  String? uid;
  static int id =0;

  Expenses({
    required this.exp_name,
    required this.amount,
    required this.uid
  }){
    id++;
  }

  Future setExpense() async {
    final db = FirebaseFirestore.instance;
    final expense = <String,dynamic>{
      "exp_name" : this.exp_name,
      "amount" : this.amount,
      "user" : this.uid
    };
    db.collection("expenses").doc(this.uid).collection(id.toString()).doc().set(expense).then((value) => print("Expense was added"));
    // db.collection("expenses").g;
  }



}
