import 'package:flutter/material.dart';
import '../screens/sidebar.dart';

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({super.key});

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
     appBar : AppBar (
        title: const Text('Minun ilmoitukset'),
        centerTitle : true,
        backgroundColor: const Color.fromARGB(255, 112, 162, 237),
     ),
    drawer: const MyDrawer(),
    body: SafeArea(
      child: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: const Card(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                child: MyReportsContent(),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class MyReportsContent extends StatelessWidget {
  const MyReportsContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
    children: [
      ...[
        const Padding(
          padding: EdgeInsets.all(0),
          child: Text('Et ole vielä tehnyt ilmoituksia.',
          ),
        ),
      ].map((w) => Padding(padding: const EdgeInsets.all(8), child: w)),
    ],
  );
}