import 'package:flutter/material.dart';
import '../screens/sidebar.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({super.key});

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
     appBar : AppBar (
        title: const Text('Minun tiedot'),
        centerTitle : true,
        backgroundColor: const Color.fromARGB(255, 112, 162, 237),
     ),
    drawer: const MyDrawer(),
    body: SafeArea(
      child: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: const Card(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                child: UserInformationContent(),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class UserInformationContent extends StatelessWidget {
  const UserInformationContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
    children: [
      ...[
        const Padding(
          padding: EdgeInsets.all(0),
          child: Text('Ei vielä toteutettu, vaatii kommunikointia serveriin(?)',
          ),
        ),
      ].map((w) => Padding(padding: const EdgeInsets.all(8), child: w)),
    ],
  );
}