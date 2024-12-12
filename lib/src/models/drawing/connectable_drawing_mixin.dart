import 'package:graphilia_board/graphilia_board.dart';

mixin ConnectableDrawingMixin<T> on Drawing<T> {
  List<T> get connectedDrawingsIds;

  /// Called when a connected drawing is updated or removed.
  ///
  /// When a connected drawing is updated, both [previous] and [next] will be
  /// non-null. When a connected drawing is removed, [next] will be null.
  Drawing<T>? onConnectionUpdate(Drawing<T> previous, Drawing<T>? next);
}
