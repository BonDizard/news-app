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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsProvider()),
      ],
      child: MaterialApp.router(
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
