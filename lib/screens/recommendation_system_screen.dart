import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

class RecommendationSystemScreen extends StatefulWidget {
  const RecommendationSystemScreen({Key? key}) : super(key: key);

  @override
  _RecommendationSystemScreenState createState() =>
      _RecommendationSystemScreenState();
}

class _RecommendationSystemScreenState
    extends State<RecommendationSystemScreen> {
  String? dropdownvalue;
  Map<String, dynamic>? jsonResponse;

  Future<List<String>> getAllCategory() async {
    var baseUrl = "https://flask-server-monutalk-production.up.railway.app/museum-options";

    try {
      http.Response response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        List<String> items = List<String>.from(jsonData["museums"]);

        return items;
      } else {
        print("Failed to load categories: ${response.statusCode}");
        throw Exception("Failed to load categories");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Failed to load categories");
    }
  }

  void _saveItem() async {
    final url =
        Uri.parse('https://flask-server-monutalk-production.up.railway.app/recommend');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {'museum': dropdownvalue},
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          jsonResponse = json.decode(response.body);
          print("single ${jsonResponse!['museum']}");
        });
      } else {
        print("Failed to save item: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recommendation System"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FutureBuilder<List<String>>(
              future: getAllCategory(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error: ${snapshot.error}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (snapshot.hasData) {
                  var data = snapshot.data!;
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: constraints.maxWidth,
                        ),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: dropdownvalue ?? data[0],
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: data.map((String items) {
                            return DropdownMenuItem<String>(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownvalue = newValue!;
                            });
                            _saveItem();
                          },
                        ),
                      );
                    },
                  );
                } else {
                  return const Text("No data available");
                }
              },
            ),
            const SizedBox(height: 20),
            if (jsonResponse != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                jsonResponse!['museum']['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Category: ${jsonResponse!['museum']['category']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Description: ${jsonResponse!['museum']['description']}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 8),
                              Row(children: [
                                
                              const SizedBox(height: 8),
                              IconButton(
                                onPressed: () => _launchURL(jsonResponse!['museum']['locationUrl']),
                                icon: Icon(Icons.location_on_rounded,color: Color.fromARGB(255, 8, 88, 154)),
                              ),
                              Text(
                                'Location: ${jsonResponse!['museum']['location']}',
                                style: const TextStyle(fontSize: 14),
                              ),

                              ],)
                              
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Recommended museums based on your choice",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...jsonResponse!['museums'].map<Widget>((museum) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  museum['name'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Category: ${museum['category']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Description: ${museum['description']}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 8),
                                Row(children: [
                                  
                                const SizedBox(height: 8),
                                IconButton(
                                  onPressed: () => _launchURL(museum['locationUrl']),
                                  icon:const Icon(Icons.location_on_rounded,color: Color.fromARGB(255, 8, 88, 154),),
                                ),
                                Text(
                                  'Location: ${museum['location']}',
                                  style: const TextStyle(fontSize: 14),
                                ),

                                ],)
                                
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
