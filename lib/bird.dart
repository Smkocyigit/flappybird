import 'package:flutter/material.dart';

class MyBird extends StatelessWidget {
  final birdY;
  final double birdWidth;
  final double birdHeight;

  MyBird({this.birdY, required this.birdWidth, required this.birdHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, (2 * birdY + birdHeight) / (2 - birdHeight)),
      child: Image.asset(
        'lib/images/flapiy.png',
        width: MediaQuery.of(context).size.height * birdWidth * 0.7,
        height: MediaQuery.of(context).size.height * birdHeight * 0.7,
        fit: BoxFit.fill,
      ),
    );
  }
}