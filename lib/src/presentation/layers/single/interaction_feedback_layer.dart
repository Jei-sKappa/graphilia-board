import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:graphilia_board/src/presentation/notifier/notifier.dart';
import 'package:graphilia_board/src/presentation/board_interactions/board_interactions.dart';
import 'package:value_notifier_tools/value_notifier_tools.dart';

class InteractionFeedback {
  const InteractionFeedback(this.canvasPaintCallback);

  final CanvasPaintCallback canvasPaintCallback;
}

class InteractionFeedbackLayer<T> extends StatelessWidget {
  const InteractionFeedbackLayer({
    super.key,
    required this.notifier,
  });

  final BoardNotifier<T, BoardStateConfig> notifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifier.select((state) => state.interactionFeedbacks).where((previous, next) => !(const DeepCollectionEquality().equals(previous, next))),
      builder: (context, interactionFeedbacks, _) {
        if (interactionFeedbacks.isEmpty) {
          return const SizedBox();
        }

        return CustomPaint(
          foregroundPainter: InteractionFeedbackPainter(interactionFeedbacks),
        );
      },
    );
  }
}

class InteractionFeedbackPainter extends CustomPainter {
  InteractionFeedbackPainter(this.interactionFeedbacks);

  final List<InteractionFeedback> interactionFeedbacks;

  @override
  void paint(Canvas canvas, Size size) {
    for (final interactionFeedback in interactionFeedbacks) {
      interactionFeedback.canvasPaintCallback(canvas);
    }
  }

  @override
  bool shouldRepaint(InteractionFeedbackPainter oldDelegate) => true;
}
