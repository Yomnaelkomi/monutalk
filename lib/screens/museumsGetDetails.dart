// import 'package:final5/screens/explore_architects.dart';
// import 'package:final5/screens/reviews.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:final5/screens/book_now.dart';
// import 'package:final5/screens/test.dart';

// class MuseumGetDetails extends StatefulWidget {
//   final String ID;
//   final String name;
//   final UID;

//   const MuseumGetDetails(
//       {super.key, required this.ID, required this.name, required this.UID});

//   @override
//   State<MuseumGetDetails> createState() => _MuseumGetDetailsState();
// }

// class _MuseumGetDetailsState extends State<MuseumGetDetails> {
//   double rating = 0;
//   var jsonResponse;
//   var jsonResponseID;
//   bool isLoading = true;
//   String errorMessage = '';

//   @override
//   void initState() {
//     super.initState();
//     fetchPost();
//   }

//   void go(BuildContext context) {
//     Navigator.of(context)
//         .push(MaterialPageRoute(builder: (ctx) => const Test()));
//   }

//   Future<void> fetchPost() async {
//     try {
//       final uri = Uri.parse(
//           'https://monu-talk-production.up.railway.app/museums/${widget.ID}');
//       final response = await http.get(uri);
//       if (response.statusCode == 200) {
//         setState(() {
//           jsonResponse = json.decode(response.body);
//           jsonResponseID = jsonResponse['id'];
//           print('jsonnnnnnnnn $jsonResponseID');
//           isLoading = false;
//         });
//       } else {
//         throw Exception('Failed to load museum data');
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = e.toString();
//         isLoading = false;
//       });
//     }
//   }

//   // Your existing implementation of the content goes here, using jsonResponse to populate data
//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Scaffold(
//         body: Center(
//           child:
//               CircularProgressIndicator(), // Show loading indicator while data is loading
//         ),
//       );
//     }

//     if (errorMessage.isNotEmpty) {
//       return Scaffold(
//         body: Center(
//           child: Text('Error: $errorMessage'), // Show error message if any
//         ),
//       );
//     }

//     // Ensure jsonResponse is not null and has required data before accessing
//     if (jsonResponse == null ||
//         !jsonResponse.containsKey('imageUrl') ||
//         !jsonResponse.containsKey('name') ||
//         !jsonResponse.containsKey('description')) {
//       return const Scaffold(
//         body: Center(
//           child: Text(
//               'Data is incomplete or not available'), // Handle case where data may be incomplete
//         ),
//       );
//     }

