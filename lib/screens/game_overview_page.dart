

import 'package:WakeUpBuddy/alarm/ListAlarmBuilder.dart';
import 'package:WakeUpBuddy/screens/premium_page.dart';
import 'package:WakeUpBuddy/screens/unityPage.dart';
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
        onTap: () {
          Navigator.of(context).push((MaterialPageRoute(builder: (BuildContext context) => UnityTestingWrapper(game: 'Level 2', scene: 2) )));
        },
        child: Card(child: Container(height: 200, width: double.infinity, child: Image.asset('assets/images/block_breaker_game.png', width: double.infinity)))),
      GestureDetector(
        onTap: () {
          Navigator.of(context).push((MaterialPageRoute(builder: (BuildContext context) => UnityTestingWrapper(game: 'Level 2', scene: 5) )));
        },
        child: Card(child: Container(height: 200, width: double.infinity, child: Image.asset('assets/images/laser_defender_game.png')))),
      GestureDetector(
        onTap: () {Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PremiumPage(),
                  ),
                );},
        child: Card(child: Container(height: 200, width: double.infinity, child: Opacity(opacity: 0.5, child: Image.asset('assets/images/games/snake_background.jpg'))))),
    ],
    );
  }
}