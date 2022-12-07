/*
 * Copyright (c) 2022, Miika Sikala, Essi Passoja, Lauri Klemettilä
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

import 'package:flutter/material.dart';
import '../routing.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({
    super.key,
  });

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Unohditko salasanasi?')),
        body: Center(
          child: Card(
            child: Container(
              //constraints: BoxConstraints.loose(const Size(600, 600)),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Image.asset(
                      'assets/logo-2x.png',
                      width: 100,
                    ),
                  ),
                  const Text(
                      'Ei hätää! Lähetämme sähköpostiisi linkin, jonka kautta voit antaa uuden salasanan ja kirjautua sen jälkeen uudelleen.'),
                  TextField(
                    decoration:
                        const InputDecoration(labelText: 'Sähköpostiosoite'),
                    key: const ValueKey("forgotten e-mail"),
                    obscureText: true,
                    controller: _emailController,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: TextButton(
                      // TODO: Not implemented yet.
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Huomio!'),
                          content: const Text(
                              'Salasanan uusimista ei ole vielä toteutettu :('),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('Selvä homma'),
                            ),
                          ],
                        ),
                      ),
                      child: const Text('Lähetä linkki'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
