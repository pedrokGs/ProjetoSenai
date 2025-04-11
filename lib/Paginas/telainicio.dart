import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
/*
final List<Image> imgList = [
  Image.asset('assets/img/carousel1.jpg', width: double.infinity, height: double.infinity,),
  Image.asset('assets/img/carousel2.jpg'),
];
*/

final List<String> imgList = [
  'assets/img/carousel1.jpg',
  'assets/img/carousel2.jpg',
  'assets/img/carousel3.jpg',
  'assets/img/carousel4.jpg'
];

class telaInicio extends StatefulWidget {
  const telaInicio({super.key});

  @override
  State<telaInicio> createState() => _telaInicioState();
}

class _telaInicioState extends State<telaInicio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: MediaQuery.sizeOf(context).height,
                  autoPlay: true,
                  viewportFraction: 1,
                  aspectRatio: 2,
                ),

                items: imgList
                    .map((item) => Container(
                  child: Center(
                      child: Image.asset(
                        item,
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height,
                      )),
                ))
                    .toList(),
                /*
                {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 0),
                          decoration: BoxDecoration(
                              color: Colors.amber
                          ),
                          child: Image.asset("assets/img/carousel1.jpg"));
                    },
                  );
                }).toList(),
                */
              ),

              Container(
                alignment: Alignment.bottomCenter,
                color: Theme.of(context).colorScheme.primary,
                height: 300,
                width: double.infinity,
                padding: EdgeInsets.all(10),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 300,
                      height: 70,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          padding: EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 20,
                          ),
                          textStyle: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Background white text
                            Text(
                              "CADASTRAR",
                              style: TextStyle(
                                fontSize: 38,
                                color: Colors.white,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(2.5, 1.5),
                                    blurRadius: 1.0,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  Shadow(
                                    offset: Offset(2.5, 1.5),
                                    blurRadius: 1.0,
                                    color: Color.fromARGB(125, 0, 0, 255),
                                  ),
                                ],
                                fontFamily: 'Harmoni',
                              ),
                            ),
                            /*                        // Foreground styled text
                            Text(
                              "CADASTRAR",
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 0.001
                                  ..color = Colors.black, // Black stroke for foreground
                                fontFamily: 'Harmoni',
                              ),
                            ),
                            */
                          ],
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/loginCadastro', arguments: {'tipo': 'cadastro'});
                        },
                      ),
                    ),

                    SizedBox(height: 20),

                    SizedBox(
                      width: 300,
                      height: 70,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          padding: EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 20,
                          ),
                          textStyle: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Text(
                          "ENTRAR",
                          style: TextStyle(
                            fontSize: 38,
                            color: Colors.white,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(2.5, 1.5),
                                blurRadius: 1.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                              Shadow(
                                offset: Offset(2.5, 1.5),
                                blurRadius: 1.0,
                                color: Color.fromARGB(125, 0, 0, 255),
                              ),
                            ],
                            fontFamily: 'Harmoni',
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/loginCadastro', arguments: {'tipo': 'login'});
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
