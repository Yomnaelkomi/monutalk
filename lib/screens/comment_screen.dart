import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key, required this.MusuemId, required this.UID});
  final MusuemId;
  final UID;

  @override
  State<CommentScreen> createState() {
    return _CommentScreenState();
  }
}

class _CommentScreenState extends State<CommentScreen> {
  final _formKey = GlobalKey<FormState>();
  var _rating=2.0;
  var _comment;
  bool isLoading = true;
  String errorMessage = '';

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.https(
          'monu-talk-production.up.railway.app', // Authority
          '/reviews');
      try {
        var response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(
            {
              'comment': _comment,
              'rating': _rating,
              'museumId': widget.MusuemId.toString(),
              'userId': widget.UID,
            },
          ),
        );
        print('commmentttt${jsonDecode(response.body)}');
        print('statusssss${response.statusCode}');
      } catch (e) {
        print('eeeeeeeee$e');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('comment done succesfully'),
        ),
      );
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add your comment'),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('comment'),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 and 50 characters.';
                  }
                  return null;
                },
                onSaved: (value) {
                  // if (value == null) {
                  //   return;
                  // }
                  _comment = value!;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    RatingBar.builder(
                      initialRating: 1,
                      itemSize: 28,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      updateOnDrag: true,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        _rating = rating;
                      },
                    ),
                    const SizedBox(width: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            _formKey.currentState!.reset();
                          },
                          child: const Text('Reset'),
                        ),
                        ElevatedButton(
                          onPressed: _saveItem,
                          child: const Text('Submit'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ),
        )));
  }
}
