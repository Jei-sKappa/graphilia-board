import 'dart:ui';

import 'package:equatable/equatable.dart';

/// {@template polygon_template_details}
/// Represents the size and bounds of a polygon template.
/// {@endtemplate}
class PolygonTemplateDetails with EquatableMixin {
  /// {@macro polygon_template_details}
  const PolygonTemplateDetails({
    required this.size,
    required this.minX,
    required this.minY,
  });

  factory PolygonTemplateDetails.fromJson(Map<String, dynamic> map) {
    return PolygonTemplateDetails(
      size: Size(map['width'], map['height']),
      minX: map['minX'],
      minY: map['minY'],
    );
  }

  /// The size of the polygon.
  final Size size;

  /// The minimum x value of the polygon.
  final double minX;

  /// The minimum y value of the polygon.
  final double minY;

  @override
  List<Object?> get props => [size, minX, minY];

  Map<String, dynamic> toJson() => {
        'width': size.width,
        'height': size.height,
        'minX': minX,
        'minY': minY,
      };
}
