import 'package:flutter/material.dart';

class ReusableButton extends StatelessWidget {
  final VoidCallback onButtonPressed;
  final String buttonText;
  const ReusableButton(
      {super.key, required this.onButtonPressed, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Center(
        child: GestureDetector(
      onTap: onButtonPressed,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.only(
            left: width * 0.18,
            right: width * 0.18,
            top: 15,
            bottom: 15,
          ),
          child: Text(
            buttonText,
            style: Theme.of(context)
                .textTheme
                .displayLarge
                ?.copyWith(color: Theme.of(context).colorScheme.surface),
          ),
        ),
      ),
    ));
  }
}
