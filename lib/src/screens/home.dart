// Copyright 2022, Poliisiauto developers.

import 'package:flutter/material.dart';
import '../auth.dart';
import '../widgets/drawer.dart';
import '../routing.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Etusivu'),
      centerTitle : true,
      backgroundColor: const Color.fromARGB(255, 112, 162, 237),
      ),
    drawer: const PoliisiautoDrawer(),
    body: SafeArea(
      child: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: double.infinity),
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
      ...[
        Image.asset('assets/logo-2x.png',
          height: 200,
          width: 200,
        ),
        
        Text(
          'Tervetuloa, ${getAuth(context).user!.name}!',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        // TODO: SOS button only for children --> separate screen(?)
        // Below is also a working option for a floating SOS button, that will
        // be located in the bottom right corner.
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: ElevatedButton(
            onPressed: () {RouteStateScope.of(context).go('/sos_confirmation');},
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(60),
              backgroundColor: const Color.fromARGB(255, 158, 29, 20),
              textStyle: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold
              ),
            ),
            child: const Text('SOS'),
          ),
        ),
        const Text(
          'Tähän tulee esimerkiksi organisaatiokohtaista sisältöä, joka voi '
          'muuttua päivittäin.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 70),
        const Divider(),
        ElevatedButton(
          onPressed: () {
            getAuth(context).signOut();
          },
          child: const Text('Kirjaudu ulos'),
        ),
        // Make a floating SOS button on the right bottom corner:
        /*Padding(padding: const EdgeInsets.only(top: 50),
          child: Align(
          alignment: const Alignment(0.75, 1.0), 
          child: FloatingActionButton(
            onPressed: () {RouteStateScope.of(context).go('/sos_confirmation');},
            backgroundColor: const Color.fromARGB(255, 158, 29, 20),
            heroTag: null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            tooltip: 'Lähetä SOS ilmoitus lähellä oleville aikuisille.',
            enableFeedback: true,
            autofocus: true,
            focusNode: FocusNode(),
            child: const Text('SOS'),
          ),
        ),
      ),*/
      ].map((w) => Padding(padding: const EdgeInsets.all(8), child: w)),
      ],
  );
}
