// //post bottom bar for the musuem details Screen
// import 'package:final5/models/musuem.dart';
// import 'package:final5/screens/book_now.dart';

// import 'package:flutter/material.dart';

// class PostBottomBar extends StatelessWidget {
//   const PostBottomBar({super.key, required this.musuem});
//   final Musuem musuem;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height / 1.8,
//       padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
//       decoration: const BoxDecoration(
//           color: Color(0xFFEDF2F6),
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(40),
//             topRight: Radius.circular(40),
//           )),
//       child: ListView(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       musuem.name,
//                       style: const TextStyle(
//                           fontSize: 23, fontWeight: FontWeight.w600),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 25,
//                 ),
//                 Text(
//                   musuem.name,
//                   style: const TextStyle(color: Colors.black54, fontSize: 16),
//                   textAlign: TextAlign.justify,
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Row(
//                   children: [
//                     const SizedBox(
//                       width: 230,
//                     ),
//                     const Padding(padding: EdgeInsets.only(right: 5)),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         ElevatedButton(
//                           onPressed: () {
//                             Navigator.push(context,
//                                 MaterialPageRoute(builder: (context) {
//                               return BookNowScreen();
//                             }));
//                           },
//                           child: const Text(
//                             'Book Now',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         ElevatedButton(
//                           onPressed: () {},
//                           child: const Text(
//                             'Explore',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
