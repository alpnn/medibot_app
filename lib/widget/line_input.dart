import 'package:flutter/material.dart';

class SingleLineTextInput extends StatelessWidget {
  const SingleLineTextInput({
    Key? key,
    required this.textInputType,
    required this.labelText,
    required this.errorText,
    required this.obscureText,
    required this.onChange,
  }) : super(key: key);

  final TextInputType textInputType;
  final String labelText;
  final String? errorText;
  final bool obscureText;
  final void Function(String) onChange;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChange,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(6),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        labelText: labelText,
        errorText: errorText,
      ),
      obscureText: obscureText,
      keyboardType: textInputType,
    );
  }
}
