import 'package:flutter/material.dart';
import 'package:pingo_learn_news_app/features/auth/screens/sign_up_screen.dart';
import 'package:routemaster/routemaster.dart';
import '../../features/auth/screens/sign_in_screen.dart';
import '../../features/news/screens/news_page.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => MaterialPage(child: SignUpScreen()),
  '/sign-in': (_) => const MaterialPage(child: SignInScreen()),
  '/news': (_) => MaterialPage(child: NewsScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => MaterialPage(child: NewsScreen()),
});
