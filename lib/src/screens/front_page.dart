import 'package:flutter/material.dart';
import '../routing.dart';

class Buttons {
  final bool signInButton;

  Buttons(this.signInButton);
}
class FrontPageScreen extends StatefulWidget {
  final ValueChanged<Buttons> onFrontPage;

  const FrontPageScreen({
    required this.onFrontPage,
    super.key,
  });

  @override
  State<FrontPageScreen> createState() => _FrontPageScreenState();
}

class _FrontPageScreenState extends State<FrontPageScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Card(
            child: Container(
              constraints: BoxConstraints.loose(const Size(600, 600)),
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "graphics/logo-text-1x.png",
                    height: 200,
                    width: 200,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 80, bottom: 50),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(80),
                        backgroundColor: const Color.fromARGB(255, 158, 29, 20),
                        textStyle: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      child: const Text('SOS'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: OutlinedButton(
                      onPressed: () async {RouteStateScope.of(context).go('/signin');},
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        primary: Colors.white,
                        backgroundColor: const Color.fromARGB(255, 97, 144, 184),
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Kirjaudu sisään'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
