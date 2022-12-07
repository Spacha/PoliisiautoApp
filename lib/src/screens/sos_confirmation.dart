// Copyright 2022, Poliisiauto developers.

import 'package:flutter/material.dart';
import '../routing.dart';

class SOSConfirmationScreen extends StatefulWidget {
  const SOSConfirmationScreen({
    super.key,
  });

  @override
  State<SOSConfirmationScreen> createState() => _SOSConfirmationScreenState();
}

class _SOSConfirmationScreenState extends State<SOSConfirmationScreen> {
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
                  const Padding(
                    padding: EdgeInsets.all(0),
                    child: Text(
                      'Klikkaa painiketta\nuudelleen jos\nhaluat lähettää\nSOS -ilmoituksen',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 80, bottom: 50),
                    child: ElevatedButton(
                      onPressed: () {
                        RouteStateScope.of(context).go('/sending_sos');
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(80),
                        backgroundColor: const Color.fromARGB(255, 158, 29, 20),
                        textStyle: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      child: const Text('SOS'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: OutlinedButton(
                      onPressed: () async {
                        RouteStateScope.of(context).go('/home');
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        primary: Colors.white,
                        backgroundColor: Theme.of(context).primaryColor,
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Peruuta'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
