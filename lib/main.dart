import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/task_provider.dart';
import './screens/login_screen.dart';
import 'package:flutter_application_1/sqflite/db_helper.dart';
import './screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: MyApp(),
    ),
  );
  DBHelper.addUser();
}

class MyApp extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 255, 255)),
        useMaterial3: true,
      ),
      home: LoginScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
        },
    );
  }
}

