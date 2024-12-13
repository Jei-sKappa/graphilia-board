import 'package:graphilia_board/graphilia_board.dart';

final class BoardStateListenerCombiner<T, C extends BoardStateConfig> extends BoardStateListener<T, C> {
  const BoardStateListenerCombiner(this.graphiliaBoardStatelisteners);

  final List<BoardStateListener> graphiliaBoardStatelisteners;

  @override
  bool shouldReceiveUpdate(
    BoardState<T, BoardStateConfig> previous,
    BoardState<T, BoardStateConfig> next,
  ) {
    for (final listener in graphiliaBoardStatelisteners) {
      if (listener.shouldReceiveUpdate(previous, next)) {
        return true;
      }
    }

    return false;
  }
}

extension BoardStateListenerCombineExtension<T, C extends BoardStateConfig> on BoardStateListener<T, C> {
  BoardStateListenerCombiner<T, C> combine(BoardStateListener<T, C> listener) {
    return BoardStateListenerCombiner<T, C>([this, listener]);
  }
}
