// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import '../data.dart';
import '../api.dart';

class ReportList extends StatefulWidget {
  final String category;
  final ValueChanged<Report>? onTap;

  const ReportList({
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
    futureReportList = api.fetchReports();
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
