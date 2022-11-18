// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../data.dart';
import '../routing.dart';
import '../widgets/drawer.dart';
import '../widgets/report_list.dart';
import '../auth.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({
    super.key,
  });

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(_handleTabIndexChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final newPath = _routeState.route.pathTemplate;
    if (newPath.startsWith('/reports/popular')) {
      _tabController.index = 0;
    } else if (newPath.startsWith('/reports/new')) {
      _tabController.index = 1;
    } else if (newPath == '/reports/all') {
      _tabController.index = 2;
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndexChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        bottom: isTeacher(context)
            ? TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(
                    text: 'Popular',
                    icon: Icon(Icons.people),
                  ),
                  Tab(
                    text: 'New',
                    icon: Icon(Icons.new_releases),
                  ),
                  Tab(
                    text: 'All',
                    icon: Icon(Icons.list),
                  ),
                ],
              )
            : null,
      ),
      drawer: const PoliisiautoDrawer(),
      body: isTeacher(context)
          ? TabBarView(
              controller: _tabController,
              children: [
                ReportList(
                  category: 'category 1',
                  onTap: _handleReportTapped,
                ),
                ReportList(
                  category: 'category 2',
                  onTap: _handleReportTapped,
                ),
                ReportList(
                  category: 'category 3',
                  onTap: _handleReportTapped,
                )
              ],
            )
          : ReportList(category: 'all', onTap: _handleReportTapped));

  RouteState get _routeState => RouteStateScope.of(context);

  void _handleReportTapped(Report report) {
    _routeState.go('/reports/${report.id}');
  }

  void _handleTabIndexChanged() {
    switch (_tabController.index) {
      case 1:
        _routeState.go('/reports/new');
        break;
      case 2:
        _routeState.go('/reports/all');
        break;
      case 0:
      default:
        _routeState.go('/reports/popular');
        break;
    }
  }
}
