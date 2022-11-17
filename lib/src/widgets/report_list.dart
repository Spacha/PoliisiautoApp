// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../data.dart';

Future<List<Report>> fetchReports() async {
  var headers = {'Authorization': 'Bearer $apiKey'};
  var request = http.MultipartRequest(
      'GET', Uri.parse('http://192.168.56.56/api/v1/reports'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    //print(await response.stream.bytesToString());
    //return Album.fromJson(jsonDecode(response.body));
    //List<Report> reports;
    //return Report.fromJson(jsonDecode(await response.stream.bytesToString()));
    final List<dynamic> reportsJson =
        jsonDecode(await response.stream.bytesToString());

    List<Report> reports = [];
    for (var reportJson in reportsJson) {
      reports.add(Report.fromJson(reportJson));
    }

    return reports;
  } else {
    //print(response.reasonPhrase);
    throw Exception('Failed to load reports');
  }
}

class ReportList extends StatefulWidget {
  final List<Report> reports;
  final ValueChanged<Report>? onTap;

  const ReportList({
    required this.reports,
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
    futureReportList = fetchReports();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<Report>>(
        future: futureReportList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //return Text(snapshot.data!.description);
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) => ListTile(
                      title: Text(
                          //widget.reports[index].description,
                          snapshot.data?[index].description ??
                              'No description'),
                    ));
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
        // itemCount: widget.reports.length,
        // itemBuilder: (context, index) => ListTile(
        //   title: Text(
        //     widget.reports[index].description,
        //   ),
        //   subtitle: Text(
        //     widget.reports[index].id.toString(),
        //   ),
        //   onTap: widget.onTap != null
        //       ? () => widget.onTap!(widget.reports[index])
        //       : null,
        // ),
      );
}
