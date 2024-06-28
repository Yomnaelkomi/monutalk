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
  double _rating = 2.0;
  late String _comment;
  bool isLoading = true;
  String errorMessage = '';

  Future<void> _sendPredictionRequest() async {
    final Map<String, dynamic> requestBody = {
      "review": [_comment]
    };
    final url = Uri.parse('https://57b0-35-198-206-210.ngrok-free.app/predict');
    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      _rating = responseBody['rating'].toDouble(); // Ensure the rating is a double
      print('_comment $_comment ');
      print('rating $_rating ');
      return;
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to get prediction');
    }
  }

  Future<void> _submitReview() async {
    final urlNodejs = Uri.https('monu-talk-production.up.railway.app', '/reviews');
    try {
      var response = await http.post(
        urlNodejs,
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
      print("Response1: ${response.body}");
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to submit review');
    }
  }

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await _sendPredictionRequest();
        await _submitReview();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Comment submitted successfully'),
          ),
        );
        Navigator.of(context).pop();
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to submit comment'),
          ),
        );
      }
    }
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
                  label: Text('Comment'),
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
                  _comment = value!;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                
                  
                   child:  Row(
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
            )],
                ),
              ),
            ),
          ),
        );
  }
}
