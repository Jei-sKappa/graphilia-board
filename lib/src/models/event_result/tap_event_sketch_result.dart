import 'package:graphilia_board/graphilia_board.dart';

// TODO: This should be in a separate file/package
// TODO: THis should use UpdatedStateDetails
typedef TapEventSketchResult<T> = EventResult<({SketchDelta<T> sketchDelta, bool shouldAddToUndoHistory})>;
