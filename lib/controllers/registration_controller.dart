import 'dart:convert';

import 'package:final5/screens/home.dart';
import 'package:final5/utils/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RegisterationController extends GetxController {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> registerWithEmail() async {
    var headers = {'Content-Type': 'application/json'};
    var url = Uri.parse(
        ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.registerEmail);
    Map body = {
      'firstName': firstNameController.text,
      'lastName': firstNameController.text,
      'email': emailController.text.trim(),
      'password': passwordController.text,
      'role': 'CLIENT'
    };

    try {
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      Get.off(HomeScreen());

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        var token = json['token'];
          final SharedPreferences? prefs = await _prefs;
          await prefs?.setString('token', token);
          firstNameController.clear();
          lastNameController.clear();
          emailController.clear();
          passwordController.clear();
          Get.off(HomeScreen());
      }
    } catch (e) {
      Get.back();
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: Text('Error'),
              contentPadding: EdgeInsets.all(20),
              children: [Text(e.toString())],
            );
          });
    }
  }
}


// success states

// 200 get success
// 201 post success
// 204 delete success
// 202 put success