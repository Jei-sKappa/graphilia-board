import 'dart:math';
import 'dart:ui';

import 'package:equatable/equatable.dart';

extension OffsetGeometryHelperExtensions on Offset {
  double distanceSquaredTo(Offset offset) {
    final xDist = dx - offset.dx;
    final yDist = dy - offset.dy;
    return xDist * xDist + yDist * yDist;
  }

  double distanceTo(Offset offset) {
    return sqrt(distanceSquaredTo(offset));
  }

  /// Also known as the dot product.
  double scalarProduct(Offset other) {
    return dx * other.dx + dy * other.dy;
  }
}

/// {@template point}
/// Represents a point in a sketch with an x and y coordinate and an optional
/// pressure value.
/// {@endtemplate}
class Point extends Offset with EquatableMixin {
  /// {@macro point}
  const Point(
    this.x,
    this.y, {
    this.pressure,
  }) : super(x, y);

  factory Point.fromMap(Map<String, dynamic> map) {
    return Point(
      map['x'],
      map['y'],
      pressure: map['pressure'],
    );
  }

  /// Identical to [dx]
  final double x;

  /// Identical to [dy]
  final double y;

  /// The pressure of the point, between 0 and 1,
  /// or null if the pressure is unknown.
  final double? pressure;

  @override
  List<Object?> get props => [x, y, pressure];

  static const zero = Point(0, 0);

  Point.fromOffset(
    Offset offset, {
    double? pressure,
  }) : this(offset.dx, offset.dy, pressure: pressure);

  /// Snaps the current point to a snap target within a given threshold.
  ///
  /// The [snapTarget] is the point to which the current point will be snapped.
  /// The [threshold] is the maximum distance allowed for snapping.
  ///
  /// Returns a new [Point] object that represents the snapped point.
  /// If the distance between the current point and the snap target is less than
  /// or equal to the threshold, the coordinates of the snap target will be
  /// used.
  /// Otherwise, the coordinates of the current point will be used.
  /// The pressure of the current point will be preserved in the snapped point.
  // TODO: Add 45 degree snapping
  Point snapTo(Point snapTarget, double threshold) {
    return Point(
      (x - snapTarget.x).abs() <= threshold ? snapTarget.x : x,
      (y - snapTarget.y).abs() <= threshold ? snapTarget.y : y,
      pressure: pressure,
    );
  }

  @override
  Point operator *(double operand) {
    return Point(
      x * operand,
      y * operand,
      pressure: pressure,
    );
  }

  @override
  Point operator +(Offset other) {
    return Point(
      x + other.dx,
      y + other.dy,
      pressure: switch (other) {
        _ when other is Point => pressure ?? other.pressure,
        _ => pressure,
      },
    );
  }

  @override
  Point operator -(Offset other) {
    return Point(
      x - other.dx,
      y - other.dy,
      pressure: switch (other) {
        _ when other is Point => other.pressure ?? pressure,
        _ => pressure,
      },
    );
  }

  /// Negates the vector.
  @override
  Point operator -() {
    return Point(
      -x,
      -y,
      pressure: pressure,
    );
  }

  @override
  Point operator /(double operand) {
    return Point(
      x / operand,
      y / operand,
      pressure: pressure,
    );
  }

  @override
  Point translate(double translateX, double translateY) => Point(x + translateX, y + translateY, pressure: pressure);

  Point copyWith({
    double? x,
    double? y,
    double? pressure,
  }) {
    return Point(
      x ?? this.x,
      y ?? this.y,
      pressure: pressure ?? this.pressure,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'x': x,
      'y': y,
      'pressure': pressure,
    };
  }
}
