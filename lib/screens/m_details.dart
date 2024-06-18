import 'package:final5/screens/explore_architects.dart';
import 'package:final5/screens/home_screen2.dart';
import 'package:final5/screens/reviews.dart';
import 'package:final5/screens/tabs.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:final5/screens/book_now.dart';
import 'package:final5/screens/test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MDetails extends StatefulWidget {
  final String ID;
  final String name;
  final UID;

  const MDetails(
      {super.key, required this.ID, required this.name, required this.UID});

  @override
  State<MDetails> createState() => _MDetailsState();
}

class _MDetailsState extends State<MDetails> {
  double rating = 0;
  var jsonResponse;
  var jsonResponseID;

  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchPost();
  }

  void go(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const Test()));
  }

  Future<void> fetchPost() async {
    try {
      final uri = Uri.parse(
          'https://monu-talk-production.up.railway.app/museums/${widget.ID}');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        setState(() {
          jsonResponse = json.decode(response.body);
          jsonResponseID = jsonResponse['id'];

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

    if (jsonResponse == null ||
        !jsonResponse.containsKey('imageUrl') ||
        !jsonResponse.containsKey('name') ||
        !jsonResponse.containsKey('description')) {
      return const Scaffold(
        body: Center(
          child: Text('Data is incomplete or not available'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (ctx) => TabsScreen(UID: widget.UID)));
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera, color: Colors.black),
            onPressed: () {
              go(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 35),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ListView(
                children: [
                  Image.network(
                    jsonResponse['imageUrl'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 250,
                  ),
                  const SizedBox(height: 35),
                  Text(
                    jsonResponse['name'],
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text('from'),
                      const SizedBox(width: 5),
                      Text(jsonResponse['openingTime']),
                      const SizedBox(width: 5),
                      const Text('to'),
                      const SizedBox(width: 5),
                      Text(jsonResponse['closingTime'])
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.location_on),
                      const SizedBox(width: 5),
                      Expanded(child: Text(jsonResponse['location'])),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    jsonResponse['description'],
                    style: const TextStyle(height: 1.5, fontSize: 17),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Reviews",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (ctx) {
                            return Reviews(UID: widget.UID, MuseumID: widget.ID);
                          }));
                        },
                        child: const Text(
                          'View All',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 71, 133, 232),
                          ),
                        ),
                      ),
                    ],
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return BookNowScreen(
                              MusuemId: jsonResponseID,
                              UID: widget.UID,
                              name: widget.name,
                              price: jsonResponse['ticketPrice'],
                            );
                          }));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 6, 118, 28),
                        ),
                        child: const Text(
                          'Book Now',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 248, 245, 245),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (ctx) {
                          return ExploreArch(MuseumID: widget.ID);
                        }));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 91, 8, 106)),
                      child: const Text(
                        'Explore',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 244, 240, 240),
                        ),
                      ),
                    ),
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
