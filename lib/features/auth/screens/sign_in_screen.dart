import 'package:flutter/material.dart';
import 'package:pingo_learn_news_app/features/auth/screens/widgets/reusable_button.dart';
import 'package:pingo_learn_news_app/features/auth/screens/widgets/reusable_text_field.dart';
import 'package:routemaster/routemaster.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/snack_bar.dart';
import '../controller/auth_controller.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void navigateToSignUpScreen(BuildContext context) {
    Routemaster.of(context).pop();
  }

  void signIn() {
    final authController = Provider.of<AuthController>(context, listen: false);
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showSnackBar(
          context: context, text: 'Please enter both email and password');
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      showSnackBar(
          context: context, text: 'Please enter a valid email address');
      return;
    }

    if (password.length < 8) {
      showSnackBar(
          context: context,
          text: 'Password must be at least 8 characters long');
      return;
    }

    authController.signInWithEmailAndPassword(
      context: context,
      email: email,
      password: password,
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;

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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ReusableTextField(
                      controller: emailController, hintText: 'Email'),
                  ReusableTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    isObscure: true,
                  ),
                ],
              ),
            ),
          ),
          ReusableButton(
            onButtonPressed: () => signIn(),
            buttonText: 'Login',
          ),
          const SizedBox(height: 20), // Add some space between button and text
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'New here?',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () => navigateToSignUpScreen(context),
                child: Text(
                  'Signup',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60), // Add some space at the bottom
        ],
      ),
    );
  }
}
