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

extension BoardStateListenerCombineExtension on BoardStateListener {
  BoardStateListenerCombiner combine(BoardStateListener listener) {
    return BoardStateListenerCombiner([this, listener]);
  }
}
