import 'package:flutter/widgets.dart';
import 'package:graphilia_board/graphilia_board.dart';

class StaticRootLayerGroup<T> extends StatelessWidget {
  const StaticRootLayerGroup({
    required this.sketch,
    this.viewPortSize,
    this.originOffset = Offset.zero,
    this.scaleFactor = 1.0,
    super.key,
  });

  final Sketch<T> sketch;
  final Size? viewPortSize;
  final Offset originOffset;
  final double scaleFactor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: StaticGridLayer(),
        ),
        Positioned.fill(
          child: StaticDrawingsLayerGroup(
            sketch: sketch,
            originOffset: originOffset,
            scaleFactor: scaleFactor,
          ),
        ),
      ],
    );
  }
}
