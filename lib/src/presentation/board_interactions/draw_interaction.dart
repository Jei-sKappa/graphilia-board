import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:graphilia_board/src/core/constants/uuid.dart';
import 'package:one_dollar_unistroke_recognizer/one_dollar_unistroke_recognizer.dart' as one_dollar_recognizer;
import 'package:graphilia_board/graphilia_board.dart';

class _DrawingState<T> {
  _DrawingState() {
    initialize();
  }

  late Drawing<T>? activeDrawing;
  late InteractionFeedback? interactionFeedback;

  void initialize() {
    activeDrawing = null;
    interactionFeedback = null;
  }
}

class DrawInteraction<T> extends BoardInteraction<T> {
  DrawInteraction({
    required this.tool,
    this.enableStraightLineRecognition = true,
    this.enableCircleRecognition = true,
    this.enableRectangleRecognition = true,
    this.enableTriangleRecognition = true,
    T Function(BoardState<T, BoardStateConfig>? state)? idGenerator,
  }) : _interactionState = _DrawingState() {
    if (idGenerator != null) {
      this.idGenerator = idGenerator;
    } else if (T == int) {
      this.idGenerator = ((state) => generateIdFromDateTime() as T);
    } else if (T == String) {
      this.idGenerator = ((state) => uuid.v4() as T);
    } else {
      throw ArgumentError('idGenerator must be provided for type $T');
    }
  }

  /// The tool that is currently selected for drawing.
  final DrawingTool<T> tool;

  final _DrawingState<T> _interactionState;

  final bool enableStraightLineRecognition;
  final bool enableCircleRecognition;
  final bool enableRectangleRecognition;
  final bool enableTriangleRecognition;

  /// An id generator that is used to generate ids for the drawings.
  ///
  /// If `null`, and [T] is [int] or [String] a default id generator will be
  /// used, otherwise an exception will be thrown.
  ///
  /// The default id generator for [int] is the current time in microseconds
  /// since epoch, and for [String] is UUID v4.
  late final T Function(BoardState<T, BoardStateConfig>? state) idGenerator;

  BoardState<T, BoardStateConfig> _removeMouseCursor(
    BoardState<T, BoardStateConfig> state,
  ) {
    return state.copyWith(
      mouseCursor: SystemMouseCursors.none,
    );
  }

  BoardState<T, BoardStateConfig> _restoreMouseCursor(
    BoardState<T, BoardStateConfig> state,
  ) {
    return state.copyWith(
      mouseCursor: null,
    );
  }

  BoardState<T, BoardStateConfig> _setInteractionFeedback(
    BoardState<T, BoardStateConfig> state,
    InteractionFeedback interactionFeedback,
  ) {
    final previousInteractionFeedback = _interactionState.interactionFeedback;
    _interactionState.interactionFeedback = interactionFeedback;

    final updatedInteractionFeedbacks = [
      ...state.interactionFeedbacks.where((e) => e != previousInteractionFeedback),
      _interactionState.interactionFeedback!,
    ];

    return state.copyWith(
      interactionFeedbacks: updatedInteractionFeedbacks,
    );
  }

  BoardState<T, BoardStateConfig> _clearInteractionFeedback(BoardState<T, BoardStateConfig> state) {
    if (_interactionState.interactionFeedback == null) return state;

    return state.copyWith(
      interactionFeedbacks: state.interactionFeedbacks.where((e) => e != _interactionState.interactionFeedback).toList(),
    );
  }

  void _drawPointer(Canvas canvas, BoardState<T, BoardStateConfig> state, BoardStateConfig config) {
    if (state.pointerPosition != null) {
      tool.drawPreview(
        canvas,
        state.pointerPosition!,
        state,
      );
    }
  }

  InteractionFeedback? _createActiveInteractionFeedback(BoardState<T, BoardStateConfig> state, BoardStateConfig config) {
    if (_interactionState.activeDrawing is CanvasDrawing) {
      return CanvasInteractionFeedback(
        (canvas) => (_interactionState.activeDrawing as CanvasDrawing).draw(
          state,
          canvas,
          isSelected: false,
        ),
      );
    } else if (_interactionState.activeDrawing is WidgetDrawing) {
      final widgetDrawing = _interactionState.activeDrawing as WidgetDrawing;
      return WidgetInteractionFeedback(
        (context) => Positioned.fromRect(
          rect: widgetDrawing.getBounds(),
          child: widgetDrawing.build(context, state, isSelected: false),
        ),
      );
    } else if (_interactionState.activeDrawing == null) {
      return null;
    } else {
      // TODO: Add a log / Think about how to handle this case
      return null;
    }
  }

  BoardState<T, BoardStateConfig> disposeResources(BoardState<T, BoardStateConfig> state) {
    var updatedState = _clearInteractionFeedback(state);

    // Restore mouse cursor
    updatedState = _restoreMouseCursor(updatedState);

    // Reset the interaction state
    _interactionState.initialize();

    return updatedState;
  }

