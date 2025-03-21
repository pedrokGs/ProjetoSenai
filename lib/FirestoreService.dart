import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseFirestore get firestore => _firestore;

  Future<void> addUser(String userId, Map<String, dynamic> userData) async{
    await _firestore.collection('users').doc(userId).set(userData);
  }

  Future<List<int>> getLivrosLidos(String userId) async {
    try {
      DocumentSnapshot userDoc = await firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        List<dynamic> leituras = userDoc.get('leituras');
        return leituras.map((item) => item as int).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Erro ao obter livros lidos: $e');
      return [];
    }
  }

  Stream<QuerySnapshot> getLivrosFiltrados(List<int> livrosLidos) {
    return firestore.collection('livros').where(FieldPath.documentId, whereIn: livrosLidos).snapshots();
  }
}