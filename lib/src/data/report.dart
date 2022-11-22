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
