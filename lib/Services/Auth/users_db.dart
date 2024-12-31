import 'package:cloud_firestore/cloud_firestore.dart';

class Usersdb {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(data['uid']).set(data);
    } on FirebaseException catch (e) {
      print(e); //debug
    }
  }

  Future<void> updateWeight(String uid, double weight) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      await _firestore.collection('users').doc(uid).update({'weight': weight});
    } on FirebaseException catch (e) {
      print(e); //debug
    }
  }

  Future<void> updateHeight(String uid, double height) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      await _firestore.collection('users').doc(uid).update({'height': height});
    } on FirebaseException catch (e) {
      print(e); //debug
    }
  }

  Future<void> updateExperience(String uid, int experience) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .update({'gymExperience': experience});
    } on FirebaseException catch (e) {
      print(e); //debug
    }
  }

    Future<double?> getWeight(String uid) async {
      try {
        final snapshot = await _firestore.collection('users').doc(uid).get();
        return snapshot.data()?['weight']?.toDouble() ?? 0;
      } on FirebaseException catch (e) {
        print(e); // debug
        return 0;
      }
    }

    Future<double?> getHeight(String uid) async {
      try {
        final snapshot = await _firestore.collection('users').doc(uid).get();
        return snapshot.data()?['height']?.toDouble() ?? 0;
      } on FirebaseException catch (e) {
        print(e); // debug
        return 0;
      }
    }

    Future<int?> getGymExperience(String uid) async {
      try {
        final snapshot = await _firestore.collection('users').doc(uid).get();
        return snapshot.data()?['gymExperience']?.toInt() ?? 0;
      } on FirebaseException catch (e) {
        print(e); // debug
        return 0;
      }
    }
  }

