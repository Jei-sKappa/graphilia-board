import 'package:flutter/foundation.dart';
import 'package:graphilia_board_core/graphilia_board_core.dart';
import 'package:graphilia_board_interaction_feedback/graphilia_board_interaction_feedback.dart';

mixin InteractionFeedbackNotifierMixin<T> on BoardNotifier<T> {
  @override
  InteractionFeedbackStateMixin<T> get state;

  @override
  ValueNotifier<InteractionFeedbackStateMixin<T>> get stateListenable;
}
