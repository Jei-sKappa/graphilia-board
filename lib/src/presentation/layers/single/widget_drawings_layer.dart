import 'package:flutter/widgets.dart';
import 'package:graphilia_board/src/models/models.dart';
import 'package:graphilia_board/src/presentation/state/state.dart';

class WidgetDrawingsLayer extends StatelessWidget {
  const WidgetDrawingsLayer({
    super.key,
    required this.drawings,
    required this.state,
    required this.areDrawingsSelected,
  });

  final List<WidgetDrawing> drawings;
  final BoardState state;
  final bool areDrawingsSelected;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        for (final drawing in drawings)
          Positioned.fromRect(
            rect: drawing.getBounds(),
            child: drawing.build(
              context,
              state,
              isSelected: areDrawingsSelected,
            ),
          ),
      ],
    );
  }
}
