import 'package:flutter/material.dart';
import 'package:lyft/views/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColorDark: Color(0xffFFBA00),
        primaryColor: Colors.black,
        primaryColorLight: Color(0xffFFBA00),
      ),
      home: const MyHomePage(),
    );
  }
}
