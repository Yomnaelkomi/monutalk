import 'package:final5/screens/aboutUs.dart';
import 'package:final5/screens/authentication_screen.dart';
import 'package:final5/screens/categories.dart';
import 'package:final5/screens/contactUs.dart';
import 'package:final5/screens/home_screen2.dart';
import 'package:final5/screens/my_account.dart';
import 'package:final5/screens/my_purchases.dart';
import 'package:final5/screens/recommendation_system_screen.dart';
import 'package:final5/screens/test.dart';
import 'package:final5/screens/tickets.dart';
import 'package:final5/screens/tickets2_screen.dart';
import 'package:final5/widgets/image_input.dart';
import 'package:final5/widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key, required this.UID});
  final UID;

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int _selectedPageIndex = 0;

  // File? _selectedImage;

  void _showInfoMsg(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));

    
  }
  // final List<Musuem> _favoriteMusuem = [];
  // void _toggleMusuemFavoriteStatus(Musuem musuem) {
  //   final isExisting = _favoriteMusuem.contains(musuem);

  //   if (isExisting) {
  //     setState(() {
  //       _favoriteMusuem.remove(musuem);
  //     });
  //     _showInfoMsg('Musuem is no longer a favorite.');
  //   } else {
  //     setState(() {
  //       _favoriteMusuem.add(musuem);
  //     });
  //     _showInfoMsg('Marked as a favorite.');
  //   }
  // }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }
 

  void _setScreen(String identifier) async {
    
    Get.back();
    if (identifier == 'home') {
      final result = await Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) =>  TabsScreen(UID: widget.UID,)));
      print(result);
    }
    // if (identifier == 'favorites') {
    //   final result = await Navigator.of(context).push(MaterialPageRoute(
    //       builder: (ctx) => FavoritesScreen(
    //             favoriteMusuems: _favoriteMusuem,
    //             ontoggleFavorite: _toggleMusuemFavoriteStatus,
    //           )));
    //   print(result);
    // }
    if (identifier == 'Musuems') {
      final result = await Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => Categories(UID: widget.UID,)));
      print(result);
    }
    if (identifier == 'Contact Us') {
      final result = await Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => const ContactUsScreen()));
      print(result);
    }
    if (identifier == 'About Us') {
      final result = await Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => const AboutUsScreen()));
      print(result);
    }
    if (identifier == 'My tickets') {
      final result = await Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) =>  Ticket2Screen(UID: widget.UID,)));
      print(result);
    }
    if (identifier == 'My Account') {
      final result = await Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => MyAccountPage(UID: widget.UID,)));
      print(result);
    }
    if (identifier == 'Camera') {
      final result = await Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => Test()));
      print(result);
    }
    if (identifier == 'Recommendations') {
      final result = await Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => RecommendationSystemScreen()));
      print(result);
    }
    
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage =  HomeScreen2(UID: widget.UID,);
    var activePageTitle = 'Monutalk';
    if (_selectedPageIndex == 1) {
      activePage = Categories(UID: widget.UID,);
      activePageTitle = 'musuems';
    }
    

    return Scaffold(
      appBar: AppBar(actions: [
        TextButton(
            onPressed: () async {
              final SharedPreferences prefs = await _prefs;
              prefs.clear();
              Get.offAll(const AuthenticationScreen());
              
            },
            child: const Text(
              'logout',
              style: TextStyle(color: Color.fromARGB(255, 2, 0, 0)),
            ))
      ]),
      drawer: MainDrawer(
        onSelectscreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.museum), label: 'Musuems'),
         
        ],
      ),
    );
  }
}
