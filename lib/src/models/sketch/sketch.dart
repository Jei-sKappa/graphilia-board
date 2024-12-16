import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'package:r_tree/r_tree.dart';
import 'package:graphilia_board/src/models/models.dart';
import 'package:graphilia_board/src/presentation/notifier/notifier.dart';
import 'package:graphilia_board/src/presentation/state/state.dart';

part 'sketch_delta.dart';

// TODO: Replace Rect with Rectangle everywhere in order to remove this extension
extension _RectToRectangle on Rect {
  Rectangle toRectangle() => Rectangle(left, top, width, height);
}

Rectangle _getRenctangleFromCenter(Point center, double side) => Rectangle(center.x - side / 2, center.y - side / 2, side, side);

const _branchingFactor = 8;

/// {@template sketch}
/// Represents a sketch with a list of [SketchDrawing]s.
/// {@endtemplate}
class Sketch<T> {
  /// {@macro sketch}
  Sketch({
    required List<Drawing<T>> drawings,
  }) {
    _drawingsMapCache = LinkedHashMap();
    _rtree = RTree<Drawing<T>>(_branchingFactor);
    _connectionMap = <T, Set<T>>{};
    _addDrawings(drawings);
  }

  /// {@macro sketch}
  Sketch.empty()
      : _drawingsMapCache = LinkedHashMap(),
        _rtree = RTree<Drawing<T>>(_branchingFactor),
        _connectionMap = <T, Set<T>>{};

  factory Sketch.fromMap(Map<String, dynamic> map) {
    final List<dynamic> drawingsMap = map['drawings'];
    final List<Drawing<T>> drawings = drawingsMap.map((e) => Drawing<T>.fromMap(e)).toList();
    return Sketch(drawings: drawings);
  }

  late final RTree<Drawing<T>> _rtree;

  late final LinkedHashMap<T, Drawing<T>> _drawingsMapCache;

  /// Every [ConnectableDrawingMixin] (source) has a list of connected drawings
  /// (targets). This map stores the connections in the opposite way.
  late final Map<T, Set<T>> _connectionMap;

  // TODO: Optimize this
  bool get isEmpty => drawings.isEmpty;

  bool get isNotEmpty => !isEmpty;

  int maxZIndex = 0;

  /// The list of drawings in the sketch.
  ///
  /// **IMPORTANT**: Use this only when you need all the drawings in the sketch.
  List<Drawing<T>> get drawings => _drawingsMapCache.values.toList();

  Drawing<T>? getDrawingById(T id) => _drawingsMapCache[id];

  List<Drawing<T>> getDrawingsByPoint(
    BoardState<T, BoardStateConfig> state,
    Point point, {
    required double tolerance,
  }) {
    late final List<Drawing<T>> requestedDrawings;

    requestedDrawings = <Drawing<T>>[];

    final searchRect = _getRenctangleFromCenter(point, tolerance);
    final rtreeDatums = _rtree.search(searchRect);
    for (final datum in rtreeDatums) {
      final drawing = datum.value;
      final isInside = drawing.isPointInside(
        state,
        point,
        tolerance,
      );

      if (isInside) {
        requestedDrawings.add(drawing);
      }
    }

    return requestedDrawings;
  }

  List<Drawing<T>> getDrawingsByRect(Rect rect) => _rtree.search(rect.toRectangle()).map((e) => e.value).toList();

  void applyDelta(SketchDelta<T> delta) {
    // Add new drawings to the map.
    if (delta.providedNewDrawings) {
      _addDrawings(delta.newDrawings);
    }

    // Update existing drawings in the map.
    if (delta.providedUpdatedDrawings) {
      _updateDrawings(
        updatedDrawingsBefore: delta.updatedDrawingsBefore,
        updatedDrawingsAfter: delta.updatedDrawingsAfter,
      );
    }

    if (delta.providedDeletedDrawings) {
      _deleteDrawings(delta.deletedDrawings);
    }

    // TODO: Inform the caller if the delta was applied successfully. For example the remove can fail and the caller should know to prevent add to the history.
  }

