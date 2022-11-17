// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

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
      openedAt: json['opened_at'] ?? "",
    );
  }
}
