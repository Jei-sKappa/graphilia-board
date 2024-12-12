import 'dart:ui';

class BoardPointersHelper {
  static const Set<PointerDeviceKind> all = {...PointerDeviceKind.values};

  static const Set<PointerDeviceKind> allStyluses = {
    PointerDeviceKind.stylus,
    PointerDeviceKind.invertedStylus,
  };

  static const Set<PointerDeviceKind> mouse = {PointerDeviceKind.mouse};

  static const Set<PointerDeviceKind> touch = {PointerDeviceKind.touch};

  static const Set<PointerDeviceKind> stylus = {PointerDeviceKind.stylus};

  static const Set<PointerDeviceKind> invertedStylus = {PointerDeviceKind.invertedStylus};
}

extension PointerDeviceKindSetCombination on Set<PointerDeviceKind> {
  Set<PointerDeviceKind> and(Set<PointerDeviceKind> other) {
    return {...this, ...other};
  }

  Set<PointerDeviceKind> without(Set<PointerDeviceKind> other) {
    return where((element) => !other.contains(element)).toSet();
  }
}

// TODO: LOOK PointerDeviceKind in Flutter code! There is an important iOS issue
