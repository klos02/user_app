import 'package:cloud_firestore/cloud_firestore.dart';

class Trainersdb {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(Map<String, dynamic> data) async {
    try{
    await _firestore.collection('users').doc(data['uid']).set(data);
    } on FirebaseException catch(e){
      print(e); //debug
    }
  }
}