import 'package:flutter/material.dart';
import 'package:mandelbrot/mandelbrot_painter.dart';

class MandelbrotScreen extends StatefulWidget {
  const MandelbrotScreen({super.key});

  @override
  State<MandelbrotScreen> createState() => _MandelbrotScreenState();
}

class _MandelbrotScreenState extends State<MandelbrotScreen> {
  // Starting zoom parameters
  final double _startingZoomScale = 1.75;
  final Offset _startingZoomOffset = Offset.zero;
  // Maximum zoom parameters
  final double _maxZoomScale = 2.0;
  final Offset _maxZoomOffset = Offset.zero;
  // Dynamic zoom parameters
  late double _currentZoomScale;
  late Offset _currentZoomOffset;

  int _currentIterations = 5; // Minimum iterations value

  bool _isInteracting = false;
  // Dynamic resolution based on interaction
  double get _resolution => _isInteracting ? 4.0 : 1.0;

  // Gesture-related state
  double _initialGestureScale = 1.0;

  void _handleInteractionStart(ScaleStartDetails details) {
    _initialGestureScale = _currentZoomScale;

    setState(() {
      _isInteracting = true;
    });
  }

  void _handleInteractionUpdate(ScaleUpdateDetails details) {
    setState(() {
      double zoomingScale = _initialGestureScale / details.scale;

      // Limit zoom while zooming out
      if (zoomingScale > _maxZoomScale) {
        _currentZoomScale = _maxZoomScale;
        _currentZoomOffset = _maxZoomOffset;
        return;
      }

      // Update zoom while zooming in
      if (zoomingScale < _maxZoomScale) {
        _currentZoomScale = zoomingScale;
        _currentZoomOffset += details.focalPointDelta * zoomingScale;
      }
    });
  }

  void _handleInteractionEnd(ScaleEndDetails details) {
    setState(() {
      _isInteracting = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize zoom parameters
    _currentZoomScale = _startingZoomScale;
    _currentZoomOffset = _startingZoomOffset;
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
                _currentZoomScale = _startingZoomScale;
                _currentZoomOffset = _startingZoomOffset;
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
            scale: _currentZoomScale,
            offset: _currentZoomOffset + const Offset(150, 0),
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
