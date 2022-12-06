// Sample request:
// "id": 1,
// "description": "Joku (ehkä Jaska) kiusaa mua taas!",
// "report_case_id": 1,
// "reporter_id": 1,
// "handler_id": null,
// "bully_id": null,
// "bullied_id": null,
// "is_anonymous": 1,
// "type": 1,
// "opened_at": "2022-10-09T13:41:31.000000Z",
// "closed_at": null,
// "created_at": "2022-10-09T12:35:58.000000Z",
// "updated_at": "2022-10-09T20:20:58.000000Z"

enum ReportStatus {
  pending('pending'),
  opened('opened'),
  closed('closed');

  const ReportStatus(this.str);
  final String str;
}

class Report {
  final int? id;
  final String description;
  final int? reportCaseId;
  final int? reporterId;
  final int? handlerId;
  final int? bullyId;
  final int? bulliedId;
  final bool isAnonymous;
  final DateTime? createdAt;
  final DateTime? openedAt;
  final DateTime? closedAt;
  final String? reporterName;
  final String? bullyName;
  final String? bulliedName;

  const Report({
    required this.description,
    required this.isAnonymous,
    this.id,
    this.createdAt,
    this.openedAt,
    this.closedAt,
    this.reportCaseId,
    this.reporterId,
    this.handlerId,
    this.bullyId,
    this.bulliedId,
    this.reporterName,
    this.bullyName,
    this.bulliedName,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      description: json['description'],
      isAnonymous: json['is_anonymous'] == 1,
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
      openedAt: json['opened_at'] != null ? DateTime.tryParse(json['opened_at']) : null,
      closedAt: json['closed_at'] != null ? DateTime.tryParse(json['closed_at']) : null,
      reportCaseId: json['report_case_id'],
      reporterId: json['reporter_id'],
      handlerId: json['handler_id'],
      bullyId: json['bully_id'],
      bulliedId: json['bullied_id'],
      reporterName: json['reporter_name'],
      bullyName: json['bully_name'],
      bulliedName: json['bullied_name'],
    );
  }

  ReportStatus get status {
    if (closedAt != null) {
      return ReportStatus.closed;
    } else if (openedAt != null) {
      return ReportStatus.opened;
    } else {
      return ReportStatus.pending;
    }
  }

  @override
  String toString() {
    return 'Report(id: $id, description: $description, isAnonymous: $isAnonymous, openedAt: $openedAt, closedAt: $closedAt, reportCaseId: $reportCaseId, reporterId: $reporterId, handlerId: $handlerId, bullyId: $bullyId, bulliedId: $bulliedId), reporterName: $reporterName)';
  }
}
