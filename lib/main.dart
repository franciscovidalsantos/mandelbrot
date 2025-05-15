import 'package:flutter/material.dart';
import 'package:mandelbrot/screens/mandelbrot.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  // enable screen to always stay on with Wakelock
  WakelockPlus.enable();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'mandelbrot set explorer',
      home: const MandelbrotScreen(),
    );
  }
}
