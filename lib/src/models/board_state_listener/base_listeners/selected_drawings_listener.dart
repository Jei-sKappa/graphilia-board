import 'package:graphilia_board/graphilia_board.dart';

final class SelectedDrawingsListener<T, C extends BoardStateConfig> extends BoardStateListener<T, C> {
  const SelectedDrawingsListener({required this.listenedDrawingsIds});

  final List<T> listenedDrawingsIds;

  @override
  bool shouldReceiveUpdate(
    BoardState<T, BoardStateConfig> previous,
    BoardState<T, BoardStateConfig> next,
  ) {
    if (next is! SelectedState<T, C>) return false;

    for (final drawingId in listenedDrawingsIds) {
      if (next.selectedDrawings.any((d) => d.id == drawingId)) {
        return true;
      }
    }

    return false;
  }
}