  @override
  void onRemoved(BoardNotifier<T, BoardStateConfig> notifier) {
    final state = notifier.value;

    final updatedState = disposeResources(state);

    notifier.setBoardState(
      state: updatedState,
      shouldAddToHistory: false,
    );
  }

  @override
  PointerHoverEventListenerHandler<T> get handlePointerHoverEvent => (
        PointerHoverEvent event,
        BoardNotifier<T, BoardStateConfig> notifier,
      ) {
        final state = notifier.value;

        // Update the mouse cursor
        var updatedState = _removeMouseCursor(state);

        // Update the interaction feedback
        updatedState = _setInteractionFeedback(
          updatedState,
          CanvasInteractionFeedback(
            (canvas) => _drawPointer(canvas, updatedState, notifier.config),
          ),
        );

        notifier.setBoardState(
          state: updatedState,
          shouldAddToHistory: false,
        );
        return true;
      };

  @override
  DetailedGestureScaleStartCallbackHandler<T> get handleOnScaleStart => (
        ScaleStartDetails details,
        PointerEvent initialEvent,
        PointerEvent event,
        BoardNotifier<T, BoardStateConfig> notifier,
      ) {
        final state = notifier.value;

        final point = event.getPoint(notifier.config.pointPressureCurve).relativeToVisibleArea(state);

        final autoGeneratedId = idGenerator(state);
        final autoGeneratedZIndex = notifier.config.zIndexManager.read();

        final drawing = tool.createDrawing(
          point,
          autoGeneratedId,
          autoGeneratedZIndex,
          state,
        );

        _setActiveDrawing(drawing);

        // Update the interaction feedback
        final interactionFeedback = _createActiveInteractionFeedback(state, notifier.config);
        if (interactionFeedback != null) {
          final updatedState = _setInteractionFeedback(state, interactionFeedback);

          notifier.setBoardState(
            state: updatedState,
            shouldAddToHistory: false,
          );
        }

        return true;
      };

  @override
  DetailedGestureScaleUpdateCallbackHandler<T> get handleOnScaleUpdate => (
        ScaleUpdateDetails details,
        PointerEvent initialEvent,
        PointerEvent event,
        BoardNotifier<T, BoardStateConfig> notifier,
      ) {
        final state = notifier.value;

        final point = event.getPoint(notifier.config.pointPressureCurve).relativeToVisibleArea(state);

        _addPointToDrawing(point, state);

        // Update the interaction feedback
        final interactionFeedback = _createActiveInteractionFeedback(state, notifier.config);
        if (interactionFeedback != null) {
          final updatedState = _setInteractionFeedback(state, interactionFeedback);

          notifier.setBoardState(
            state: updatedState,
            shouldAddToHistory: false,
          );
        }

        return true;
      };

  @override
  DetailedGestureScaleEndCallbackHandler<T> get handleOnScaleEnd => (
        ScaleEndDetails details,
        PointerEvent initialEvent,
        PointerEvent event,
        BoardNotifier<T, BoardStateConfig> notifier,
      ) {
        final state = notifier.value;

        // Try to recognize the drawing;
        if (_interactionState.activeDrawing is SimpleLine<T>) {
          final simpleLine = _interactionState.activeDrawing as SimpleLine<T>;
          final recognizedName = simpleLine.recognizeUnistroke();
          if (recognizedName != null) {
            if (_shouldConvertDrawing(recognizedName)) {
              final newDrawing = simpleLine.tryConvertToRecognizedDrawing(
                recognizedName,
              );
              // [newDrawing] can't be null because we checked if it should be
              // converted
              _setActiveDrawing(newDrawing!);
            }
          }
        }

        var updatedState = _addActiveDrawingToSketch(state, notifier.config);

        // Update the interaction feedback
        updatedState = _clearInteractionFeedback(updatedState);

        // Reset the interaction state
        _interactionState.initialize();

        notifier.setBoardState(
          state: updatedState,
          shouldAddToHistory: true,
        );
        return true;
      };

  @override
  PointerCancelEventListenerHandler<T> get handlePointerCancelEvent => (
        PointerCancelEvent event,
        BoardNotifier<T, BoardStateConfig> notifier,
      ) {
        var updatedState = _addActiveDrawingToSketch(notifier.value, notifier.config);

        // Update the interaction feedback
        updatedState = _clearInteractionFeedback(updatedState);

        // Reset the interaction state
        _interactionState.initialize();

        notifier.setBoardState(
          state: updatedState,
          shouldAddToHistory: false,
        );
        return true;
      };

  @override
  PointerExitEventListenerHandler<T> get handlePointerExitEvent => (
        PointerExitEvent event,
        BoardNotifier<T, BoardStateConfig> notifier,
      ) {
        var updatedState = _addActiveDrawingToSketch(notifier.value, notifier.config);

        updatedState = disposeResources(updatedState);

        notifier.setBoardState(
          state: updatedState,
          shouldAddToHistory: false,
        );
        return true;
      };

