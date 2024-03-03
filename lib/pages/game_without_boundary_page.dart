import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snake_game/constant/assets_constant.dart';

import '../utils.dart';
import 'widgets/grass_button_widget.dart';

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
  bool isGamePaused = false;

  List<String> foods = [
    'assets/food1.png',
    'assets/food2.png',
    'assets/food3.png',
    'assets/grape.png',
    'assets/food4.png',
  ];
  @override
  void initState() {
    startGame();
    super.initState();
  }

  String getRandomFood() {
    // Get a random index within the range of the food list
    int randomIndex = Random().nextInt(foods.length);

    // Get the random food image path
    String randomFood = foods[randomIndex];

    return randomFood;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        } else {
          showDialog(
            barrierDismissible: false,
            builder: (context) => gameOverDialog(context, 'Confirm Exit',
                AssetsConstant.yesButton, AssetsConstant.noButton, () {
              Navigator.pop(context);
              Navigator.of(context).pop();
              timer?.cancel();
            }, () {
              Navigator.pop(context);
            }),
            context: context,
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xffd1ffa6),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GrassButtonWidget(
                                      widget: Text(
                                        currentScore.toString(),
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      img: AssetsConstant.woodBackground),
                                  GrassButtonWidget(
                                    img: AssetsConstant.homeButton,
                                    function: () {
                                      gameOver();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  GrassButtonWidget(
                                      function: () {
                                        togglePause();
                                      },
                                      img: isGamePaused
                                          ? AssetsConstant.playGameButton
                                          : AssetsConstant.pauseButton)
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
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: totalNumberOfSquare,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
                                        borderRadius: currentDirection ==
                                                    Direction.down ||
                                                currentDirection == Direction.up
                                            ? BorderRadius.vertical(
                                                bottom: Radius.circular(
                                                  (index == snakePos.last &&
                                                          currentDirection ==
                                                              Direction.down)
                                                      ? 30
                                                      : 0,
                                                ),
                                                top: Radius.circular(
                                                  (index == snakePos.last &&
                                                          currentDirection ==
                                                              Direction.up)
                                                      ? 30
                                                      : 0,
                                                ),
                                              )
                                            : BorderRadius.horizontal(
                                                right: Radius.circular(
                                                  (index == snakePos.last &&
                                                          currentDirection ==
                                                              Direction.right)
                                                      ? 30
                                                      : 0,
                                                ),
                                                left: Radius.circular(
                                                  (index == snakePos.last &&
                                                          currentDirection ==
                                                              Direction.left)
                                                      ? 60
                                                      : 0,
                                                ),
                                              )),
                                  ),
                                  index == snakePos.last
                                      ? Positioned(
                                          top:
                                              currentDirection == Direction.down
                                                  ? null
                                                  : 0,
                                          bottom:
                                              currentDirection == Direction.up
                                                  ? null
                                                  : 0,
                                          left: currentDirection ==
                                                  Direction.right
                                              ? null
                                              : 0,
                                          right:
                                              currentDirection == Direction.left
                                                  ? null
                                                  : 0,
                                          child: Transform.rotate(
                                            angle: currentDirection ==
                                                        Direction.down ||
                                                    currentDirection ==
                                                        Direction.up
                                                ? 0
                                                : pi / 2,
                                            child: const Padding(
                                              padding: EdgeInsets.all(2),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.circle,
                                                    size: 3,
                                                  ),
                                                  SizedBox(
                                                    width: 3,
                                                  ),
                                                  Icon(
                                                    Icons.circle,
                                                    size: 3,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                  index == snakePos.last
                                      ? Positioned(
                                          left: currentDirection ==
                                                  Direction.right
                                              ? -6
                                              : currentDirection ==
                                                      Direction.left
                                                  ? null
                                                  : 0,
                                          top:
                                              currentDirection == Direction.down
                                                  ? -6
                                                  : 0,
                                          bottom:
                                              currentDirection == Direction.up
                                                  ? -6
                                                  : 0,
                                          right: currentDirection ==
                                                      Direction.down ||
                                                  currentDirection ==
                                                      Direction.up
                                              ? 0
                                              : currentDirection ==
                                                      Direction.left
                                                  ? -6
                                                  : null,
                                          child: Transform.rotate(
                                            angle: currentDirection ==
                                                        Direction.down ||
                                                    currentDirection ==
                                                        Direction.up
                                                ? 0
                                                : pi / 2,
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
                                /*  index == snakePos.last?Image.asset
                                    (AssetsConstant.dizzyIcon,height: 100,)
                                      :SizedBox
                                      .shrink()*/
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
      ),
    );
  }

  void togglePause() {
    setState(() {
      isGamePaused = !isGamePaused;
    });
    if (isGamePaused) {
      timer?.cancel(); // Pause the timer
    } else {
      startGame(); // Resume the game
    }
  }

  void startGame() {
    timer?.cancel();
    if (!isGamePaused) {
      timer =
          Timer.periodic(Duration(milliseconds: initialTimerDuration), (timer) {
        setState(() {
          timer = timer;
          moveSnake();
          if (gameOver()) {
            timer.cancel();
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => gameOverDialog(context));
          }
        });
      });
    } else {
      timer?.cancel(); // Cancel the timer if the game is paused
    }
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
      int newDuration = (initialTimerDuration - 100).toInt(); // Decrease
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
              builder: (context) => gameOverDialog(context),
            );
          }
        });
      });

      foodPos = Random().nextInt(totalNumberOfSquare);
    }
  }

  gameOverDialog(
    BuildContext context, [
    String? text,
    String? img1,
    String? img2,
    Function()? function1,
    Function()? function2,
  ]) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 20,
        content: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Image.asset(AssetsConstant.woodBackground),
            Positioned(
                left: 0,
                top: 0,
                child: Transform.rotate(
                    angle: pi,
                    child: Image.asset(
                      AssetsConstant.grassImg2,
                      height: 50,
                    ))),
            Positioned(
              right: 0,
              top: 0,
              child: Transform.rotate(
                  angle: pi,
                  child: Image.asset(
                    AssetsConstant.grassImg2,
                    height: 50,
                  )),
            ),
            Text(text ?? 'Game Over!',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Color(0xff3c220c))),
            Positioned(
              bottom: -30,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: Image.asset(
                      img1 ?? AssetsConstant.homeButton,
                      height: 70,
                    ),
                    onTap: function1 ??
                        () {
                          Navigator.pop(context);
                          Navigator.of(context).pop();
                        },
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  GestureDetector(
                      onTap: function2 ??
                          () {
                            Navigator.pop(context);
                            restartGame();
                          },
                      child: Image.asset(img2 ?? AssetsConstant.restoreButton,
                          height: 70)),
                ],
              ),
            ),
            Positioned(
                top: -50,
                left: 0,
                right: 0,
                child: Container(
                  height: 120,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(AssetsConstant.ribbon))),
                  child: Text(
                    currentScore.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                ))
          ],
        ),
      ),
    );
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
      snakePos = [0, 1, 2, 3];
      foodPos = Random().nextInt(totalNumberOfSquare);
      currentDirection = Direction.right;
    });
    startGame();
  }
}
