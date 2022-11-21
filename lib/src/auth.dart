// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'api.dart';
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

enum Role { teacher, student }

/// TODO: Implement and move to 'data/user.dart'
class User {
  final String name;
  final Role role;

  User(this.name, this.role);
}

/// A mock authentication service
class PoliisiautoAuth extends ChangeNotifier {
  bool _signedIn = false;
  User? user;

  bool get signedIn => _signedIn;

  Future<void> signOut() async {
    //await Future<void>.delayed(const Duration(milliseconds: 200));

    _signedIn = await api.sendLogout();

    notifyListeners();
  }

  Future<bool> signIn(Credentials credentials) async {
    //await Future<void>.delayed(const Duration(milliseconds: 200));

    String? token = await api.sendLogin(credentials);

    if (token == null) {
      // Login failed, return to the form with a message
      return false;
    }

    api.setToken(token);

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
