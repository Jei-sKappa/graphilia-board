import 'dart:ui';

import 'package:graphilia_board/src/models/point/point.dart';
import 'package:graphilia_board/src/models/polygon_template/polygon_template.dart';

// TODO: PolygonTemplate should not use Point with pressure

/// The [PolygonTemplate] for a square polygon.
const squarePolygon = PolygonTemplate(
  vertices: [
    Point(0, 0),
    Point(0, 500),
    Point(500, 500),
    Point(500, 0),
  ],
  maintainAspectRatio: true,
  details: PolygonTemplateDetails(
    size: Size(500, 500),
    minX: 0,
    minY: 0,
  ),
);

const rectanglePolygon = PolygonTemplate(
  vertices: [
    Point(0, 0),
    Point(0, 500),
    Point(1000, 500),
    Point(1000, 0),
  ],
  maintainAspectRatio: false,
  details: PolygonTemplateDetails(
    size: Size(1000, 500),
    minX: 0,
    minY: 0,
  ),
);

/// The [PolygonTemplate] for a isosceles triangle polygon.
const isoscelesTrianglePolygon = PolygonTemplate(
  vertices: [
    Point(0, 0),
    Point(3, 5),
    Point(-3, 5),
  ],
  maintainAspectRatio: true,
  details: PolygonTemplateDetails(
    size: Size(6, 5),
    minX: -3,
    minY: 0,
  ),
);
