// Copyright 2022, Poliisiauto developers.

import 'package:flutter/material.dart';
import '../routing.dart';
import '../screens/splash.dart';
import '../screens/sign_in.dart';
import '../screens/new_report.dart';
import '../screens/report_details.dart';
import 'fade_transition_page.dart';
//import 'scaffold.dart';
import '../screens/home.dart';
import '../screens/reports.dart';
import '../screens/information.dart';

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
  //final _scaffoldKey = const ValueKey('App scaffold');
  final _newReportKey = const ValueKey('New report');
  final _reportDetailsKey = const ValueKey('Report details');

  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);
    final currentRoute = routeState.route;
    //final authState = PoliisiautoAuthScope.of(context);
    final pathTemplate = currentRoute.pathTemplate;

    bool creatingNewReport = false;
    int? selectedReportId;
    if (pathTemplate == '/reports/:reportId') {
      if (currentRoute.parameters['reportId'] == 'new') {
        creatingNewReport = true;
      } else {
        selectedReportId = int.tryParse(currentRoute.parameters['reportId']!);
      }
    }

    // TODO: Wrap this with try-catch. Then, if a SessionExpiredException is thrown, redirect to /home!

    return Navigator(
      key: widget.navigatorKey,
      onPopPage: (route, dynamic result) {
        // refresh the reports after successful report creation
        // if (route.settings is Page &&
        //     (route.settings as Page).key == _newReportKey &&
        //     result == 'report_created') {
        //   routeState.go('/reports');
        // }

        var page = route.settings is Page ? route.settings as Page : null;

        if (page != null && page.key == _newReportKey) {}
        print('$route did pop with result: $result');

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
          //////////////////////////////////////////////////////////////////////

          // Add an additional page to the stack if the user is viewing a report

          // Show report
          if (selectedReportId != null)
            MaterialPage<void>(
              key: _reportDetailsKey,
              child: ReportDetailsScreen(
                reportId: selectedReportId,
              ),
            )
          else if (creatingNewReport)
            MaterialPage<void>(
              key: _newReportKey,
              child: const NewReportScreen(),
            )
        ],
      ],
    );
  }
}
