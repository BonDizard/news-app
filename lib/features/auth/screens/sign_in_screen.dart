import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  void navigateToNewsScreen(BuildContext context) {
    Routemaster.of(context).push('/news');
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        toolbarHeight: height * .07,
        automaticallyImplyLeading: false,
        title: Text(
          'MyNews',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Name',
                  floatingLabelStyle: Theme.of(context).textTheme.displayMedium,
                  labelStyle: Theme.of(context).textTheme.displayMedium,
                  hintStyle:
                      Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              child: Text(
                'Signup',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Theme.of(context).colorScheme.surface,
                    ),
              ),
              onPressed: () => navigateToNewsScreen(context),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
