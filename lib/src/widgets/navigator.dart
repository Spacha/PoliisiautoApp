// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

//import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../auth.dart';
import '../routing.dart';
import '../screens/sign_in.dart';
import '../screens/report_new.dart';
import '../screens/report_details.dart';
import 'fade_transition_page.dart';
import 'scaffold.dart';

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
  final _signInKey = const ValueKey('Sign in');
  final _scaffoldKey = const ValueKey('App scaffold');
  final _reportNewKey = const ValueKey('New report screen');
  final _reportDetailsKey = const ValueKey('Report details screen');

  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);
    final authState = PoliisiautoAuthScope.of(context);
    final pathTemplate = routeState.route.pathTemplate;

    bool creatingNewReport = false;
    int? selectedReportId;
    if (pathTemplate == '/reports/:reportId') {
      if (routeState.route.parameters['reportId'] == 'new') {
        creatingNewReport = true;
      } else {
        selectedReportId =
            int.tryParse(routeState.route.parameters['reportId']!);
      }
      //selectedReport =
      // selectedReport = libraryInstance.allBooks.firstWhereOrNull(
      //     (b) => b.id.toString() == routeState.route.parameters['reportId']);
    }

    // Author? selectedAuthor;
    // if (pathTemplate == '/author/:authorId') {
    //   selectedAuthor = libraryInstance.allAuthors.firstWhereOrNull(
    //       (b) => b.id.toString() == routeState.route.parameters['authorId']);
    // }

    return Navigator(
      key: widget.navigatorKey,
      onPopPage: (route, dynamic result) {
        // When a page that is stacked on top of the scaffold is popped, display
        // the /books or /authors tab in BookstoreScaffold.
        // if (route.settings is Page &&
        //     (route.settings as Page).key == _reportDetailsKey) {
        //   routeState.go('/reports/popular');
        // }
        // if (route.settings is Page &&
        //     (route.settings as Page).key == _authorDetailsKey) {
        //   routeState.go('/authors');
        // }
        return route.didPop(result);
      },
      pages: [
        if (routeState.route.pathTemplate == '/signin')
          // Display the sign in screen.
          FadeTransitionPage<void>(
            key: _signInKey,
            child: SignInScreen(
              onSignIn: (credentials) async {
                var signedIn = await authState.signIn(
                    credentials.username, credentials.password);
                if (signedIn) {
                  await routeState.go('/home');
                }
              },
            ),
          )
        else ...[
          // Display the app
          FadeTransitionPage<void>(
            key: _scaffoldKey,
            child: const PoliisiautoScaffold(),
          ),

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
              key: _reportNewKey,
              child: ReportNewScreen(),
            )
        ],
      ],
    );
  }
}
