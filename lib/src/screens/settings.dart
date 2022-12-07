/*
 * Copyright (c) 2022, Miika Sikala, Essi Passoja, Lauri Klemettilä
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

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
            ElevatedButton.icon(
              icon: const Icon(Icons.logout_outlined),
              onPressed: () {
                PoliisiautoAuthScope.of(context).signOut();
              },
              label: const Text('Kirjaudu ulos'),
            ),
          ].map((w) => Padding(padding: const EdgeInsets.all(8), child: w)),
        ],
      );
}
