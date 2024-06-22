import 'package:final5/screens/chat_screen.dart';
import 'package:final5/screens/talk_to_me.dart';
import 'package:final5/screens/test.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ArchitectsDetails extends StatefulWidget {
  const ArchitectsDetails({Key? key, required this.ArchID}) : super(key: key);
  final String ArchID;

  @override
  State<ArchitectsDetails> createState() => _ArchitectsDetailsState();
}

class _ArchitectsDetailsState extends State<ArchitectsDetails> {
  Map<String, dynamic>? jsonResponse;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchPost();
  }

  Future<void> fetchPost() async {
    try {
      final uri = Uri.parse(
          'https://monu-talk-production.up.railway.app/artifacts/${widget.ArchID}');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        setState(() {
          jsonResponse = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load museum data');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void go(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const Test()));
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Scaffold(
        body: Center(
          child: Text('Error: $errorMessage'),
        ),
      );
    }

    if (jsonResponse == null) {
      return Scaffold(
        body: Center(
          child: Text('No data found'),
        ),
      );
    }

    // Extracting values with default fallbacks
    String imageUrl = jsonResponse?['imageUrl'] ?? '';
    String name = jsonResponse?['name'] ?? 'Unknown';
    String description =
        jsonResponse?['description'] ?? 'No description available';

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const SizedBox(height: 35),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ListView(
                children: [
                  Container(
                    height: 250, // Set a fixed height for the image container
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Image.network(
                      jsonResponse!['imageUrlList'][0],
                      fit: BoxFit.contain, // Ensure the image fits within the container without cropping
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Text('Image not available'),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 35),
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: const TextStyle(height: 1.5, fontSize: 17),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 207, 148, 72),
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const TalkToMe();
                          }));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 6, 118, 28),
                        ),
                        child: const Text(
                          'Talk To Me',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 248, 245, 245),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => ChatScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 195, 19, 186),
                        ),
                        child: const Text(
                          "Chat With Me",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 248, 245, 245),
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
