// import 'package:final5/models/musuem.dart';
// import 'package:final5/screens/musuem_details_screen2.dart';
// // import 'package:final5/screens/musuems.dart';
// import 'package:final5/screens/musuemsF.dart';
// import 'package:flutter/material.dart';

// class FavoritesScreen extends StatefulWidget {
//   const FavoritesScreen({
//     super.key,
//     required this.favoriteMusuems,
//     required this.ontoggleFavorite,
//     this.title,
//   });
//   final List<Musuem> favoriteMusuems;

//   final void Function(Musuem musuem) ontoggleFavorite;
//   final String? title;

//   @override
//   State<FavoritesScreen> createState() => _FavoritesScreenState();
// }

// class _FavoritesScreenState extends State<FavoritesScreen> {
//   void selectMusuem(BuildContext context, Musuem musuem) {
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (ctx) => MusuemDetailsScreen(
//                   musuem: musuem,
//                   ontoggleFavorite: widget.ontoggleFavorite,
//                   favoriteMusuems: widget.favoriteMusuems,
//                 )));
//   }

//   @override
//   Widget build(BuildContext context) {
//     Widget content = Scaffold(
//       body: ListView.builder(
//           physics: const NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           itemCount: widget.favoriteMusuems.length,
//           itemBuilder: ((ctx, index) => MusuemsF(
//               musuem: widget.favoriteMusuems[index],
//               onSelectMusuem: (musuem) {
//                 selectMusuem(context, musuem);
//               }))),
//     );
//     if (widget.favoriteMusuems.isEmpty) {
//       content = Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'uhoh...nothing here!',
//               style: Theme.of(context)
//                   .textTheme
//                   .headlineLarge!
//                   .copyWith(color: Theme.of(context).colorScheme.onBackground),
//             ),
//             const SizedBox(
//               height: 16,
//             ),
//             Text(
//               'try adding some fav musuems',
//               style: Theme.of(context)
//                   .textTheme
//                   .bodyLarge!
//                   .copyWith(color: Theme.of(context).colorScheme.onBackground),
//             )
//           ],
//         ),
//       );
//     }

//     return Scaffold(
//       body: Container(padding: const EdgeInsets.only(top: 20), child: content),
//     );
//   }
// }