  @pragma('vm:prefer-inline')
  void _registerConnection(Drawing<T> source) {
    if (source is ConnectableDrawingMixin<T>) {
      final targetsIds = source.connectedDrawingsIds;

      for (final targetId in targetsIds) {
        // Create the [Set] for the targetId if it doesn't exist
        _connectionMap[targetId] ??= {};

        // Add the sourceId to the targetId set
        _connectionMap[targetId]!.add(source.id);
      }
    }
  }

  @pragma('vm:prefer-inline')
  void _addDrawing(Drawing<T> drawing) {
    _rtree.add([RTreeDatum(drawing.getBounds().toRectangle(), drawing)]);
    _drawingsMapCache[drawing.id] = drawing;
    maxZIndex = max(maxZIndex, drawing.zIndex);

    // Register the Target-Source connection
    _registerConnection(drawing);
  }

  void _addDrawings(List<Drawing<T>> newDrawings) {
    if (newDrawings.isEmpty) return;

    // Sort the new drawings by zIndex
    newDrawings.sort((a, b) => a.zIndex.compareTo(b.zIndex));

    if (newDrawings.first.zIndex >= maxZIndex) {
      _addDrawingsWithBiggerOrEqualZIndex(newDrawings);
    } else {
      // TODO: Check if this is still needed
      _addDrawingsWithSmallerZIndex(newDrawings);
    }
  }

  void _addDrawingsWithBiggerOrEqualZIndex(List<Drawing<T>> newDrawings) {
    for (final Drawing<T> drawing in newDrawings) {
      _addDrawing(drawing);
    }
  }

  void _addDrawingsWithSmallerZIndex(List<Drawing<T>> newDrawings) {
    final newDrawingWithLowerZIndex = newDrawings.first;

    final allDrawingsList = _drawingsMapCache.values.toList();

    // looping in reverse order
    final removedDrawings = <Drawing<T>>[];
    for (int i = allDrawingsList.length - 1; i >= 0; i--) {
      final item = allDrawingsList[i];
      if (item.zIndex > newDrawingWithLowerZIndex.zIndex) {
        if (_drawingsMapCache.remove(item.id) != null) {
          removedDrawings.add(item);
        }
      } else {
        break;
      }
    }

    _addDrawing(newDrawingWithLowerZIndex);

    var removedIndex = removedDrawings.length - 1;
    var newIndex = 1; // Skip the first one that was already added

    Drawing<T>? currentRemovedDrawing;
    Drawing<T>? currentNewDrawing;

    // Insert removed drawings and new drawings (excluding the first one) in the
    // right z-index order
    while (removedIndex >= 0 && newIndex < newDrawings.length) {
      currentRemovedDrawing ??= removedDrawings[removedIndex];
      currentNewDrawing ??= newDrawings[newIndex];

      // Pick the min between the removed object and the new one
      if (currentNewDrawing.zIndex < currentRemovedDrawing.zIndex) {
        _addDrawing(currentNewDrawing);
        newIndex++;
        currentNewDrawing = null;
      } else {
        _drawingsMapCache[currentRemovedDrawing.id] = currentRemovedDrawing;
        removedIndex--;
        currentRemovedDrawing = null;
      }
    }

    for (int i = removedIndex; i >= 0; i--) {
      final removedDrawing = removedDrawings[i];
      _drawingsMapCache[removedDrawing.id] = removedDrawing;
    }

    for (int i = newIndex; i < newDrawings.length; i++) {
      final newDrawing = newDrawings[i];
      _addDrawing(newDrawing);
    }
  }

