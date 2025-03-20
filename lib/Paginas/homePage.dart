import 'package:biblioteca/FirestoreService.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "VORTEXUS",
          style: TextStyle(
            fontSize: 30,
            fontFamily: 'Harmoni',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF834d40),
      ),

      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(" Leituras Iniciadas", style: TextStyle(fontSize: 28, fontFamily: 'Harmoni'),),
                  StreamBuilder<QuerySnapshot>(
                    stream: _firestoreService.firestore.collection('livros').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }
                      final livros = snapshot.data!.docs;
                      return CarouselSlider(
                        options: CarouselOptions(height: 200.0),
                        items: livros.map((livro) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                padding: EdgeInsets.all(50),
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(color: Color(0xFFedc9af)),
                                child: Column(
                                  children: [
                                    CachedNetworkImage(
                                        imageUrl: livro['imagem'],
                                      placeholder: (context, url) => CircularProgressIndicator(),
                                      errorWidget: (context,url,error) => Icon(Icons.error),
                                    ),
                                    Text(livro['titulo']),
                                    Text(livro['autor']),
                                  ],
                                ),
                              );
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(),
            Container(),
          ],
        ),
      ),
    );
  }
}
