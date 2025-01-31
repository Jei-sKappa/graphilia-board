import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:graphilia_board_core/graphilia_board_core.dart';
import 'package:value_notifier_tools/value_notifier_tools.dart';

export 'board_notifier.dart';

/// {@template graphilia_board_notifier}
/// This class controls the state and behavior for a [GraphiliaBoard] widget.
/// {@endtemplate}
class BoardNotifier<T> extends ValueNotifier<BoardState<T>> with HistoryValueNotifierMixin<BoardState<T>> {
  /// {@macro graphilia_board_notifier}
  BoardNotifier({
    required Sketch<T> sketch,
    int? maxHistoryLength,
  }) : super(
          BoardState(
            sketch: sketch,
            sketchDelta: const SketchDelta.initial(),
          ),
        ) {
    maxHistoryLength = maxHistoryLength;
  }

  final GlobalKey _repaintBoundaryKey = GlobalKey();

  /// Workaround to detect whether the [transformHistoryValue] was called by an
  /// undo or redo operation.
  ///
  /// True if it was an undo operation, false if it was a redo operation.
  ///
  /// Null after the operation was completed.
  bool? _hasTriggeredUndo;

  GlobalKey get repaintBoundaryKey => _repaintBoundaryKey;

  @override
  @protected
  BoardState<T> transformHistoryValue(
    BoardState<T> newValue,
    BoardState<T> currentValue,
  ) =>
      currentValue.trasformFrom(newValue, _hasTriggeredUndo!);

  @override
  void undo() {
    _hasTriggeredUndo = true;
    super.undo();
    _hasTriggeredUndo = null;
  }

  @override
  void redo() {
    _hasTriggeredUndo = false;
    super.redo();
    _hasTriggeredUndo = null;
  }

  /// Sets the current board state.
  ///
  /// If [shouldAddToHistory] is `true`, the provided [state] will be set as the
  /// current value. Otherwise, it will be set as a temporary value.
  ///
  /// Parameters:
  /// - [state]: The new board state to be set.
  /// - [shouldAddToHistory]: A boolean flag indicating whether the state should
  ///   be added to the history. Defaults to `true`.
  ///
  /// **Note**: Before using it make sure that the [BoardState] is up to
  /// date. Avoid using this as much as possible, use the specific methods
  /// instead.
  void setBoardState({
    required BoardState<T> state,
    bool shouldAddToHistory = true,
  }) {
    if (shouldAddToHistory) {
      value = state;
    } else {
      temporaryValue = state;
    }
  }

  void updateDrawing({
    required Drawing<T> previous,
    required Drawing<T> next,
    bool shouldAddToHistory = false,
  }) {
    setBoardState(
      shouldAddToHistory: shouldAddToHistory,
      state: value.copyWith(
        sketchDelta: SketchDelta.update(
          [previous],
          [next],
          value.sketchDelta.version + 1,
        ),
      ),
    );
  }

  /// Clear the entire drawing.
  void clear() {
    value = value.clear();
  }

  Future<ByteData> renderImage({
    double pixelRatio = 1.0,
    ImageByteFormat format = ImageByteFormat.png,
  }) async {
    final renderObject = repaintBoundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (renderObject == null) {
      throw StateError(
        'Tried to convert GraphiliaBoard to Image, but no valid RenderObject '
        'was found!',
      );
    }

    final img = await renderObject.toImage(pixelRatio: pixelRatio);

    return (await img.toByteData(format: format))!;
  }

  /// Sets the zoom factor to allow for adjusting line width.
  ///
  /// If the factor is 2 for example, lines will be drawn half as thick as
  /// actually selected to allow for drawing details.
  ///
  /// Has to be greater than 0.
  void setScaleFactor(double factor) {
    assert(factor > 0, "The scale factor must be greater than 0.");
    temporaryValue = value.copyWith(
      scaleFactor: factor,
    );
  }

  void setVisibleArea(Rect area, Size boardSize, {double? padding}) {
    final areaWithPadding = padding != null ? area.inflate(padding) : area;

    final newOriginOffset = areaWithPadding.topLeft;
    final newScaleFactor = boardSize.width / areaWithPadding.width;

    temporaryValue = value.copyWith(
      originOffset: newOriginOffset,
      scaleFactor: newScaleFactor,
    );
  }
}
