import 'package:flutter/material.dart';
import 'package:pingo_learn_news_app/features/auth/screens/widgets/reusable_button.dart';
import 'package:pingo_learn_news_app/features/auth/screens/widgets/reusable_text_field.dart';
import 'package:routemaster/routemaster.dart';
import 'package:provider/provider.dart';
import '../../../core/common/loader.dart';
import '../../../core/utils/snack_bar.dart';
import '../controller/auth_controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  void navigateToSignInScreen(BuildContext context) {
    Routemaster.of(context).push('/sign-in');
  }

  void signUp() {
    final authController = Provider.of<AuthController>(context, listen: false);
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final name = nameController.text.trim();

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      showSnackBar(context: context, text: 'Please enter all the fields');
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

    if (name.length < 3) {
      showSnackBar(
          context: context, text: 'Name must be at least 3 characters long');
      return;
    }

    authController.signUpWithEmailAndPassword(
      context: context,
      email: email,
      userName: name,
      password: password,
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final isLoading =
        Provider.of<AuthController>(context, listen: false).isLoading;
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
      body: isLoading
          ? Loader()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ReusableTextField(
                            controller: nameController, hintText: 'Name'),
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
                  onButtonPressed: () => signUp(),
                  buttonText: 'Signup',
                ),
                const SizedBox(
                    height: 20), // Add some space between button and text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () => navigateToSignInScreen(context),
                      child: Text(
                        'Login',
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
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
