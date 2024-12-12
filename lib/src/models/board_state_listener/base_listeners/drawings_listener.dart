import 'package:graphilia_board/graphilia_board.dart';

final class DrawingsListener<T, C extends BoardStateConfig> extends BoardStateListener<T, C> {
  const DrawingsListener({required this.listenedDrawingsIds});

  final List<T> listenedDrawingsIds;

  @override
  bool shouldReceiveUpdate(
    BoardState<T, BoardStateConfig> previous,
    BoardState<T, BoardStateConfig> next,
  ) {
    final delta = next.sketchDelta;

    if (!delta.providedUpdatedDrawings) return false;

    final updatedDrawingsAfterIds = delta.updatedDrawingsAfter.map((d) => d.id).toList();

    for (final drawingId in listenedDrawingsIds) {
      if (updatedDrawingsAfterIds.contains(drawingId)) {
        return true;
      }
    }

    return false;
  }
}
