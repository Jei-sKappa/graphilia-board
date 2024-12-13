import 'package:flutter/gestures.dart';
import 'package:graphilia_board/src/presentation/notifier/notifier.dart';
import 'package:graphilia_board/src/presentation/board_interactions/board_interactions.dart';
import 'package:graphilia_board/src/presentation/state/state.dart';

class ConvertSelectedStateToBoardStateInteraction<T> extends BoardInteraction<T> {
  const ConvertSelectedStateToBoardStateInteraction();

  @override
  DetailedGestureScaleStartCallbackHandler<T> get handleOnScaleStart => (
        ScaleStartDetails details,
        PointerEvent initialEvent,
        PointerEvent event,
        BoardNotifier<T, BoardStateConfig> notifier,
      ) {
        if (notifier.value is! SelectedState) {
          return false;
        }

        notifier.setBoardState(
          state: BoardState.fromOther(notifier.value),
          shouldAddToHistory: false,
        );

        // The state is updated by we don't want to interrupt the rest of the
        // handlers
        return false;
      };
}
