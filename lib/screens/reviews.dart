import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'comment_screen.dart'; // Adjust the import as necessary

final formatter = DateFormat.yMd();

class Reviews extends StatefulWidget {
  const Reviews({Key? key, required this.UID, required this.MuseumID})
      : super(key: key);

  final String UID;
  final String MuseumID;

  @override
  _ReviewsState createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  bool isLoading = true;
  String errorMessage = '';
  List<double> ratings = [0.1, 0.3, 0.5, 0.7, 0.9];
  File? _imageFile;
  List<dynamic> reviews = [];
  String? avgrating;

  @override
  void initState() {
    super.initState();
    loadImageFromPreferences();
    fetchPost();
  }

  Future<void> loadImageFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('imagePath');
    print('Image path from SharedPreferences: $imagePath');
    if (imagePath != null) {
      setState(() {
        _imageFile = File(imagePath);
      });
    }
  }

  Future<void> fetchPost() async {
    final uri = Uri.parse(
        'https://monu-talk-production.up.railway.app/reviews/museums/${widget.MuseumID}');

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          reviews = jsonResponse['reviews'];
          avgrating = jsonResponse["avgRating"];
          print('average $avgrating');
          print('reviews $reviews');
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load reviews data');
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  color: const Color.fromARGB(255, 241, 239, 239),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(TextSpan(children: [
                            TextSpan(
                                text: "$avgrating",
                                style: const TextStyle(fontSize: 48)),
                            const TextSpan(
                                text: "/5", style: TextStyle(fontSize: 24)),
                          ])),
                          RatingBarIndicator(
                            rating: 4.5,
                            itemSize: 28,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            '${reviews.length} Reviews',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => CommentScreen(
                                    MusuemId: widget.MuseumID,
                                    UID: widget.UID,
                                  ),
                                ),
                              );
                            },
                            child: const Text('Add a comment'),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 200,
                        child: ListView.builder(
                          shrinkWrap: true,
                          reverse: true,
                          itemCount: 5,
                          itemBuilder: (ctx, index) {
                            return Row(
                              children: [
                                Text(
                                  '${index + 1}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                const Icon(
                                  Icons.star,
                                  color: Colors.orange,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                LinearPercentIndicator(
                                  width:
                                      MediaQuery.of(context).size.width / 2.8,
                                  animation: true,
                                  animationDuration: 2500,
                                  lineHeight: 6.0,
                                  progressColor: Colors.orange,
                                  percent: ratings[index],
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      String rate = reviews[index]['rating'].toString();
                      double rateS = double.parse(rate);
                      DateTime dateTimeWithTimeZone =
                          DateTime.parse(reviews[index]['createdAt']);

                      // Check if the current comment belongs to the logged-in user
                      bool isCurrentUserComment =
                          reviews[index]['userId'] == widget.UID;

                      return Container(
                        padding: const EdgeInsets.only(
                            top: 2, bottom: 20, left: 16, right: 0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 45,
                                  height: 45,
                                  margin: const EdgeInsets.only(right: 16),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      // Display the user's image if it's their comment, otherwise display a default image
                                      image: isCurrentUserComment &&
                                              _imageFile != null
                                          ? FileImage(_imageFile!)
                                          : const AssetImage(
                                                  'assets/images/contactImage.png')
                                              as ImageProvider<Object>,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(44),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    reviews[index]['userName'],
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.more_vert),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  RatingBarIndicator(
                                    rating: rateS,
                                    itemSize: 28,
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  const SizedBox(width: 80),
                                  Text(
                                    formatter.format(dateTimeWithTimeZone),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    reviews[index]['comment'],
                                    maxLines: 2,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        overflow: TextOverflow.fade),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
