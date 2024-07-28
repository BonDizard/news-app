import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
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
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setDefaults(const {
    'countryCode': 'in', // Set your default values here
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
      child: const MyAppContent(),
    );
  }
}

class MyAppContent extends StatefulWidget {
  const MyAppContent({super.key});

  @override
  State<MyAppContent> createState() => _MyAppContentState();
}

class _MyAppContentState extends State<MyAppContent> {
  UserModel? userModel;
  String countryCode = 'in';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initialize());
  }

  Future<void> initialize() async {
    final user = Provider.of<User?>(context, listen: false);
    if (user != null) {
      await getUserData(user.uid);
    }
    await configureRemoteConfig();
  }

  Future<void> configureRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    setState(() {
      countryCode = remoteConfig.getString('countryCode');
    });
    remoteConfig.onConfigUpdated.listen((RemoteConfigUpdate event) async {
      await remoteConfig.activate();
      setState(() {
        countryCode = remoteConfig.getString('countryCode');
      });
      Provider.of<NewsProvider>(context, listen: false)
          .setSelectedCountry(countryCode, context);
    });
  }

  Future<void> getUserData(String uid) async {
    if (kDebugMode) {
      print('getData called');
    }
    try {
      final authController =
          Provider.of<AuthController>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userStream = authController.getUserData(uid);
      userModel = await userStream.first;
      userProvider.updateUser(userModel);
      if (kDebugMode) {
        print('getData completed');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error in getData: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Consumer<User?>(
      builder: (context, user, child) {
        return MaterialApp.router(
          theme: buildThemeData(height),
          debugShowCheckedModeBanner: false,
          routerDelegate: RoutemasterDelegate(
            routesBuilder: (context) =>
                user != null ? loggedInRoute : loggedOutRoute,
          ),
          routeInformationParser: const RoutemasterParser(),
        );
      },
    );
  }

  ThemeData buildThemeData(double height) {
    return ThemeData(
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
    );
  }
}
