import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:graphilia_board/graphilia_board.dart';
import 'package:graphilia_board/src/core/constants/undefined.dart';
import 'package:graphilia_board/src/presentation/layers/layers.dart';

class SelectedState<T, C extends BoardStateConfig> extends BoardState<T, C> with EquatableMixin {
  const SelectedState({
    super.originOffset,
    super.strokePoints,
    super.activePointerIds,
    super.pointerPosition,
    super.scaleFactor,
    super.mouseCursor,
    super.interactionFeedbacks,
    required super.sketch,
    required super.sketchDelta,
    required this.selectionPoints,
    required this.selectionRect,
    required this.selectedDrawings,
    required this.selectedDrawingsBounds,
    this.displayRectangularSelection = false,
  }) : previousSelectedDrawings = selectedDrawings;

  const SelectedState._({
    required super.originOffset,
    required super.strokePoints,
    required super.activePointerIds,
    required super.pointerPosition,
    required super.scaleFactor,
    required super.mouseCursor,
    required super.interactionFeedbacks,
    required super.sketch,
    required super.sketchDelta,
    required this.selectionPoints,
    required this.selectionRect,
    required this.previousSelectedDrawings,
    required this.selectedDrawings,
    required this.selectedDrawingsBounds,
    required this.displayRectangularSelection,
  });

  SelectedState.fromOther(
    super.other, {
    required this.selectionPoints,
    required this.selectionRect,
    required this.selectedDrawingsBounds,
    required this.selectedDrawings,
    this.displayRectangularSelection = false,
  })  : previousSelectedDrawings = selectedDrawings,
        super.fromOther();

  final List<Point> selectionPoints;
  final Rect selectionRect;
  final List<Drawing<T>> previousSelectedDrawings;
  final List<Drawing<T>> selectedDrawings;
  final Rect selectedDrawingsBounds;
  // TODO: This shouldn't be a property of the state
  final bool displayRectangularSelection;

  @override
  List<Object?> get props => [
        ...super.props,
        selectionPoints,
        selectionRect,
        previousSelectedDrawings,
        selectedDrawings,
        selectedDrawingsBounds,
        displayRectangularSelection,
      ];

  @override
  SelectedStateCopyWith<T, C> get copyWith => _SelectedStateCopyWithImpl<T, C>(this);

  // TODO: Make the inflation factor customizable
  /// The [selectedDrawingsBounds] rect inflated by 5 pixels.
  Rect get rectangularSelection => selectedDrawingsBounds.inflate(
        5 / scaleFactor,
      );

  @override
  StateLayerPainter get paintStateLayer => (Canvas canvas, Size size) {
        if (displayRectangularSelection) {
          _drawRectangularSelection(
            canvas: canvas,
            rect: rectangularSelection,
            radius: kBaseResizeRectAnchorRadius / scaleFactor,
            rectPaint: Paint()
              ..color = Colors.blue.shade700
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2 / scaleFactor,
            circleFillPaint: Paint()
              ..color = Colors.blue.shade100
              ..style = PaintingStyle.fill,
            circleBorderPaint: Paint()
              ..color = Colors.blue.shade700
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.5 / scaleFactor,
          );
        } else {
          drawDashedPath(
            canvas: canvas,
            points: selectionPoints,
            dashWidth: 6 / scaleFactor,
            dashSpace: 6 / scaleFactor,
            paint: Paint()
              ..color = Colors.grey
              ..style = PaintingStyle.stroke
              ..strokeCap = StrokeCap.round
              ..strokeWidth = 2.5 / scaleFactor,
          );
        }
      };

  @override
  bool shouldRepaintStateLayer(BoardState other) {
    if (other is! SelectedState) return true;

    if (displayRectangularSelection != other.displayRectangularSelection) return true;

    if (displayRectangularSelection) {
      return selectedDrawingsBounds != other.selectedDrawingsBounds;
    }

    return selectionPoints != other.selectionPoints;
  }

  @override
  BoardState<T, C> trasformFrom(BoardState<T, C> other, isUndo) {
    final rollbackedState = super.trasformFrom(other, isUndo);

    if (rollbackedState is! SelectedState<T, C>) return rollbackedState;

    if (other is! SelectedState<T, C>) {
      return rollbackedState.copyWith(
        selectionPoints: [],
        selectionRect: null,
        previousSelectedDrawings: [],
        selectedDrawings: [],
        selectedDrawingsBounds: null,
        displayRectangularSelection: false,
      );
    }

    return rollbackedState.copyWith(
      selectionPoints: other.selectionPoints,
      selectionRect: other.selectionRect,
      previousSelectedDrawings: other.previousSelectedDrawings,
      selectedDrawings: other.selectedDrawings,
      selectedDrawingsBounds: other.selectedDrawingsBounds,
      displayRectangularSelection: other.displayRectangularSelection,
    );
  }

  /// Intented to use only by [SelectingState]
  static SelectedState<T, C> trasformFromSelectingState<T, C extends BoardStateConfig>(
    BoardState<T, C> state,
    SelectedState<T, C> other,
    isUndo,
  ) =>
      SelectedState._(
        originOffset: state.originOffset,
        strokePoints: state.strokePoints,
        activePointerIds: state.activePointerIds,
        pointerPosition: state.pointerPosition,
        scaleFactor: state.scaleFactor,
        mouseCursor: state.mouseCursor,
        interactionFeedbacks: state.interactionFeedbacks,
        sketch: state.sketch,
        sketchDelta: state.sketchDelta,
        selectionPoints: other.selectionPoints,
        selectionRect: other.selectionRect,
        selectedDrawingsBounds: other.selectedDrawingsBounds,
        selectedDrawings: other.selectedDrawings,
        previousSelectedDrawings: other.previousSelectedDrawings,
        displayRectangularSelection: other.displayRectangularSelection,
      );

