import 'package:graphilia_board/graphilia_board.dart';

final class BoardStateListenerCombiner<T> extends BoardStateListener<T> {
  const BoardStateListenerCombiner(this.graphiliaBoardStatelisteners);

  final List<BoardStateListener> graphiliaBoardStatelisteners;

  @override
  bool shouldReceiveUpdate(
    BoardState<T> previous,
    BoardState<T> next,
  ) {
    for (final listener in graphiliaBoardStatelisteners) {
      if (listener.shouldReceiveUpdate(previous, next)) {
        return true;
      }
    }

    return false;
  }
}

extension BoardStateListenerCombineExtension<T> on BoardStateListener<T> {
  BoardStateListenerCombiner<T> combine(BoardStateListener<T> listener) {
    return BoardStateListenerCombiner<T>([this, listener]);
  }
}