  bool _shouldConvertDrawing(one_dollar_recognizer.DefaultUnistrokeNames name) {
    switch (name) {
      case one_dollar_recognizer.DefaultUnistrokeNames.line:
        return enableStraightLineRecognition;
      case one_dollar_recognizer.DefaultUnistrokeNames.circle:
        return enableCircleRecognition;
      case one_dollar_recognizer.DefaultUnistrokeNames.rectangle:
        return enableRectangleRecognition;
      case one_dollar_recognizer.DefaultUnistrokeNames.triangle:
        return enableTriangleRecognition;
      default:
        return false;
    }
  }

  void _setActiveDrawing(Drawing<T> activeDrawing) {
    _interactionState.activeDrawing = activeDrawing;
  }

  void _addPointToDrawing(Point point, BoardState<T, BoardStateConfig> state) {
    if (_interactionState.activeDrawing == null) return;

    // TODO: Consider determining if the point is far enough away from the
    // last point to be considered a new point. Currently this details is
    // leave to the drawing tool.

    final updatedActiveDrawing = _interactionState.activeDrawing!.update(
      state,
      point,
    );

    if (updatedActiveDrawing == null) return;

    _interactionState.activeDrawing = updatedActiveDrawing;
  }

  BoardState<T, BoardStateConfig> _addActiveDrawingToSketch(
    BoardState<T, BoardStateConfig> state,
    BoardStateConfig config,
  ) {
    if (_interactionState.activeDrawing == null) return state;

    return state.copyWith(
      sketchDelta: SketchDelta.add(
        [_interactionState.activeDrawing!],
        state.sketchDelta.version + 1,
      ),
    );
  }
}

extension ConvertLineToOtherDrawing<T> on SimpleLine<T> {
  one_dollar_recognizer.DefaultUnistrokeNames? recognizeUnistroke() {
    final recognized = one_dollar_recognizer.recognizeUnistroke(representation.points);

    if (recognized == null) return null;

    if (recognized.score < 0.735) return null;

    return recognized.name;
  }

  Drawing<T>? tryConvertToRecognizedDrawing(one_dollar_recognizer.DefaultUnistrokeNames name) {
    switch (name) {
      case one_dollar_recognizer.DefaultUnistrokeNames.line:
        return convertToStraightLine();
      case one_dollar_recognizer.DefaultUnistrokeNames.circle:
        return convertToCircleDrawing();
      case one_dollar_recognizer.DefaultUnistrokeNames.rectangle:
        return convertToRectangle();
      case one_dollar_recognizer.DefaultUnistrokeNames.triangle:
        return convertToTriangle();
      default:
        return null;
    }
  }

  SimpleStraightLine<T> convertToStraightLine() {
    return SimpleStraightLine<T>(
      id: id,
      zIndex: zIndex,
      representation: AnchoredDrawingRepresentation(
        anchorPoint: representation.points.first,
        endPoint: representation.points.last,
      ),
      color: color,
      width: width,
    );
  }

  SimpleCircleDrawing<T> convertToCircleDrawing() {
    final bounds = getBounds();
    return SimpleCircleDrawing<T>(
      id: id,
      zIndex: zIndex,
      representation: AnchoredDrawingRepresentation(
        anchorPoint: Point.fromOffset(bounds.topLeft),
        endPoint: Point.fromOffset(bounds.bottomRight),
      ),
      color: color,
      width: width,
    );
  }

  SimplePolygonDrawing<T> convertToSquare() {
    final bounds = getBounds();
    return SimplePolygonDrawing<T>(
      id: id,
      zIndex: zIndex,
      representation: AnchoredDrawingRepresentation(
        anchorPoint: Point.fromOffset(bounds.topLeft),
        endPoint: Point.fromOffset(bounds.bottomRight),
      ),
      color: color,
      width: width,
      polygonTemplate: squarePolygon,
    );
  }

  SimplePolygonDrawing<T> convertToRectangle() {
    final bounds = getBounds();

    // Check if the with and height are similar by a certain threshold: 10%. If so convert it to a square
    if ((bounds.width - bounds.height).abs() < bounds.width * 0.1) {
      return convertToSquare();
    }

    return SimplePolygonDrawing<T>(
      id: id,
      zIndex: zIndex,
      representation: AnchoredDrawingRepresentation(
        anchorPoint: Point.fromOffset(bounds.topLeft),
        endPoint: Point.fromOffset(bounds.bottomRight),
      ),
      color: color,
      width: width,
      polygonTemplate: rectanglePolygon,
    );
  }

  SimplePolygonDrawing<T> convertToTriangle() {
    final bounds = getBounds();
    return SimplePolygonDrawing<T>(
      id: id,
      zIndex: zIndex,
      representation: AnchoredDrawingRepresentation(
        anchorPoint: Point.fromOffset(bounds.topLeft),
        endPoint: Point.fromOffset(bounds.bottomRight),
      ),
      color: color,
      width: width,
      // TODO: Change it to a generic triangle polygon
      polygonTemplate: isoscelesTrianglePolygon,
    );
  }
}
