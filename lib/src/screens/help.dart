// Copyright 2022, Poliisiauto developers.

import 'package:flutter/material.dart';
import '../widgets/drawer.dart';
import '../data.dart';
import '../api.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Apua')),
      drawer: const PoliisiautoDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: double.infinity),
              child: const Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                  child: HelpContent(),
                ),
              ),
            ),
          ),
        ),
      ));
}

class HelpContent extends StatefulWidget {
  const HelpContent({super.key});

  @override
  State<HelpContent> createState() => _HelpContentState();
}

class _HelpContentState extends State<HelpContent> {
  late Future<Organization> futureOrganization;

  @override
  void initState() {
    super.initState();
    futureOrganization = api.fetchAuthenticatedUserOrganization();
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          ...[
            Text(
              'Jaajaa',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
          FutureBuilder<Organization>(
            future: futureOrganization,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                    textAlign: TextAlign.center,
                    'Testiorganisaatio: ${snapshot.data!.name}\n${snapshot.data!.completeAddress}');
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          )
        ],
      );
}
