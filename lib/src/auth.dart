// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'data.dart';

////////////////////////////////////////////////////////////////////////////////
/// Helpers
////////////////////////////////////////////////////////////////////////////////

PoliisiautoAuth getAuth(BuildContext context) {
  return PoliisiautoAuthScope.of(context);
}

bool isTeacher(BuildContext context) {
  PoliisiautoAuth auth = getAuth(context);
  return auth.signedIn && auth.user?.role == Role.teacher;
}

bool isStudent(BuildContext context) {
  PoliisiautoAuth auth = getAuth(context);
  return auth.signedIn && auth.user?.role == Role.student;
}

////////////////////////////////////////////////////////////////////////////////
/// Login
////////////////////////////////////////////////////////////////////////////////

Future<String?> sendLogin(Credentials credentials) async {
  // TODO: api.sendLogin(credentials);

  var request = http.MultipartRequest(
      'POST', Uri.parse('http://192.168.56.56/api/v1/login'));

  request.fields.addAll({
    'email': credentials.email,
    'password': credentials.password,
    'device_name': credentials.deviceName
  });

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
    return 'token here';
  } else {
    print('Error: ${response.stream.toString()}');
    return null;
    //throw Exception('Failed to login (${response.statusCode})');
  }
}

enum Role { teacher, student }

/// TODO: Implement and move to 'data/user.dart'
class User {
  final String name;
  final Role role;

  User(this.name, this.role);
}

/// A mock authentication service
class PoliisiautoAuth extends ChangeNotifier {
  final storage = const FlutterSecureStorage();
  bool _signedIn = false;
  User? user;

  bool get signedIn => _signedIn;

  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    // Sign out.
    _signedIn = false;
    notifyListeners();
  }

  Future<bool> signIn(Credentials credentials) async {
    //await Future<void>.delayed(const Duration(milliseconds: 200));

    // login...
    String? token = await sendLogin(credentials);

    // ...and store the token received
    if (token == null) {
      // Login failed, return to the form with a message
      return false;
    }

    await storage.write(key: 'bearer_token', value: token);

    //user = await getUser();
    user = User(credentials.email, Role.teacher); // FIXME

    _signedIn = true;

    notifyListeners();
    return _signedIn;
  }

  @override
  bool operator ==(Object other) =>
      other is PoliisiautoAuth && other._signedIn == _signedIn;

  @override
  int get hashCode => _signedIn.hashCode;
}

class PoliisiautoAuthScope extends InheritedNotifier<PoliisiautoAuth> {
  const PoliisiautoAuthScope({
    required super.notifier,
    required super.child,
    super.key,
  });

  static PoliisiautoAuth of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<PoliisiautoAuthScope>()!
      .notifier!;
}
