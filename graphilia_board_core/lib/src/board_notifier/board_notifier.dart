import 'package:flutter/foundation.dart';
import 'package:graphilia_board_core/graphilia_board_core.dart';

abstract class BoardNotifier<T> {
  BoardState<T> get state;

  ValueNotifier<BoardState<T>> get stateListenable;
}
