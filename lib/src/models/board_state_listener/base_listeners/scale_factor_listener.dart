import 'package:graphilia_board/src/models/models.dart';
import 'package:graphilia_board/src/presentation/notifier/notifier.dart';
import 'package:graphilia_board/src/presentation/state/board_state.dart';

final class ScaleFactorListener<T, C extends BoardStateConfig> extends BoardStateListener<T, C> {
  const ScaleFactorListener();

  @override
  bool shouldReceiveUpdate(
    BoardState<T, BoardStateConfig> previous,
    BoardState<T, BoardStateConfig> next,
  ) =>
      previous.scaleFactor != next.scaleFactor;
}
