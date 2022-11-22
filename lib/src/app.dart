// Copyright 2022, Poliisiauto developers.

import 'package:flutter/material.dart';

import 'auth.dart';
import 'routing.dart';
import 'widgets/navigator.dart';

class PoliisiautoApp extends StatefulWidget {
  const PoliisiautoApp({super.key});

  @override
  State<PoliisiautoApp> createState() => _PoliisiautoAppState();
}

class _PoliisiautoAppState extends State<PoliisiautoApp> {
  final _auth = PoliisiautoAuth();
  final _navigatorKey = GlobalKey<NavigatorState>();
  late final RouteState _routeState;
  late final SimpleRouterDelegate _routerDelegate;
  late final TemplateRouteParser _routeParser;

  @override
  void initState() {
    // initialize the global API accessor
    // api = PoliisiautoApi(host: 'http://192.168.56.56', version: 'v1');

    /// Configure the parser with all of the app's allowed path templates.
    _routeParser = TemplateRouteParser(
      allowedPaths: [
        '/signin',
        '/home',
        '/reports',
        '/reports/new',
        '/reports/popular',
        '/reports/recent',
        '/reports/all',
        '/reports/:reportId',
        '/profile',
        '/information',
      ],
      guard: _guard,
      initialRoute: '/signin',
    );

    _routeState = RouteState(_routeParser);

    _routerDelegate = SimpleRouterDelegate(
      routeState: _routeState,
      navigatorKey: _navigatorKey,
      builder: (context) => PoliisiautoNavigator(
        navigatorKey: _navigatorKey,
      ),
    );

    // Listen for when the user logs out and display the signin screen.
    _auth.addListener(_handleAuthStateChanged);

    super.initState();
  }

  @override
  Widget build(BuildContext context) => RouteStateScope(
        notifier: _routeState,
        child: PoliisiautoAuthScope(
          notifier: _auth,
          child: MaterialApp.router(
            routerDelegate: _routerDelegate,
            routeInformationParser: _routeParser,
            // Revert back to pre-Flutter-2.5 transition behavior:
            // https://github.com/flutter/flutter/issues/82053
            theme: ThemeData(
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                },
              ),
            ),
          ),
        ),
      );

  Future<ParsedRoute> _guard(ParsedRoute from) async {
    final signedIn = _auth.signedIn;
    final signInRoute = ParsedRoute('/signin', '/signin', {}, {});
    final homeRoute = ParsedRoute('/home', '/home', {}, {});

    // Flow paths:
    // | signedIn | from == signInRoute | canRestoreSession || return value
    // |----------|---------------------|-------------------||--------------
    // |    0     |          0          |         x         || signInRoute
    // |    0     |          1          |         0         || from
    // |    0     |          1          |         1         || homeRoute
    // |    1     |          0          |         x         || homeRoute
    // |    1     |          1          |         x         || from

    if (!signedIn) {
      // If the user IS NOT signed in...
      // ...and not on sign-in page -> redirect there
      if (from != signInRoute) return signInRoute;

      // ...and already in signInRoute, try restoring previous session
      if (await _auth.tryRestoreSession()) return homeRoute;
    } else {
      // If the user IS signed in...
      // ...going to signInRoute -> redirect home
      if (from == signInRoute) return homeRoute;
    }

    return from;
  }

  void _handleAuthStateChanged() {
    if (!_auth.signedIn) {
      _routeState.go('/signin');
    }
  }

  @override
  void dispose() {
    _auth.removeListener(_handleAuthStateChanged);
    _routeState.dispose();
    _routerDelegate.dispose();
    super.dispose();
  }
}