import 'package:accordion/accordion.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:final5/models/response.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickImage});
  final void Function(File image) onPickImage;

  @override
  State<ImageInput> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  late Response1 res;
  File? _selectedimage;
  String base64String = '';
  String infoData = '';
  String name = '';
  List<List<String>> questionAnswerPairs = [];

  void _takePicture() async {
    name = '';
    infoData = '';
    questionAnswerPairs = [];
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _selectedimage = File(pickedImage.path);
    });
    widget.onPickImage(_selectedimage!);
    Uint8List bytes = await _selectedimage!.readAsBytes();

    String base64String = base64.encode(bytes);
    print('base64:$base64String');
    setState(() {
      base64String = base64String;
    });
  }

  Future<void> upload() async {
    String imagename = _selectedimage!.path.split('/').last;
    FormData formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        _selectedimage!.path,
        filename: imagename,
      )
    });
    Dio()
        .post('https://57b0-35-198-206-210.ngrok-free.app/upload',
            data: formData)
        .then((response) {
      var jsonResponse = jsonDecode(response.toString());
      print("Json Response: $jsonResponse");


      setState(() {
        List<dynamic> questionsData = jsonResponse['questions'];

        infoData = jsonResponse['info'];
        name = jsonResponse['name'];
        questionAnswerPairs = [];

        for (var questionData in questionsData) {
          String question = questionData['question'];
          String answer = questionData['answer'];
          questionAnswerPairs.add([question, answer]);
        }
      });
      print('questionsAnswerPairs $questionAnswerPairs');
    }).catchError((error) => print("Error: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView(children: [
          Container(
            margin: const EdgeInsets.all(25),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: _takePicture,
                        child: const Text('Take a picture')),
                    const SizedBox(
                      width: 5,
                    ),
                    ElevatedButton(
                        onPressed: upload, child: const Text('Start')),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Center(
                    child: _selectedimage == null
                        ? const Text('Try taking an image of the statue')
                        : Column(
                            children: [
                              Container(
                                height: 300, // Fixed height
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                                child: Image.file(
                                  _selectedimage!,
                                  fit: BoxFit.contain, // Preserve aspect ratio
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(infoData),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: questionAnswerPairs.length,
                                      itemBuilder: (context, index) {
                                        final question =
                                            questionAnswerPairs[index][0];
                                        final answer =
                                            questionAnswerPairs[index][1];
                                        return Accordion(
                                            headerBackgroundColor:
                                                const Color.fromARGB(
                                                    255, 104, 131, 240),
                                            paddingListTop: 0,
                                            paddingListBottom: 0,
                                            children: [
                                              AccordionSection(
                                                  header: Center(
                                                      child: Text(
                                                    question,
                                                    style: const TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  )),
                                                  content: Text(answer,
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                      )))
                                            ]);
                                      },
                                    ),
                                  ]),
                            ],
                          ))
              ],
            ),
          )
        ]));
  }
}
