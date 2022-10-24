import 'package:flutter/material.dart';
import '../routing.dart';

class Buttons {
  final bool forgotPasswordButton;

  Buttons(this.forgotPasswordButton);
}
class ForgotPasswordScreen extends StatefulWidget {
  final ValueChanged<Buttons> onForgotPassword;

  const ForgotPasswordScreen({
    required this.onForgotPassword,
    super.key,
  });

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar : AppBar (
        title: const Text('Unohditko salasanasi?'),
        centerTitle : true,
        backgroundColor: const Color.fromARGB(255, 97, 144, 184),
        leading: InkWell(
          onTap: () {
            RouteStateScope.of(context).go('/frontpage');
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
    ),
        body: Center(
          child: Card(
            child: Container(
              constraints: BoxConstraints.loose(const Size(600, 600)),
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "graphics/logo-text-1x.png",
                    height: 200,
                    width: 200,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Sähköposti:'),
                    obscureText: true,
                    controller: _emailController,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: TextButton(
                      onPressed: () async {RouteStateScope.of(context).go('/frontpage');},
                      child: const Text('Lähetä salasanan uusimislinkki sähköpostiin.'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
