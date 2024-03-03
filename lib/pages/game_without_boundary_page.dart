import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils.dart';

class GameWithoutBoundaryScreen extends StatefulWidget {
  const GameWithoutBoundaryScreen({super.key});

  @override
  State<GameWithoutBoundaryScreen> createState() =>
      _GameWithoutBoundaryScreenState();
}

class _GameWithoutBoundaryScreenState extends State<GameWithoutBoundaryScreen> {
  int rowSize = 20;
  int totalNumberOfSquare = 500;
  List<int> snakePos = [0, 1, 2,3];
  int foodPos = 55;
  var currentDirection = Direction.right;
  int currentScore = 0;
  int initialTimerDuration = 300; // Initial duration of the timer
  Timer? timer;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     /* appBar: AppBar(
        title: Text('Current score $currentScore\nspeed: $initialTimerDuration'),
        actions: [
          ElevatedButton(onPressed: startGame, child: const Text('Play'))
        ],
      ),*/
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (value) {
          if (value.isKeyPressed(LogicalKeyboardKey.arrowUp) &&
              currentDirection != Direction.down) {
            currentDirection = Direction.up;
          }
          if (value.isKeyPressed(LogicalKeyboardKey.arrowDown) &&
              currentDirection != Direction.up) {
            currentDirection = Direction.down;
          }
          if (value.isKeyPressed(LogicalKeyboardKey.arrowLeft) &&
              currentDirection != Direction.right) {
            currentDirection = Direction.left;
          }
          if (value.isKeyPressed(LogicalKeyboardKey.arrowRight) &&
              currentDirection != Direction.right) {
            currentDirection = Direction.right;
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy > 0 &&
                      currentDirection != Direction.up) {
                    /*print('move down');*/
                    currentDirection = Direction.down;
                  }
                  if (details.delta.dy < 0 &&
                      currentDirection != Direction.down) {
                    /*print('move top');*/
                    currentDirection = Direction.up;
                  }
                },
                onHorizontalDragUpdate: (details) {
                  if (details.delta.dx > 0 &&
                      currentDirection != Direction.left) {
                    /*print('move right');*/
                    currentDirection = Direction.right;
                  }
                  if (details.delta.dx < 0 &&
                      currentDirection != Direction.right) {
                    /*print('move left');*/
                    currentDirection = Direction.left;
                  }
                },
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: totalNumberOfSquare,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: rowSize,
                  ),
                  itemBuilder: (context, index) {
                    if (snakePos.contains(index)) {
                      return Container(
                        /*child: Text(snakePos[index].toString()),*/
                        margin: const EdgeInsets.all(2),
                        color: Colors.green,
                      );
                    } else if (foodPos == index) {
                      return Container(
                        margin: const EdgeInsets.all(2),
                        color: Colors.red,
                      );
                    } else {
                      return Container(
                        margin: const EdgeInsets.all(2),
                        color: Colors.yellow,
                        child: Text(
                          index.toString(),
                          style: const TextStyle(fontSize: 5),
                        ),
                      );
                    }
                  },
                ),
              )),
              /*  Expanded(
                  child: Container(
                color: Colors.blue,
              )),*/
            ],
          ),
        ),
      ),
    );
  }

  void startGame() {
    Timer.periodic( Duration(milliseconds: initialTimerDuration), (timer) {
      setState(() {
        moveSnake();
        if (gameOver()) {
          timer.cancel();
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => AlertDialog(
              content: Text('Game over\nCurrent score $currentScore'),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      restartGame();
                    },
                    child: const Text('play Again'))
              ],
            ),
          );
        }
      });
    });
  }

  void moveSnake() {
    switch (currentDirection) {
      case Direction.right:
        {
          if (snakePos.last % rowSize == rowSize - 1) {
            snakePos.add(snakePos.last + 1 - rowSize);
          } else {
            // add a new head
            snakePos.add(snakePos.last + 1);
          }
          // remove a tail
        }
        break;
      case Direction.left:
        {
          if (snakePos.last % rowSize == 0) {
            snakePos.add(snakePos.last - 1 + rowSize);
          } else {
            // add a new head
            snakePos.add(snakePos.last - 1);
          }
          // remove a tail
        }
        break;
      case Direction.up:
        {
          if (snakePos.last < rowSize) {
            snakePos.add(snakePos.last - rowSize + totalNumberOfSquare);
          } else {
            // add a new head
            snakePos.add(snakePos.last - rowSize);
          }
          // remove a tail
        }
        break;
      case Direction.down:
        {
          if (snakePos.last + rowSize > totalNumberOfSquare) {
            snakePos.add(snakePos.last + rowSize - totalNumberOfSquare);
          } else {
            // add a new head
            snakePos.add(snakePos.last + rowSize);
          }
          // remove a tail
        }
        break;
    }
/*
    print(snakePos.last.toString());
*/
    if (snakePos.last == foodPos) {
      eatFood();
    } else {
      snakePos.removeAt(0);
    }
  }

  void eatFood() {
    while (snakePos.contains(foodPos)) {
      currentScore++;
      int newDuration = (initialTimerDuration * .2).toInt(); // Decrease
      // duration by 10%

      // Cancel the current timer
      timer?.cancel();

      // Start a new timer with the updated duration
      timer = Timer.periodic(Duration(milliseconds: newDuration), (timer) {
        setState(() {
          moveSnake();
          if (gameOver()) {
            timer.cancel();
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => AlertDialog(
                content: Text('Game over\nCurrent score $currentScore'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      restartGame();
                    },
                    child: Text('Play Again'),
                  ),
                ],
              ),
            );
          }
        });
      });

      foodPos = Random().nextInt(totalNumberOfSquare);

    }
  }

  bool gameOver() {
    List<int> snakeBody = snakePos.sublist(0, snakePos.length - 1);
    if (snakeBody.contains(snakePos.last)) {
      return true;
    } else {
      return false;
    }
  }

  void restartGame() {
    setState(() {
      currentScore = 0;
      snakePos = [0, 1, 2,3];
      foodPos = Random().nextInt(totalNumberOfSquare);
      currentDirection = Direction.right;
    });
    startGame();
  }
}
