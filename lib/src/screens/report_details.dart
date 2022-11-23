// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import '../api.dart';
import '../data.dart';

class ReportDetailsScreen extends StatefulWidget {
  final int reportId;

  const ReportDetailsScreen({
    super.key,
    required this.reportId,
  });

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  late Future<Report> futureReport;

  @override
  void initState() {
    super.initState();
    futureReport = api.fetchReport(widget.reportId);
  }

  @override
  Widget build(BuildContext context) {
    // if (report == null) {
    //   return const Scaffold(
    //     body: Center(
    //       child: Text('No report found.'),
    //     ),
    //   );
    // }
    return Scaffold(
      appBar: AppBar(title: const Text('Report details')),
      body: FutureBuilder<Report>(
          future: futureReport,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: Column(
                  children: [
                    Text(snapshot.data!.description),
                    Text(
                      snapshot.data!.status == ReportStatus.opened
                          ? 'Opened at ${snapshot.data!.openedAt}'
                          : 'Not opened',
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                    // TextButton(
                    //   child: const Text('View author (Push)'),
                    //   onPressed: () {
                    //     Navigator.of(context).push<void>(
                    //       MaterialPageRoute<void>(
                    //         builder: (context) =>
                    //             AuthorDetailsScreen(author: book!.author),
                    //       ),
                    //     );
                    //   },
                    // ),
                    // Link(
                    //   uri: Uri.parse('/author/${book!.author.id}'),
                    //   builder: (context, followLink) => TextButton(
                    //     onPressed: followLink,
                    //     child: const Text('View author (Link)'),
                    //   ),
                    // ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
