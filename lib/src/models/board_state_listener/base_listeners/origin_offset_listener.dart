import 'package:graphilia_board/src/models/models.dart';
import 'package:graphilia_board/src/presentation/state/board_state.dart';

final class OriginOffsetListener<T> extends BoardStateListener<T> {
  const OriginOffsetListener();

  @override
  bool shouldReceiveUpdate(
    BoardState<T> previous,
    BoardState<T> next,
  ) =>
      previous.originOffset != next.originOffset;
}
