// Copyright 2022, Poliisiauto developers.

import 'package:flutter/material.dart';
import '../data.dart';
import '../api.dart';

////////////////////////////////////////////////////////////////////////////////
/// Form field sub-builders
////////////////////////////////////////////////////////////////////////////////

/// Description: Text field
Widget buildDescriptionField(
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
        icon: Icon(Icons.speaker_notes_outlined),
        hintText: 'Kerro omin sanoin mitä tapahtui',
        labelText: 'Mitä tapahtui?',
      ),
    );

/// Bully: Text field with autocomplete
Widget buildBullyField(BuildContext context, List<User> bullyOptions,
        TextEditingController controller) =>
    Autocomplete<User>(
        displayStringForOption: (option) => option.name,
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return const Iterable<User>.empty();
          }
          return bullyOptions.where((User option) {
            return option.name
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase());
          });
        },
        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) =>
            TextFormField(
              controller: controller,
              focusNode: focusNode,
              onEditingComplete: onFieldSubmitted,
              maxLength: 100,
              validator: (value) {
                return null;
              },
              decoration: const InputDecoration(
                icon: Icon(Icons.person_outline),
                hintText: 'Kirjoita kiusaajan nimi',
                labelText: 'Kuka kiusasi? (valinnainen)',
                counterText: '',
              ),
            ),
        onSelected: ((option) => controller.text = option.id.toString()));

Widget buildAssigneeField(BuildContext context, List<User> assigneeOptions,
        ValueSetter<User?> onChanged) =>
    DropdownButtonFormField<User>(
      onChanged: onChanged,
      items: assigneeOptions.map<DropdownMenuItem<User>>((User option) {
        return DropdownMenuItem<User>(
          value: option,
          child: Text(option.name),
        );
      }).toList(),
      decoration: const InputDecoration(
        icon: Icon(Icons.person_outline),
        hintText: 'Valitse opettaja',
        labelText: 'Kenelle haluat lähettää ilmoituksen?',
        counterText: '',
      ),
    );

////////////////////////////////////////////////////////////////////////////////

class NewReportScreen extends StatefulWidget {
  const NewReportScreen({super.key});

  @override
  State<NewReportScreen> createState() => _NewReportScreenState();
}

class _NewReportScreenState extends State<NewReportScreen> {
  final _formKey = GlobalKey<FormState>();

  /// Form fields
  final _descriptionController = TextEditingController();
  final _bullyController = TextEditingController();

  User? _selectedAssignee;

  @override
  void initState() {
    super.initState();
    _selectedAssignee = null;
  }

  static final List<User> _bullyOptions = <User>[
    User(
        id: 1,
        firstName: 'Miika',
        lastName: 'Sikala',
        email: 'miika@example.com',
        emailVerified: true,
        role: UserRole.student),
    User(
        id: 2,
        firstName: 'Essi',
        lastName: 'Passoja',
        email: 'essi@example.com',
        emailVerified: true,
        role: UserRole.student),
    User(
        id: 3,
        firstName: 'Lauri',
        lastName: 'Klemettilä',
        email: 'lauri@example.com',
        emailVerified: true,
        role: UserRole.student),
  ];

  static final List<User> _assigneeOptions = <User>[
    User(
        // Always add this to the front
        id: -1,
        firstName: 'Kuka tahansa opettaja',
        lastName: '',
        email: '',
        emailVerified: true,
        role: UserRole.teacher),
    User(
        id: 4,
        firstName: 'Onni',
        lastName: 'Opettaja',
        email: 'onni@example.com',
        emailVerified: true,
        role: UserRole.teacher),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Tee ilmoitus')),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildDescriptionField(context, _descriptionController),
                  buildBullyField(context, _bullyOptions, _bullyController),
                  buildAssigneeField(context, _assigneeOptions, (User? option) {
                    setState(() => _selectedAssignee = option);
                  }),
                  const SizedBox(height: 16),
                  Center(
                    child: SizedBox(
                      height: 40,
                      width: 120,
                      child: TextButton(
                        onPressed: () {
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.
                          if (_formKey.currentState!.validate()) {
                            // Process data.
                            _submitForm();
                          }
                        },
                        child: const Text('Lähetä'),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }

  void _submitForm() {
    api.storeReport(Report(
      description: _descriptionController.value.text,
      bullyId: int.parse(_bullyController.value.text),
      // bulliedId: int.parse(_bulliedController.value.text),
      // isAnonymous: int.parse(_isAnonymous.value.text) == 1,
      assigneeId: _selectedAssignee?.id,
      isAnonymous: true,
    ));
  }
}
