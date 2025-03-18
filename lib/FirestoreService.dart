import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseFirestore get firestore => _firestore;

  Future<void> addUser(String userId, Map<String, dynamic> userData) async{
    await _firestore.collection('users').doc(userId).set(userData);
  }
}