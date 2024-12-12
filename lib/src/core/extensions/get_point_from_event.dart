import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:graphilia_board/src/models/models.dart';

/// Extension on [PointerEvent] to get the [Point] from the event.
extension GetPointFromEvent on PointerEvent {
  /// Converts a pointer event to the [Point] on the canvas.
  Point getPoint(Curve pressureCurve) {
    final p = kIsWeb || pressureMin == pressureMax ? 0.5 : (pressure - pressureMin) / (pressureMax - pressureMin);

    final transformedPressure = pressureCurve.transform(p);

    late final Offset offset;
    if (this is PointerPanZoomUpdateEvent) {
      final ue = this as PointerPanZoomUpdateEvent;
      offset = ue.localPosition + ue.pan;
    } else {
      offset = localPosition;
    }

    return Point.fromOffset(
      offset,
      pressure: transformedPressure,
    );
  }
}