//     // Existing implementation with safely checked jsonResponse
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: NetworkImage(jsonResponse['imageUrl']),
//             fit: BoxFit.cover,
//             opacity: 0.7,
//           ),
//         ),
//         child: Scaffold(
//             backgroundColor: Colors.transparent,
//             appBar: PreferredSize(
//                 preferredSize: const Size.fromHeight(90),
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 40),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           Navigator.pop(context);
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.all(10),
//                           // decoration: BoxDecoration(
//                           //     color: Colors.white,
//                           //     borderRadius: BorderRadius.circular(15),
//                           //     boxShadow: const [
//                           //       BoxShadow(color: Colors.white, blurRadius: 6)
//                           //     ]),
//                           child: const Icon(
//                             Icons.arrow_back,
//                             size: 28,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       Container(
//                           margin: const EdgeInsets.only(left: 16),
//                           padding: const EdgeInsets.all(3),
//                           child: IconButton(
//                               icon: const Icon(
//                                 Icons.camera,
//                                 color: Colors.white,
//                               ),
//                               onPressed: () {
//                                 go(context);
//                               })),
//                     ],
//                   ),
//                 )),
//             bottomNavigationBar: Container(
//               height: MediaQuery.of(context).size.height / 1.8,
//               padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
//               decoration: const BoxDecoration(
//                   color: Color(0xFFEDF2F6),
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(40),
//                     topRight: Radius.circular(40),
//                   )),
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.only(bottom: 150),
//                 child: Padding(
//                   padding: const EdgeInsets.only(),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Text(
//                         jsonResponse['name'],
//                         style: const TextStyle(
//                             fontSize: 23, fontWeight: FontWeight.w600),
//                       ),
//                       const SizedBox(
//                         height: 5,
//                       ),
//                       Text(
//                         jsonResponse['description'],
//                         style: const TextStyle(
//                             color: Colors.black54, fontSize: 16),
//                         textAlign: TextAlign.justify,
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Container(margin: const EdgeInsets.only(left: 20), child: const Text("Reviews",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
//                             const SizedBox(width: 160,),
//                             TextButton(
                              
//                               onPressed: () {
//                                 Navigator.push(context,
//                                     MaterialPageRoute(builder: (ctx) {
//                                   return Reviews(
//                                       UID: widget.UID, MuseumID: widget.ID);
//                                 }));
//                               },
                              
//                               child: const Text(
//                                 'View All',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Color.fromARGB(255, 71, 133, 232),
//                                 ),
//                               ),
//                             ),
//                             // ElevatedButton(
//                             //     onPressed: () {
//                             //       Navigator.push(context,
//                             //           MaterialPageRoute(builder: (ctx) {
//                             //         return Reviews(
//                             //             UID: widget.UID, MuseumID: widget.ID);
//                             //       }));
//                             //     },
//                             // child: const Text(
//                             //   'Reviews',
//                             //   style: TextStyle(
//                             //     fontWeight: FontWeight.bold,
//                             //     color: Colors.black,
//                             //   ),
//                             // ),
//                           ]),

//                       const SizedBox(
//                         height: 40,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           // Add a SizedBox to create space between elements
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Container(
//                                 margin: const EdgeInsets.only(left: 10),
//                                 width: 225,
//                                 child: ElevatedButton(
//                                   onPressed: () {
//                                     Navigator.push(context,
//                                         MaterialPageRoute(builder: (context) {
//                                       return BookNowScreen(
//                                         MusuemId: jsonResponseID,
//                                         UID: widget.UID,
//                                       );
//                                     }));
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: const Color.fromARGB(255, 6, 118, 28),
//                                   ),
//                                   child: const Text(
//                                     'Book Now',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: Color.fromARGB(255, 248, 245, 245),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(
//                                   width:
//                                       10), // Add a SizedBox to create space between buttons
//                               ElevatedButton(
//                                 onPressed: () {
//                                   Navigator.push(context,
//                                       MaterialPageRoute(builder: (ctx) {
//                                     return ExploreArch(MuseumID: widget.ID);
//                                   }));
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                     backgroundColor: const Color.fromARGB(255, 91, 8, 106)),
//                                 child: const Text(
//                                   'Explore',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: Color.fromARGB(255, 244, 240, 240),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       // const SizedBox(
//                       //   height: 15,
//                       // ),
//                       // Row(
//                       //   mainAxisAlignment: MainAxisAlignment.start,
//                       //   children: [
//                       //     ElevatedButton(
//                       //         onPressed: () {
//                       //           Navigator.push(context,
//                       //               MaterialPageRoute(builder: (ctx) {
//                       //             return Reviews(
//                       //                 UID: widget.UID, MuseumID: widget.ID);
//                       //           }));
//                       //         },
//                       //         child: const Text(
//                       //           'Reviews',
//                       //           style: TextStyle(
//                       //             fontWeight: FontWeight.bold,
//                       //             color: Colors.black,
//                       //           ),
//                       //         )),
//                       // const SizedBox(
//                       //   width: 20,
//                       // ),
//                       // RatingBar.builder(
//                       //   initialRating: 0,
//                       //   minRating: 1,
//                       //   direction: Axis.horizontal,
//                       //   allowHalfRating: true,
//                       //   itemCount: 5,
//                       //   updateOnDrag: true,
//                       //   itemPadding:
//                       //       const EdgeInsets.symmetric(horizontal: 4),
//                       //   itemBuilder: (context, _) => const Icon(
//                       //     Icons.star,
//                       //     color: Colors.amber,
//                       //   ),
//                       //   onRatingUpdate: (rating) {
//                       //     setState(() {
//                       //       this.rating = rating;
//                       //     });
//                       //   },
//                       // ),
//                     ],
//                   ),
//                 ),
//               ),
//             )),
//       ),
//     );
//   }
// }
// // Rest of your widget implementation that uses jsonResponse...


   