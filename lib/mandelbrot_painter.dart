import 'package:flutter/material.dart';

class MandelbrotPainter extends CustomPainter {
  final double scale;
  final Offset offset;
  final int currentIterations;
  final double resolution;

  MandelbrotPainter({
    required this.scale,
    required this.offset,
    required this.currentIterations,
    this.resolution = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    // Adjust scale and position
    final double adjustedScale = 200.0 / scale;
    final double offsetX = offset.dx / scale;
    final double offsetY = offset.dy / scale;

    final double step = resolution; // Use resolution to skip pixels

    for (double x = 0; x < size.width; x += step) {
      for (double y = 0; y < size.height; y += step) {
        double zx = (x - centerX - offsetX) / adjustedScale;
        double zy = (y - centerY - offsetY) / adjustedScale;

        // Mandelbrot set calculation
        int iteration = 0;
        double cx = zx;
        double cy = zy;

        while (zx * zx + zy * zy < 4 && iteration < currentIterations) {
          final tmp = zx * zx - zy * zy + cx;
          zy = 2 * zx * zy + cy;
          zx = tmp;
          iteration++;
        }
        double t = iteration / currentIterations;
        paint.color =
            iteration == currentIterations
                // Color based on iterations
                ? Colors.black
                // Simple coloring based on iterations
                : Color.fromRGBO(
                  (255 * t).toInt(),
                  (255 * t * t).toInt(),
                  (255 * (1 - t)).toInt(),
                  0.75,
                );

        canvas.drawRect(Rect.fromLTWH(x, y, step, step), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant MandelbrotPainter oldDelegate) {
    return oldDelegate.scale != scale ||
        oldDelegate.offset != offset ||
        oldDelegate.currentIterations != currentIterations ||
        oldDelegate.resolution != resolution;
  }
}
