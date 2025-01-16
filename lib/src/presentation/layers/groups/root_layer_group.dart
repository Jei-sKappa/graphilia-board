import 'package:flutter/widgets.dart';
import 'package:graphilia_board/src/presentation/interaction_controller/interaction_controller.dart';
import 'package:graphilia_board/src/presentation/layers/layers.dart';
import 'package:graphilia_board/src/presentation/notifier/notifier.dart';

class RootLayerGroup<T> extends StatelessWidget {
  const RootLayerGroup({
    super.key,
    required this.notifier,
    required this.interactionController,
  });

  final BoardNotifier<T, BoardStateConfig> notifier;
  final InteractionControllerBase<T> interactionController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Layers that don't need to be transformed
        Positioned.fill(
          child: RepaintBoundary(
            child: GridLayer(
              notifier: notifier,
            ),
          ),
        ),
        Positioned.fill(
          child: TransformedLayerGroup(
            notifier: notifier,
            interactionController: interactionController,
          ),
        ),
        Positioned.fill(
          child: MouseRegionLayer(
            notifier: notifier,
            onExit: interactionController.onPointerExit,
          ),
        ),
      ],
    );
  }
}
