import 'package:flutter/material.dart';

class PieceWidget extends StatelessWidget {
  final int posX, posY, size;
  final Color color;
  const PieceWidget({super.key, required this.posX, required this.posY,
    required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: posY.toDouble(),
        left: posX.toDouble(),
        child: Opacity(
      opacity: 1,
          child: Container(
            width: size.toDouble(),
            height: size.toDouble(),
            decoration: BoxDecoration(color: color,borderRadius: BorderRadius.circular(12)
            ),
          ),
    ));
  }
}
