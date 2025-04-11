import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importe o pacote do Firestore
import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final double radius;

  const ProfileImage({Key? key, this.radius = 30}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return CircleAvatar(child: Text("Erro"));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            String? fotoPerfilURL = data['fotoPerfil'];

            if (fotoPerfilURL != null) {
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

          return CircularProgressIndicator();
        },
      );
    } else {
      return CircleAvatar(child: Icon(Icons.person), radius: 30);
    }
  }
}