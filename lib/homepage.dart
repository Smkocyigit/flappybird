import 'dart:async';
import 'package:flappybird/barrier.dart';
import 'package:flappybird/bird.dart';
import 'package:flutter/material.dart';
import 'barrier.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 static  double birdY = 0;
  double initialPos = birdY;
  double height = 0;
  double time = 0;
  double gravity = -4.9;
  double velocity = 3.5;
  double birdWidth = 0.1;
  double birdHeight = 0.1;

  bool gameHasStarted = false;
 int score = 0; // Score değişkenini ekledik
 int bestScore = 0; // En yüksek skorunuzu temsil eden bir değişken
 static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.5;
  List<List<double>> barrierHeight = [

    [0.6, 0.4],
    [0.4, 0.6],
  ];

  void startGame() {
    gameHasStarted = true;
  Timer.periodic(Duration (milliseconds:10),(timer) {


    height = gravity * time * time + velocity * time;

    setState(() {
      birdY = initialPos - height;
    });

    if (birdIsDead()){
      timer.cancel();
      gameHasStarted = false;
      _showDialog();
    }

    moveMap();

    time += 0.01;
  });
  }

  void resetGame(){
    Navigator.pop(context);
    setState(() {
      birdY = 0;
      gameHasStarted = false;
      time = 0;
      initialPos = birdY;
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // İnce çerçeve için border radius ayarlayın
          ),
          backgroundColor: Colors.brown.shade600,
          title: Center(
            child: Text(
              "G A M E   O V E R",
              style: TextStyle(color: Colors.white),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: resetGame,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white, // İnce çerçeve rengini ayarlayın
                    width: 2.0, // İnce çerçeve kalınlığını ayarlayın
                  ),
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.brown.shade900, // Burada istediğiniz rengi ayarlayabilirsiniz
                ),
                padding: EdgeInsets.all(11),
                child: Text(
                  'PLAY AGAIN',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
        });
       }



  void moveMap() {
    for(int i = 0; i < barrierX.length; i++){

      setState(() {
        barrierX[i] -= 0.005;
      });

      if (barrierX[i] < -1.5) {
        barrierX[i] += 3;
      }
    }
  }
  void jump(){
    setState(() {
      time = 0;
      initialPos = birdY;
    });
  }

  bool birdIsDead(){

    if (birdY < -1 || birdY > 1){
      return true;
    }

    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
          barrierX[i] + barrierWidth >= -birdWidth &&
          (birdY <= -1 + barrierHeight[i] [0] ||
              birdY + birdHeight >= 1 - barrierHeight[i] [1])) {
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameHasStarted ? jump : startGame ,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
              color:Colors.blue,
              child:Center(
               child: Stack(
                 children: [
                   MyBird(
                     birdY: birdY,
                     birdWidth: birdWidth,
                     birdHeight: birdHeight,
                  ),




                 MyBarrier(
                   barrierX: barrierX[0],
                   barrierWidth: barrierWidth,
                   barrierHeight: barrierHeight [0] [0],
                   isThisBottomBarrier: false,
                 ),

                 MyBarrier(
                   barrierX: barrierX[0],
                   barrierWidth: barrierWidth,
                   barrierHeight: barrierHeight[0] [0],
                   isThisBottomBarrier: false,
                 ),
                 MyBarrier(
                   barrierX: barrierX[0],
                   barrierWidth: barrierWidth,
                   barrierHeight: barrierHeight[0] [1],
                   isThisBottomBarrier: true,
                 ),
                   MyBarrier(
                     barrierX: barrierX[1],
                     barrierWidth: barrierWidth,
                     barrierHeight: barrierHeight[1] [0],
                     isThisBottomBarrier: false,
                   ),

                   MyBarrier(
                     barrierX: barrierX[1],
                     barrierWidth: barrierWidth,
                     barrierHeight: barrierHeight[1] [1],
                     isThisBottomBarrier: true,
                   ),

                 Container(
                   alignment: Alignment(0, -0.5),
                   child: Text(
                     gameHasStarted ? '' : 'T A P    T O   P L A Y' ,
                     style: GoogleFonts.pacifico( // Pacifico yazı tipini kullanın
                       textStyle: TextStyle(
                         color: Colors.white,
                         fontSize: 20,
                         fontStyle: FontStyle.italic, // Sadece italik yazı stili ekleyin
                         fontWeight: FontWeight.w500, // Yazıyı inceltmek için FontWeight'i ayarlayın
                       ),
                       ),
                     ),
                   ),
                 ],
               ),
              ),
              ),
            ),
            Container(
              height: 15,
              color: Colors.green,
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 80.0),
                            child: Text(
                              "SCORE: " + score.toString(),
                              style: GoogleFonts.pacifico( // Google Fonts ile yazı tipini belirtin (örneğin "lato" yazı tipi)
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Text(
                            "BEST: 1 " + bestScore.toString(),
                            style: GoogleFonts.pacifico( // Google Fonts ile yazı tipini belirtin (örneğin "lato" yazı tipi)
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 80.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
                  ],
                ),
              ),
            );
          }
       }