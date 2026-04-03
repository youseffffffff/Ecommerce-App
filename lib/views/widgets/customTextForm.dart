import 'package:flutter/material.dart';

class Customtextform extends StatelessWidget {
  const Customtextform({
    super.key,
    required this.textEditingController,
    required this.textInputType,
    required this.hintText,
  });

  final TextEditingController textEditingController;
  final TextInputType textInputType;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        controller: textEditingController,
        keyboardType: textInputType,
        validator: (value) => value != null && value.isEmpty
            ? 'Please enter your ${hintText}'
            : null,
        decoration: InputDecoration(
          labelText: hintText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
