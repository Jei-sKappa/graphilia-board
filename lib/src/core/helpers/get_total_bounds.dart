import 'dart:ui';

import 'package:graphilia_board/graphilia_board.dart';

Rect? getTotalBounds(List<Drawing> drawings) {
  // If no drawing is selected, reset the state
  if (drawings.isEmpty) return null;

  // There is at least one drawing selected

  // Get the bouding box of the selected drawings
  var bounds = drawings.first.getBounds();
  for (var i = 1; i < drawings.length; i++) {
    bounds = bounds.expandToInclude(drawings[i].getBounds());
  }

  return bounds;
}
