import 'dart:ui';

typedef CartesianRectangle = ({
  Offset topLeft,
  Offset topRight,
  Offset bottomLeft,
  Offset bottomRight,
});

extension CartesianRectangleExtension on CartesianRectangle {
  List<Offset> get vertices => [topLeft, topRight, bottomRight, bottomLeft];
}
