/*
 * Copyright (c) 2022, Miika Sikala, Essi Passoja, Lauri Klemettilä
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'src/app.dart';

void main() {
  /// load the environment file...
  dotenv.load(fileName: ".env");

  /// ...and run the app
  runApp(const PoliisiautoApp());
}
