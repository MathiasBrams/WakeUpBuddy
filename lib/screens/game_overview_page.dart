

import 'package:WakeUpBuddy/alarm/ListAlarmBuilder.dart';
import 'package:WakeUpBuddy/games/snaake/lib/snaake_game_main.dart';
import 'package:WakeUpBuddy/screens/premium_page.dart';
import 'package:flutter/material.dart';

class GamesPage extends StatefulWidget {
  @override
  _GamesPageState createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      GestureDetector(
        onTap: () {Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SnakeGame(),
                  ),
                );},
        child: Card(child: Container(height: 200, width: double.infinity, child: Image.asset('assets/images/games/snake_background.jpg')))),
      GestureDetector(
        onTap: () {Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PremiumPage(),
                  ),
                );},
        child: Card(child: Container(height: 200, width: double.infinity, child: Opacity(opacity: 0.5, child: Image.asset('assets/images/games/snake_background.jpg'))))),
      Card(child: Container(height: 200, width: double.infinity, child: Opacity(opacity: 0.5, child: Image.asset('assets/images/games/snake_background.jpg')))),
    ],
    );
  }
}