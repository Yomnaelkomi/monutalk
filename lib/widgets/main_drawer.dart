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
            Icons.account_box,
            size: 26,
          ),
          title:const Text('My Account'),
          onTap: () {
            onSelectscreen('My Account');
          },
        ),
        ListTile(
          leading:const Icon(
            Icons.home,
            size: 26,
          ),
          title:const Text('HOME'),
          onTap: () {
            onSelectscreen('HOME');
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
        ListTile(
          leading:const Icon(
            Icons.tab,
            size: 26,
          ),
          title:const Text('My tickets'),
          onTap: () {
            onSelectscreen('My tickets');
          },
        ),
        ListTile(
          leading:const Icon(
            Icons.camera,
            size: 26,
          ),
          title:const Text('Camera'),
          onTap: () {
            onSelectscreen('Camera');
          },
        ),
        ListTile(
          leading:const Icon(
            Icons.recommend,
            size: 26,
          ),
          title:const Text('Recommendations'),
          onTap: () {
            onSelectscreen('Recommendations');
          },
        ),
        ListTile(
          leading:const Icon(
            Icons.mic,
            size: 26,
          ),
          title:const Text('Talk to Me'),
          onTap: () {
            onSelectscreen('Talk to Me');
          },
        ),
        ListTile(
          leading:const Icon(
            Icons.chat_rounded,
            size: 26,
          ),
          title:const Text('Chat with Me'),
          onTap: () {
            onSelectscreen('Chat with Me');
          },
        ),
      ]),
    );
  }
}
