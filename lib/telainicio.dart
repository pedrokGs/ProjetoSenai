import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CarouselSlider(
            options: CarouselOptions(height: 400.0),
            items: [1,2,3,4,5].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                          color: Colors.amber
                      ),
                      child: Text('text $i', style: TextStyle(fontSize: 16.0),)
                  );
                },
              );
            }).toList(),
          ),

          Container(
            color: Theme.of(context).colorScheme.primary,
            height: 300,
            width: 500,
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
                      backgroundColor: Color(0xFFedc9af),
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
                            fontSize: 50,
                            color: Colors.white,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(2.5 , 1.5),
                                blurRadius: 1.0,
                                color: Color.fromARGB(255, 0, 0, 0)
                              ),
                              Shadow(
                                offset: Offset(2.5, 1.5),
                                blurRadius: 1.0,
                                color: Color.fromARGB(125, 0, 0, 255),
                              )
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
                    onPressed: () {},
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
                      backgroundColor: Color(0xFFedc9af),
                      padding: EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 20,
                      ),
                      textStyle: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text(
                      "ENTRAR",
                      style: TextStyle(
                        fontSize: 50,
                        color: Colors.white,
                        shadows: <Shadow>[
                          Shadow(
                              offset: Offset(2.5 , 1.5),
                              blurRadius: 1.0,
                              color: Color.fromARGB(255, 0, 0, 0)
                          ),
                          Shadow(
                            offset: Offset(2.5, 1.5),
                            blurRadius: 1.0,
                            color: Color.fromARGB(125, 0, 0, 255),
                          )
                        ],
                        fontFamily: 'Harmoni',
                      ),
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
