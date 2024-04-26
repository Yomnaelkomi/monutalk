// import 'package:final5/models/musuem.dart';
// import 'package:flutter/material.dart';

// class MusuemDetailsPage extends StatelessWidget {
//   const MusuemDetailsPage({super.key, required this.musuem,required this.ontoggleFavorite});
//   final Musuem musuem;
//   final void Function(Musuem musuem) ontoggleFavorite;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [IconButton(
//               onPressed: () {
//                 ontoggleFavorite(musuem);
//               },
//               icon: const Icon(Icons.star))],
//         title: Text(
//           musuem.title,
//           style: const TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Image.asset(
//             musuem.image,
//             fit: BoxFit.cover,
//             height: 300,
//             width: double.infinity,
//           ),
//           Container(
//             margin: const EdgeInsets.all(10),
//             child: Text(
//               musuem.info,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 letterSpacing: 1.2,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
