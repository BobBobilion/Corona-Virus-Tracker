import 'package:flutter/material.dart';
import 'HomePage.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyHomePage homePage = new MyHomePage(null);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: MyHomePage(title: 'Coronavirus'),
      home: homePage,
    );
  }
}