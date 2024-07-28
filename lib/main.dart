import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pingo_learn_news_app/core/common/error_text.dart';
import 'package:pingo_learn_news_app/core/common/loader.dart';
import 'core/utils/routes.dart';
import 'package:routemaster/routemaster.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'features/auth/controller/auth_controller.dart';
import 'features/auth/providers/user_provider.dart';
import 'features/auth/repository/auth_repository.dart';
import 'features/news/providers/news_provider.dart';
import 'models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    // Move getData call to initState to avoid multiple calls
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (Provider.of<User?>(context, listen: false) != null) {
        getData(context, Provider.of<User?>(context, listen: false)!);
      }
    });
  }

  Future<void> getData(BuildContext context, User data) async {
    print('getData called');
    try {
      userModel = await Provider.of<AuthController>(context, listen: false)
          .getUserData(data.uid)
          .first;
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.updateUser(userModel);
      setState(() {});
      print('getData completed');
    } catch (error) {
      print('Error in getData: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(
          create: (_) => AuthController(
            authRepository: AuthRepository(
              auth: FirebaseAuth.instance,
              firestore: FirebaseFirestore.instance,
            ),
          ),
        ),
        StreamProvider<User?>(
          create: (context) =>
              Provider.of<AuthController>(context, listen: false)
                  .authStateChange,
          initialData: null,
        ),
      ],
      child: Consumer<User?>(
        builder: (context, data, child) {
          return MaterialApp.router(
            theme: ThemeData(
              textTheme: TextTheme(
                displayLarge: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  fontSize: height * 0.02,
                  color: Colors.black,
                ),
                displayMedium: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Poppins',
                  fontSize: height * 0.015,
                  color: Colors.black,
                ),
                bodyLarge: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: height * 0.01,
                  color: Colors.black,
                ),
              ),
              colorScheme: const ColorScheme(
                brightness: Brightness.light,
                primary: Color(0xFF0C54BE),
                onPrimary: Colors.white,
                secondary: Color(0xFF303F60),
                onSecondary: Colors.white,
                error: Colors.red,
                onError: Colors.white,
                surface: Color(0xFFF5F9FD),
                onSurface: Color(0xFFCED3DC),
              ),
            ),
            debugShowCheckedModeBanner: false,
            routerDelegate: RoutemasterDelegate(
              routesBuilder: (context) {
                if (data != null) {
                  print('User is logged in');
                  return loggedInRoute;
                }
                print('User is not logged in');
                return loggedOutRoute;
              },
            ),
            routeInformationParser: const RoutemasterParser(),
          );
        },
      ),
    );
  }
}
