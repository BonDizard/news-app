import 'package:flutter/material.dart';

class ReusableTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isObscure;

  const ReusableTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isObscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextField(
          controller: controller,
          obscureText: isObscure,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.black),
          decoration: InputDecoration(
            hintText: hintText,
            floatingLabelStyle: Theme.of(context).textTheme.displayMedium,
            labelStyle: Theme.of(context).textTheme.displayMedium,
            hintStyle: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
            contentPadding: const EdgeInsets.only(
                left: 16), // Gap between hint text and the beginning
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
