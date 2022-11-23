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
  return auth.signedIn && auth.user?.role == UserRole.teacher;
}

bool isStudent(BuildContext context) {
  PoliisiautoAuth auth = getAuth(context);
  return auth.signedIn && auth.user?.role == UserRole.student;
}

/// A mock authentication service
class PoliisiautoAuth extends ChangeNotifier {
  bool _signedIn = false;
  User? user;

  bool get signedIn => _signedIn;

  Future<void> signOut() async {
    //await Future<void>.delayed(const Duration(milliseconds: 200));

    _signedIn = !(await api.sendLogout());

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
    // api.getTokenAsync().then((t) {
    //   print('TOKEN: $t');
    // });

    return _tryInitializeSession();
  }

  Future<bool> tryRestoreSession() async {
    // Before trying anything, check if we have an existing token stored
    if (!(await api.hasTokenStored())) return false;

    return _tryInitializeSession();
  }

  Future<bool> _tryInitializeSession() async {
    try {
      user = await api.fetchAuthenticatedUser();

      _signedIn = true;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
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
