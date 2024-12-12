import 'dart:ui';

import 'package:graphilia_board/src/models/models.dart';

class PlaceholderRectRepresentation extends AnchoredDrawingRepresentation {
  const PlaceholderRectRepresentation({
    required super.anchorPoint,
    required super.endPoint,
  });

  PlaceholderRectRepresentation.fromSize({
    required super.anchorPoint,
    super.size = const Size(50, 50),
  }) : super.fromSize();
}
