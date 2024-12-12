import 'dart:ui';

enum ResizeAnchor {
  topLeft,
  topRight,
  bottomRight,
  bottomLeft,
  topCenter,
  centerRight,
  bottomCenter,
  centerLeft;

  ResizeAnchor get opposite {
    switch (this) {
      case ResizeAnchor.topLeft:
        return ResizeAnchor.bottomRight;
      case ResizeAnchor.topRight:
        return ResizeAnchor.bottomLeft;
      case ResizeAnchor.bottomRight:
        return ResizeAnchor.topLeft;
      case ResizeAnchor.bottomLeft:
        return ResizeAnchor.topRight;
      case ResizeAnchor.topCenter:
        return ResizeAnchor.bottomCenter;
      case ResizeAnchor.centerRight:
        return ResizeAnchor.centerLeft;
      case ResizeAnchor.bottomCenter:
        return ResizeAnchor.topCenter;
      case ResizeAnchor.centerLeft:
        return ResizeAnchor.centerRight;
    }
  }
}

extension RectResizeAnchor on Rect {
  Offset getAnchorPoint(ResizeAnchor anchor) {
    switch (anchor) {
      case ResizeAnchor.topLeft:
        return topLeft;
      case ResizeAnchor.topRight:
        return topRight;
      case ResizeAnchor.bottomRight:
        return bottomRight;
      case ResizeAnchor.bottomLeft:
        return bottomLeft;
      case ResizeAnchor.topCenter:
        return topCenter;
      case ResizeAnchor.centerRight:
        return centerRight;
      case ResizeAnchor.bottomCenter:
        return bottomCenter;
      case ResizeAnchor.centerLeft:
        return centerLeft;
    }
  }

  Rect inflateAnchorPoint(ResizeAnchor anchor, Offset delta) {
    switch (anchor) {
      case ResizeAnchor.topLeft:
        return Rect.fromLTRB(left + delta.dx, top + delta.dy, right, bottom);
      case ResizeAnchor.topCenter:
        return Rect.fromLTRB(left, top + delta.dy, right, bottom);
      case ResizeAnchor.topRight:
        return Rect.fromLTRB(left, top + delta.dy, right + delta.dx, bottom);
      case ResizeAnchor.centerRight:
        return Rect.fromLTRB(left, top, right + delta.dx, bottom);
      case ResizeAnchor.bottomRight:
        return Rect.fromLTRB(left, top, right + delta.dx, bottom + delta.dy);
      case ResizeAnchor.bottomCenter:
        return Rect.fromLTRB(left, top, right, bottom + delta.dy);
      case ResizeAnchor.bottomLeft:
        return Rect.fromLTRB(left + delta.dx, top, right, bottom + delta.dy);
      case ResizeAnchor.centerLeft:
        return Rect.fromLTRB(left + delta.dx, top, right, bottom);
    }
  }
}
