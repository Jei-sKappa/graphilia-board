import 'package:flutter/widgets.dart';
import 'package:graphilia_board/src/presentation/interaction_controller/interaction_controller.dart';
import 'package:graphilia_board/src/presentation/layers/layers.dart';
import 'package:graphilia_board/src/presentation/notifier/notifier.dart';
import 'package:value_notifier_tools/value_notifier_tools.dart';

class TransformedLayerGroup<T> extends StatelessWidget {
  const TransformedLayerGroup({
    super.key,
    required this.notifier,
    required this.interactionController,
    required this.viewPortSize,
  });

  final BoardNotifier<T, BoardStateConfig> notifier;
  final InteractionControllerBase<T> interactionController;
  final Size viewPortSize;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable:
          // TODO: Consider implementing [ValueListenableDebouncer] with the actual max FPS that the device can handle.
          // ValueListenableDebouncer(
          //   debounceDuration: const Duration(microseconds: 4100), // 240 FPS
          notifier.where(
        (previous, next) {
          if (previous.scaleFactor != next.scaleFactor) {
            return true;
          }

          if (previous.originOffset != next.originOffset) {
            return true;
          }

          return false;
        },
      ),
      builder: (context, state, child) {
        return Transform(
          transform: Matrix4.identity()
            ..scale(state.scaleFactor)
            ..translate(
              -state.originOffset.dx,
              -state.originOffset.dy,
            ),
          child: child,
        );
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: DrawingsLayerGroup(
              notifier: notifier,
              viewPortSize: viewPortSize,
            ),
          ),
          Positioned.fill(
            child: SelectedDrawingsLayerGroup(
              notifier,
            ),
          ),
          Positioned.fill(
            child: RepaintBoundary(
              child: StatePainterLayer(
                notifier: notifier,
              ),
            ),
          ),
          Positioned.fill(
            child: RepaintBoundary(
              child: InteractionFeedbackLayer(
                notifier: notifier,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
