import 'dart:ui';

import 'package:graphilia_board_core/graphilia_board_core.dart';

part 'sketch_delta.dart';

abstract class Sketch<T> {
  bool get isEmpty;

  bool get isNotEmpty => !isEmpty;

  List<Drawing<T>> get drawings;

  Drawing<T>? getDrawingById(T id);

  List<Drawing<T>> getDrawingsByPoint(
    BoardState<T> state,
    Point point, {
    required double tolerance,
  });

  List<Drawing<T>> getDrawingsByRect(Rect rect);

  void applyDelta(SketchDelta<T> delta);

  @override
  String toString() {
    return 'Sketch(drawings: $drawings)';
  }

  Map<String, dynamic> toMap() {
    return {
      'drawings': drawings.map((drawing) => drawing.toMap()).toList(),
    };
  }
}
