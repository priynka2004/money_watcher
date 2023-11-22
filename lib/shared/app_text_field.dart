import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    this.controller,
    this.obscureText = false,
    super.key, this.hintText, this.onPressed, this.suffixIcon});

  final TextEditingController? controller;
  final bool obscureText;
  final String? hintText;
  final VoidCallback? onPressed;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return  TextFormField(
      controller: controller,
      obscureText:obscureText,
      decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          )),
    );
  }
}
