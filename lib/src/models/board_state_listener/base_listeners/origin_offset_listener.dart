import 'package:graphilia_board/src/models/models.dart';
import 'package:graphilia_board/src/presentation/notifier/notifier.dart';
import 'package:graphilia_board/src/presentation/state/board_state.dart';

final class OriginOffsetListener<T, C extends BoardStateConfig> extends BoardStateListener<T, C> {
  const OriginOffsetListener();

  @override
  bool shouldReceiveUpdate(
    BoardState<T, BoardStateConfig> previous,
    BoardState<T, BoardStateConfig> next,
  ) =>
      previous.originOffset != next.originOffset;
}
