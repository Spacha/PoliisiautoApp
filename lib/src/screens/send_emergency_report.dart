/*
 * Copyright (c) 2022, Miika Sikala, Essi Passoja, Lauri Klemettilä
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

import 'package:flutter/material.dart';

class SendEmergencyReportScreen extends StatefulWidget {
  const SendEmergencyReportScreen({
    super.key,
  });

  @override
  State<SendEmergencyReportScreen> createState() =>
      _SendEmergencyReportScreenState();
}

class _SendEmergencyReportScreenState extends State<SendEmergencyReportScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Lähetetään hätäilmoitusta')),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  child: Text('Hätäilmoitus on lähetetty lähimmille aikuisille',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium),
                ),

                // 'Help card'
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Card(
                    color: Colors.lightBlue[50],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 16.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.support_outlined,
                            color: Theme.of(context).primaryColor,
                            size: 40,
                          ),
                          const SizedBox(height: 16.0),
                          const Text(
                            'Jos mahdollista, yritä irtautua tilanteesta.',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8.0),
                          const Text(
                            'Etsi läheltäsi luotettava aikuinen, kuten opettaja tai koulukuraattori.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Buttons for sending more material
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                        icon: const Icon(Icons.keyboard_voice_outlined),
                        onPressed: () => _onSendAudio(context),
                        label: const Text('Lähetä ääniviesti')),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                        icon: const Icon(Icons.videocam),
                        onPressed: () => _onSendVideo(context),
                        label: const Text('Lähetä videokuvaa')),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Lopeta lähetys'),
                ),
              ],
            ),
          ),
        ),
      );

  void _onSendAudio(BuildContext context) async {}

  void _onSendVideo(BuildContext context) async {}
}
