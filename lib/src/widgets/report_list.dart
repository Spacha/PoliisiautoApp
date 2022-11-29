// Copyright 2022, Poliisiauto developers.

import 'package:flutter/material.dart';
import '../auth.dart';
import '../data.dart';
import '../api.dart';
import 'empty_list.dart';

class ReportList extends StatefulWidget {
  final String category;
  final ValueChanged<Report>? onTap;
  final int dataDirtyCounter;

  const ReportList({
    required this.dataDirtyCounter,
    required this.category,
    super.key,
    this.onTap,
  });

  @override
  State<ReportList> createState() => _ReportListState();

  // Messages that are shown if there are no reports to show.
  // Depends on the category we are viewing
  static const Map<String, String> emptyListMessages = {
    'assigned': 'Ei sinulle osoitettuja ilmoituksia',
    'created': 'Et ole luonut ilmoituksia',
    'all': 'Ei ilmoituksia',
  };

  String get emptyListMessage => emptyListMessages[category]!;
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

    // If a counter value has changed, we need to reload the data from the server
    // This happens if a new report was created or one was deleted.
    if (oldWidget.dataDirtyCounter != widget.dataDirtyCounter) {
      setState(() {
        futureReportList = _fetchReports();
      });
    }
  }

  /// Fetch reports from the server to show in the list.
  /// The current category affects the API route we are making the request to.
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
          return snapshot.data!.isEmpty
              ? EmptyListWidget(widget.emptyListMessage)
              : ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) => ListTile(
                        title: Text(snapshot.data?[index].description ??
                            '(Ei kuvausta)'),
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
