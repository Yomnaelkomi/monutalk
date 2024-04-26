import 'package:final5/screens/authentication_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

main() async {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: AuthenticationScreen(),
  ));
}