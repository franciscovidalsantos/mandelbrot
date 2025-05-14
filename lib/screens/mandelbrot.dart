import 'package:flutter/material.dart';
import 'package:mandelbrot/mandelbrot_painter.dart';

class MandelbrotScreen extends StatefulWidget {
  const MandelbrotScreen({super.key});

  @override
  State<MandelbrotScreen> createState() => _MandelbrotScreenState();
}

class _MandelbrotScreenState extends State<MandelbrotScreen> {
  double _scale = 1.0;
  Offset _offset = Offset.zero;
  Offset? _lastFocalPoint;
  int _maxIterations = 50; // Reduced iterations for simplicity

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('mandelbrot', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt, color: Colors.white),
            onPressed: () {
              setState(() {
                _scale = 1.0;
                _offset = Offset.zero;
              });
            },
          ),
        ],
      ),
      body: GestureDetector(
        onScaleStart: (details) {
          _lastFocalPoint = details.localFocalPoint;
        },
        onScaleUpdate: (details) {
          setState(() {
            _scale *= details.scale;

            // Calculate the translation caused by the scaling
            final Offset currentFocalPoint = details.localFocalPoint;
            final Offset offsetDelta = currentFocalPoint - _lastFocalPoint!;
            _offset += offsetDelta;
            _lastFocalPoint = currentFocalPoint;
          });
        },
        child: CustomPaint(
          size: Size.infinite,
          painter: MandelbrotPainter(
            scale: _scale,
            offset: _offset,
            maxIterations: _maxIterations,
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () {
              setState(() {
                _maxIterations = (_maxIterations + 10).clamp(10, 200);
              });
            },
            mini: true,
            child: const Icon(Icons.add, color: Colors.white),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () {
              setState(() {
                _maxIterations = (_maxIterations - 10).clamp(10, 200);
              });
            },
            mini: true,
            child: const Icon(Icons.remove, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
