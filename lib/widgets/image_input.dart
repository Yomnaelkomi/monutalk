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
  // List<dynamic> questions = [];
  // late List<Question> ques;
  // late Question quest;
  // Map<String, dynamic>? questionss;
  // String q = '';
  // String A = '';

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
        .post('https://84b2-34-83-172-215.ngrok-free.app/upload',
            data: formData)
        .then((response) {
      var jsonResponse = jsonDecode(response.toString());
      print("Json Response: $jsonResponse");

      setState(() {
        List<dynamic> questionsData = jsonResponse['questions'];

        infoData = jsonResponse['info'];
        name = jsonResponse['name'];
        questionAnswerPairs = []; // Clear previous data

        for (var questionData in questionsData) {
          String question = questionData['question'];
          String answer = questionData['answer'];
          questionAnswerPairs.add([question, answer]);
        }
      });
      print('questionsAnswerPairs $questionAnswerPairs');

      // print('questionsq $questions');
      // var details = {'Usrname': q, 'Password': A};
      // print('D $details');

      // print('q $q');
      // print('A $A');

      // print('info ${res.info}');
      // print("name $name");
      // questions = jsonResponse['questions'];
      //  print('QQ $questionss');
      // print('1)Q&A ${questions[0]}');
      // print('Ques: ${jsonResponse['questions'][0]['question']}');
      // print('Answer: ${jsonResponse['questions'][0]['answer']}');
      //  print('Length of ques ${questions.length}');
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
                        ? const Text('try taking an image of the statue')
                        : Expanded(
                            child: Column(
                              children: [
                                SizedBox(
                                    height: 200,
                                    width: double.infinity,
                                    child: GestureDetector(
                                      onTap: _takePicture,
                                      child: Image.file(
                                        _selectedimage!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    )),
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
                            ),
                          ))
              ],
            ),
          )
        ]));
  }
}

// Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Text(
//                                 name,
//                                 style: const TextStyle(
//                                     fontSize: 17, fontWeight: FontWeight.bold),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Text(infoData),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           SizedBox(
                            
//                             height: double.infinity,
//                             width: double.infinity,
//                             child: ListView.builder(
                              
//                               shrinkWrap: true,
//                               itemCount: questionAnswerPairs.length,
//                               itemBuilder: (context, index) {
//                                 final question = questionAnswerPairs[index][0];
//                                 final answer = questionAnswerPairs[index][1];
//                                 return Accordion(
                                  
//                                     headerBackgroundColor: const Color.fromARGB(
//                                         255, 104, 131, 240),
//                                     paddingListTop: 0,
//                                     paddingListBottom: 0,
//                                     children: [
//                                       AccordionSection(
//                                           header: Center(
//                                               child: Text(
//                                             question,
//                                             style: const TextStyle(
//                                                 fontSize: 17,
//                                                 fontWeight: FontWeight.w700),
//                                           )),
//                                           content: Text(answer,
//                                               style: const TextStyle(
//                                                 fontSize: 15,
//                                               )))
//                                     ]);
//                               },
//                             ),
//                           ),
//                         ],
//                       ),

