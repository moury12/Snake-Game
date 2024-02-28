import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snake_game/utils.dart';

import 'widgets/piece_widget.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int upperBoundX = 0;
  int lowerBoundX = 0;
  int upperBoundY = 0;
  int lowerBoundY = 0;
  int step = 20;
  int length =5;
  double screenWidth=0.0;
  double screenHeight=0.0;
  List<Offset> positions =[];
  Direction direction =Direction.right;
  Timer? timer;
  @override
  void initState() {
    restart();
    super.initState();
  }
  void restart(){
    if(timer!=null&& timer!.isActive){
      timer!.cancel();
    }
    timer =Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {

      });
    });
  }
  int getNearestTens(int num){
    int output= (num~/ step)*step;
    if(output==0){
      output += step;
    }
    return output;
  }
  void draw() {
    if(positions.isEmpty){
      positions.add(getRandomPosition());
    }
    while(length>positions.length){
      positions.add(positions[positions.length-1]);
    }
    for(var i =positions.length-1; i>0; i--){
      positions[i]==positions[i-1];
    }
    positions [0] =getNextPosition(positions [0]);
  }
  Offset getNextPosition(Offset position) {
    Offset nextPosition =Offset(position.dx+step, position.dy);
    if(direction==Direction.right){
      nextPosition =Offset(position.dx+step, position.dy);
    }else if(direction==Direction.left){
      nextPosition =Offset(position.dx-step, position.dy);
    }else if(direction==Direction.up){
      nextPosition =Offset(position.dx, position.dy-step);
    }else if(direction==Direction.down){
      nextPosition =Offset(position.dx, position.dy+step);
    }

    return nextPosition;
  }

  Offset getRandomPosition() {
    Offset position;
    int posX=Random().nextInt(upperBoundX)+lowerBoundX;
    int posY =Random().nextInt(upperBoundY)+lowerBoundY;
    position = Offset(getNearestTens(posX).toDouble(),getNearestTens(posY)
        .toDouble() );
    return position;
  }

  List<PieceWidget> getPieces(){
    final pieces =<PieceWidget>[];
    draw();
  for(var i=0; i<length; i++){
    pieces.add(PieceWidget(posX: positions[i].dx.toInt(), posY: positions[i]
        .dy.toInt(),
        size: step,
        color: Colors.green));
  }
    return pieces;
  }
  @override
  Widget build(BuildContext context) {
    screenHeight =MediaQuery.of(context).size.height;
    screenWidth =MediaQuery.of(context).size.width;
    upperBoundX=getNearestTens(screenWidth.toInt()-step);
    upperBoundY=getNearestTens(screenHeight.toInt()-step);
    lowerBoundX=step;
    lowerBoundY=step;
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Stack(
        children: [
          Stack(
            children: getPieces(),
          )
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 200,
        child: Row(
          children: [
            Expanded(child: Row(
              children: [
                FloatingActionButton(
                  onPressed: () {
                    direction =Direction.left;
                  },
                  child: Icon(Icons.arrow_left),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    FloatingActionButton(
                      onPressed: () {
                        direction =Direction.up;
                        setState(() {

                        });
                      },
                      child: Icon(Icons.arrow_drop_up_outlined),
                    ), FloatingActionButton(
                      onPressed: () {
                        direction =Direction.down;
                      },
                      child: Icon(Icons.arrow_drop_down),
                    ),
                  ],
                ),
                FloatingActionButton(
                  onPressed: () {
                    direction =Direction.right;
                  },
                  child: Icon(Icons.arrow_right),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }



}