  @pragma('vm:prefer-inline')
  void _updateConnection({
    required Drawing<T> drawingBefore,
    required Drawing<T> drawingAfter,
  }) {
    final beforeIsConnectable = drawingBefore is ConnectableDrawingMixin<T>;
    final afterIsConnectable = drawingAfter is ConnectableDrawingMixin<T>;

    // No one is a connectable drawing
    //
    // This is the most common case and so we check it first.
    if (!beforeIsConnectable && !afterIsConnectable) return;

    // At least one is a connectable drawing

    // Both drawings are connectable drawings
    if (beforeIsConnectable && afterIsConnectable) {
      final areTargetsDifferent = drawingBefore.connectedDrawingsIds != drawingAfter.connectedDrawingsIds;
      if (areTargetsDifferent) {
        // While unregister and re register the connection works, it is not the
        // most efficient way to handle this.
        _unregisterConnection(drawingBefore);
        _registerConnection(drawingAfter);
      }
    }
    // Only one of the drawings is a connectable drawing
    else if (beforeIsConnectable != afterIsConnectable) {
      // If the only one is [beforeIsConnectable] so the drawing is no more a
      // connectable drawing so we need to unregister the connection.
      if (beforeIsConnectable) {
        _unregisterConnection(drawingBefore);
      }
      // If the only one is [afterIsConnectable] so the drawing is now a
      // connectable drawing so we need to register the connection.
      else {
        _registerConnection(drawingAfter);
      }
    }
  }

  void _updateDrawings({
    required List<Drawing<T>> updatedDrawingsBefore,
    required List<Drawing<T>> updatedDrawingsAfter,
  }) {
    for (int i = 0; i < updatedDrawingsAfter.length; i++) {
      final drawingBefore = updatedDrawingsBefore[i];
      final drawingAfter = updatedDrawingsAfter[i];

      // 1) Remove the drawing from the RTree
      final removed = _rtree.remove(
        RTreeDatum(drawingBefore.getBounds().toRectangle(), drawingBefore),
      );

      if (!removed) {
        print('!!!!!! ERROR: DRAWING NOT FOUND IN THE RTree | $drawingBefore<T>!!!!!!');
        if (_drawingsMapCache.containsKey(drawingBefore.id)) {
          print('Drawing<T>found in the map');
        } else {
          print('Drawing<T>not found in the map');
        }
        throw Exception('Drawing<T> not found in the RTree: $drawingBefore');
      }

      // 2) Remove the drawing from the map
      _drawingsMapCache.remove(drawingBefore.id);

      // 3) Add the new drawing to the RTree
      _rtree.add([RTreeDatum(drawingAfter.getBounds().toRectangle(), drawingAfter)]);

      // 4) Add the new drawing to the map
      _drawingsMapCache[drawingAfter.id] = drawingAfter;

      // 5) Update the connection
      _updateConnection(
        drawingBefore: drawingBefore,
        drawingAfter: drawingAfter,
      );

      // 6) Get the updated connectable drawings
      final updatedConnectableDrawingsResult = getUpdatedConnectableDrawings(
        updatedDrawingsBefore: updatedDrawingsBefore,
        updatedDrawingsAfter: updatedDrawingsAfter,
      );

      // 7) Recursively update the new connectable drawings
      //
      // This is needed because the updated connectable drawings can be a target
      // of another connectable drawing.
      if (updatedConnectableDrawingsResult.after.isNotEmpty) {
        _updateDrawings(
          updatedDrawingsBefore: updatedConnectableDrawingsResult.before,
          updatedDrawingsAfter: updatedConnectableDrawingsResult.after,
        );
      }
    }
  }

  @pragma('vm:prefer-inline')
  void _unregisterConnection(Drawing<T> drawing) {
    // Remove the drawing from the connection map
    // Note that this will actually remove the drawing id from
    // [_connectionMap] if the drawing is a target of a
    // [ConnectableDrawingMixin].
    // This check is implicit in the remove method.
    _connectionMap.remove(drawing.id);

    // If the drawing is a [ConnectableDrawingMixin] (source) then remove
    // it from every target's set in the connection map.
    if (drawing is ConnectableDrawingMixin<T>) {
      for (final targetId in drawing.connectedDrawingsIds) {
        final targetSources = _connectionMap[targetId];

        if (targetSources != null) {
          targetSources.remove(drawing.id);

          if (targetSources.isEmpty) {
            _connectionMap.remove(targetId);
          }
        }
      }
    }
  }