  void _drawRectangularSelection({
    required Canvas canvas,
    required Rect rect,
    required double radius,
    required Paint rectPaint,
    required Paint circleFillPaint,
    required Paint circleBorderPaint,
  }) {
    // Draw the interaction rect
    canvas.drawRect(rect, rectPaint);

    // Draw smaller filled circles on every corner of the interaction rect
    canvas.drawCircle(rect.topLeft, radius, circleFillPaint);
    canvas.drawCircle(rect.topCenter, radius, circleFillPaint);
    canvas.drawCircle(rect.topRight, radius, circleFillPaint);
    canvas.drawCircle(rect.centerRight, radius, circleFillPaint);
    canvas.drawCircle(rect.bottomRight, radius, circleFillPaint);
    canvas.drawCircle(rect.bottomCenter, radius, circleFillPaint);
    canvas.drawCircle(rect.bottomLeft, radius, circleFillPaint);
    canvas.drawCircle(rect.centerLeft, radius, circleFillPaint);

    // Draw a circle on every corner of the interaction rect
    canvas.drawCircle(rect.topLeft, radius, circleBorderPaint);
    canvas.drawCircle(rect.topCenter, radius, circleBorderPaint);
    canvas.drawCircle(rect.topRight, radius, circleBorderPaint);
    canvas.drawCircle(rect.centerRight, radius, circleBorderPaint);
    canvas.drawCircle(rect.bottomRight, radius, circleBorderPaint);
    canvas.drawCircle(rect.bottomCenter, radius, circleBorderPaint);
    canvas.drawCircle(rect.bottomLeft, radius, circleBorderPaint);
    canvas.drawCircle(rect.centerLeft, radius, circleBorderPaint);
  }
}

// CopyWith helpers
abstract class SelectedStateCopyWith<T, C extends BoardStateConfig> implements BoardStateCopyWith<T, C> {
  @override
  SelectedState<T, C> call({
    Offset? originOffset,
    List<Point>? strokePoints,
    List<int>? activePointerIds,
    Point? pointerPosition,
    double? scaleFactor,
    MouseCursor? mouseCursor,
    List<InteractionFeedback>? interactionFeedbacks,
    SketchDelta<T>? sketchDelta,
    SketchDelta<T>? sketchDeltaToApplyToSketch,
    bool shouldApplySketchDeltaToSketch = true,
    List<Point>? selectionPoints,
    Rect? selectionRect,
    List<Drawing<T>>? previousSelectedDrawings,
    List<Drawing<T>>? selectedDrawings,
    Rect? selectedDrawingsBounds,
    bool? displayRectangularSelection,
  });
}

class _SelectedStateCopyWithImpl<T, C extends BoardStateConfig> implements SelectedStateCopyWith<T, C> {
  _SelectedStateCopyWithImpl(this._state);

  final SelectedState<T, C> _state;

  @override
  SelectedState<T, C> call({
    Offset? originOffset,
    List<Point>? strokePoints,
    List<int>? activePointerIds,
    Object? pointerPosition = const Undefinied(),
    double? scaleFactor,
    Object? mouseCursor = const Undefinied(),
    List<InteractionFeedback>? interactionFeedbacks,
    SketchDelta<T>? sketchDelta,
    SketchDelta<T>? sketchDeltaToApplyToSketch,
    bool shouldApplySketchDeltaToSketch = true,
    List<Point>? selectionPoints,
    Rect? selectionRect,
    List<Drawing<T>>? previousSelectedDrawings,
    List<Drawing<T>>? selectedDrawings,
    Rect? selectedDrawingsBounds,
    bool? displayRectangularSelection,
  }) {
    if (shouldApplySketchDeltaToSketch) {
      if (sketchDeltaToApplyToSketch != null) {
        _state.sketch.applyDelta(sketchDeltaToApplyToSketch);
      } else if (sketchDelta != null) {
        _state.sketch.applyDelta(sketchDelta);
      }
    }

    return SelectedState._(
      originOffset: originOffset ?? _state.originOffset,
      strokePoints: strokePoints ?? _state.strokePoints,
      activePointerIds: activePointerIds ?? _state.activePointerIds,
      pointerPosition: pointerPosition == const Undefinied() ? _state.pointerPosition : pointerPosition as Point?,
      scaleFactor: scaleFactor ?? _state.scaleFactor,
      mouseCursor: mouseCursor == const Undefinied() ? _state.mouseCursor : mouseCursor as MouseCursor?,
      interactionFeedbacks: interactionFeedbacks ?? _state.interactionFeedbacks,
      sketch: _state.sketch,
      sketchDelta: sketchDelta ?? _state.sketchDelta,
      selectionPoints: selectionPoints ?? _state.selectionPoints,
      selectionRect: selectionRect ?? _state.selectionRect,
      previousSelectedDrawings: previousSelectedDrawings ?? _state.previousSelectedDrawings,
      selectedDrawings: selectedDrawings ?? _state.selectedDrawings,
      selectedDrawingsBounds: selectedDrawingsBounds ?? _state.selectedDrawingsBounds,
      displayRectangularSelection: displayRectangularSelection ?? _state.displayRectangularSelection,
    );
  }
}

extension SelectedStateCast<T, C extends BoardStateConfig> on BoardState<T, C> {
  SelectedState<T, C> get asSelectedState => this as SelectedState<T, C>;
}
