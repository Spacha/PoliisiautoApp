// Copyright 2022, Poliisiauto developers.

import 'package:flutter/material.dart';
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
    futureReportList = api.fetchReports(order: 'ASC');
  }

  @override
  void didUpdateWidget(ReportList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.dataDirtyCounter != widget.dataDirtyCounter) {
      setState(() {
        futureReportList = api.fetchReports(order: 'ASC');
      });
    }
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
                        snapshot.data?[index].description ?? 'No description'),
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
