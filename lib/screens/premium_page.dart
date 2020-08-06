import 'package:WakeUpBuddy/alarm/ListAlarmBuilder.dart';
import 'package:WakeUpBuddy/games/snaake/lib/snaake_game_main.dart';
import 'package:flutter/material.dart';

class PremiumPage extends StatefulWidget {
  @override
  _PremiumPageState createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Get premium'),
          centerTitle: true,
        ),
        body: ListView(padding: EdgeInsets.all(12), children: <Widget>[
          Container(
              height: 200,
              width: double.infinity,
              child: Image.asset('assets/images/games/snake_background.jpg')),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Upgrade', style: TextStyle(fontSize: 24)),
              SizedBox(width: 10),
              Icon(Icons.thumb_up, color: Colors.orange),
            ],
          ),
          Text(
            'Join all the other PRO users',
            textAlign: TextAlign.center,
          ),
          ListTile(
              leading: Icon(Icons.check, color: Colors.green),
              title: Text('Unlock 4 different themes')),
          ListTile(
              leading: Icon(Icons.check, color: Colors.green),
              title: Text('Full access to all games')),
          ListTile(
              leading: Icon(Icons.check, color: Colors.green),
              title: Text('Instant upgrade to new features')),
          ListTile(
              leading: Icon(Icons.check, color: Colors.green),
              title: Text('Choose your own ringtones')),
          ListTile(
              leading: Icon(Icons.check, color: Colors.green),
              title: Text('Instant upgrade to new features')),
          Align(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 40,
                  child: RaisedButton(
                      color: Colors.orange[300],
                      elevation: 5,
                      child: Text('PREMIUM MONTHLY 0.99€',
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {}))),
          SizedBox(height: 10),
          Align(
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 50,
                child: RaisedButton(
                    color: Colors.orange,
                    elevation: 5,
                    child: Text('PREMIUM ANNUAL 8.99€',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {})),
          )
        ]));
  }
}
