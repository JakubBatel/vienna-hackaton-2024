import 'package:flutter/material.dart';
import 'package:flame/components.dart';

class BackgroundComponent extends Component {
  final Paint _paint;

  BackgroundComponent()
      : _paint = Paint()
          ..shader = LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color(0xFF08F0F8),
              Color(0xFF08F0F8),
            ],
          ).createShader(const Rect.fromLTWH(0, 0, 1, 1));

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.largest,
      _paint,
    );
  }
}
