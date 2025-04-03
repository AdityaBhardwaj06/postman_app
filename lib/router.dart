import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:postman_app/home.dart';
import 'package:postman_app/login.dart';
import 'package:postman_app/signup.dart';

class StreamRouterRefresh extends ChangeNotifier {
  StreamRouterRefresh() {
    FirebaseAuth.instance.authStateChanges().listen((event) {
      notifyListeners(); // Notify GoRouter when auth state changes
    });
  }
}

class AppRouter {
  final GoRouter router;

  AppRouter() : router = GoRouter(
    initialLocation: "/login",
    refreshListenable: StreamRouterRefresh(),
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      return user == null ? "/login" : "/home";
    },
    routes: [
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => MaterialPage(child: LoginPage()),
      ),
      GoRoute(
        path: '/signup',
        pageBuilder: (context, state) => MaterialPage(child: SignupPage()),
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => MaterialPage(child: MyHomePage()),
      ),
    ],
  );
}
