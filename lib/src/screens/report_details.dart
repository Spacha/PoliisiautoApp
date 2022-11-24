// Copyright 2022, Poliisiauto developers.

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
  late Future<Report> _futureReport;

  @override
  void initState() {
    super.initState();
    _futureReport = api.fetchReport(widget.reportId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ilmoituksen tiedot'), actions: [
        IconButton(
          onPressed: () async {
            bool sure = await _confirmDelete(context) ?? false;
            if (sure) {
              if (await _delete() && mounted) {
                Navigator.pop(context, 'report_deleted');
              }
            }
          },
          icon: const Icon(Icons.delete_outline),
        ),
      ]),
      body: FutureBuilder<Report>(
          future: _futureReport,
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

  Future<bool?> _confirmDelete(context) => showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Oletko varma?'),
          content: const Text('Haluatko varmasti poistaa ilmoituksen?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Peru'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Kyllä',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );

  Future<bool> _delete() async {
    return await api.deleteReport(widget.reportId);
  }
}
