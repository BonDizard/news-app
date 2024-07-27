import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  void navigateToNewsScreen(BuildContext context) {
    Routemaster.of(context).push('/news');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('login screen'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('news'),
          onPressed: () => navigateToNewsScreen(context),
        ),
      ),
    );
  }
}
