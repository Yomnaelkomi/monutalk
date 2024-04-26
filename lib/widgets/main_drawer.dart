import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, required this.onSelectscreen});
  final void Function(String identifier) onSelectscreen;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        DrawerHeader(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromARGB(255, 207, 148, 72),
            Color.fromARGB(255, 216, 158, 83),
            Color.fromARGB(255, 218, 179, 128),
          ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
          child: Row(
            children: [
              const Icon(
                Icons.museum,
                size: 50,
                color: Colors.white,
              ),
              const SizedBox(
                width: 18,
              ),
              Text(
                'Monutalk',
                style: GoogleFonts.anekLatin(
                    fontSize: 30,
                    color: Colors.brown,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        ListTile(
          leading:const Icon(
            Icons.home,
            size: 26,
          ),
          title:const Text('home'),
          onTap: () {
            onSelectscreen('home');
          },
        ),
        ListTile(
          leading:const Icon(
            Icons.museum_sharp,
            size: 26,
          ),
          title:const Text('Musuems'),
          onTap: () {
            onSelectscreen('Musuems');
          },
        ),
        ListTile(
          leading:const Icon(
            Icons.contact_phone,
            size: 26,
          ),
          title:const Text('Contact Us'),
          onTap: () {
            onSelectscreen('Contact Us');
          },
        ),
        ListTile(
          leading:const Icon(
            Icons.info,
            size: 26,
          ),
          title:const Text('About Us'),
          onTap: () {
            onSelectscreen('About Us');
          },
        ),
      ]),
    );
  }
}
