import 'dart:async';

import 'package:WakeUpBuddy/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:WakeUpBuddy/sign_in/sign_in_page.dart';
import 'package:WakeUpBuddy/services/auth.dart';
import 'package:WakeUpBuddy/services/database.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User>(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            if (user == null) {
              return SignInPage.create(context);
            }
            return Provider<User>.value(
              value: user,
              child: Provider<Database>(
                create: (_) => FirestoreDatabase(uid: user.uid),
                child: HomePage(),
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}