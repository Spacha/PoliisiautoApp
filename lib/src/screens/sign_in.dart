// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import '../routing.dart';

class Credentials {
  final String username;
  final String password;

  Credentials(this.username, this.password);
}

class SignInScreen extends StatefulWidget {
  final ValueChanged<Credentials> onSignIn;

  const SignInScreen({
    required this.onSignIn,
    super.key,
  });

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar : AppBar (
        title: const Text('Kirjaudu Sisään'),
        centerTitle : true,
        backgroundColor: const Color.fromARGB(255, 112, 162, 237),
        leading: InkWell(
          onTap: () {
            RouteStateScope.of(context).go('/frontpage');
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
    ),
        body: Center(
          child: Card(
            child: Container(
              constraints: BoxConstraints.loose(const Size(600, 600)),
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  //Text('Kirjaudu sisään',
                  //style: Theme.of(context).textTheme.headlineMedium),
                  Image.asset(
                    "graphics/logo-text-1x.png",
                    height: 200,
                    width: 200,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Käyttäjätunnus'),
                    controller: _usernameController,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Salasana'),
                    obscureText: true,
                    controller: _passwordController,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: OutlinedButton(
                      onPressed: () async {
                        widget.onSignIn(Credentials(
                            _usernameController.value.text,
                            _passwordController.value.text));},
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        primary: Colors.white,
                        backgroundColor: const Color.fromARGB(255, 112, 162, 237),
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Kirjaudu'),
                    ),
                  ),
                   Padding(
                    padding: const EdgeInsets.all(0),
                      child: TextButton(
                        onPressed: () async {RouteStateScope.of(context).go('/forgot_password');},
                        child: const Text('Unohtuiko salasana?'),
                      ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
