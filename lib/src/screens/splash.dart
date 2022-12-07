/*
 * Copyright (c) 2022, Miika Sikala, Essi Passoja, Lauri Klemettilä
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

import 'package:flutter/material.dart';
import 'package:poliisiauto/src/routing.dart';

class SplashScreen extends StatefulWidget {
  final int duration;

  const SplashScreen({
    super.key,
    required this.duration,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: widget.duration)).then((val) {
      RouteStateScope.of(context).go('/signin');
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 200, child: Image.asset('assets/logo-text-2x.png')),
            const Text('beta',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        )),
      );
}
