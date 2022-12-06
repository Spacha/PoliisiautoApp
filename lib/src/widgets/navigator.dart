// Copyright 2022, Poliisiauto developers.

import 'package:flutter/material.dart';
import 'package:poliisiauto/src/screens/forgot_password.dart';
import '../routing.dart';
import '../screens/splash.dart';
import '../screens/sign_in.dart';
import 'fade_transition_page.dart';
import '../screens/home.dart';
import '../screens/reports.dart';
import '../screens/information.dart';
import '../screens/sos_confirmation.dart';
import '../screens/sending_sos.dart';

/// Builds the top-level navigator for the app. The pages to display are based
/// on the `routeState` that was parsed by the TemplateRouteParser.
class PoliisiautoNavigator extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const PoliisiautoNavigator({
    required this.navigatorKey,
    super.key,
  });

  @override
  State<PoliisiautoNavigator> createState() => _PoliisiautoNavigatorState();
}

class _PoliisiautoNavigatorState extends State<PoliisiautoNavigator> {
  final _splashKey = const ValueKey('Splash');
  final _signInKey = const ValueKey('Sign in');
  final _forgotPasswordKey = const ValueKey('Forgot Password');

  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);
    final currentRoute = routeState.route;
    final pathTemplate = currentRoute.pathTemplate;

    // TODO: Wrap this with try-catch. Then, if a SessionExpiredException is thrown, redirect to /home!

    return Navigator(
      key: widget.navigatorKey,
      onPopPage: (route, dynamic result) {
        return route.didPop(result);
      },
      pages: [
        //////////////////////////////////////////////////////////////////////
        // Display the special screens
        //////////////////////////////////////////////////////////////////////
        if (pathTemplate == '/splash')
          // Display the splash screen
          FadeTransitionPage<void>(
            key: _splashKey,
            child: const SplashScreen(duration: 3),
          )
        else if (pathTemplate == '/signin')
          // Display the sign in screen.
          FadeTransitionPage<void>(
            key: _signInKey,
            child: const SignInScreen(),
          )
        else if (pathTemplate == '/forgot_password')
          // Display the forgot password screen.
          FadeTransitionPage<void>(
            key: _forgotPasswordKey,
            child: const ForgotPasswordScreen(),
          )
        else ...[
          //////////////////////////////////////////////////////////////////////
          // Display the app
          //////////////////////////////////////////////////////////////////////
          if (pathTemplate.startsWith('/home') || pathTemplate == '/')
            const FadeTransitionPage<void>(
              key: ValueKey('home'),
              child: HomeScreen(),
            )
          else if (pathTemplate.startsWith('/reports'))
            const FadeTransitionPage<void>(
              key: ValueKey('reports'),
              child: ReportsScreen(),
            )
          else if (pathTemplate.startsWith('/information'))
            const FadeTransitionPage<void>(
              key: ValueKey('information'),
              child: InformationScreen(),
            )
          else if (pathTemplate.startsWith('/sos_confirmation'))
            const FadeTransitionPage<void>(
              key: ValueKey('SOS confirmation'),
              child: SOSConfirmationScreen(),
            )
          else if (pathTemplate.startsWith('/sending_sos'))
            const FadeTransitionPage<void>(
              key: ValueKey('sending SOS'),
              child: SendingSOSScreen(),
            )
          // Avoid building a Navigator with an empty `pages` list when the
          // RouteState is set to an unexpected path, such as /signin.
          //
          // Since RouteStateScope is an InheritedNotifier, any change to the
          // route will result in a call to this build method, even though this
          // widget isn't built when those routes are active.
          else
            FadeTransitionPage<void>(
              key: const ValueKey('empty'),
              child: Container(),
            ),

          // Add an additional page to the stack if the user is viewing a report

          // ...
        ],
      ],
    );
  }
}
