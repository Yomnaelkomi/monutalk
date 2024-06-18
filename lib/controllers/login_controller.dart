import 'dart:convert';

import 'package:final5/screens/tabs.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final Future<SharedPreferences> _userId = SharedPreferences.getInstance();
  var user;
  Future<void> loginWithEmail() async {
    var headers = {'Content-Type': 'application/json'};

    // try catch
    // try api request
    // catch error automaticalluu

    var url =
        Uri.parse('https://monu-talk-production.up.railway.app/auth/login');
    Map body = {
      'email': emailController.text.trim(),
      'password': passwordController.text
    };

    try {
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      print('login: ${jsonDecode(response.body)}');
      print('login Status code : ${response.statusCode}');
      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        var token = json['token'];
        var UserId = json['userId'];
        final SharedPreferences prefs = await _prefs;
        final SharedPreferences userId = await _userId;
        print('ttttttttttttttttttttttttttttttttttt$token');
        await prefs.setString('token', token);
        await userId.setString('userID', UserId);
        print('prefssssssssssssss ${prefs.getString('token')}');
        user = userId.getString('userID');
        print('Iddddddddddddddddd $user}');
        emailController.clear();
        passwordController.clear();
        Get.off(TabsScreen(
          UID: user,
        ));
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (error) {
      Get.back();
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: const Text('Error'),
              contentPadding: const EdgeInsets.all(20),
              children: [Text(error.toString())],
            );
          });
    }
  }
}
