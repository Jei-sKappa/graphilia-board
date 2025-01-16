import 'package:flutter/material.dart';

class GraphiliaBoardDetails extends InheritedWidget {
  final Size boardSize;

  const GraphiliaBoardDetails({
    required this.boardSize,
    required super.child,
    super.key,
  });

  @override
  bool updateShouldNotify(GraphiliaBoardDetails oldWidget) => false;

  static GraphiliaBoardDetails of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GraphiliaBoardDetails>()!;
  }
}
