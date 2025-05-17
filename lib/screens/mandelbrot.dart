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
  int _currentIterations = 5; // Minimum iterations value
  bool _isInteracting = false;

  // Dynamic resolution based on interaction
  double get _resolution => _isInteracting ? 4.0 : 1.0;

  // Zoom control parameters
  static const double _zoomSensitivity = 0.05; // Lower = slower zoom (0.0-1.0)
  // static const double _minScale = 0.1; // Minimum zoom level
  // static const double _maxScale = double.infinity; // Maximum zoom level

  void _handleInteractionStart(ScaleStartDetails details) {
    setState(() {
      _isInteracting = true;
    });
  }

  void _handleInteractionUpdate(ScaleUpdateDetails details) {
    setState(() {
      // Smooth, controlled zoom calculation
      final double scaleFactor = details.scale;
      final double zoomFactor = (scaleFactor - 1.0) * _zoomSensitivity + 1.0;
      // _scale = (_scale / zoomFactor).clamp(_minScale, _maxScale);

      _scale = (_scale / zoomFactor);

      _offset += details.focalPointDelta;
    });
  }

  void _handleInteractionEnd(ScaleEndDetails details) {
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
                _currentIterations = 5;
              });
              print('Pressed reset');
            },
          ),
        ],
      ),
      body: GestureDetector(
        onScaleStart: _handleInteractionStart,
        onScaleUpdate: _handleInteractionUpdate,
        onScaleEnd: _handleInteractionEnd,
        child: CustomPaint(
          isComplex: true,
          willChange: _isInteracting,
          size: Size.infinite,
          painter: MandelbrotPainter(
            scale: _scale,
            offset: _offset + const Offset(100, 0),
            currentIterations: _currentIterations,
            resolution: _resolution,
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
            // Disable button when iterations count are bellow 5
            onPressed:
                _currentIterations == 5
                    ? null
                    : () {
                      setState(() {
                        _currentIterations = (_currentIterations - 5).clamp(
                          5,
                          200,
                        );
                      });
                      print(_currentIterations.toString());
                    },
            mini: true,
            child: const Icon(Icons.remove, color: Colors.white),
          ),
          FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: null,
            mini: true,
            child: Text(
              _currentIterations.toString(),
              style: TextStyle(color: Colors.white),
            ),
          ),
          FloatingActionButton(
            backgroundColor: Colors.black,
            // Disable button when iterations count are above 200
            onPressed:
                _currentIterations == 200
                    ? null
                    : () {
                      setState(() {
                        _currentIterations = (_currentIterations + 5).clamp(
                          5,
                          200,
                        );
                      });
                    },
            mini: true,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
