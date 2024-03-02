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
  int length = 5;
  bool gameOver = false;
  double screenWidth = 0.0;
  double screenHeight = 0.0;
  List<Offset> positions = [];
  Direction direction = Direction.right;
  Timer? timer;
  Offset foodPosition = Offset.zero;
  PieceWidget? food;
  int score = 0;
  double speed =1.2;
  @override
  void initState() {
    restart();
    super.initState();
  }

  void restart() {
    length = 6;
    score = 0;
    speed = 1.2;
    positions = [];
    direction = getRandomDirection();
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
    timer = Timer.periodic(Duration(milliseconds: (200 ~/ speed).toInt()),
            (timer) {
      setState(() {});
    });
  }

  bool detectionCollision(Offset position) {
    if (position.dx >= upperBoundX && direction == Direction.right) {
      return true;
    }
    if (position.dx <= lowerBoundX && direction == Direction.left) {
      return true;
    }
    if (position.dy >= upperBoundY && direction == Direction.down) {
      return true;
    }
    if (position.dy <= lowerBoundY && direction == Direction.up) {
      return true;
    }
    return false;
  }

  bool detectSelfCollision() {
    Offset head = positions[0];
    for (int i = 1; i < positions.length - 1; i++) { // Exclude the last body segment
      if (positions[i] == head) { // Check if the head overlaps with any body segment
        return true; // Collision detected
      }
    }
    return false; // No collision detected
  }

  void drawFood() {
    if (food == null) {
      foodPosition = getRandomPosition();
      // Check if the food position coincides with the snake's head position
      if (foodPosition == positions[0]) {
        // Increment length, score, and speed
        length++;
        score += 5;
        speed += 0.2;
        // Update the food position to a new random position
        foodPosition = getRandomPosition();
      }
      // Initialize the food widget
      food = PieceWidget(
        posX: foodPosition.dx.toInt(),
        posY: foodPosition.dy.toInt(),
        size: step,
        color: Colors.red,
      );
    } else {
      // Check if the food position coincides with the snake's head position
      if (foodPosition == positions[0]) {
        // Increment length, score, and speed
        length++;
        score += 5;
        speed += 0.2;
        // Update the food position to a new random position
        foodPosition = getRandomPosition();
      }
      // Update the position of the existing food widget
      food = PieceWidget(
        posX: foodPosition.dx.toInt(),
        posY: foodPosition.dy.toInt(),
        size: step,
        color: Colors.red,
      );
    }
  }
  Direction getRandomDirection() {
    int val = Random().nextInt(4);
    direction = Direction.values[val];
    return direction;
  }

  int getNearestTens(int num) {
    int output = (num ~/ step) * step;
    if (output == 0) {
      output += step;
    }
    return output;
  }

  void draw() async {
    if (positions.isEmpty) {
      positions.add(getRandomPosition());
    }
    while (length > positions.length) {
      positions.add(positions[positions.length - 1]);
    }
    for (var i = positions.length - 1; i > 0; i--) {
      positions[i] = positions[i - 1];
    }
    positions[0] = await getNextPosition(positions[0]);
    if (detectSelfCollision() && !gameOver) {
      if (timer != null && timer!.isActive) {
        timer!.cancel();
      }
      gameOver = true; // Set the flag to true to prevent showing the dialog multiple times
      await Future.delayed(const Duration(milliseconds: 200), () => showGameOverDialog(),);
      return;
    }
    /*if (positions[0] == foodPosition) {
      // Increment length, score, and speed
      length++;
      score += 5;
      speed += 0.2;
      // Update the food position to a new random position
      foodPosition = getRandomPosition();
    }*/
  }

  Future<Offset> getNextPosition(Offset position) async {
    Offset nextPosition = Offset(position.dx + step, position.dy);
    if (direction == Direction.right) {
      nextPosition = Offset(position.dx + step, position.dy);
    } else if (direction == Direction.left) {
      nextPosition = Offset(position.dx - step, position.dy);
    } else if (direction == Direction.up) {
      nextPosition = Offset(position.dx, position.dy - step);
    } else if (direction == Direction.down) {
      nextPosition = Offset(position.dx, position.dy + step);
    }
    if (detectionCollision(position) == true) {
      if (timer != null && timer!.isActive) {
        timer!.cancel();
      }
      await Future.delayed(
        Duration(milliseconds: 200),
        () => showGameOverDialog(),
      );
      return position;
    }
    if (detectSelfCollision() && !gameOver) {
      if (timer != null && timer!.isActive) {
        timer!.cancel();
      }
      gameOver = true; // Set the flag to true to prevent showing the dialog multiple times
      await Future.delayed(const Duration(milliseconds: 200), () => showGameOverDialog(),);

    }
    return nextPosition;
  }

  Offset getRandomPosition() {
    Offset position;
    // Calculate the maximum X and Y values within the screen bounds
    int maxX = (upperBoundX - step).toInt(); // Subtract step to ensure the position doesn't exceed the screen bounds
    int maxY = (upperBoundY - step).toInt(); // Subtract step to ensure the position doesn't exceed the screen bounds
    int posX = Random().nextInt(maxX) + lowerBoundX;
    int posY = Random().nextInt(maxY) + lowerBoundY;
    position = Offset(
        getNearestTens(posX).toDouble(),
        getNearestTens(posY).toDouble()
    );
    return position;
  }


  List<PieceWidget> getPieces() {
    final pieces = <PieceWidget>[];
    draw();
    drawFood();
    for (var i = 0; i < length; i++) {
      if (i >= positions.length) {
        continue;
      }
      pieces.add(PieceWidget(
          posX: positions[i].dx.toInt(),
          posY: positions[i].dy.toInt(),
          size: step,
          color: Colors.green));
    }
    return pieces;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    upperBoundX = getNearestTens(screenWidth.toInt() - step);
    upperBoundY = getNearestTens(screenHeight.toInt() - step - 150);
    lowerBoundX = 0;
    lowerBoundY = step + MediaQuery.of(context).padding.bottom.toInt();
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Stack(
        children: [
          Stack(
            children: getPieces(),
          ),
          food ?? const SizedBox.shrink()
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 150,
        child: Row(
          children: [
            Expanded(
                child: Row(
              children: [
                FloatingActionButton(
                  onPressed: () {
                    direction = Direction.left;
                  },
                  child: const Icon(Icons.arrow_left),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        direction = Direction.up;
                      },
                      child: const Icon(Icons.arrow_drop_up_outlined),
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        direction = Direction.down;
                      },
                      child: const Icon(Icons.arrow_drop_down),
                    ),
                  ],
                ),
                FloatingActionButton(
                  onPressed: () {
                    direction = Direction.right;
                  },
                  child: const Icon(Icons.arrow_right),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(actions: [
        Text('Game is over'),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              restart();
            },
            child: Text('restart'))
      ]),
    );
  }


}
