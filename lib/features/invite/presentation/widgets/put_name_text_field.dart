import 'package:flutter/material.dart';

class PutNameTextField extends StatelessWidget {
  PutNameTextField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.focusNode,
    this.errorText,
  });

  final Function(String) onChanged;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      onChanged: onChanged,
      controller: controller,
      decoration: InputDecoration(
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
        errorText: errorText,
        filled: true,
        fillColor: const Color(0xFFF0F0F0),
        contentPadding: const EdgeInsets.all(20),
        hintText: 'Имя',
        hintStyle: const TextStyle(
          color: Color(0xFF959595),
          fontSize: 18,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w800,
          height: 0.06,
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none),
      ),
    );
  }
}
