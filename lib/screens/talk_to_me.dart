import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:convert';
import 'dart:async';

class TalkToMe extends StatefulWidget {
  const TalkToMe({super.key});

  @override
  State<TalkToMe> createState() => _TalkToMeState();
}

class _TalkToMeState extends State<TalkToMe> {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  bool _speechEnabled = false;
  String _wordsSpoken = "";
  double _confidenceLevel = 0;
  bool _isSpeaking = false;
  Timer? _imageChangeTimer;
  int _currentImageIndex = 0;
  final List<String> _images = [
    'assets/images/characteree2.jpg',
    'assets/images/characteree1.jpg'
  ];

  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initSpeech();
    _textController.addListener(_updateWordsSpoken);

    // Set up TTS
    _flutterTts.setCompletionHandler(() {
      print("TTS playback completed.");
      _stopSpeakingAnimation();
    });
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      _confidenceLevel = 0;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = result.recognizedWords;
      _confidenceLevel = result.confidence;
      _textController.text = _wordsSpoken; // Update the TextField
      print('spoken $_textController');
    });
  }

  void _updateWordsSpoken() {
    setState(() {
      _wordsSpoken = _textController.text;
    });
  }

  void _saveEditedText() {
    setState(() {
      _wordsSpoken = _textController.text;
      print("edited $_wordsSpoken");
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Text saved successfully')),
    );
  }

  Future<void> _sendTextAndPlayResponse() async {
    try {
      final response = await http.post(
        Uri.parse('https://flask-server-monutalk-production.up.railway.app/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': _wordsSpoken}),
      );

      if (response.statusCode == 200) {
        final responseText = response.body;
        print("Received response from server: $responseText");
        await _startSpeakingAnimation();
        await _flutterTts.speak(responseText);
      } else {
        print('Server responded with status code: ${response.statusCode}');
        print('Server response: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to get response from server: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _startSpeakingAnimation() async {
    setState(() {
      _isSpeaking = true;
    });

    print("Starting speaking animation.");
    _imageChangeTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % _images.length;
      });
    });
  }

  Future<void> _stopSpeakingAnimation() async {
    if (_imageChangeTimer != null) {
      _imageChangeTimer?.cancel();
      print("Stopping speaking animation.");
      setState(() {
        _isSpeaking = false;
        _currentImageIndex = 0;
      });
    }
  }

  @override
  void dispose() {
    _textController.removeListener(_updateWordsSpoken);
    _textController.dispose();
    _imageChangeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 244, 171, 54),
        title: const Text(
          'Talk with me',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                _speechToText.isListening
                    ? "Listening..."
                    : _speechEnabled
                        ? "Tap the microphone to start listening..."
                        : "Speech not available",
                style: const TextStyle(fontSize: 20.0),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _textController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Words spoken will appear here',
                  ),
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
            if (_isSpeaking)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Image.asset(
                  _images[_currentImageIndex],
                  height: 150,
                  errorBuilder: (context, error, stackTrace) {
                    return Text('Error loading image', style: TextStyle(fontSize: 20));
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ElevatedButton(
                onPressed: () async {
                  _saveEditedText();
                  await _sendTextAndPlayResponse();
                },
                child: const Text('Save and Send Text'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _speechToText.isListening ? _stopListening : _startListening,
        tooltip: 'Listen',
        child: Icon(
          _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
          color: Colors.white,
        ),
        backgroundColor: const Color.fromARGB(255, 244, 171, 54),
      ),
    );
  }
}
