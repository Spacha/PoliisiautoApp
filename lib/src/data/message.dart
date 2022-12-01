// Sample request:
// "id": 3,
// "content": "This is a message to a report!",
// "author_id": 3,
// "report_id": 36,
// "is_anonymous": 0
// "created_at": "2022-11-30T19:54:12.000000Z",
// "updated_at": "2022-11-30T19:54:12.000000Z",

class Message {
  final int? id;
  final String content;
  final int? authorId;
  final int reportId;
  final bool isAnonymous;
  final DateTime? createdAt;
  final String? authorName;

  const Message({
    required this.content,
    required this.reportId,
    required this.isAnonymous,
    this.id,
    this.authorId,
    this.createdAt,
    this.authorName,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
      authorId: json['author_id'],
      reportId: json['report_id'],
      isAnonymous: json['is_anonymous'] == 1,
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
      authorName: json['author_name'],
    );
  }
  @override
  String toString() {
    return 'ReportMessage(id: $id, content: $content, isAnonymous: $isAnonymous, createdAt: $createdAt, reportId: $reportId, authorId: $authorId, authorName: $authorName)';
  }
}
