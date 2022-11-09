import 'package:flutter/material.dart';

import '../routing.dart';

class PoliisiautoDrawer extends StatelessWidget {
  const PoliisiautoDrawer({super.key});

  final Color tileHighlightColor = const Color.fromARGB(255, 230, 230, 230);

  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);
    final selectedIndex = _getSelectedIndex(routeState.route.pathTemplate);

    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Welcome, teacher!'),
          ),
          ListTile(
            leading: const Icon(Icons.house_outlined),
            title: const Text('Home'),
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
            title: const Text('Reports'),
            tileColor:
                (selectedIndex == 1) ? tileHighlightColor : Colors.transparent,
            onTap: () {
              // Update the state of the app
              routeState.go('/reports');
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outlined),
            title: const Text('Information'),
            tileColor:
                (selectedIndex == 2) ? tileHighlightColor : Colors.transparent,
            onTap: () {
              // Update the state of the app
              routeState.go('/information');
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
    if (pathTemplate.startsWith('/information')) return 2;

    return -1;
  }
}
