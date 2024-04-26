// import 'package:final5/models/musuem.dart';
// import 'package:flutter/material.dart';
// import 'package:transparent_image/transparent_image.dart';

// class MusuemsF extends StatelessWidget {
//   const MusuemsF(
//       {super.key, required this.musuem, required this.onSelectMusuem});
//   final Musuem musuem;
//   final void Function(Musuem musuem) onSelectMusuem;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.all(8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       clipBehavior: Clip.hardEdge,
//       elevation: 2,
//       child: InkWell(
//         onTap: () {
//           onSelectMusuem(musuem);
//         },
//         child: Stack(
//           //stack by default ignores the shape and margin so to enforces this by using clipbehavior
//           children: [
//             FadeInImage(
//               placeholder: MemoryImage(kTransparentImage),
//               image: AssetImage(musuem.imageUrl),
//               fit: BoxFit.cover,
//                height: 200,
//               width: double.infinity,
//             ), //to make sure that the image is never distorted
//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: Container(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 5, horizontal: 44),
//                 color: Colors.black54, //transparent black color
//                 child: Column(
//                   children: [
//                     Text(
//                       musuem.name,
//                       maxLines: 2,
//                       textAlign: TextAlign.center,
//                       softWrap: true,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white),
//                     ), //to make sure that the text is wraped in a good looking way,overflow if the text passed the chosen lines very long text elipses addes 3 dots after the text which better than suddenly cutting it ioff
//                     // const SizedBox(
//                     //   height: 12,
//                     // ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ), ////position items above each other image background and a text above it
//       ),
//     );
//   }
// }