  void _deleteDrawings(List<Drawing<T>> deletedDrawings) {
    for (final Drawing<T> drawing in deletedDrawings) {
      // 1) Remove the drawing from the RTree
      final removed = _rtree.remove(RTreeDatum(drawing.getBounds().toRectangle(), drawing));

      if (!removed) {
        print('!!!!!! ERROR: DRAWING NOT FOUND IN THE RTree | $drawing !!!!!!');
        if (_drawingsMapCache.containsKey(drawing.id)) {
          print('Drawing<T>found in the map');
        } else {
          print('Drawing<T>not found in the map');
        }
        throw Exception('Drawing<T>not found in the RTree');
      }

      // 2) Remove the drawing from the map
      _drawingsMapCache.remove(drawing.id);

      // 3) Unregister the connection
      _unregisterConnection(drawing);

      // TODO: This should call the onConnectionUpdate with next null and update the updatedDrawings
    }
  }

  ({List<ConnectableDrawingMixin<T>> before, List<Drawing<T>> after}) getUpdatedConnectableDrawings({
    required List<Drawing<T>> updatedDrawingsBefore,
    required List<Drawing<T>> updatedDrawingsAfter,
  }) {
    final Map<T, ({ConnectableDrawingMixin<T> before, Drawing<T> after})> updatedSourcesDrawingsMap = {};

    for (var i = 0; i < updatedDrawingsAfter.length; i++) {
      final updatedDrawingAfter = updatedDrawingsAfter[i];

      final sourceDrawingsIds = _connectionMap[updatedDrawingAfter.id];
      if (sourceDrawingsIds == null) continue;

      // The updated drawing is a target of a connectable drawing

      final updatedDrawingBefore = updatedDrawingsBefore[i];

      for (final sourceDrawingId in sourceDrawingsIds) {
        late final ConnectableDrawingMixin<T> sourceDrawing;
        late final bool wasSourceDrawingAlreadyUpdated;

        // Check if the connectable drawing has already been updated by a previous drawing
        if (updatedSourcesDrawingsMap.containsKey(sourceDrawingId)) {
          wasSourceDrawingAlreadyUpdated = true;
          final alreadyUpdatedSourceDrawing = updatedSourcesDrawingsMap[sourceDrawingId]!.after;

          // If the already updated source drawing is not a
          // [ConnectableDrawingMixin<T>] it means that the source drawing
          // is no more a [ConnectableDrawingMixin<T>] so we must ignore the
          // updates.
          if (alreadyUpdatedSourceDrawing is! ConnectableDrawingMixin<T>) {
            continue;
          }

          // The already updated connectable drawing is still a [ConnectableDrawingMixin<T>]

          sourceDrawing = alreadyUpdatedSourceDrawing;
        } else {
          wasSourceDrawingAlreadyUpdated = false;
          // sourceDrawing = _connectableDrawingsMap[sourceDrawingId]!;
          final maybeSourceDrawing = _drawingsMapCache[sourceDrawingId];

          // If the source drawing is not a [ConnectableDrawingMixin<T>] it means
          // that the source drawing is no more a [ConnectableDrawingMixin<T>]
          // so we must ignore the updates.
          if (maybeSourceDrawing is! ConnectableDrawingMixin<T>) {
            continue;
          }

          // The source drawing is a [ConnectableDrawingMixin<T>]

          sourceDrawing = maybeSourceDrawing;
        }

        final newConnectableDrawing = sourceDrawing.onConnectionUpdate(updatedDrawingBefore, updatedDrawingAfter);

        if (newConnectableDrawing == null) continue;

        // The connectable drawing has been updated
        if (wasSourceDrawingAlreadyUpdated) {
          updatedSourcesDrawingsMap[sourceDrawingId] = (
            before: updatedSourcesDrawingsMap[sourceDrawingId]!.before,
            after: newConnectableDrawing,
          );
        } else {
          updatedSourcesDrawingsMap[sourceDrawingId] = (
            before: sourceDrawing,
            after: newConnectableDrawing,
          );
        }
      }
    }

    return (
      before: updatedSourcesDrawingsMap.entries.map((e) => e.value.before).toList(),
      after: updatedSourcesDrawingsMap.entries.map((e) => e.value.after).toList(),
    );
  }

  @override
  String toString() {
    return 'Sketch(drawings: ${drawings.map((e) => e.id).toList()})';
  }

  Map<String, dynamic> toMap() {
    return {
      'drawings': drawings.map((e) => e.toMap()).toList(),
    };
  }
}
