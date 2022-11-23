// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final int delaySeconds;
  final VoidCallback redirectCallback;

  const SplashScreen({
    super.key,
    required this.delaySeconds,
    required this.redirectCallback,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: widget.delaySeconds)).then((val) {
      widget.redirectCallback();
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
