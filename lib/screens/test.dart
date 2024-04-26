import 'package:final5/widgets/image_input.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class Test extends StatelessWidget {
  const Test({super.key});
  
  @override
  Widget build(BuildContext context) {
    File? selectedImage;
    return Scaffold(
      body: ImageInput(
        onPickImage: (image) {
          selectedImage = image;
        },
      ),
    );
  }
}
