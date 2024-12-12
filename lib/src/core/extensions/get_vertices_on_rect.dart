import 'dart:ui';

extension GetVertices on Rect {
  List<Offset> get vertices => [topLeft, topRight, bottomRight, bottomLeft];
}
