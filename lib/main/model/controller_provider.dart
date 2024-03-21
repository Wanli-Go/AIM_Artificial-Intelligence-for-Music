// controller_provider.dart
import 'package:flutter/material.dart';

AnimationController? globalController;

void initializeController(TickerProvider vsync) {
  globalController = AnimationController(
    duration: const Duration(seconds: 15),
    vsync: vsync,
  );
  globalController!.repeat();
}

void disposeController() {
  globalController?.dispose();
  globalController = null;
}

void stopsAnimation() {
  globalController!.stop();
}

void startAnimation() {
  globalController!.forward(from: globalController!.value);
  globalController!.repeat();
}

