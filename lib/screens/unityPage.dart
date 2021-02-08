import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:flutter/services.dart';

class UnityTestingWrapper extends StatefulWidget
{
  String game;
  int scene;
  String payload;
  UnityTestingWrapper({this.game, this.scene, this.payload});


  UnityTestingState createState() => UnityTestingState();
}

class CustomPopupMenu {
  CustomPopupMenu({this.title, this.scene});

  String title;
  int scene;
}

List<CustomPopupMenu> choices = <CustomPopupMenu>[
  CustomPopupMenu(title: 'Block Breaker Start', scene: 0),
  CustomPopupMenu(title: 'Block Breaker Level 1', scene: 1),
  CustomPopupMenu(title: 'Block Breaker Level 2', scene: 2),
  CustomPopupMenu(title: 'Laser Defender Start', scene: 4),
  CustomPopupMenu(title: 'Laser Defender LVL 1', scene: 5),
  CustomPopupMenu(title: 'Laser Defender LVL 2', scene: 6),
];

class UnityTestingState extends State<UnityTestingWrapper>
{

  UnityWidgetController _unityWidgetController;
  double _sliderValue = 0.0;


  get onUnityMessage => null;

  // @override
  // void initState() {
  //   super.initState();
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.landscapeRight,
  //     DeviceOrientation.landscapeLeft,
  // ]);
  // }

  // @override
  // dispose(){
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.landscapeRight,
  //     DeviceOrientation.landscapeLeft,
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown,
  //   ]);
  //   super.dispose();
  // }
  

  @override
  Widget build(BuildContext context) {
    // widget.scene represents the payload sent from the alarm to choose the appropiate game
    int scene = widget.scene;
    // unity splash screen takes 2 seconds to load, thus the delay
    // method to choose game in unity
    Future.delayed(const Duration(milliseconds: 2000), () {
    _unityWidgetController.postMessage(
      'GameManager',
      'LoadGameScene',
      widget.payload,
      // scene.toString(),
    );
    });
    return MaterialApp(
      home: Scaffold(
        body: Card(
          margin: const EdgeInsets.all(8),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Stack(
            children: <Widget>[
              UnityWidget(
                onUnityViewCreated: onUnityCreated,
                isARScene: false,
              ),
              PopupMenuButton<CustomPopupMenu>(
                elevation: 3.2,
                initialValue: choices[1],
                onCanceled: () {
                  print('You have not chossed anything');
                },
                tooltip: 'This is tooltip',
                onSelected: _select,
                itemBuilder: (BuildContext context) {
                  return choices.map((CustomPopupMenu choice) {
                    return PopupMenuItem<CustomPopupMenu>(
                      value: choice,
                      child: Text(choice.title),
                    );
                  }).toList();
                },
              )
            ],
          ),
        ),
      ),
    );
    
  }
    void onUnityCreated(controller) {
    this._unityWidgetController = controller;
  }

    void setRotationSpeed(String speed) {
    _unityWidgetController.postMessage(
      'Cube',
      'SetRotationSpeed',
      speed,
    );
  }

    void chooseGame(String game) {
    _unityWidgetController.postMessage(
      'Scene Loader',
      'ChooseGame',
      game,
    );
  }


  CustomPopupMenu _selectedChoices = choices[0];

  // method to choose game from pop up menu
  void _select(CustomPopupMenu choice) {
    setState(() {
      _selectedChoices = choice;
    });

    print('Selected');

    _unityWidgetController.postMessage(
      'GameManager',
      'LoadGameScene',
      choice.scene.toString(),
    );

  }
}