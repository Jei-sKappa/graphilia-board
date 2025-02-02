import 'package:flutter/widgets.dart';

sealed class InteractionFeedback {
  const InteractionFeedback();
}

typedef CanvasPaintCallback = void Function(Canvas);
class CanvasInteractionFeedback extends InteractionFeedback {
  const CanvasInteractionFeedback(this.paintCallback);

  final CanvasPaintCallback paintCallback;
}

class WidgetInteractionFeedback extends InteractionFeedback {
  const WidgetInteractionFeedback(this.builder);

  final WidgetBuilder builder;
}