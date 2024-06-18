import 'dart:convert';
import 'package:final5/screens/tabs.dart';
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
  final Future<SharedPreferences> _userId = SharedPreferences.getInstance();
  var user;

  Future<void> registerWithEmail() async {
    var headers = {'Content-Type': 'application/json'};
    var url =
        Uri.parse('https://monu-talk-production.up.railway.app/auth/register');
    Map body = {
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'email': emailController.text.trim(),
      'password': passwordController.text,
      'role': 'CLIENT'
    };

    try {
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      print('responseeeeeee $response');
      print('status code: ${response.statusCode}');

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        var token = json['token'];
        var UserId = json['userId'];
        final SharedPreferences prefs = await _prefs;
        final SharedPreferences userId = await _userId;
        await prefs.setString('token', token);
        await userId.setString('userID', UserId);
        user = userId.getString('userID');
        print('registerUserrrrrrrrrrrr $user');
        firstNameController.clear();
        lastNameController.clear();
        emailController.clear();
        passwordController.clear();
        Get.off(TabsScreen(
          UID: user,
        ));
      }else{
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      Get.back();
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: const Text('Error'),
              contentPadding: const EdgeInsets.all(20),
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