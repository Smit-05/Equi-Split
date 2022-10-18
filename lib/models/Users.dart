import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String? id;
  String? name;
  String? email;
  Users({
    required this.id,
    required this.name,
    required this.email
  });

  Future setUsers() async{
    final db = FirebaseFirestore.instance;
    final user = <String,dynamic>{
      "id": this.id,
      "name" : this.name,
      "email" : this.email
    };
    db.collection("users").add(user).then((value) => print("User was added"));
  }



}