import 'package:graphilia_board/src/models/models.dart';
import 'package:graphilia_board/src/presentation/state/state.dart';

Point relativeToOriginFromState(Point point, BoardState state) => (point / state.scaleFactor) + state.originOffset;
