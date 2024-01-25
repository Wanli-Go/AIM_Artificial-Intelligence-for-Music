import 'package:flutter/material.dart';
import 'package:music_therapy/theme.dart';
import 'package:music_therapy/view/FavoriteMusicListPage.dart';
import 'package:music_therapy/view/ScaffoldPage.dart';
import 'package:music_therapy/view/SongListPage.dart';

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
      home: const ScaffoldPage()
    );
  }
}






