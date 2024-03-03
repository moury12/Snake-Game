import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:snake_game/constant/assets_constant.dart';
import 'package:snake_game/pages/home_page.dart';

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
  List<int> snakePos = [0, 1, 2, 3];
  int foodPos = 55;
  var currentDirection = Direction.right;
  int currentScore = 0;
  int initialTimerDuration = 300; // Initial duration of the timer
  Timer? timer;
  List<String> foods = [
    'assets/food1.png',
    'assets/food2.png',
    'assets/food3.png',
    'assets/food4.png',
  ];
  String getRandomFood() {
    // Get a random index within the range of the food list
    int randomIndex = Random().nextInt(foods.length);

    // Get the random food image path
    String randomFood = foods[randomIndex];

    return randomFood;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd1ffa6),
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
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 2,
                    child: Stack(
                      children: [
                        Transform.rotate(
                            angle: pi,
                            child: Image.asset(
                              AssetsConstant.rockImg,
                              fit: BoxFit.fill,
                            )),
                        Transform.rotate(
                            angle: pi,
                            child: Image.asset(
                              AssetsConstant.grassImg3,
                              fit: BoxFit.fill,
                            )),
                        Positioned(
                          bottom: 16,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GrassButtonWidget(widget: Text(currentScore
                                    .toString(),style: TextStyle(fontSize:
                                20,fontWeight: FontWeight.bold,color: Colors.white),),
                                    img: AssetsConstant.woodBackground),
                                GrassButtonWidget(img: AssetsConstant
                                    .homeButton,function: () {
                                  gameOver();
                                  Navigator.of(context).pop();
                                    },),
                                GrassButtonWidget(
                                  function: () {
                                    startGame();
                                  },
                                    img: AssetsConstant.playGameButton)
                              ],
                            ),
                          ),
                        )
                      ],
                    )),
                Expanded(
                    flex: 4,
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
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        itemCount: totalNumberOfSquare,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: rowSize,
                        ),
                        itemBuilder: (context, index) {
                          int row = index ~/ rowSize;
                          int col = index % rowSize;
                          if (snakePos.contains(index)) {
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  /*child: Text(snakePos[index].toString()),*/
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.horizontal(
                                        right: Radius.circular(
                                          (index == snakePos.last )
                                              ? 30
                                              : 0,
                                        ),
                                        left: Radius.circular(
                                          (index == snakePos.first )
                                              ? 60
                                              : 0,
                                        ),)),
                                ),
                                index == snakePos.last
                                    ? Positioned(

                                  top:currentDirection==Direction
                                      .up?0: null,
                                  bottom:currentDirection==Direction
                                      .down?0: null,
left: 0,
                                        right: 0,

                                        child: Transform.rotate(
                                          angle: currentDirection==Direction
                                              .down||currentDirection==Direction
                                              .up?0: pi/2,
                                          child: const Row(
                                            children: [
                                              Icon(
                                                Icons.circle,
                                                size: 3,
                                              ),
                                              const SizedBox(
                                                width: 3,
                                              ),
                                              Icon(
                                                Icons.circle,
                                                size: 3,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                                index == snakePos.last
                                    ? Positioned(
                                        left:currentDirection==Direction
                                            .down||currentDirection==Direction
                                            .up?0: -6,
                                        top:currentDirection==Direction
                                            .down?-6: 0,
                                        bottom:currentDirection==Direction
                                            .up?-6: 0,
                                        right:currentDirection==Direction
                                            .down||currentDirection==Direction
                                            .up?0:null,
                                        child: Transform.rotate(
                                          angle:currentDirection==Direction
                                              .down||currentDirection==Direction
                                              .up?0: pi/2,
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                AssetsConstant.eyeImg,
                                                height: 10,
                                              ),
                                              Image.asset(
                                                AssetsConstant.eyeImg,
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            );
                          } else if (foodPos == index) {
                            return Image.asset(getRandomFood());
                          } else {
                            return Container(
                              color: (row + col) % 2 == 0
                                  ? const Color(0xffb9ff7e)
                                  : const Color(0xffd1ffa6),
                            );
                          }
                        },
                      ),
                    )),
                Expanded(
                    child: Image.asset(
                  AssetsConstant.grassImg3,
                  fit: BoxFit.fill,
                )),
              ],
            ),
            Image.asset(AssetsConstant.grassImg4),
            Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Transform.rotate(
                    angle: pi, child: Image.asset(AssetsConstant.grassImg4))),
          ],
        ),
      ),
    );
  }

  void startGame() {
    Timer.periodic(Duration(milliseconds: initialTimerDuration), (timer) {
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
      int newDuration = (initialTimerDuration -22).toInt(); // Decrease
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
                    child: const Text('Play Again'),
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
  double _getCurveRotation(Direction direction) {
    switch (direction) {
      case Direction.up:
        return pi;
      case Direction.down:
        return 0;
      case Direction.left:
        return -pi / 2;
      case Direction.right:
        return pi / 2;
    }
  }

  void restartGame() {
    setState(() {
      currentScore = 0;
      snakePos = [0, 1, 2, 3];
      foodPos = Random().nextInt(totalNumberOfSquare);
      currentDirection = Direction.right;
    });
    startGame();
  }
}
