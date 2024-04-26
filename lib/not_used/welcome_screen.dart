// import 'package:final5/screens/tabs.dart';
// import 'package:flutter/material.dart';

// class WelcomeScreen extends StatefulWidget {
//   const WelcomeScreen({super.key});

//   @override
//   State<WelcomeScreen> createState() => _WelcomeScreenState();
// }

// class _WelcomeScreenState extends State<WelcomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//           image: DecorationImage(
//               image: AssetImage("assets/images/intropage4.jpeg"),
//               fit: BoxFit.cover,
//               opacity: 0.8)),
//       child: Material(
//         color: Colors.transparent,
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 65, horizontal: 25),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Enjoy',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 35,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 1.5),
//                 ),
//                 const SizedBox(
//                   height: 2,
//                 ),
                
//                 const Text(
//                   'Monutalk',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 35,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 1.5),
//                 ),
//                 const SizedBox(
//                   height: 2,
//                 ),
//                 const Text(
//                   'The World!',
//                   style: TextStyle(
//                       color: Color.fromARGB(184, 255, 255, 255),
//                       fontSize: 30,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 1.5),
//                 ),
//                 const SizedBox(
//                   height: 2,
//                 ),
//                 const Text(
//                   'Best Interactive Musuem Application!',
//                   style: TextStyle(
//                       color: Color.fromARGB(184, 255, 255, 255),
//                       fontSize: 26,
//                       letterSpacing: 1.2),
//                 ),
                
//                 const SizedBox(
//                   height: 30,
//                 ),
//                 InkWell(
//                   onTap: () {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) =>const TabsScreen()));
//                   },
//                   child: Ink(
//                     padding: const EdgeInsets.all(15),
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12)),
//                     child: const Icon(
//                       Icons.arrow_forward_ios,
//                       color: Colors.black54,
//                       size: 20,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

