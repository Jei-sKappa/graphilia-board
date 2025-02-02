import 'package:flutter/animation.dart';
import 'package:flutter/gestures.dart';
import 'package:equatable/equatable.dart';
import 'package:graphilia_board/graphilia_board.dart';
import 'package:graphilia_board/src/core/constants/undefined.dart';
import 'package:graphilia_board/src/presentation/notifier/z_index_generator.dart';

int _generateUnsecureDrawingIdFromState(BoardState? _) => generateIdFromDateTime();

class BoardStateConfig<T> with EquatableMixin {
  BoardStateConfig({
    // Core
    this.allowedPointerKinds = BoardPointersHelper.all,
    this.maxHistoryLength,
    this.pointPressureCurve = Curves.linear,
    ZIndexManager? zIndexManager,
    // Drawing
    this.initialDrawings = const [],
    required this.initialTool,
    Object Function(BoardState? state)? idGenerator,
    this.pointsSimplifier = const VisvalingamPointsSimplifier(),
    this.simplificationTolerance = 0,
    this.onTapDown,
    this.onTapUp,
    // Erasing
    this.initialEraserWidth = 10,
    this.shouldScaleEraserWidth = true,
    // Selecting
    this.selectionMode = PointsInPolygonMode.partial,
    this.shouldMoveSelectedDrawingsOnTop = false,
  })  : zIndexManager = zIndexManager ?? ZIndexManager(),
        idGenerator = idGenerator ?? _generateUnsecureDrawingIdFromState;

  // Core

  // TODO(Jei-sKappa): Create the option to assing a tool/mode based on the pointer type (eg: Finger-Eraser, Pen-Draw)
  /// Which pointers are allowed for drawing and will be captured by the
  /// board.
  final Set<PointerDeviceKind> allowedPointerKinds;

  /// How many states you want stored in the undo history.
  ///
  /// If `null`, the undo history wont have a limit.
  final int? maxHistoryLength;

  /// The curve that's used to map a pointer's pressure to the pressure value
  /// in the [Point]. Defaults to [Curves.linear].
  final Curve pointPressureCurve;

  final ZIndexManager zIndexManager;

  // Drawing

  /// The initial sketch that is used to draw on the canvas.
  final List<Drawing<T>> initialDrawings;

  /// The initial tool that is used to draw on the sketch.
  final DrawingTool initialTool;

  /// {@template graphilia_board.id_generator}
  /// A function that generates an identifier for a drawing in the sketch.
  ///
  /// The [idGenerator] function takes a [BoardState] object as input and
  /// returns an identifier.
  /// {@endtemplate}
  final Object Function(BoardState? state) idGenerator;

  /// The [PointsSimplifier] that is used to simplify the lines of the sketch.
  ///
  /// Defaults to [VisvalingamPointsSimplifier].
  final PointsSimplifier pointsSimplifier;

  /// The tolerance used to simplify the sketch in logical pixels.
  /// 0 means no simplification.
  final double simplificationTolerance;

  /// {@template graphilia_board.on_tap_down}
  /// The callback that gets called when a tap down gesture is detected on a
  /// drawing.
  ///
  /// The [onTapDown] callback of a specific drawing will be called first. If it
  /// doesn't handle the gesture, this will be called.
  /// {@endtemplate}
  final BoardTapHandler<T>? onTapDown;

  /// {@template graphilia_board.on_tap_up}
  /// The callback that gets called when a tap up gesture is detected on a
  /// drawing.
  ///
  /// The [onTapUp] callback of a specific drawing will be called first. If it
  /// doesn't handle the gesture, this will be called.
  /// {@endtemplate}
  final BoardTapHandler<T>? onTapUp;

  // Erasing

  /// The initial width of the eraser tool.
  final double initialEraserWidth;

  /// Whether the eraser width should scale with the zoom level.
  final bool shouldScaleEraserWidth;

  // Selecting

  /// The mode that is used to determine if a Drawing is inside a selection.
  ///
  /// Defaults to [PointsInPolygonMode.partial].
  final PointsInPolygonMode selectionMode;

  /// Whether to move the selected drawings to the top of the sketch when they
  /// are selected.
  final bool shouldMoveSelectedDrawingsOnTop;

  @override
  List<Object?> get props => [
        allowedPointerKinds,
        maxHistoryLength,
        pointPressureCurve,
        zIndexManager,
        initialDrawings,
        initialTool,
        idGenerator,
        pointsSimplifier,
        simplificationTolerance,
        onTapDown,
        onTapUp,
        initialEraserWidth,
        shouldScaleEraserWidth,
        selectionMode,
        shouldMoveSelectedDrawingsOnTop,
      ];

  bool isPointerDeviceKindSupported(PointerDeviceKind kind) => allowedPointerKinds.contains(kind);

  BoardStateConfig<T> copyWith({
    Set<PointerDeviceKind>? allowedPointerKinds,
    Object? maxHistoryLength = const Undefinied(),
    Curve? pointPressureCurve,
    ZIndexManager? zIndexManager,
    List<Drawing<T>>? initialDrawings,
    DrawingTool? initialTool,
    Object Function(BoardState? state)? idGenerator,
    PointsSimplifier? pointsSimplifier,
    double? simplificationTolerance,
    Object? onTapDown = const Undefinied(),
    Object? onTapUp = const Undefinied(),
    double? initialEraserWidth,
    bool? shouldScaleEraserWidth,
    PointsInPolygonMode? selectionMode,
    bool? autoToggleRectangularSelectionOnSelectionEnd,
    bool? shouldMoveSelectedDrawingsOnTop,
  }) {
    assert(maxHistoryLength is int? || maxHistoryLength is Undefinied);
    assert(onTapDown is BoardTapHandler<T>? || onTapDown is Undefinied);
    assert(onTapUp is BoardTapHandler<T>? || onTapUp is Undefinied);
    return BoardStateConfig<T>(
      allowedPointerKinds: allowedPointerKinds ?? this.allowedPointerKinds,
      maxHistoryLength: maxHistoryLength is int? ? maxHistoryLength : this.maxHistoryLength,
      pointPressureCurve: pointPressureCurve ?? this.pointPressureCurve,
      zIndexManager: zIndexManager ?? this.zIndexManager,
      initialDrawings: initialDrawings ?? this.initialDrawings,
      initialTool: initialTool ?? this.initialTool,
      idGenerator: idGenerator ?? this.idGenerator,
      pointsSimplifier: pointsSimplifier ?? this.pointsSimplifier,
      simplificationTolerance: simplificationTolerance ?? this.simplificationTolerance,
      onTapDown: onTapDown is BoardTapHandler<T>? ? onTapDown : this.onTapDown,
      onTapUp: onTapUp is BoardTapHandler<T>? ? onTapUp : this.onTapUp,
      initialEraserWidth: initialEraserWidth ?? this.initialEraserWidth,
      shouldScaleEraserWidth: shouldScaleEraserWidth ?? this.shouldScaleEraserWidth,
      selectionMode: selectionMode ?? this.selectionMode,
      shouldMoveSelectedDrawingsOnTop: shouldMoveSelectedDrawingsOnTop ?? this.shouldMoveSelectedDrawingsOnTop,
    );
  }
}

typedef BoardTapHandler<T> = TapEventSketchResult<T> Function(
  PointerEvent details,
  BoardState<T> state,
  Drawing<T> drawing,
);
