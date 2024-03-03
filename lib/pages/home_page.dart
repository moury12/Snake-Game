import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:snake_game/constant/assets_constant.dart';
import 'package:snake_game/pages/game_without_boundary_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            AssetsConstant.backgroundImg,
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
          ),


          Positioned(
              top: MediaQuery.of(context).size.height / 1.6,
              child: Image.asset(
                AssetsConstant.snakeImg,
                height: 200,
              )),
          Column(
            children: [
              Padding(
                padding:  EdgeInsets.symmetric(vertical:MediaQuery.of
                  (context).viewPadding.top+12,horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(AssetsConstant.highScoreIcon,height: 50,),
                    Image.asset(AssetsConstant.soundButton,height: 50,),
                  ],
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => GameWithoutBoundaryScreen(),));
                },
                child: Image.asset(
                  AssetsConstant.playButton,
                  height: 100,
                ),
              ),
              Padding(

                padding:  EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GrassButtonWidget(img: AssetsConstant.menuButton,),
                    GrassButtonWidget(img: AssetsConstant.profileButton,),
                    GrassButtonWidget(img: AssetsConstant.questionButton,),
                  ],
                ),
              )
            ],
          )

        ],
      ),
    );
  }
}

class GrassButtonWidget extends StatelessWidget {
  final String img;
  const GrassButtonWidget({
    super.key, required this.img,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          AssetsConstant.grassImg,
          height: 80,
        ),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
             img ,
              height: 50,
            )),
      ],
    );
  }
}
