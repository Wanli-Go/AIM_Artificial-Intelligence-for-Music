import 'package:flutter/material.dart';
import 'package:music_therapy/login/login.dart';
import 'package:music_therapy/app_theme.dart';
import 'package:music_therapy/main/model/controller_provider.dart';
/*
Entry to application.

Defines theme data and some routes.

Directs to the LoginScreen. See the Login.dart file for more details.
*/
void main() {
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {

    
    initializeController(this);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: mainTheme),
        fontFamily: "StarRail",
        useMaterial3: true,
      ),
      home: const LoginScreen(
        existingName: "12312341234",
        existingPassword: "A123der123foo",
      )
      // TODO: remove existing name and password
    );
  }
}






