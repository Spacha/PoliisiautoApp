// Copyright 2022, Poliisiauto developers.

import 'package:flutter/material.dart';
import '../widgets/drawer.dart';
import '../data.dart';
import '../api.dart';

List<Widget> buildCreditWidgets() {
  /*
  Thesis worker summer 2021 - 2022
  Moilanen Tapio (concept videos)
  * Producing videos of three concepts (winners)

  Research and Development Project course group spring 2021
  * Producing descriptive videos based on children's ideas
  * Arranging a voting based on these videos; best idea from each school
  * Producing three concepts for the winning ideas; one idea from each school
  * Organizing a workshop for further development of their idea in Jääli school
  * Developing a prototype based on the workshop results for the Jääli concept
  * Developing protypes based on the voting results for the Kaakkuri and OIS concepts
  Pesonen Atte (project manager)
  Ansamaa Matti
  Bui Le Ba Vuong
  Salmelin Silja
  Kärkäs Petteri

  * Jääli, Kaakkuri & Oulu International School (OIS) autumn 2020
  */
  Text normText(String t) => Text(t, textAlign: TextAlign.center);
  Text boldText(String t) => Text(
        t,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold),
      );
  return [
    const SizedBox(height: 10),
    boldText('Software project -kurssi, syksy 2022'),
    normText('Miika Sikala (projektimanageri)'),
    normText('Lauri Klemettilä'),
    normText('Essi Passoja'),
    const SizedBox(height: 10),
    boldText('Oulu International School (OIS) ja Jäälin koulu, 2022'),
    normText('OIS 3-4 luokka, opettaja Heidi Tuomela'),
    normText('OIS 7A- ja 7B-luokat, opettaja Pooja Kakkar'),
    normText('Jääli 1-4 luokka, opettajat Sanna Alalauri ja Mari Perätalo'),
    const SizedBox(height: 10),
    boldText('Thesis worker, 2021 - 2022'),
    normText('Moilanen Tapio (konseptivideot)'),
    const SizedBox(height: 10),
    boldText('Research and Development Project -kurssiryhmä, kevät 2021'),
    normText('Pesonen Atte (projektimanageri)'),
    normText('Ansamaa Matti'),
    normText('Bui Le Ba Vuong'),
    normText('Salmelin Silja'),
    normText('Kärkäs Petteri'),
    const SizedBox(height: 10),
    boldText(
        'Jäälin koulu, Kaakkurin koulu ja Oulu International School (OIS), 2021'),
    normText('Jääli 6 luokka, opettaja Eveliina Jurvelin'),
    normText('Kaakkuri 6 luokka, opettaja Antti Arffman'),
    normText('OIS 2-3 luokka, opettaja Heidi Tuomela'),
  ];
}

class InformationScreen extends StatefulWidget {
  const InformationScreen({super.key});

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Tietoa sovelluksesta')),
      drawer: const PoliisiautoDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: double.infinity),
              child: const Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                  child: InformationContent(),
                ),
              ),
            ),
          ),
        ),
      ));
}

class InformationContent extends StatefulWidget {
  const InformationContent({super.key});

  @override
  State<InformationContent> createState() => _InformationContentState();
}

class _InformationContentState extends State<InformationContent> {
  late Future<Organization> futureOrganization;

  @override
  void initState() {
    super.initState();
    futureOrganization = api.fetchAuthenticatedUserOrganization();
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          ...[
            Text(
              'Poliisiauto (beta)',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
          FutureBuilder<Organization>(
            future: futureOrganization,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                    textAlign: TextAlign.center,
                    'Testiorganisaatio: ${snapshot.data!.name}\n${snapshot.data!.completeAddress}');
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
          const SizedBox(height: 20),
          Text(
            'Kiitokset',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          ...buildCreditWidgets()
        ],
      );
}
