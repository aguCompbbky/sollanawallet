import 'package:flutter/material.dart';

class PasswordFormWidget extends StatefulWidget {
  const PasswordFormWidget({
    super.key,
    required this.text,
    required this.controller,
  });
  final String text;
  final TextEditingController controller;

  @override
  State<PasswordFormWidget> createState() => _PasswordFormWidgetState();
}

class _PasswordFormWidgetState extends State<PasswordFormWidget> {
  bool _obscureText = true;

  late String password = widget.controller.text;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.visiblePassword,
      obscureText: _obscureText,
      decoration: InputDecoration(
        hintText: widget.text,
        suffixIcon: IconButton(
          onPressed: () {
            _obscureText = !_obscureText;
            setState(() {
              widget.controller.text = password;
            });
          },
          icon: Icon(Icons.remove_red_eye_rounded),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
      ),
    );
  }
}

///////

class EmailFormWidget extends StatefulWidget {
  const EmailFormWidget({
    super.key,
    required this.text,
    required this.controller,
  });
  final String text;
  final TextEditingController controller;

  @override
  State<EmailFormWidget> createState() => _EmailFormWidgetState();
}

class _EmailFormWidgetState extends State<EmailFormWidget> {
  late String password = widget.controller.text;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: widget.text,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
      ),
    );
  }
}
