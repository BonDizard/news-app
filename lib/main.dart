import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'core/utils/routes.dart';
import 'package:routemaster/routemaster.dart';
import 'package:provider/provider.dart';

import 'features/news/repository/news_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsProvider()),
      ],
      child: MaterialApp.router(
        theme: ThemeData(
          textTheme: TextTheme(
            displayLarge: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              fontSize: height * 0.02,
              color: Colors.black,
            ), // Bold
            displayMedium: TextStyle(
              fontWeight: FontWeight.normal,
              fontFamily: 'Poppins',
              fontSize: height * 0.015,
              color: Colors.black,
            ), // Medium
            bodyLarge: TextStyle(
              fontFamily: 'Poppins',
              fontSize: height * 0.01,
              color: Colors.black,
            ), // Regular
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
            return loggedOutRoute;
          },
        ),
        routeInformationParser: const RoutemasterParser(),
      ),
    );
  }
}
