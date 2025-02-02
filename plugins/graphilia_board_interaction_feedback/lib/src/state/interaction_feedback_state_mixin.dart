import 'package:graphilia_board_core/graphilia_board_core.dart';
import '../../graphilia_board_interaction_feedback.dart';

mixin InteractionFeedbackStateMixin<T> on BoardState<T> {
  List<InteractionFeedback> get interactionFeedbacks;

  set interactionFeedbacks(List<InteractionFeedback> value);
}
