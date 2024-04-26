// //post app bar for the musuems details Screen
// import 'package:final5/models/musuem.dart';
// import 'package:flutter/material.dart';

// class PostAppBar extends StatefulWidget {
//   const PostAppBar(
//       {super.key,
//       required this.ontoggleFavorite,
//       required this.musuem,
//       required this.favoriteMusuems});
//   final void Function(Musuem musuem) ontoggleFavorite;
//   final Musuem musuem;
//   final List<Musuem> favoriteMusuems;

//   @override
//   State<PostAppBar> createState() => _PostAppBarState();
// }

// class _PostAppBarState extends State<PostAppBar>
//     with SingleTickerProviderStateMixin {
//   late AnimationController controller;
//   late Animation<double> animation;

//   @override
//   void initState() {
//     super.initState();
//     controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 300),
//     );
    
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isfavorite = widget.favoriteMusuems.contains(widget.musuem);
//     return Padding(
//       padding: const EdgeInsets.all(20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           InkWell(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(15),
//                   boxShadow: const [
//                     BoxShadow(color: Colors.white, blurRadius: 6)
//                   ]),
//               child: const Icon(
//                 Icons.arrow_back,
//                 size: 28,
//               ),
              
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.all(3),
//             decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(15),
//                 boxShadow: const [
//                   BoxShadow(color: Colors.white, blurRadius: 6)
//                 ]),
//             child: IconButton(
//                 onPressed: () {
//                   widget.ontoggleFavorite(widget.musuem);
//                 },
//                 icon: AnimatedSwitcher(
//                     duration: const Duration(milliseconds: 300),
//                     transitionBuilder: (child, animation) {
//                       return  RotationTransition(
//                         turns: Tween(begin: 0.8, end: 1.0).animate(animation),
//                         child: child,
//                       );
//                     },
                    
//                     child:  Icon(
                      
//                       isfavorite ? Icons.star : Icons.star_border,
//                       key: ValueKey(isfavorite),
//                     ))),
//           ),
//         ],
//       ),
//     );
//   }
// }
