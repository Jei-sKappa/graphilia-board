import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:graphilia_board/graphilia_board.dart';
import 'package:value_notifier_tools/value_notifier_tools.dart';

class MouseRegionLayer<T> extends StatelessWidget {
  const MouseRegionLayer({
    super.key,
    required this.notifier,
    required this.onExit,
  });

  final BoardNotifier<T> notifier;
  final void Function(PointerExitEvent)? onExit;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifier.select((state) => state.mouseCursor),
      builder: (context, mouseCursor, _) {
        return MouseRegion(
          opaque: false,
          cursor: notifier.config.isPointerDeviceKindSupported(PointerDeviceKind.mouse) && mouseCursor != null ? mouseCursor : MouseCursor.defer,
          onExit: onExit,
        );
      },
    );
  }
}
