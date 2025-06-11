import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritosService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> adicionarFavorito(String userId, String livroId, Map<String, dynamic> livroData) async {
    await _firestore
        .collection('usuarios')
        .doc(userId)
        .collection('favoritos')
        .doc(livroId)
        .set(livroData);
  }

  Future<void> removerFavorito(String userId, String livroId) async {
    await _firestore
        .collection('usuarios')
        .doc(userId)
        .collection('favoritos')
        .doc(livroId)
        .delete();
  }

  Future<List<QueryDocumentSnapshot>> getFavoritos(String userId) async {
    final snapshot = await _firestore
        .collection('usuarios')
        .doc(userId)
        .collection('favoritos')
        .get();
    return snapshot.docs;
  }
}
