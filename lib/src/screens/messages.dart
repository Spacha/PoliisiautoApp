import 'package:flutter/material.dart';
import '../screens/sidebar.dart';

class MyMessagesScreen extends StatefulWidget {
  const MyMessagesScreen({super.key});

  @override
  State<MyMessagesScreen> createState() => _MyMessagesScreenState();
}

class _MyMessagesScreenState extends State<MyMessagesScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
     appBar : AppBar (
        title: const Text('Viestit'),
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
                child: MyMessagesContent(),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class MyMessagesContent extends StatelessWidget {
  const MyMessagesContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
    children: [
      ...[
        const Padding(
          padding: EdgeInsets.all(0),
          child: Text('Ei näytettäviä viestejä.',
          ),
        ),
      ].map((w) => Padding(padding: const EdgeInsets.all(8), child: w)),
    ],
  );
}