// Copyright 2022, Poliisiauto developers.

import 'package:flutter/material.dart';
import 'package:poliisiauto/src/auth.dart';
import '../data.dart';
import '../api.dart';

class ReportList extends StatefulWidget {
  final String category;
  final ValueChanged<Report>? onTap;
  final int dataDirtyCounter;

  const ReportList({
    required this.dataDirtyCounter,
    required this.category,
    this.onTap,
    super.key,
  });

  @override
  State<ReportList> createState() => _ReportListState();
}

class _ReportListState extends State<ReportList> {
  late Future<List<Report>> futureReportList;

  @override
  void initState() {
    super.initState();
    futureReportList = Future.delayed(Duration.zero, () => _fetchReports());
  }

  @override
  void didUpdateWidget(ReportList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.dataDirtyCounter != widget.dataDirtyCounter) {
      setState(() {
        futureReportList = _fetchReports();
      });
    }
  }

  Future<List<Report>> _fetchReports() {
    String? route;
    if (widget.category == 'assigned') {
      route = 'teachers/${getAuth(context).user!.id}/assigned-reports';
    } else if (widget.category == 'created') {
      route = 'teachers/${getAuth(context).user!.id}/reports';
    }

    return api.fetchReports(order: 'ASC', route: route);
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<Report>>(
      future: futureReportList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) => ListTile(
                    title: Text(
                        snapshot.data?[index].description ?? '(Ei kuvausta)'),
                    subtitle: snapshot.data?[index].reporterName != null
                        ? Text(snapshot.data?[index].reporterName ?? '')
                        : null,
                    onTap: (widget.onTap != null)
                        ? () => widget.onTap!(snapshot.data![index])
                        : null,
                  ));
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const Center(child: CircularProgressIndicator());
      });
}
