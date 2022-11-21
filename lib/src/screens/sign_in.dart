// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:poliisiauto/src/auth.dart';
import '../routing.dart';
import '../data.dart';

class SignInScreen extends StatefulWidget {
  // final ValueChanged<Credentials> onSignIn;

  const SignInScreen({
    // required this.onSignIn,
    super.key,
  });

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // TODO: Validate form!

  @override
  Widget build(BuildContext context) {
    final authState = getAuth(context);
    final routeState = RouteStateScope.of(context);

    return Scaffold(
      body: Center(
        child: Card(
          child: Container(
            constraints: BoxConstraints.loose(const Size(600, 600)),
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Sign in',
                    style: Theme.of(context).textTheme.headlineMedium),
                TextField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  controller: _emailController,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextButton(
                    onPressed: () async {
                      bool success = await _tryLogin(authState);

                      if (success) {
                        await routeState.go('/home');
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) => const AlertDialog(
                                  title: Text('Login failed!'),
                                ));
                      }
                    },
                    child: const Text('Sign in'),
                  ),
                ),

                /// Debug:
                const Divider(),
                TextButton(
                  onPressed: () {
                    _emailController.text = 'miika@example.com';
                    _passwordController.text = 'kikkakokkeli';
                  },
                  child: const Text('Autofill (student)'),
                ),
                TextButton(
                  onPressed: () {
                    _emailController.text = 'miika@example.com';
                    _passwordController.text = 'kikkakokkeli';
                  },
                  child: const Text('Autofill (teacher)'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _tryLogin(PoliisiautoAuth authState) async {
    Credentials credentials = Credentials(_emailController.value.text,
        _passwordController.value.text, _getDeviceName());

    return await authState.signIn(credentials);
  }

  String _getDeviceName() {
    // FIXME: Get or ask actual name
    return 'Android';
  }
}
