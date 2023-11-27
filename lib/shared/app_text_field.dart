import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    this.controller,
    this.obscureText = false,
    super.key,
    this.hintText,
    this.onPressed,
    this.suffixIcon,
    this.keyboardType,
  });

  final TextEditingController? controller;
  final bool obscureText;
  final String? hintText;
  final VoidCallback? onPressed;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          )),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter some text";
        }
        return null;
      },
    );
  }
}
