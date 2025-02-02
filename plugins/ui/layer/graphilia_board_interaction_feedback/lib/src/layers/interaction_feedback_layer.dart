import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:graphilia_board_interaction_feedback/graphilia_board_interaction_feedback.dart';
import 'package:value_notifier_tools/value_notifier_tools.dart';

class InteractionFeedbackLayer<T> extends StatelessWidget {
  const InteractionFeedbackLayer({
    super.key,
    required this.notifier,
  });

  final InteractionFeedbackNotifierMixin<T> notifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifier.stateListenable.select((state) => state.interactionFeedbacks).where(
            (previous, next) => !(const DeepCollectionEquality().equals(previous, next)),
          ),
      builder: (context, interactionFeedbacks, _) {
        if (interactionFeedbacks.isEmpty) {
          return const SizedBox();
        }

        return Stack(
          children: [
            for (final interactionFeedback in interactionFeedbacks)
              switch (interactionFeedback) {
                CanvasInteractionFeedback canvasInteractionFeedback => CustomPaint(
                    painter: CanvasInteractionFeedbackPainter(
                      canvasInteractionFeedback,
                    ),
                  ),
                WidgetInteractionFeedback widgetInteractionFeedback => Builder(
                    builder: widgetInteractionFeedback.builder,
                  ),
              }
          ],
        );
      },
    );
  }
}

class CanvasInteractionFeedbackPainter extends CustomPainter {
  CanvasInteractionFeedbackPainter(this.canvasInteractionFeedback);

  final CanvasInteractionFeedback canvasInteractionFeedback;

  @override
  void paint(Canvas canvas, Size size) {
    canvasInteractionFeedback.paintCallback(canvas);
  }

  @override
  bool shouldRepaint(CanvasInteractionFeedbackPainter oldDelegate) => true;
}
