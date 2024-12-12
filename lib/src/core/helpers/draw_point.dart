import 'dart:ui';

import 'package:graphilia_board/src/models/point/point.dart';

void drawPoint(
  Canvas canvas,
  Point point,
  double width,
  Paint paint,
) {
  canvas.drawCircle(
    point,
    width / 2,
    paint,
  );
}
