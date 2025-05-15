import 'package:flutter/material.dart';
import 'package:mandelbrot/mandelbrot_painter.dart';

class MandelbrotScreen extends StatefulWidget {
  const MandelbrotScreen({super.key});

  @override
  State<MandelbrotScreen> createState() => _MandelbrotScreenState();
}

class _MandelbrotScreenState extends State<MandelbrotScreen> {
  double _scale = 1.75;
  Offset _offset = Offset.zero;
  int _maxIterations = 10; // Reduced iterations for simplicity
  bool _isInteracting = false;
  final double _interactionResolution =
      4.0; // Lower resolution during interaction

  void _handleInteractionStart() {
    setState(() {
      _isInteracting = true;
    });
  }

  void _handleInteractionUpdate(ScaleUpdateDetails details) {
    setState(() {
      _scale /= details.scale;
      _offset += details.focalPointDelta;
    });
  }

  void _handleInteractionEnd() {
    setState(() {
      _isInteracting = false;
    });
  }

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
                _scale = 1.75;
                _offset = Offset.zero;
              });
              print('Pressed reset');
            },
          ),
        ],
      ),
      body: GestureDetector(
        onScaleStart: (_) => _handleInteractionStart(),
        onScaleUpdate: _handleInteractionUpdate,
        onScaleEnd: (_) => _handleInteractionEnd(),
        child: CustomPaint(
          size: Size.infinite,
          painter: MandelbrotPainter(
            scale: _scale,
            offset: _offset,
            maxIterations: _maxIterations,
            resolution: _isInteracting ? _interactionResolution : 1.0,
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
              print(_maxIterations.toString());
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
              print(_maxIterations.toString());
            },
            mini: true,
            child: const Icon(Icons.remove, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
