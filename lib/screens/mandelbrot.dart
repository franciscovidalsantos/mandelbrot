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

  // Zoom control parameters
  static const double _zoomSensitivity = 0.5; // Lower = slower zoom (0.1-1.0)
  static const double _minScale = 0.1; // Minimum zoom level
  static const double _maxScale = double.infinity; // Maximum zoom level

  void _handleInteractionStart() {
    setState(() {
      _isInteracting = true;
    });
  }

  void _handleInteractionUpdate(ScaleUpdateDetails details) {
    setState(() {
      // Smooth, controlled zoom calculation
      final double scaleFactor = details.scale;
      final double zoomFactor = (scaleFactor - 1.0) * _zoomSensitivity + 1.0;
      _scale = (_scale / zoomFactor).clamp(_minScale, _maxScale);

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
                _maxIterations = 10;
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
            offset: _offset + const Offset(100, 0),
            maxIterations: _maxIterations,
            resolution: _isInteracting ? _interactionResolution : 1.0,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
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
          FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: null,
            mini: true,
            child: Text(
              _maxIterations.toString(),
              style: TextStyle(color: Colors.white),
            ),
          ),
          FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed:
                _maxIterations == 10
                    ? null
                    : () {
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
