import 'package:flutter/material.dart';
import 'package:postman_app/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures everything initializes properly
  await Firebase.initializeApp(); // Initializes Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String myTitle = "Postman Counter App";
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: myTitle,
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 216, 92, 52),
          
        ),
      ),
      routerConfig: AppRouter().router,
    );
  }
}
