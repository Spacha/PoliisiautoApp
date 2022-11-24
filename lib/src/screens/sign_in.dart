// Copyright 2022, Poliisiauto developers.

import 'package:flutter/material.dart';
import 'package:poliisiauto/src/auth.dart';
import '../routing.dart';
import '../data.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({
    super.key,
  });

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  /// Form fields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = getAuth(context);
    final routeState = RouteStateScope.of(context);

    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              constraints: BoxConstraints.loose(const Size(600, 600)),
              padding: const EdgeInsets.all(20),
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                          width: 120, child: Image.asset('assets/logo-2x.png')),
                      const SizedBox(height: 20),
                      Text(
                        'Kirjaudu sisään',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Anna sähköpostiosoite';
                          }
                          return null;
                        },
                        decoration:
                            const InputDecoration(labelText: 'Sähköposti'),
                        controller: _emailController,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Anna salasana';
                          }
                          return null;
                        },
                        decoration:
                            const InputDecoration(labelText: 'Salasana'),
                        obscureText: true,
                        controller: _passwordController,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextButton(
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }

                            bool success = await _tryLogin(authState);
                            if (success) {
                              await routeState.go('/home');
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text(
                                            'Kirjautuminen epäonnistui!'),
                                        content: const Text(
                                            'Varmista että kirjoitit sähköpostin ja salasanan oikein.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('Selvä'),
                                          ),
                                        ],
                                      ));
                            }
                          },
                          child: const Text('Sign in'),
                        ),
                      ),

                      /// Debug:
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              _emailController.text = 'miika@example.com';
                              _passwordController.text = 'kikkakokkeli';
                            },
                            child: const Text('Autofill (student)',
                                style: TextStyle(color: Colors.orange)),
                          ),
                          TextButton(
                            onPressed: () {
                              _emailController.text = 'olli@example.com';
                              _passwordController.text = 'kikkakokkeli';
                            },
                            child: const Text('Autofill (teacher)',
                                style: TextStyle(color: Colors.orange)),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
          ]),
    );
  }

  Future<bool> _tryLogin(PoliisiautoAuth authState) async {
    Credentials credentials = Credentials(_emailController.value.text,
        _passwordController.value.text, _getDeviceName());

    return await authState.signIn(credentials);
  }

  String _getDeviceName() {
    // TODO: Get or ask actual name
    return 'Android';
  }
}
