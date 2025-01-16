import 'package:flutter/material.dart';
import 'package:graphilia_board/src/presentation/notifier/notifier.dart';
import 'package:graphilia_board/src/presentation/state/state.dart';
import 'package:value_notifier_tools/value_notifier_tools.dart';

class StatePainterLayer<T> extends StatelessWidget {
  const StatePainterLayer({
    super.key,
    required this.notifier,
  });

  final BoardNotifier<T> notifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      // TODO: Optimize notify on only the necessary stuff
      valueListenable: notifier.where((previous, next) => previous.runtimeType != next.runtimeType || next.shouldRepaintStateLayer(previous)),
      builder: (context, state, _) {
        if (state.paintStateLayer == null) {
          return const SizedBox();
        }

        return CustomPaint(
          foregroundPainter: StatePainter(state.paintStateLayer!),
        );
      },
    );
  }
}

class StatePainter extends CustomPainter {
  StatePainter(this.paintStateLayer);

  final StateLayerPainter paintStateLayer;

  @override
  void paint(Canvas canvas, Size size) => paintStateLayer(canvas, size);

  @override
  bool shouldRepaint(StatePainter oldDelegate) => true;
}
