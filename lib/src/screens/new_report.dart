// Copyright 2022, Poliisiauto developers.

import 'package:flutter/material.dart';
import 'package:poliisiauto/src/auth.dart';
import 'package:poliisiauto/src/routing.dart';
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

/// Bullied was not me: Checkbox
Widget buildBulliedWasNotMeField(
        BuildContext context, bool state, ValueSetter<bool?> onChanged) =>
    CheckboxListTile(
      title: const Padding(
          padding: EdgeInsets.only(left: 24),
          child: Text('Kiusattu oli joku muu kuin minä')),
      value: state,
      onChanged: onChanged,
    );

/// Bullied: Text field with autocomplete
Widget buildBulliedField(BuildContext context, List<User> bulliedOptions,
        TextEditingController controller, bool enabled) =>
    Autocomplete<User>(
        displayStringForOption: (option) => option.name,
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return const Iterable<User>.empty();
          }
          return bulliedOptions.where((User option) {
            return option.name
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase());
          });
        },
        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) =>
            TextFormField(
              controller: controller,
              enabled: enabled,
              focusNode: focusNode,
              onEditingComplete: onFieldSubmitted,
              maxLength: 100,
              validator: (value) {
                return null;
              },
              decoration: const InputDecoration(
                icon: Icon(Icons.person_outline),
                hintText: 'Kirjoita kiusatun nimi',
                labelText: 'Ketä kiusattiin? (valinnainen)',
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
  final _bulliedController = TextEditingController();

  User? _selectedAssignee;
  bool _bulliedWasNotMe = false;
  bool _isAnonymous = true;
  static final List<User> _studentOptions = <User>[
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

  static final List<User> _teacherOptions = <User>[
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
  void initState() {
    super.initState();
    _selectedAssignee = null;
    _bulliedWasNotMe = false;
    _isAnonymous = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Tee ilmoitus')),
        resizeToAvoidBottomInset: false,
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildDescriptionField(context, _descriptionController),
                  buildBullyField(context, _studentOptions, _bullyController),
                  buildAssigneeField(context, _teacherOptions, (User? option) {
                    setState(() => _selectedAssignee = option);
                  }),
                  buildBulliedWasNotMeField(context, _bulliedWasNotMe, (state) {
                    setState(() => _bulliedWasNotMe = state ?? false);
                  }),
                  buildBulliedField(context, _studentOptions,
                      _bulliedController, _bulliedWasNotMe),
                  buildAnonymousField(context, _isAnonymous, (state) {
                    setState(() => _isAnonymous = state ?? false);
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

  void _submitForm() async {
    // Defaults: if ID is not a positive integer, set it to null
    int authUserId = getAuth(context).user!.id;
    int? bullyId = int.tryParse(_bullyController.value.text) ?? -1;
    int? bulliedId = int.tryParse(_bulliedController.value.text) ?? -1;
    int assigneeId = _selectedAssignee?.id ?? -1;

    // if 'bullied was me', set the current user as bullied
    if (!_bulliedWasNotMe) bulliedId = authUserId;

    await api
        .storeReport(Report(
      description: _descriptionController.value.text,
      reporterId: authUserId,
      bullyId: bullyId > 0 ? bullyId : null,
      bulliedId: bulliedId > 0 ? bulliedId : null,
      assigneeId: assigneeId > 0 ? assigneeId : null,
      isAnonymous: _isAnonymous,
    ))
        .then((success) {
      // if (success) {
      //   RouteStateScope.of(context).go('/reports/sent');
      // }
    });
  }
}
