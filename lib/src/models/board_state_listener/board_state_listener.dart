import 'package:graphilia_board/src/presentation/notifier/notifier.dart';
import 'package:graphilia_board/src/presentation/state/state.dart';

export 'base_listeners/base_listeners.dart';

abstract class BoardStateListener<T, C extends BoardStateConfig> {
  const BoardStateListener();

  bool shouldReceiveUpdate(
    BoardState<T, C> previous,
    BoardState<T, C> next,
  );
}
