import 'package:flutter/material.dart';

Color mainTheme = Colors.deepOrange.shade400;
Color unselectedItemColor = Colors.grey.shade400;
Color appBarTheme = const Color.fromARGB(255, 252, 245, 243);

TextStyle appBarTextStyle = TextStyle(color: mainTheme, fontSize: 16.5, shadows: [
                Shadow(
                  color: mainTheme.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ]);