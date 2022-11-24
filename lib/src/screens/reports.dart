// Copyright 2022, Poliisiauto developers.

import 'package:flutter/material.dart';
import '../data.dart';
import '../routing.dart';
import '../widgets/drawer.dart';
import '../widgets/report_list.dart';
import '../auth.dart';
import '../screens/new_report.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  RouteState get _routeState => RouteStateScope.of(context);

  late int _dataDirtyCounter;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(_handleTabIndexChanged);

    _dataDirtyCounter = 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final newPath = _routeState.route.pathTemplate;
    if (newPath.startsWith('/reports/assigned-to-me')) {
      _tabController.index = 0;
    } else if (newPath.startsWith('/reports/created-by-me')) {
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
  Widget build(BuildContext context) {
    //final routeState = RouteStateScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ilmoitukset'),
        bottom: isTeacher(context)
            ? TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(
                    text: 'Osoitetut',
                    icon: Icon(Icons.school),
                  ),
                  Tab(
                    text: 'Minun luomat',
                    icon: Icon(Icons.person),
                  ),
                  Tab(
                    text: 'Kaikki',
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
                  dataDirtyCounter: _dataDirtyCounter,
                  category: 'assigned',
                  onTap: _handleReportTapped,
                ),
                ReportList(
                  dataDirtyCounter: _dataDirtyCounter,
                  category: 'created',
                  onTap: _handleReportTapped,
                ),
                ReportList(
                  dataDirtyCounter: _dataDirtyCounter,
                  category: 'all',
                  onTap: _handleReportTapped,
                )
              ],
            )
          : ReportList(
              dataDirtyCounter: _dataDirtyCounter,
              category: 'all',
              onTap: _handleReportTapped),
      floatingActionButton: FloatingActionButton(
        //onPressed: () => _routeState.go('/reports/new'),
        //onPressed: () => Navigator.pushNamed(context, '/reports/new'),
        onPressed: () => _openNewReportScreen(context),
        tooltip: 'New report',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openNewReportScreen(BuildContext context) async {
    return Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => const NewReportScreen(),
    ))
        .then((result) {
      setState(() {
        _dataDirtyCounter++;
      });
    });
  }

  void _handleReportTapped(Report report) {
    _routeState.go('/reports/${report.id}');
  }

  void _handleTabIndexChanged() {
    switch (_tabController.index) {
      case 1:
        _routeState.go('/reports/recent');
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
