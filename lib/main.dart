import 'package:flutter/material.dart';
import 'package:word_mail/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Word Mail',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        textTheme: const TextTheme(
          headline2: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
          bodyText1: TextStyle(
            fontSize: 24.0,
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
