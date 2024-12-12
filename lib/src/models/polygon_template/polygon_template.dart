import 'dart:math';
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:graphilia_board/src/models/point/point.dart';
import 'package:graphilia_board/src/models/polygon_template/polygon_template_details.dart';

export 'default_polygon_templates.dart';
export 'polygon_template_details.dart';

/// {@template polygon_template}
/// Represents a polygon template with a list of [Point]s representing the
/// vertices
/// {@endtemplate}
class PolygonTemplate with EquatableMixin {
  /// {@macro polygon_template}
  const PolygonTemplate({
    required this.vertices,
    required this.maintainAspectRatio,
    this.details,
  });

  factory PolygonTemplate.fromJson(Map<String, dynamic> map) {
    final List<dynamic> verticesMap = map['vertices'];
    final List<Point> vertices = verticesMap.map((e) => Point.fromMap(e)).toList();
    return PolygonTemplate(
      vertices: vertices,
      maintainAspectRatio: map['maintainAspectRatio'],
      details: map['details'] != null ? PolygonTemplateDetails.fromJson(map['details']) : null,
    );
  }

  /// The points representing the vertices of the polygon.
  final List<Point> vertices;

  /// Whether the aspect ratio should be maintained when scaling the polygon.
  final bool maintainAspectRatio;

  /// The details of the polygon template.
  /// It contains the size and bounds of the polygon.
  ///
  /// If a [PolygonTemplateDetails] is not provided, the size and bounds will be
  /// calculated based on the vertices every time the polygon is drawn. To
  /// improve performance, it is recommended to provide the size and bounds
  /// manually.
  final PolygonTemplateDetails? details;

  @override
  List<Object?> get props => [vertices, maintainAspectRatio, details];

  List<Offset> calculateScaledVertices(Offset anchorPoint, Offset endPoint) {
    final polygonDetails = details ??
        () {
          // Calculate the size and bounds of the polygon
          late double minX;
          late double maxX;
          late double minY;
          late double maxY;
          for (var i = 0; i < vertices.length; i++) {
            final vertex = vertices[i];
            if (i == 0) {
              minX = vertex.x;
              maxX = vertex.x;
              minY = vertex.y;
              maxY = vertex.y;
            } else {
              minX = min(minX, vertex.x);
              maxX = max(maxX, vertex.x);
              minY = min(minY, vertex.y);
              maxY = max(maxY, vertex.y);
            }
          }
          final polygonWidth = maxX - minX;
          final polygonHeight = maxY - minY;
          return PolygonTemplateDetails(
            size: Size(polygonWidth, polygonHeight),
            minX: minX,
            minY: minY,
          );
        }();

    // Calculate the difference between the first and last point
    final dx = endPoint.dx - anchorPoint.dx;
    final dy = endPoint.dy - anchorPoint.dy;

    // Calculate the scale factor for the x and y axis
    var scaleX = dx / polygonDetails.size.width;
    var scaleY = dy / polygonDetails.size.height;

    // If the aspect ratio should be maintained, use the smaller scale factor
    // for both the x and y axis
    if (maintainAspectRatio) {
      final double scale = min(scaleX.abs(), scaleY.abs());
      scaleX = scaleX.isNegative ? -scale : scale;
      scaleY = scaleY.isNegative ? -scale : scale;
    }

    // Calculate the scaled vertices
    // The polygonDetails.mins are used to allow also negative values
    // in the polygon template definition.
    final scaledVertices = <Offset>[];
    for (var i = 0; i < vertices.length; i++) {
      final vertex = vertices[i];
      scaledVertices.add(
        Offset(
          anchorPoint.dx + (vertex.x - polygonDetails.minX) * scaleX,
          anchorPoint.dy + (vertex.y - polygonDetails.minY) * scaleY,
        ),
      );
    }

    return scaledVertices;
  }

  Map<String, dynamic> toJson() => {
        'vertices': vertices.map((vertex) => vertex.toMap()).toList(),
        'maintainAspectRatio': maintainAspectRatio,
        'details': details?.toJson(),
      };
}
