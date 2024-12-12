import 'package:flutter/painting.dart';

extension DrawText on Canvas {
  void drawText(
    String text, {
    TextStyle style = const TextStyle(),
    TextDirection textDirection = TextDirection.ltr,
    double minWidth = 0,
    required double maxWidth,
    required Offset offset,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: textDirection,
    );

    textPainter.layout(minWidth: minWidth, maxWidth: maxWidth);

    textPainter.paint(this, offset);
  }
}
