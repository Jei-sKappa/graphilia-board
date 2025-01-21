import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:graphilia_board/src/core/helpers/helpers.dart';
import 'package:graphilia_board/src/presentation/layers/layers.dart';
import 'package:graphilia_board/src/presentation/notifier/notifier.dart';
import 'package:graphilia_board/src/presentation/state/state.dart';
import 'package:value_notifier_tools/value_notifier_tools.dart';

class SelectedDrawingsLayerGroup<T> extends StatelessWidget {
  const SelectedDrawingsLayerGroup(
    this.notifier, {
    super.key,
  });

  final BoardNotifier<T> notifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      // Check if the selected drawings changed
      // This is necessary because the above
      // valueListenable checks only if the ids of
      // the selected drawings changed, but not if
      // the drawings themselves changed, for
      // example due to a movement of the drawings
      valueListenable: notifier.select(
        (value) {
          if (value is SelectedState<T>) {
            // TODO: Check only if the selected drawings in the visible area changed
            return value.selectedDrawings;
          }
          return null;
        },
      ).where(
        (previous, next) {
          // TODO: This can be expensive, try to optimize it
          final areSelectedDrawingsChanged = !(const DeepCollectionEquality().equals(previous, next));
          return areSelectedDrawingsChanged;
        },
      ),
      builder: (context, selectedDrawings, _) {
        if (selectedDrawings == null) {
          return const SizedBox.shrink();
        }

        final (:widgetDrawings, :canvasDrawings) = groupDrawings(selectedDrawings);

        // TODO: Insted of ignoring the pointer, for every element, we should provide an option to enable/disable the pointer when selecting directly inside the Drawing class (or somewhere else)
        return IgnorePointer(
          child: Stack(
            children: [
              if (widgetDrawings.isNotEmpty)
                Positioned.fill(
                  child: RepaintBoundary(
                    child: WidgetDrawingsLayer(
                      drawings: widgetDrawings,
                      state: notifier.value,
                      areDrawingsSelected: true,
                    ),
                  ),
                ),
              if (canvasDrawings.isNotEmpty)
                Positioned.fill(
                  child: RepaintBoundary(
                    child: CanvasDrawingsLayer(
                      drawings: canvasDrawings,
                      state: notifier.value,
                      areDrawingsSelected: true,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
