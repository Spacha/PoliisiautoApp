// Copyright 2022, Poliisiauto developers.

import 'package:flutter/material.dart';
import '../auth.dart';
import '../api.dart';
import '../data.dart';
import '../screens/new_message.dart';

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
  late Future<List<Message>> _futureMessages;

  @override
  void initState() {
    super.initState();
    _futureReport = api.fetchReport(widget.reportId);
    _refreshMessages();
  }

  void _refreshMessages() {
    setState(() {
      _futureMessages = api.fetchMessages(widget.reportId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ilmoituksen tiedot'), actions: [
        IconButton(
          onPressed: () async {
            bool sure = await _confirmDelete(
                    context, 'Haluatko varmasti poistaa ilmoituksen?') ??
                false;
            if (sure) {
              if (await _deleteReport() && mounted) {
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
              return ListView(
                children: [
                  const SizedBox(height: 6),
                  _buildField('Ilmoituksen kuvaus',
                      content: snapshot.data!.description),
                  const Divider(color: Color.fromARGB(255, 193, 193, 193)),
                  _buildField('Ilmoittaja',
                      content: snapshot.data!.reporterName ?? '(nimetön)'),
                  const Divider(color: Color.fromARGB(255, 193, 193, 193)),
                  _buildField('Kiusaaja',
                      content: snapshot.data!.bullyName ?? '(ei ilmoitettu)'),
                  const Divider(color: Color.fromARGB(255, 193, 193, 193)),
                  _buildField('Kiusattu',
                      content: snapshot.data!.bulliedName ?? '(ei ilmoitettu)'),
                  const Divider(color: Color.fromARGB(255, 193, 193, 193)),
                  _buildField('Viestit',
                      child: _buildMessagesWidget(_futureMessages)),
                  const Divider(color: Color.fromARGB(255, 193, 193, 193)),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _openNewMessageScreen(
                            context, snapshot.data!.isAnonymous),
                        icon: const Icon(Icons.message_outlined),
                        label: const Text('Lähetä viesti'),
                      ),
                    ),
                  )
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

  Future<bool?> _confirmDelete(context, String message) => showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Oletko varma?'),
          content: Text(message),
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

  Future<bool> _deleteReport() async {
    return await api.deleteReport(widget.reportId);
  }

  Future<bool> _deleteMessage(int messageId) async {
    return await api.deleteMessage(messageId);
  }

  void _openNewMessageScreen(BuildContext context, bool isAnonymous) async {
    return Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => NewMessageScreen(
          reportId: widget.reportId,
          isTeacher: isTeacher(context),
          reportIsAnonymous: isAnonymous),
    ))
        .then((result) {
      if (result != null) _refreshMessages();
    });
  }

  /////////////////////////////////////////////////////////////////////////////
  /// Builders
  /////////////////////////////////////////////////////////////////////////////

  Widget _buildField(String label, {String? content, Widget? child}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 6),
        child ?? Text(content ?? '')
      ]));

  Widget _buildMessagesWidget(Future<List<Message>> futureMessageList) =>
      FutureBuilder<List<Message>>(
          future: futureMessageList,
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!.isEmpty
                  ? Text('tyhjä') //TODO!
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: Column(
                        children: [
                          ...snapshot.data!
                              .map((msg) => _buildMessageBubbleWidget(msg))
                        ],
                      ),
                    );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const Center(child: CircularProgressIndicator());
          }));

  Widget _buildMessageBubbleWidget(Message message) {
    int currentUserId = getAuth(context).user!.id;
    bool byCurrentUser = message.authorId == currentUserId;

    return SizedBox(
        width: double.infinity,
        child: GestureDetector(
            onLongPress: () async {
              if (!byCurrentUser) return;

              bool sure = await _confirmDelete(
                      context, 'Haluatko varmasti poistaa viestin?') ??
                  false;
              if (sure) {
                if (await _deleteMessage(message.id!) && mounted) {
                  _refreshMessages();
                }
              }
            },
            child: Card(
              color: byCurrentUser ? Colors.green.shade100 : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: byCurrentUser
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                          byCurrentUser
                              ? 'Sinä'
                              : (message.authorName ?? 'Nimetön'),
                          style: TextStyle(
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic)),
                      Text(
                        message.content,
                        textAlign: TextAlign.left,
                      ),
                    ]),
              ),
            )));
    /*return ListTile(
      title: Text(message.content),
      subtitle: Text('${message.authorName ?? 'Nimetön'}$byMeStr'),
      tileColor: Colors.,
    );*/
  }
}
