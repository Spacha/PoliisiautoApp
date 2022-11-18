// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:url_launcher/link.dart';

import '../data.dart';

Future<Report> fetchReport(int reportId) async {
  var headers = {'Authorization': 'Bearer $apiKey'};
  var request = http.MultipartRequest(
      'GET', Uri.parse('http://192.168.56.56/api/v1/reports/$reportId'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    //print(await response.stream.bytesToString());
    //return Album.fromJson(jsonDecode(response.body));
    //List<Report> reports;
    return Report.fromJson(jsonDecode(await response.stream.bytesToString()));
  } else {
    //print(response.reasonPhrase);
    throw Exception('Failed to load report');
  }
}

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
    futureReport = fetchReport(widget.reportId);
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
                      snapshot.data!.openedAt.isNotEmpty
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
