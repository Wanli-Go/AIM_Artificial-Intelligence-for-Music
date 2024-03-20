import 'package:flutter/material.dart';
import 'package:music_therapy/login/login.dart';
import 'package:music_therapy/app_theme.dart';
import 'package:music_therapy/main/view/FavoriteMusicListPage.dart';
import 'package:music_therapy/main/view/SongListPage.dart';

/*
Entry to application.

Defines theme data and some routes.

Directs to the LoginScreen. See the Login.dart file for more details.
*/
void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: mainTheme),
        fontFamily: "StarRail",
        useMaterial3: true,
      ),
        routes: {
          '/songList': (context) => const SongListPage(),
          '/favoriteMusic': (context) => const FavoriteMusicListPage(),
        },
      home: const LoginScreen()
    );
  }
}






