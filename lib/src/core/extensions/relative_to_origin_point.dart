import 'package:graphilia_board/src/core/helpers/helpers.dart';
import 'package:graphilia_board/src/models/models.dart';
import 'package:graphilia_board/src/presentation/state/state.dart';

extension RelativeToOriginPoint on Point {
  Point relativeToVisibleArea(BoardState state) => relativeToOriginFromState(this, state);
}
