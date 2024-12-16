import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:graphilia_board/graphilia_board.dart';

// TODO: Make the ConnectableDrawing also work with DrawingGroups by default
// ignore: must_be_immutable
class DrawingGroup<T> extends Drawing<T> with EquatableMixin {
  DrawingGroup({
    required super.id,
    required super.zIndex,
    required this.drawings,
  });

  factory DrawingGroup.fromMap(Map<String, dynamic> map) {
    return DrawingGroup(
      id: map['id'] as T,
      zIndex: map['zIndex'] as int,
      drawings: (map['drawings'] as List).map((e) => Drawing<T>.fromMap(e)).toList(),
    );
  }

  final List<Drawing<T>> drawings;

  @override
  List<Object?> get props => [...super.props, drawings];

  Rect? _boundsCache;

  @override
  Rect getBounds() => _boundsCache ??= _getBounds();

  Rect _getBounds() => getTotalBounds(drawings) ?? Rect.zero;

  @override
  bool isInsidePolygon(
    BoardState<T, BoardStateConfig> state,
    List<Point> vertices,
    PointsInPolygonMode mode,
  ) {
    for (final drawing in drawings) {
      final isInside = drawing.isInsidePolygon(state, vertices, mode);
      if (isInside) {
        return true;
      }
    }

    return false;
  }

  @override
  bool isPointInside(
    BoardState<T, BoardStateConfig> state,
    Point point,
    double tolerance,
  ) {
    for (final drawing in drawings) {
      final isInside = drawing.isPointInside(state, point, tolerance);
      if (isInside) {
        return true;
      }
    }

    return false;
  }

  @override
  Drawing<T> move(BoardState<T, BoardStateConfig> state, Point offset) {
    final movedDrawings = drawings.map((d) => d.move(state, offset)).toList();

    return copyWith(
      drawings: movedDrawings,
    );
  }

  @override
  Drawing<T> resize(
    BoardState<T, BoardStateConfig> state,
    Rect resizeRect,
    ResizeAnchor anchor,
    Offset delta,
  ) {
    final resizedDrawings = drawings.map((d) => d.resize(state, resizeRect, anchor, delta)).toList();

    return copyWith(
      drawings: resizedDrawings,
    );
  }

  @override
  Drawing<T>? update(BoardState<T, BoardStateConfig> state, Point newPoint) {
    final updatedDrawings = drawings.map((d) => d.update(state, newPoint)).whereType<Drawing<T>>().toList();

    return copyWith(
      drawings: updatedDrawings,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'zIndex': zIndex,
      'drawings': drawings.map((d) => d.toMap()).toList(),
    };
  }

  DrawingGroup<T> copyWith({
    T? id,
    int? zIndex,
    List<Drawing<T>>? drawings,
  }) {
    return DrawingGroup(
      id: id ?? this.id,
      zIndex: zIndex ?? this.zIndex,
      drawings: drawings ?? this.drawings,
    );
  }
}

extension ExpandDrawingGroupsExtension<T> on List<Drawing<T>> {
  List<Drawing<T>> expandDrawingGroups() {
    final expandedDrawings = <Drawing<T>>[];

    for (final drawing in this) {
      if (drawing is DrawingGroup<T>) {
        // Recursively expand drawing groups
        expandedDrawings.addAll(drawing.drawings.expandDrawingGroups());
      } else {
        expandedDrawings.add(drawing);
      }
    }

    return expandedDrawings;
  }
}
