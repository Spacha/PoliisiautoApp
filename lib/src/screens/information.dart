// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:url_launcher/link.dart';
import 'package:http/http.dart' as http;

//import '../auth.dart';
//import '../routing.dart';
import '../widgets/drawer.dart';

Future<Report> fetchReport() async {
  var headers = {
    'Authorization': 'Bearer 7|B95Amhh0gXp8rwDu3Ozhi0tFyolzYCpTPJtrSc7Y'
  };
  var request = http.MultipartRequest(
      'GET', Uri.parse('http://192.168.56.56/api/v1/reports/1'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    //print(await response.stream.bytesToString());
    //return Album.fromJson(jsonDecode(response.body));
    return Report.fromJson(jsonDecode(await response.stream.bytesToString()));
  } else {
    //print(response.reasonPhrase);
    throw Exception('Failed to load album');
  }
}

class Report {
  final int id;
  final String description;
  final int reportCaseId;
  final String openedAt;

  const Report({
    required this.id,
    required this.description,
    required this.reportCaseId,
    required this.openedAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      description: json['description'],
      reportCaseId: json['report_case_id'],
      openedAt: json['opened_at'],
    );
  }
}

class InformationScreen extends StatefulWidget {
  const InformationScreen({super.key});

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Information')),
      drawer: const PoliisiautoDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: double.infinity),
              child: const Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                  child: InformationContent(),
                ),
              ),
            ),
          ),
        ),
      ));
}

class InformationContent extends StatefulWidget {
  const InformationContent({
    super.key,
  });

  @override
  State<InformationContent> createState() => _InformationContentState();
}

class _InformationContentState extends State<InformationContent> {
  late Future<Report> futureReport;

  @override
  void initState() {
    super.initState();
    futureReport = fetchReport();
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          ...[
            Text(
              'Information',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
          TextButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Alert!'),
                content: const Text('The alert description goes here.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
            child: const Text('Show Dialog'),
          ),
          FutureBuilder<Report>(
            future: futureReport,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.description);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ],
      );
}
