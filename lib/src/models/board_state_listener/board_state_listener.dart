import 'package:graphilia_board/src/presentation/state/state.dart';

export 'base_listeners/base_listeners.dart';

abstract class BoardStateListener<T> {
  const BoardStateListener();

  bool shouldReceiveUpdate(
    BoardState<T> previous,
    BoardState<T> next,
  );
}
