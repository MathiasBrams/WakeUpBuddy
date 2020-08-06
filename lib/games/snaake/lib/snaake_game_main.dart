import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'game/blocs/game_bloc.dart';
import 'game/flame/flame_manager.dart';
import 'game/screens/game_screen.dart';
import 'ui/colors.dart';

/// Main application.
class SnakeGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wake Up Buddy',
      theme: ThemeData(
        primaryColor: GameColors.primary,
        primaryColorDark: GameColors.primaryDark,
      ),
      home: BlocProvider(
        create: (context) => GameBloc(
          flameManager: FlameManager(),
          random: Random(),
        ),
        child: GameScreen(),
      ),
    );
  }
}
