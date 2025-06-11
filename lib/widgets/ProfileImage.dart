import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final String? userId;
  final double radius;

  const ProfileImage({Key? key, this.userId, this.radius = 30}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? effectiveUserId = userId ?? FirebaseAuth.instance.currentUser?.uid;

    if (effectiveUserId != null) {
      return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(effectiveUserId).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return CircleAvatar(child: Icon(Icons.error), radius: radius);
          }

          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            Map<String, dynamic>? data = snapshot.data!.data() as Map<String, dynamic>?;
            String? fotoPerfilURL = data?['fotoPerfil'];

            if (fotoPerfilURL != null && fotoPerfilURL.isNotEmpty) {
              return CircleAvatar(
                backgroundImage: NetworkImage(fotoPerfilURL),
                radius: radius,
              );
            } else {
              return CircleAvatar(
                child: Icon(Icons.person),
                radius: radius,
              );
            }
          }

          return CircleAvatar(
            child: CircularProgressIndicator(strokeWidth: 2),
            radius: radius,
          );
        },
      );
    } else {
      return CircleAvatar(child: Icon(Icons.person), radius: radius);
    }
  }
}
