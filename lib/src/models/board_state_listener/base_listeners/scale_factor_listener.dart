import 'package:graphilia_board/src/models/models.dart';
import 'package:graphilia_board/src/presentation/state/board_state.dart';

final class ScaleFactorListener<T> extends BoardStateListener<T> {
  const ScaleFactorListener();

  @override
  bool shouldReceiveUpdate(
    BoardState<T> previous,
    BoardState<T> next,
  ) =>
      previous.scaleFactor != next.scaleFactor;
}
