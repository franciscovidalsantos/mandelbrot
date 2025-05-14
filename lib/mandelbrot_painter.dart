import 'package:flutter/material.dart';

class MandelbrotPainter extends CustomPainter {
  final double scale;
  final Offset offset;
  final int maxIterations;

  MandelbrotPainter({
    required this.scale,
    required this.offset,
    required this.maxIterations,
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

    for (double x = 0; x < size.width; x++) {
      for (double y = 0; y < size.height; y++) {
        // Convert pixel coordinates to complex plane coordinates
        double zx = (x - centerX - offsetX) / adjustedScale;
        double zy = (y - centerY - offsetY) / adjustedScale;

        // Mandelbrot set calculation
        int iteration = 0;
        double cx = zx;
        double cy = zy;
        double tmp;

        while (zx * zx + zy * zy < 4 && iteration < maxIterations) {
          tmp = zx * zx - zy * zy + cx;
          zy = 2 * zx * zy + cy;
          zx = tmp;
          iteration++;
        }

        // Color based on iterations
        if (iteration == maxIterations) {
          paint.color = Colors.black;
        } else {
          // Simple coloring based on iterations
          double t = iteration / maxIterations;
          paint.color = Color.fromRGBO(
            (255 * t).toInt(),
            (255 * t * t).toInt(),
            (255 * (1 - t)).toInt(),
            1.0,
          );
        }

        canvas.drawRect(Rect.fromLTWH(x, y, 1, 1), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant MandelbrotPainter oldDelegate) {
    return oldDelegate.scale != scale ||
        oldDelegate.offset != offset ||
        oldDelegate.maxIterations != maxIterations;
  }
}
