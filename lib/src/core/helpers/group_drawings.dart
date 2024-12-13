import 'package:graphilia_board/graphilia_board.dart';

({
  List<WidgetDrawing<T>> widgetDrawings,
  List<CanvasDrawing<T>> canvasDrawings,
}) groupDrawings<T>(List<Drawing<T>> drawings) {
  final widgetDrawings = <WidgetDrawing<T>>[];
  final canvasDrawings = <CanvasDrawing<T>>[];

  for (final drawing in drawings) {
    if (drawing is WidgetDrawing<T>) {
      widgetDrawings.add(drawing);
    } else if (drawing is CanvasDrawing<T>) {
      canvasDrawings.add(drawing);
    } else if (drawing is DrawingGroup<T>) {
      // Recursively group the drawings
      final group = groupDrawings(drawing.drawings);
      widgetDrawings.addAll(group.widgetDrawings);
      canvasDrawings.addAll(group.canvasDrawings);
    } else {
      throw Exception('Invalid drawing type');
    }
  }

  return (
    widgetDrawings: widgetDrawings,
    canvasDrawings: canvasDrawings,
  );
}
