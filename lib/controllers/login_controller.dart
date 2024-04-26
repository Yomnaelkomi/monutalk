import 'dart:convert';

import 'package:final5/screens/home.dart';
import 'package:final5/utils/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> loginWithEmail() async {
    var headers = {'Content-Type': 'application/json'};

    // try catch
    // try api request
    // catch error automaticalluu

    var url =
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.loginEmail);
    Map body = {
      'email': emailController.text.trim(),
      'password': passwordController.text
    };

    try {
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
         var token = json['token'];
          final SharedPreferences? prefs = await _prefs;
          print('ttttttttttttttttttttttttttttttttttt$token');
          await prefs?.setString('token', token);
          emailController.clear();
          passwordController.clear();
          Get.off(HomeScreen());
      }
    } catch (error) {
      Get.back();
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: Text('Error'),
              contentPadding: EdgeInsets.all(20),
              children: [Text(error.toString())],
            );
          });
    }
  }
}
