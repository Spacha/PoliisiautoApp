// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

import '../auth.dart';
import '../routing.dart';
import '../widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Welcome!')),
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
      ));
}

class HomeContent extends StatelessWidget {
  const HomeContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Image.asset('images/stock-image-classroom.jpg', fit: BoxFit.contain),
          ...[
            Text(
              'Welcome, anonymous user!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Text(
              'This is a sample page with some weird sample and debugging content.',
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () {
                PoliisiautoAuthScope.of(context).signOut();
              },
              child: const Text('Sign out'),
            ),
            Link(
              uri: Uri.parse('/report/0'),
              builder: (context, followLink) => TextButton(
                onPressed: followLink,
                child: const Text('Go directly to /report/0 (Link)'),
              ),
            ),
            TextButton(
              child: const Text('Go directly to /report/0 (RouteState)'),
              onPressed: () {
                RouteStateScope.of(context).go('/report/0');
              },
            ),
          ].map((w) => Padding(padding: const EdgeInsets.all(8), child: w)),
          TextButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Alert!'),
                content: const Text('The alert description goes here.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
            child: const Text('Show Dialog'),
          )
        ],
      );
}
