import 'package:flutter/material.dart';
import 'dart:io';

class Camera extends StatefulWidget {
  Camera({super.key,required this.selectedImage});
  File? selectedImage;
  @override
  State<Camera> createState() {
    return _CameraState();
  }
}

class _CameraState extends State<Camera> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.file(
            widget.selectedImage!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
    );
  }
}
