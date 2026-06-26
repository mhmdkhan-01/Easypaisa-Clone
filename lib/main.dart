import 'package:flutter/material.dart';
import 'package:payx/screens/flashscreen_into.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorSchemeSeed: Color.fromARGB(255, 0, 194, 82)),
      home: FlashscreenInto(),
      debugShowCheckedModeBanner: false,
    );
  }
}
