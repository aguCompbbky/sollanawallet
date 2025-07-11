import 'package:flutter/material.dart';
import 'package:walletsolana/utilities/button_utilities.dart';
import 'package:walletsolana/utilities/text_utilities.dart';
import 'package:go_router/go_router.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        child: Align(
          alignment: Alignment.bottomCenter,
          //color: Colors.red,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SizedBox(
                  width: 279,
                  height: 52,
                  child: ButtonWidget(
                    buttonBackgroundColor: Colors.white,
                    text: TextUtilities.singUp,
                    onpressed: () => context.go("/register"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 90),
                child: SizedBox(
                  width: 279,
                  height: 52,
                  child: ButtonWidget(
                    buttonBackgroundColor: Colors.black,
                    text: TextUtilities.logIn,
                    onpressed: () => context.go("/login"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
