import 'package:flutter/material.dart';
import '../auth.dart';
import '../routing.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color.fromARGB(255, 112, 162, 237),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 90,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 32, 112, 232),
                ),
                child: Text('Maijan Poliisiauto', 
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 25
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Etusivu'),
              textColor: Colors.white70,
              onTap: () {
                RouteStateScope.of(context).go('/home');
              },
            ),
            ListTile(
              leading: const Icon(Icons.border_color),
              title: const Text('Tee uusi ilmoitus'),
              textColor: Colors.white70,
              onTap: () {
                RouteStateScope.of(context).go('/create_new_report');
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Minun ilmoitukset'),
              textColor: Colors.white70,
              onTap: () {
                RouteStateScope.of(context).go('/reports/popular');  // TODO: change route
              },
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Viestit'),
              textColor: Colors.white70,
              onTap: () {
                RouteStateScope.of(context).go('/reports/popular');  // TODO: change route
              },
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.white70),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Asetukset'),
              textColor: Colors.white70,
              onTap: () {
                RouteStateScope.of(context).go('/reports/popular');  // TODO: change route
              },
            ),ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Minun tiedot'),
              textColor: Colors.white70,
              onTap: () {
                RouteStateScope.of(context).go('/authors');  // TODO: change route
              },
            ),ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Kirjaudu ulos'),
              textColor: Colors.white70,
              onTap: () {
                PoliisiautoAuthScope.of(context).signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}