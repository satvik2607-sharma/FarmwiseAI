import 'package:farmwise_ai_satvik_sharma_20bce10196/screen_1.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Screen1(),
      debugShowCheckedModeBanner: false,
    );
  }
}
