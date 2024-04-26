// import 'package:final5/screens/musuem_details_screen2.dart';
// import 'package:flutter/material.dart';
// import 'package:final5/data/musuem_data.dart';
// import 'package:final5/screens/musuems.dart';
// import 'package:final5/models/musuem.dart';

// // void selectMusuem(BuildContext context, Musuem musuem) {
// //   Navigator.push(context,
// //       MaterialPageRoute(builder: (ctx) => MusuemDetailsPage(musuem: musuem,)));
// // }

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key, required this.ontoggleFavorite,required this.favoriteMusuems});
//   final void Function(Musuem musuem) ontoggleFavorite;
//   final List<Musuem> favoriteMusuems;

//   void selectMusuem(BuildContext context, Musuem musuem) {
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (ctx) => MusuemDetailsScreen(
//                   musuem: musuem,
//                   ontoggleFavorite: ontoggleFavorite,
//                   favoriteMusuems: favoriteMusuems,
                  
//                 )));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: Color.fromARGB(255, 212, 189, 181),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 30),
//           child: SingleChildScrollView(
//             child: Column(children: [
//               Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       height: 200,
//                       child: ListView.builder(
//                           itemCount: 6,
//                           scrollDirection: Axis.horizontal,
//                           shrinkWrap: true,
//                           itemBuilder: (context, index) {
//                             return SingleChildScrollView(
//                               child: Container(
//                                 width: 160,
//                                 height: 250,
//                                 padding: const EdgeInsets.all(20),
//                                 margin: const EdgeInsets.only(left: 15),
//                                 decoration: BoxDecoration(
//                                   color: Colors.black,
//                                   borderRadius: BorderRadius.circular(15),
//                                   image: DecorationImage(
//                                     image: AssetImage(
//                                         'assets/images/p${index + 1}.jpeg'),
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 40,
//               ),
//               const Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(padding: EdgeInsets.all(10)),
//                   Icon(Icons.museum),
//                   Text(
//                     'Top 5 Most Popular Musuems',
//                     style: TextStyle(
//                       color: Color.fromARGB(255, 88, 26, 4),
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
              
                  
//                   ListView.builder(
//                       physics: const NeverScrollableScrollPhysics(),
//                       shrinkWrap: true,
//                       itemCount: musuemData.length,
//                       itemBuilder: ((ctx, index) => Musuems(
//                           musuem: musuemData[index],
//                           onSelectMusuem: (musuem) {
//                             selectMusuem(context, musuem);
//                           }))),
//                 ]),
//               ),
//             ),
//           ),
        
      
//     );
//   }
// }
