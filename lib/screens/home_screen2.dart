import 'package:final5/screens/museumsGetDetails.dart';
import 'package:final5/screens/musuem_details_screen2.dart';
import 'package:flutter/material.dart';
import 'package:final5/not_used/musuem_data.dart';
import 'package:final5/not_used/musuems.dart';
import 'package:final5/not_used/musuem.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({
    super.key,
  
  });
  // final List<Musuem> favoriteMusuems;

  // final void Function(Musuem musuem) ontoggleFavorite;

  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
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
    print(jsonResponse);
  }

  @override
  // void selectMusuem(BuildContext context, Musuem musuem) {
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (ctx) => MusuemDetailsScreen(
  //                 musuem: musuem,
  //                 ontoggleFavorite: widget.ontoggleFavorite,
  //                 favoriteMusuems: widget.favoriteMusuems,
  //               )));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10, top: 6),
              child: const Text(
                'WELCOME!',
                style: TextStyle(
                    color: Color.fromARGB(255, 4, 3, 0),
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5),
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Container(
              padding: const EdgeInsets.only(left: 10),
              child: const Text(
                'TO Monutalk',
                style: TextStyle(
                    color: Color.fromARGB(255, 4, 3, 0),
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5),
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Image.asset(
              'assets/images/intro1.jpeg',
              height: 240,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: 400,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color:const Color(0xFF3F4067)),
              ),
              child: const TextField(
                decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF464A7E),
                    ),
                    suffixIcon: Icon(Icons.search),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Padding(padding: EdgeInsets.all(10)),
                 Icon(Icons.museum),
                 Text(
                  'Top 5 Most Popular Musuems',
                  style: TextStyle(
                    color: Color.fromARGB(255, 88, 26, 4),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                  //used for creating scrollable lists or grids of items.
                  scrollDirection: Axis.horizontal,
                  itemCount: jsonResponse.length,
                  itemBuilder: (context, index) {
                   return Card(
                      margin: const EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      clipBehavior: Clip.hardEdge,
                      elevation: 2,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (ctx) {
                           return MuseumGetDetails(
                              ID: jsonResponse[index]['id'],
                              name: jsonResponse[index]['name'],
                            );
                          }));
                        },
                        child: Stack(
                          //stack by default ignores the shape and margin so to enforces this by using clipbehavior
                          children: [
                            FadeInImage(
                              placeholder: MemoryImage(kTransparentImage),
                              image:
                                  NetworkImage(jsonResponse[index]['imageUrl']),

                              fit: BoxFit.cover,
                              // height: 200,
                              width: 200,
                            ),
                            //to make sure that the image is never distorted
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 44),
                                color: Colors.black54, //transparent black color
                                child: Column(
                                  children: [
                                    Text(
                                      jsonResponse[index]['name'],
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ), //to make sure that the text is wraped in a good looking way,overflow if the text passed the chosen lines very long text elipses addes 3 dots after the text which better than suddenly cutting it ioff
                                    // const SizedBox(
                                    //   height: 12,
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ), ////position items above each other image background and a text above it
                      ),
                    );
                  }),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

    // body: ListView(
    //     // This next line does the trick.
    //     scrollDirection: Axis.horizontal,
    //     children: [
    //   for (final musuem in musuemData)
    //     InkWell(
    //       borderRadius: BorderRadius.circular(16),
    //       onTap: () {
    //         selectMusuem(context, musuem);
    //       },
    //       child: Stack(
    //           //stack by default ignores the shape and margin so to enforces this by using clipbehavior
    //           children: [
    //             FadeInImage(
    //               placeholder: MemoryImage(kTransparentImage),
    //               image: AssetImage(musuem.image),
    //               fit: BoxFit.cover,
    //               height: 150,
    //               width: 150,
    //             ),
    //             Positioned(
    //               bottom: 560,
    //               left: 0,
    //               right: 0,
    //               child: Container(
    //                 padding: const EdgeInsets.symmetric(
    //                     vertical: 5, horizontal: 30),
    //                 color: Colors.black54, //transparent black color
    //                 child: Column(
    //                   children: [
    //                     Text(
    //                       musuem.title,
    //                       maxLines: 1,
    //                       textAlign: TextAlign.center,
    //                       softWrap: true,
    //                       overflow: TextOverflow.ellipsis,
    //                       style: const TextStyle(
    //                           fontSize: 14,
    //                           fontWeight: FontWeight.bold,
    //                           color: Colors.white),
    //                     ), //to make sure that the text is wraped in a good looking way,overflow if the text passed the chosen lines very long text elipses addes 3 dots after the text which better than suddenly cutting it ioff
    //                     const SizedBox(
    //                       height: 3,
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ), //to make sure that the image is never distorted
    //           ]),
    //     )
    // ])
  
