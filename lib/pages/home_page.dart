import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snake_game/constant/assets_constant.dart';
import 'package:snake_game/pages/game_without_boundary_page.dart';
import 'package:snake_game/pages/widgets/grass_button_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.transparent,
                content: Stack(clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 200,
                      clipBehavior: Clip.none,
                      padding: const EdgeInsets.all(16),

                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image:  AssetImage(AssetsConstant.woodBackground),
                              fit: BoxFit.fitWidth)),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Are you sure you want to exit?',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Color(0xff3c220c)),
                            textAlign: TextAlign.center,
                          ),

                        ],
                      ),
                    ),
                    Positioned(
                      bottom: -12,
                      left: 0,
                      right: 0,
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        GrassButtonWidget(img: AssetsConstant.yesButton,function: () {
                          Navigator.pop(context);
                          exit(0);
                        },
                        ),
                        SizedBox(width: 10,),
                        GrassButtonWidget(img: AssetsConstant.noButton,function: () {
                          Navigator.pop(context);

                        },),
                      ],),
                    ),
                    Transform.rotate(
                        angle: pi,
                        child: Image.asset(
                          AssetsConstant.grassImg2,
                          height: 50,
                        ))                  ],
                ),
                contentPadding: EdgeInsets.zero,
              );
            },
          );
        }
      },
      child: Scaffold(
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
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).viewPadding.top + 12,
                      horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        AssetsConstant.highScoreIcon,
                        height: 50,
                      ),
                      Image.asset(
                        AssetsConstant.soundButton,
                        height: 50,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const GameWithoutBoundaryScreen(),
                        ));
                  },
                  child: Image.asset(
                    AssetsConstant.playButton,
                    height: 100,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GrassButtonWidget(
                        img: AssetsConstant.menuButton,
                      ),
                      GrassButtonWidget(
                        img: AssetsConstant.profileButton,
                      ),
                      GrassButtonWidget(
                        img: AssetsConstant.questionButton,
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
