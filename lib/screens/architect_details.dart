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
          child: Text(errorMessage),
        ),
      );
    }
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(jsonResponse!['imageUrlList'][0]),
                fit: BoxFit.cover,
                opacity: 0.7,
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(90),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: const [
                                  BoxShadow(color: Colors.white, blurRadius: 6)
                                ]),
                            child: const Icon(
                              Icons.arrow_back,
                              size: 28,
                            ),
                          ),
                        ),
                        Container(
                  margin: const EdgeInsets.only(left: 16),
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                      boxShadow: const [
                        BoxShadow(color: Colors.white, blurRadius: 6)
                      ]),
                  child: IconButton(
                      icon: const Icon(Icons.camera),
                      onPressed: () {
                        go(context);
                      })),
            
                      ],
                    ),
                  )),
              bottomNavigationBar: Container(
                height: MediaQuery.of(context).size.height / 1.8,
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                decoration: const BoxDecoration(
                    color: Color(0xFFEDF2F6),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    )),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                jsonResponse!['name'],
                                style: const TextStyle(
                                    fontSize: 23, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Text(
                            jsonResponse!['description'],
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 16),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          
                        ],
                      ),
                    )
                  ],
                ),
              ),
             
            )));
  }
}
      
