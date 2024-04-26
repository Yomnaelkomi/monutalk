import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
      ),
      backgroundColor: const Color(0xffeeeeee),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            Container(
              padding:const EdgeInsets.only(left: 17,top: 10),
              child: const Text(
                        'About Monutalk',
                        style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 26,
                        ),
                      ),
            ),
            Container(
              padding:const EdgeInsets.only(left: 17,top: 10),
              child: const Text(
                'Bringing Statues to Life',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            Container(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  'At Monutalk, we believe statues are more than just stone or metal. They\'re silent storytellers, frozen moments in history waiting to be unraveled. But sometimes, the stories they hold can be a mystery. That\'s where we come in We are a team of passionate history buffs and tech enthusiasts who developed Monutalk, a revolutionary tourist app designed to bring statues to life for curious explorers like you.',
                  style: TextStyle(letterSpacing: 0.1, fontSize: 15),
                )),
                Container(
              padding:const EdgeInsets.only(left: 17,top: 10),
              child: const Text(
                'Your Pocket-Sized Virtual Guide',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            Container(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  'Ditch the bulky guidebooks and forget struggling to remember obscure statue names. Monutalk puts a friendly virtual guide right in your pocket, accessible through your smartphone. This digital companion will be your personal museum and outdoor sculpture park expert, ready to unveil the fascinating stories behind the statues you encounter.',
                  style: TextStyle(letterSpacing: 0.1, fontSize: 15),
                )),
                Container(
              padding:const EdgeInsets.only(left: 17,top: 10),
              child: const Text(
                'Explore at Your Own Pace',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            Container(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  'Monutalk empowers you to explore independently. No more following rigid tour schedules!  Intrigued by a particular statue? Simply snap a picture using the app, and our powerful image recognition technology will identify it. Monutalk will then unlock a treasure trove of information, from the statue\'s creation date and sculptor to its historical significance and hidden meanings.',
                  style: TextStyle(letterSpacing: 0.1, fontSize: 15),
                )),
                Container(
              padding:const EdgeInsets.only(left: 17,top: 10),
              child: const Text(
                'Ask Me Anything (Virtually!)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,

                ),
              ),
            ),
            Container(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  'Monutalk isn\'t just about one-way information. We believe in interactive learning. Our virtual guide is always happy to chat and answer your questions in real-time.  Curious about the symbolism behind a pose or the inspiration for a particular statue? Just ask! The more you delve deeper, the richer your understanding and appreciation will become.',
                  style: TextStyle(letterSpacing: 0.1, fontSize: 15),
                )),
                Container(
              padding:const EdgeInsets.only(left: 17,top: 10,right: 2),
              child: const Text(
                'Monutalk: More Than Just an App',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            Container(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  'We\'re passionate about making travel enriching and engaging. Monutalk is more than just an app; it\'s a gateway to a deeper understanding of art, history, and culture.',
                  style: TextStyle(letterSpacing: 0.1, fontSize: 15),
                )),
                Container(
              padding:const EdgeInsets.only(left: 17,top: 10),
              child: const Text(
                'Join the Monutalk Community',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            Container(
              margin:const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(20),
                child: const Text(
                  'Download Monutalk today and embark on a journey of discovery alongside your virtual guide. Let\'s turn those silent statues into captivating narratives, together.',
                  style: TextStyle(letterSpacing: 0.1, fontSize: 15),
                )),
          ],
        ),
      ),
    );
  }
}
