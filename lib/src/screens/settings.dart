// Copyright 2022, Poliisiauto developers.

import 'package:flutter/material.dart';

import '../auth.dart';
import '../widgets/drawer.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Asetukset')),
        drawer: const PoliisiautoDrawer(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: double.infinity),
                child: const SettingsContent(),
              ),
            ),
          ),
        ),
      );
}

class SettingsContent extends StatelessWidget {
  const SettingsContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
        children: [
          ...[
            Text(
              'Minun asetukset',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Text('Ei vielä implementoitu.'),
            ElevatedButton(
              onPressed: () {
                PoliisiautoAuthScope.of(context).signOut();
              },
              child: const Text('Kirjaudu ulos'),
            ),
          ].map((w) => Padding(padding: const EdgeInsets.all(8), child: w)),
        ],
      );
}
