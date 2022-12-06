import 'package:flutter/material.dart';
import '../routing.dart';

class SendingSOSScreen extends StatefulWidget {
  const SendingSOSScreen({
    super.key,
  });

  @override
  State<SendingSOSScreen> createState() => _SendingSOSScreenState();
}

class _SendingSOSScreenState extends State<SendingSOSScreen> {
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
                child: Text('SOS ilmoitusta lähetetään',
                ),
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
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text('Sijaintiasi lähetetään\nlähimmille opettajille',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: OutlinedButton(
                  onPressed: () async {},
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    primary: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 112, 162, 237),
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('Paina tästä lähettääksesi\n     ääninäyte tai video'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0),
                child: OutlinedButton(
                  onPressed: () async {RouteStateScope.of(context).go('/home');},
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    primary: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 112, 162, 237),
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('   Lopeta lähetys   '),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}