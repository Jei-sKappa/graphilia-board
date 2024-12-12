import 'package:graphilia_board/graphilia_board.dart';

({
  List<WidgetDrawing> widgetDrawings,
  List<CanvasDrawing> canvasDrawings,
}) groupDrawings(List<Drawing> drawings) {
  final widgetDrawings = <WidgetDrawing>[];
  final canvasDrawings = <CanvasDrawing>[];

  for (final drawing in drawings) {
    if (drawing is WidgetDrawing) {
      widgetDrawings.add(drawing);
    } else if (drawing is CanvasDrawing) {
      canvasDrawings.add(drawing);
    } else if (drawing is DrawingGroup) {
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
