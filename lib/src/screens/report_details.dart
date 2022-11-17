// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
//import 'package:url_launcher/link.dart';

import '../data.dart';

class ReportDetailsScreen extends StatelessWidget {
  final Report? report;

  const ReportDetailsScreen({
    super.key,
    this.report,
  });

  @override
  Widget build(BuildContext context) {
    if (report == null) {
      return const Scaffold(
        body: Center(
          child: Text('No report found.'),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(report!.description),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              report!.description,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              'Something', //report!.author.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton(
              child: const Text('View author (Push)'),
              onPressed: () {
                // Navigator.of(context).push<void>(
                //   MaterialPageRoute<void>(
                //     builder: (context) =>
                //         AuthorDetailsScreen(author: book!.author),
                //   ),
                // );
              },
            ),
            // Link(
            //   uri: Uri.parse('/author/${book!.author.id}'),
            //   builder: (context, followLink) => TextButton(
            //     onPressed: followLink,
            //     child: const Text('View author (Link)'),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
