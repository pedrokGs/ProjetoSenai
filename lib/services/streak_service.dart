import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StreakService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> atualizarStreak() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userDocRef = _firestore.collection('users').doc(user.uid);
    final userDoc = await userDocRef.get();
    final now = DateTime.now();

    if (!userDoc.exists) {
      // Usuário novo: inicializa streak
      await userDocRef.set({
        'streak': 1,
        'lastAccess': Timestamp.fromDate(now),
      }, SetOptions(merge: true));
      return;
    }

    final data = userDoc.data()!;
    final lastAccessTimestamp = data['lastAccess'] as Timestamp?;
    final lastAccess = lastAccessTimestamp?.toDate();

    if (lastAccess == null) {
      await userDocRef.update({
        'streak': 1,
        'lastAccess': Timestamp.fromDate(now),
      });
      return;
    }

    final differenceInDays = now.difference(
      DateTime(lastAccess.year, lastAccess.month, lastAccess.day),
    ).inDays;

    if (differenceInDays == 0) {
      return;
    } else if (differenceInDays == 1) {
      int currentStreak = data['streak'] ?? 0;
      await userDocRef.update({
        'streak': currentStreak + 1,
        'lastAccess': Timestamp.fromDate(now),
      });
    } else {
      await userDocRef.update({
        'streak': 1,
        'lastAccess': Timestamp.fromDate(now),
      });
    }
  }

  Future<int> getStreak() async {
    final user = _auth.currentUser;
    if (user == null) return 0;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return 0;

    return (doc.data()?['streak'] ?? 0) as int;
  }

  Future<DateTime?> getLastAccessDate() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;

    final timestamp = doc.data()?['lastAccess'] as Timestamp?;
    return timestamp?.toDate();
  }
}
