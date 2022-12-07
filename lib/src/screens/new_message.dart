/*
 * Copyright (c) 2022, Miika Sikala, Essi Passoja, Lauri Klemettilä
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

import 'package:flutter/material.dart';
import 'package:poliisiauto/src/auth.dart';
import '../data.dart';
import '../api.dart';

////////////////////////////////////////////////////////////////////////////////
/// Form field sub-builders
////////////////////////////////////////////////////////////////////////////////

/// Description: Text field
Widget buildMessageField(
        BuildContext context, TextEditingController controller) =>
    TextFormField(
      controller: controller,
      autofocus: true,
      maxLength: 1000,
      minLines: 3,
      maxLines: 10,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Tätä kenttää ei voi jättää tyhjäksi';
        }
        return null;
      },
      decoration: const InputDecoration(
        icon: Icon(Icons.chat_outlined),
        hintText: 'Kirjoita viesti',
        labelText: 'Viestin sisältö',
      ),
    );

/// Anonymous: Checkbox
Widget buildAnonymousField(
        BuildContext context, bool state, ValueSetter<bool?> onChanged) =>
    CheckboxListTile(
      title: const Padding(
          padding: EdgeInsets.only(left: 24),
          child: Text('En halua että opettaja tietää nimeni')),
      value: state,
      onChanged: onChanged,
    );

////////////////////////////////////////////////////////////////////////////////

class NewMessageScreen extends StatefulWidget {
  final int reportId;
  final bool isTeacher;
  final bool reportIsAnonymous;

  const NewMessageScreen({
    super.key,
    required this.reportId,
    this.isTeacher = false,
    this.reportIsAnonymous = false,
  });

  @override
  State<NewMessageScreen> createState() => _NewMessageScreenState();
}

class _NewMessageScreenState extends State<NewMessageScreen> {
  final _formKey = GlobalKey<FormState>();

  /// Form fields
  final _messageController = TextEditingController();
  bool _isAnonymous = false;

  @override
  void initState() {
    super.initState();

    // set the default state of the message's anonymity:
    // if the current user is a teacher, make it always non-anonymous
    // otherwise, pre-set it to anonymous only if the report is also anonymous
    _isAnonymous = widget.isTeacher ? false : widget.reportIsAnonymous;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Lähetä viesti')),
        resizeToAvoidBottomInset: false,
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildMessageField(context, _messageController),
                  !widget.isTeacher
                      ? buildAnonymousField(context, _isAnonymous, (state) {
                          setState(() => _isAnonymous = state ?? false);
                        })
                      : const SizedBox(),
                  const SizedBox(height: 16),
                  Center(
                    child: SizedBox(
                      height: 40,
                      width: 120,
                      child: TextButton(
                        onPressed: () {
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          // Process data.
                          _submitForm();
                        },
                        child: const Text('Lähetä'),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }

  void _submitForm() async {
    int authUserId = getAuth(context).user!.id;

    await api
        .sendNewMessage(Message(
      content: _messageController.value.text,
      authorId: authUserId,
      reportId: widget.reportId,
      isAnonymous: _isAnonymous,
    ))
        .then((success) {
      if (success) {
        Navigator.pop(context, 'message_created');
      }
    });
  }
}
