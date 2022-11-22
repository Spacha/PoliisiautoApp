import 'package:flutter/material.dart';
import '../screens/sidebar.dart';
import '../routing.dart';

class CreateNewReportScreen extends StatefulWidget {
  const CreateNewReportScreen({super.key});

  @override
  State<CreateNewReportScreen> createState() => _CreateNewReportScreenState();
}

class _CreateNewReportScreenState extends State<CreateNewReportScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
     appBar : AppBar (
        title: const Text('Uusi ilmoitus'),
        centerTitle : true,
        backgroundColor: const Color.fromARGB(255, 112, 162, 237),
     ),
    drawer: const MyDrawer(),
    body: SafeArea(
      child: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: const Card(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                child: NewReportContent(),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class NewReportContent extends StatelessWidget {
  const NewReportContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
    key: const ValueKey("scroll new report page"),
    children: [
      ...[
          const Padding(
            padding: EdgeInsets.all(0),
            child: Text('Mitä tapahtui?',),),
          TextField(
            decoration: const InputDecoration(labelText: ''),
            controller: TextEditingController(),
            keyboardType: TextInputType.multiline,
            maxLines: null,
            key: const ValueKey('What happened'),
          ),
          const Padding(
            padding: EdgeInsets.all(0),
            child: Text('Ketkä olivat paikalla?',),),
          TextField(
            decoration: const InputDecoration(labelText: ''),
            controller: TextEditingController(),
            keyboardType: TextInputType.multiline,
            maxLines: null,
            key: const ValueKey('Who was there'),
          ),
          const Padding(
            padding: EdgeInsets.all(0),
            child: Text('Kenelle haluat lähettää ilmoituksen?',),),
          const Padding(
            padding: EdgeInsets.all(0),
            child: SelectTeacherDropdown()
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: SendAnonymousReportCheckbox()),
          Padding(
            padding: const EdgeInsets.all(0),
            child: OutlinedButton(
              onPressed: () async {RouteStateScope.of(context).go('/home');},
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                primary: Colors.white,
                backgroundColor: const Color.fromARGB(255, 112, 162, 237),
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('          Lähetä          '),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(0),
            child: OutlinedButton(
              onPressed: () async {RouteStateScope.of(context).go('/home');},
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                primary: Colors.white,
                backgroundColor: const Color.fromARGB(255, 158, 29, 20),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Peruuta'),
            ),
          ),
      ].map((w) => Padding(padding: const EdgeInsets.all(8), child: w)),
    ],
  );
}

const List<String> teacherList = <String>['Olli Opettaja', 'Oona Opinto-ohjaaja', 'Kaija Koulukuraattori'];

class SelectTeacherDropdown extends StatefulWidget {
  const SelectTeacherDropdown({super.key});

  @override
  State<SelectTeacherDropdown> createState() => _SelectTeacherDropdownState();
}

class _SelectTeacherDropdownState extends State<SelectTeacherDropdown> {
  String dropdownValue = teacherList.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: const Color.fromARGB(255, 112, 162, 237),
      ),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      items: teacherList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class SendAnonymousReportCheckbox extends StatefulWidget {
  const SendAnonymousReportCheckbox({super.key});

  @override
  State<SendAnonymousReportCheckbox> createState() => _SendAnonymousReportCheckboxState();
}

class _SendAnonymousReportCheckboxState extends State<SendAnonymousReportCheckbox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {

    return CheckboxListTile(
      title: const Text('Lähetä nimetön ilmoitus'),
      checkColor: Colors.white,
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      },
    );
  }
}
