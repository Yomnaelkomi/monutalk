import 'package:final5/not_used/musuem.dart';
import 'package:final5/screens/aboutUs.dart';
import 'package:final5/screens/categories.dart';
import 'package:final5/screens/contactUs.dart';
import 'package:final5/not_used/favorites_screen.dart';
import 'package:final5/screens/home_screen2.dart';
import 'package:final5/widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({
    super.key,
  });

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
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
    Navigator.pop(context);
    if (identifier == 'home') {
      final result = await Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => const TabsScreen()));
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
      final result = await Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => Categories(
               
              )));
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
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage =const HomeScreen2();
    var activePageTitle = 'Monutalk';
    if (_selectedPageIndex == 1) {
      activePage = Categories()
      ;
      activePageTitle = 'musuems';
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.primary,
            ),
          )
        ],
        // title: Text(activePageTitle,
        //     style: const TextStyle(
        //         color: Colors.brown, fontWeight: FontWeight.bold)),
      ),
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
