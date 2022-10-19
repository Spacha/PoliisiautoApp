import 'package:flutter/material.dart';

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
                  Text('Kirjaudu sisään',
                  style: Theme.of(context).textTheme.headlineMedium),
                  Image.asset(
                    "graphics/logo-text-1x.png",
                    height: 200,
                    width: 200,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextButton(
                      onPressed: () async {},
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

