import 'package:final5/screens/architect_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:transparent_image/transparent_image.dart';

class ExploreArch extends StatefulWidget {
  const ExploreArch({super.key, required this.MuseumID,});
  final MuseumID;
  
  @override
  State<ExploreArch> createState() {
    return _ExploreArchState();
  }
}

class _ExploreArchState extends State<ExploreArch> {
  List<dynamic> jsonResponse = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMuseums();
  }

  Future<void> fetchMuseums() async {
    try {
      final uri = Uri.parse(
          'https://monu-talk-production.up.railway.app/artifacts/museums/${widget.MuseumID}');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        setState(() {
          jsonResponse = json.decode(response.body);
          print(jsonResponse);
          print(jsonResponse[0]['name']);
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
          //title: const Text('Error'),
          title: const Text('unfortunately'),
          //content: Text('Failed to fetch data: $e'),
          content: Text('No artifacts in this museum'),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
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
      appBar: AppBar(title: const Text('Artifacts')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: jsonResponse.length,
              itemBuilder: (context, index) {
                final museumArch = jsonResponse[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  clipBehavior: Clip.hardEdge,
                  elevation: 2,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                        return ArchitectsDetails(ArchID: museumArch['id']);
                      }));
                    },
                    child: Stack(
                      children: [
                        FadeInImage(
                          placeholder: MemoryImage(kTransparentImage),
                          image: NetworkImage(museumArch['imageUrlList'][0]),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            color: Colors.black54,
                            child: Text(
                              museumArch['name'],
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
