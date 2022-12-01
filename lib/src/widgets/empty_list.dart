// Copyright 2022, Poliisiauto developers.

import 'package:flutter/material.dart';

class EmptyListWidget extends StatelessWidget {
  final String message;
  final bool showIcon;

  const EmptyListWidget(this.message, {super.key, this.showIcon = true});

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          showIcon
              ? Icon(
                  Icons.sms_failed_outlined,
                  size: 50,
                  color: Colors.blue.shade200,
                )
              : const SizedBox(),
          const SizedBox(height: 25),
          Text(message,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade500)),
        ],
      );
}
