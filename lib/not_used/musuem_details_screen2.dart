// import 'package:final5/models/musuem.dart';
// import 'package:final5/screens/test.dart';
// import 'package:final5/widgets/post_app_bar.dart';
// import 'package:final5/widgets/post_bottom_bar.dart';
// import 'package:flutter/material.dart';
// import 'dart:io';

// class MusuemDetailsScreen extends StatelessWidget {
//    const MusuemDetailsScreen(
//       {super.key,

//       required this.musuem,
//       required this.ontoggleFavorite,
//       required this.favoriteMusuems,
//       });
//   final void Function(Musuem musuem) ontoggleFavorite;
//   final Musuem musuem;
  
//   final List<Musuem> favoriteMusuems;
//   void go(BuildContext context) {
//     Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const Test()));
//   }

//   @override
//   Widget build(BuildContext context) {
//     File? selectedImage;
//     return Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(musuem.imageUrl),
//             fit: BoxFit.cover,
//             opacity: 0.7,
//           ),
//         ),
//         child: Scaffold(
//           backgroundColor: Colors.transparent,
//           appBar: PreferredSize(
//               preferredSize: const Size.fromHeight(90),
//               child: PostAppBar(
//                 ontoggleFavorite: ontoggleFavorite,
//                 musuem: musuem,
//                 favoriteMusuems: favoriteMusuems,
//               )),
//           bottomNavigationBar: PostBottomBar(
//             musuem: musuem,
//           ),
//           body: Container(
//               margin: const EdgeInsets.only(left: 16),
//               padding: const EdgeInsets.all(3),
//               decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(13),
//                   boxShadow: const [
//                     BoxShadow(color: Colors.white, blurRadius: 6)
//                   ]),
//               child: IconButton(
//                   icon: const Icon(Icons.camera),
//                   onPressed: () {
//                     go(context);
//                   })),
//         ));
//   }
// }
