import 'package:final5/screens/m_details.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({super.key, required this.UID});
  final UID;

  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<dynamic> jsonResponse = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMuseums();
  }

  Future<void> fetchMuseums() async {
    try {
      final uri =
          Uri.parse('https://monu-talk-production.up.railway.app/museums');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        setState(() {
          jsonResponse = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load museums');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to fetch data: $e'),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20, top: 50),
              alignment: Alignment.centerLeft,
              child: const Text(
                'WELCOME!',
                style: TextStyle(
                    color: Color(0xFF3E2723),
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5),
              ),
            ),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.only(left: 20),
              alignment: Alignment.centerLeft,
              child: const Text(
                'TO Monutalk',
                style: TextStyle(
                    color: Color(0xFF3E2723),
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  'assets/images/intro1.jpeg',
                  height: 240,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF464A7E),
                    ),
                    prefixIcon: Icon(Icons.search, color: Color(0xFF464A7E)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.all(10)),
                Icon(Icons.museum, color: Color(0xFF3E2723)),
                SizedBox(width: 10),
                Text(
                  'Top 5 Most Popular Museums',
                  style: TextStyle(
                    color: Color(0xFF3E2723),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: jsonResponse.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.all(8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          clipBehavior: Clip.hardEdge,
                          elevation: 5,
                          child: InkWell(
                            onTap: () {
                              Get.to(MDetails(
                                ID: jsonResponse[index]['id'],
                                name: jsonResponse[index]['name'],
                                UID: widget.UID,
                              ));
                            },
                            child: Stack(
                              children: [
                                FadeInImage(
                                  placeholder: MemoryImage(kTransparentImage),
                                  image: NetworkImage(
                                      jsonResponse[index]['imageUrl']),
                                  fit: BoxFit.cover,
                                  width: 200,
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 15),
                                    color: Colors.black54,
                                    child: Text(
                                      jsonResponse[index]['name'],
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
