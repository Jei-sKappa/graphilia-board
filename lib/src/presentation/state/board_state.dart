import 'package:flutter/widgets.dart';
import 'package:equatable/equatable.dart';
import 'package:graphilia_board/graphilia_board.dart';
import 'package:graphilia_board/src/core/constants/undefined.dart';

typedef StateLayerPainter = void Function(Canvas canvas, Size size);

// TODO: This should be removed
typedef UpdatedSketchDetails<T> = ({
  bool shouldAddToUndoHistory,
  SketchDelta<T> sketchDelta,
});

/// {@template graphilia_board_state}
/// The state of the board widget when it is being drawn on.
/// {@endtemplate}

// TODO: !!! RENAME THIS TO BoardState
class BoardState<T> with EquatableMixin {
  /// {@macro graphilia_board_state}
  const BoardState({
    this.originOffset = Offset.zero,
    this.strokePoints = const [],
    this.activePointerIds = const [],
    this.pointerPosition,
    this.scaleFactor = 1,
    this.mouseCursor,
    this.interactionFeedbacks = const [],
    required this.sketch,
    required this.sketchDelta,
  });

  const BoardState._({
    required this.originOffset,
    required this.strokePoints,
    required this.activePointerIds,
    required this.pointerPosition,
    required this.scaleFactor,
    required this.mouseCursor,
    required this.interactionFeedbacks,
    required this.sketch,
    required this.sketchDelta,
  });

  BoardState.fromOther(BoardState<T> other)
      : originOffset = other.originOffset,
        strokePoints = other.strokePoints,
        activePointerIds = other.activePointerIds,
        pointerPosition = other.pointerPosition,
        scaleFactor = other.scaleFactor,
        mouseCursor = other.mouseCursor,
        interactionFeedbacks = other.interactionFeedbacks,
        sketch = other.sketch,
        sketchDelta = other.sketchDelta;

  /// The offset representing the current offset from the origin
  /// (`Offset.zero`).
  final Offset originOffset;

  /// The list of operations that have been undone and can be redone.
  final List<Point> strokePoints;

  /// The ids of all supported pointers that are currently interacting with
  /// the widget.
  final List<int> activePointerIds;

  /// The current position of the pointer
  final Point? pointerPosition;

  /// How much the widget is scaled at the moment.
  ///
  /// Can be used if zoom functionality is needed
  /// (e.g. through InteractiveViewer) so that the pen width remains the same.
  final double scaleFactor;

  final MouseCursor? mouseCursor;

  final List<InteractionFeedback> interactionFeedbacks;

  /// The current state of the sketch
  final Sketch<T> sketch;

  /// Represent a single update to the sketch.
  ///
  /// Every modification to the sketch should applied by updating this delta and
  /// not the sketch directly.
  final SketchDelta<T> sketchDelta;

  @override
  List<Object?> get props => [
        originOffset,
        strokePoints,
        activePointerIds,
        pointerPosition,
        scaleFactor,
        mouseCursor,
        interactionFeedbacks,
        sketch,
        sketchDelta,
      ];

  BoardStateCopyWith<T> get copyWith => _BoardStateCopyWithImpl<T>(this);

  StateLayerPainter? get paintStateLayer => null;

  bool shouldRepaintStateLayer(BoardState<T> other) => false;

  /// Returns the oldState while preserving the necessary data in the current
  /// state.
  @mustCallSuper
  BoardState<T> trasformFrom(BoardState<T> other, bool isUndo) {
    if (sketchDelta.version == other.sketchDelta.version) return this;

    final transformedState = copyWith(
      sketchDelta: other.sketchDelta,
      sketchDeltaToApplyToSketch: isUndo ? this.sketchDelta.reverse() : null,
    );

    // TODO: Check if this is necessary
    // TODO: [BoardState] should not be aware of [SelectedState]
    if (other is! SelectedState<T>) return transformedState;

    // Redirect the transformation to the [SelectedState] state
    return SelectedState.trasformFromSelectingState<T>(
      transformedState,
      other,
      isUndo,
    );
  }

  /// Returns a new state with the unnecessary data removed.
  BoardState<T> clear() {
    return copyWith(
      sketchDelta: SketchDelta.delete(
        sketch.drawings,
        sketchDelta.version + 1,
      ),
    );
  }
}

// CopyWith Helper
abstract class BoardStateCopyWith<T> {
  BoardState<T> call({
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
  });
}

class _BoardStateCopyWithImpl<T> implements BoardStateCopyWith<T> {
  _BoardStateCopyWithImpl(this._state);

  final BoardState<T> _state;

  @override
  BoardState<T> call({
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
  }) {
    if (shouldApplySketchDeltaToSketch) {
      if (sketchDeltaToApplyToSketch != null) {
        _state.sketch.applyDelta(sketchDeltaToApplyToSketch);
      } else if (sketchDelta != null) {
        _state.sketch.applyDelta(sketchDelta);
      }
    }

    return BoardState._(
      originOffset: originOffset ?? _state.originOffset,
      strokePoints: strokePoints ?? _state.strokePoints,
      activePointerIds: activePointerIds ?? _state.activePointerIds,
      pointerPosition: pointerPosition == const Undefinied() ? _state.pointerPosition : pointerPosition as Point?,
      scaleFactor: scaleFactor ?? _state.scaleFactor,
      mouseCursor: mouseCursor == const Undefinied() ? _state.mouseCursor : mouseCursor as MouseCursor?,
      interactionFeedbacks: interactionFeedbacks ?? _state.interactionFeedbacks,
      sketch: _state.sketch,
      sketchDelta: sketchDelta ?? _state.sketchDelta,
    );
  }
}
