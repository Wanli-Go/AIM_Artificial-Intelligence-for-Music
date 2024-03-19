import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final List<Color> colors;
  final List<Widget> children;

  const GradientBackground({
    required this.children,
    this.colors = const [Color.fromARGB(255, 228, 111, 76), Colors.white],
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(gradient: LinearGradient(colors: colors)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.1,
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}
