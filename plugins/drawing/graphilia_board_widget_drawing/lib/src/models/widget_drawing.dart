import 'package:flutter/widgets.dart';
import 'package:graphilia_board_core/graphilia_board_core.dart';

abstract class WidgetDrawing<T> extends Drawing<T> {
  const WidgetDrawing({
    required super.id,
    required super.zIndex,
  });

  Widget build(
    BuildContext context,
    BoardState<T> state, {
    required bool isSelected,
  });

  /// This method is called when the [Drawing] is being created for the first time.
  ///
  /// See [DrawInteraction] and [InteractionFeedbackLayer] for more information.
  Widget buildFeedback(
    BuildContext context,
    BoardState<T> state,
  ) =>
      build(context, state, isSelected: false);
}
