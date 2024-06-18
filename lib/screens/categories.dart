import 'dart:convert';
import 'package:final5/screens/m_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';
import 'package:final5/screens/museumsGetDetails.dart';

class Categories extends StatefulWidget {
  // final void Function(Musuem musuem) ontoggleFavorite;
  // final List<Musuem> favoriteMusuems;
  final UID;

  const Categories({
    super.key,
    required this.UID
  });

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
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
      appBar: AppBar(title: const Text('Museums')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: jsonResponse.length,
              itemBuilder: (context, index) {
                final museum = jsonResponse[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  clipBehavior: Clip.hardEdge,
                  elevation: 2,
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => MDetails(
                              ID: museum['id'],
                              name: museum['name'],
                              UID: widget.UID),
                        )),
                    child: Stack(
                      children: [
                        FadeInImage(
                          placeholder: MemoryImage(kTransparentImage),
                          image: NetworkImage(museum['imageUrl']),
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
                              museum['name'],
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
