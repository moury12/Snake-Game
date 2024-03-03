import 'package:flutter/material.dart';
import 'package:snake_game/constant/assets_constant.dart';

class GrassButtonWidget extends StatelessWidget {
  final String img;
  final Widget? widget;
  final Function()? function;
  const GrassButtonWidget({
    super.key, required this.img, this.function, this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:function?? () {

      },
      child: Stack(
        children: [
          Image.asset(
            AssetsConstant.grassImg,
            height: 80,
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child:Container(height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(image: DecorationImage(image:
                AssetImage(img))),child: widget??SizedBox.shrink(),)),
        ],
      ),
    );
  }
}
