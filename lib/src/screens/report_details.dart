// Copyright 2022, Poliisiauto developers.

import 'package:flutter/material.dart';
import '../api.dart';
import '../data.dart';

Widget buildField(BuildContext context, String label, String content) =>
    Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 6),
          Text(content)
        ]));

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
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  buildField(context, 'Ilmoituksen kuvaus',
                      snapshot.data!.description),
                  const Divider(color: Color.fromARGB(255, 193, 193, 193)),
                  buildField(context, 'Ilmoittaja',
                      snapshot.data!.reporterName ?? '(ei tiedossa)'),
                  const Divider(color: Color.fromARGB(255, 193, 193, 193)),
                  buildField(context, 'Kiusaaja',
                      snapshot.data!.bullyName ?? '(ei ilmoitettu)'),
                  const Divider(color: Color.fromARGB(255, 193, 193, 193)),
                  buildField(context, 'Kiusattu',
                      snapshot.data!.bulliedName ?? '(ei ilmoitettu)'),
                  const Divider(color: Color.fromARGB(255, 193, 193, 193)),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: Card(
                              color: Color.fromARGB(255, 170, 231, 202),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Text('Ei viestejä',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 86, 157, 123)))
                                  ])))),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _onSendMessage(),
                          icon: const Icon(Icons.message_outlined),
                          label: const Text('Lähetä viesti'),
                        ),
                      ))
                ],
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

  void _onSendMessage() {
    return;
  }
}
