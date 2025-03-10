import 'package:flutter/material.dart';
import 'package:postman_app/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const String myTitle = "Postman Counter App";
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: myTitle,
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 216, 92, 52),
        ),
      ),
      home: const MyHomePage(title: myTitle),
    );
  }
}
