// Copyright 2022, Poliisiauto developers.

import 'package:flutter/material.dart';
import '../auth.dart';
import '../widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Tervetuloa!')),
        drawer: const PoliisiautoDrawer(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: double.infinity),
                /*child: const Card(
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                    child: HomeContent()),
              ),*/
                child: const HomeContent(),
              ),
            ),
          ),
        ),
      );
}

class HomeContent extends StatelessWidget {
  const HomeContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Image.asset('assets/images/stock-image-classroom.jpg',
              fit: BoxFit.contain),
          ...[
            Text(
              'Tervetuloa, ${getAuth(context).user!.name}!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Text(
              'This is a sample page with some weird sample and debugging content.',
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () {
                getAuth(context).signOut();
              },
              child: const Text('Kirjaudu ulos'),
            ),
          ].map((w) => Padding(padding: const EdgeInsets.all(8), child: w)),
        ],
      );
}
