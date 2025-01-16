import 'package:graphilia_board/graphilia_board.dart';

final class SelectedDrawingsListener<T> extends BoardStateListener<T> {
  const SelectedDrawingsListener({required this.listenedDrawingsIds});

  final List<T> listenedDrawingsIds;

  @override
  bool shouldReceiveUpdate(
    BoardState<T> previous,
    BoardState<T> next,
  ) {
    if (next is! SelectedState<T>) return false;

    for (final drawingId in listenedDrawingsIds) {
      if (next.selectedDrawings.any((d) => d.id == drawingId)) {
        return true;
      }
    }

    return false;
  }
}
