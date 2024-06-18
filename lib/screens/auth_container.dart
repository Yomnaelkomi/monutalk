import 'package:final5/screens/authentication_screen.dart';
import 'package:final5/screens/tabs.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthContainer extends StatefulWidget {
  const AuthContainer({super.key});

  @override
  State<AuthContainer> createState() => _AuthContainerState();
}

class _AuthContainerState extends State<AuthContainer> {
  String? token;
  String? UID;
  @override
  Widget build(BuildContext context)  {
    SharedPreferences.getInstance().then((sharedPreferencesValue) {
      setState(() {
        token = sharedPreferencesValue.getString('token');
      });
    });
     SharedPreferences.getInstance().then((sharedPreferencesValue2) {
      setState(() {
        UID = sharedPreferencesValue2.getString('userID');
      });
    });

    if (token != null) {
      return TabsScreen(UID: UID);
    } else {
      return const AuthenticationScreen();
    }
  }
}
