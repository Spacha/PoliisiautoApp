// Copyright 2022, Poliisiauto developers.

import 'package:flutter/material.dart';
import '../routing.dart';
import '../auth.dart';

class PoliisiautoDrawer extends StatelessWidget {
  const PoliisiautoDrawer({super.key});

  final Color tileHighlightColor = const Color.fromARGB(255, 88, 145, 230);

  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);
    final selectedIndex = _getSelectedIndex(routeState.route.pathTemplate);

    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      backgroundColor: const Color.fromARGB(255, 112, 162, 237),
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 32, 112, 232),
            ),
            child: Text(
              'Hei ${getAuth(context).user!.name}!',
              style: const TextStyle(color: Colors.white),
              textScaleFactor: 1.5,
              textAlign: TextAlign.center,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.house_outlined),
            title: const Text('Etusivu'),
            iconColor: Colors.white,
            textColor: Colors.white,
            tileColor:
                (selectedIndex == 0) ? tileHighlightColor : Colors.transparent,
            onTap: () {
              // Update the state of the app
              routeState.go('/home');
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.speaker_notes_outlined),
            title: isTeacher(context)
                ? const Text('Minun ilmoitukset')
                : const Text('Ilmoitukset'),
            iconColor: Colors.white,
            textColor: Colors.white,
            tileColor:
                (selectedIndex == 1) ? tileHighlightColor : Colors.transparent,
            onTap: () {
              // Update the state of the app
              routeState.go('/reports');
              // Then close the drawer
              Navigator.pop(context);
            },
          ),

          // TODO: Add help screen (selectedIndex = 2)

          const Divider(color: Color.fromARGB(255, 193, 193, 193)),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Asetukset'),
            iconColor: Colors.white,
            textColor: Colors.white,
            tileColor:
                (selectedIndex == 3) ? tileHighlightColor : Colors.transparent,
            onTap: () {
              // Update the state of the app
              routeState.go('/settings');
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outlined),
            title: const Text('Tietoa sovelluksesta'),
            iconColor: Colors.white,
            textColor: Colors.white,
            tileColor:
                (selectedIndex == 4) ? tileHighlightColor : Colors.transparent,
            onTap: () {
              // Update the state of the app
              routeState.go('/information');
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          const Divider(color: Color.fromARGB(255, 193, 193, 193)),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: const Text('Kirjaudu ulos'),
            iconColor: Colors.white,
            textColor: Colors.white,
            onTap: () {
              // Update the state of the app
              getAuth(context).signOut();
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  int _getSelectedIndex(String pathTemplate) {
    if (pathTemplate.startsWith('/home')) return 0;
    if (pathTemplate.startsWith('/reports')) return 1;
    if (pathTemplate.startsWith('/help')) return 2;
    if (pathTemplate.startsWith('/settings')) return 3;
    if (pathTemplate.startsWith('/information')) return 4;

    return -1;
  }
}
