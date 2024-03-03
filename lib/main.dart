import 'package:flutter/material.dart';
import 'package:snake_game/pages/game_page.dart';
import 'package:snake_game/pages/game_without_boundary_page.dart';
import 'package:snake_game/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

      ),
      home: HomeScreen(),
    );
  }
}

