/*
 * Copyright (c) 2022, Miika Sikala, Essi Passoja, Lauri Klemettilä
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

import 'package:flutter/material.dart';
import '../auth.dart';
import '../widgets/drawer.dart';
import 'send_emergency_report.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Etusivu')),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () => _openEmergencyReportScreen(context),
          tooltip: 'Tee hätäilmoitus',
          backgroundColor: Colors.red,
          child: const Icon(Icons.support_outlined),
        ),
      );

  void _openEmergencyReportScreen(BuildContext context) async {
    final bool? sure = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(
                  'Oletko varma että haluat lähettää hätäilmoituksen?'),
              content: const Text(
                  'Kun teet hätäilmoituksen, lähimmät aikuiset saavat ilmoituksen, jossa näkyy nimesi, sijaintisi ja muuta tietoa.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Peruuta'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text(
                    'Olen varma',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ));

    // if the user canceled, do nothing
    if (sure == null || !sure || !mounted) return;

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const SendEmergencyReportScreen()));
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
        children: [
          ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Image.asset(
                'assets/logo-2x.png',
                width: 100,
              ),
            ),
            Text(
              'Tervetuloa, ${getAuth(context).user!.name}!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Text(
              'Tähän tulee esimerkiksi organisaatiokohtaista sisältöä, joka voi muuttua päivittäin.',
              textAlign: TextAlign.center,
            ),
            const Divider(),
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
