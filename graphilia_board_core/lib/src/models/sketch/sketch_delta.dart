part of 'sketch.dart';

class SketchDelta<T> {
  const SketchDelta.add(List<Drawing<T>> drawings, this.version)
      : newDrawings = drawings,
        updatedDrawingsBefore = const [],
        updatedDrawingsAfter = const [],
        deletedDrawings = const [];

  const SketchDelta.update(
    List<Drawing<T>> before,
    List<Drawing<T>> after,
    this.version,
  )   : assert(before.length == after.length, 'Updated drawings before and after should have the same length'),
        newDrawings = const [],
        updatedDrawingsBefore = before,
        updatedDrawingsAfter = after,
        deletedDrawings = const [];

  const SketchDelta.delete(List<Drawing<T>> drawings, this.version)
      : newDrawings = const [],
        updatedDrawingsBefore = const [],
        updatedDrawingsAfter = const [],
        deletedDrawings = drawings;

  const SketchDelta({
    required this.version,
    required this.newDrawings,
    required this.updatedDrawingsBefore,
    required this.updatedDrawingsAfter,
    required this.deletedDrawings,
  }) : assert(updatedDrawingsBefore.length == updatedDrawingsAfter.length, 'Updated drawings before and after should have the same length');

  const SketchDelta.initial()
      : version = 0,
        newDrawings = const [],
        updatedDrawingsBefore = const [],
        updatedDrawingsAfter = const [],
        deletedDrawings = const [];

  final int version;
  final List<Drawing<T>> newDrawings;
  final List<Drawing<T>> updatedDrawingsBefore;
  final List<Drawing<T>> updatedDrawingsAfter;
  final List<Drawing<T>> deletedDrawings;

  bool get isEmpty => newDrawings.isEmpty && updatedDrawingsBefore.isEmpty && updatedDrawingsAfter.isEmpty && deletedDrawings.isEmpty;

  bool get providedNewDrawings => newDrawings.isNotEmpty;

  bool get providedUpdatedDrawings => updatedDrawingsBefore.isNotEmpty && updatedDrawingsAfter.isNotEmpty;

  bool get providedDeletedDrawings => deletedDrawings.isNotEmpty;

  SketchDelta<T> reverse() {
    return SketchDelta(
      version: version,
      newDrawings: deletedDrawings,
      updatedDrawingsBefore: updatedDrawingsAfter,
      updatedDrawingsAfter: updatedDrawingsBefore,
      deletedDrawings: newDrawings,
    );
  }

  SketchDelta<T> add(List<Drawing<T>> drawings) {
    return copyWith(
      newDrawings: [
        ...newDrawings,
        ...drawings,
      ],
    );
  }

  SketchDelta<T> update({
    required List<Drawing<T>> before,
    required List<Drawing<T>> after,
  }) {
    assert(before.length == after.length, 'Updated drawings before and after should have the same length');
    return copyWith(
      updatedDrawingsBefore: [
        ...updatedDrawingsBefore,
        ...before,
      ],
      updatedDrawingsAfter: [
        ...updatedDrawingsAfter,
        ...after,
      ],
    );
  }

  SketchDelta<T> delete(List<Drawing<T>> drawings) {
    return copyWith(
      deletedDrawings: [
        ...deletedDrawings,
        ...drawings,
      ],
    );
  }

  SketchDelta<T> copyWith({
    int? newVersion,
    List<Drawing<T>>? newDrawings,
    List<Drawing<T>>? updatedDrawingsBefore,
    List<Drawing<T>>? updatedDrawingsAfter,
    List<Drawing<T>>? deletedDrawings,
  }) {
    return SketchDelta(
      version: newVersion ?? version,
      newDrawings: newDrawings ?? this.newDrawings,
      updatedDrawingsBefore: updatedDrawingsBefore ?? this.updatedDrawingsBefore,
      updatedDrawingsAfter: updatedDrawingsAfter ?? this.updatedDrawingsAfter,
      deletedDrawings: deletedDrawings ?? this.deletedDrawings,
    );
  }

  SketchDelta<T> copyWithNewVersion(int newVersion) {
    return SketchDelta(
      version: newVersion,
      newDrawings: newDrawings,
      updatedDrawingsBefore: updatedDrawingsBefore,
      updatedDrawingsAfter: updatedDrawingsAfter,
      deletedDrawings: deletedDrawings,
    );
  }

  @override
  String toString() {
    String addedDetails = '';
    if (newDrawings.isNotEmpty) {
      addedDetails = 'added ${newDrawings.length} drawings: ${newDrawings.map((e) => e.id).toList()}, ';
    }

    String updatedBeforeDetails = '';
    if (updatedDrawingsBefore.isNotEmpty) {
      updatedBeforeDetails = 'updated before ${updatedDrawingsBefore.length} drawings: ${updatedDrawingsBefore.map((e) => e.id).toList()}, ';
    }

    String updatedAfterDetails = '';
    if (updatedDrawingsAfter.isNotEmpty) {
      updatedAfterDetails = 'updated after ${updatedDrawingsAfter.length} drawings: ${updatedDrawingsAfter.map((e) => e.id).toList()}, ';
    }

    String deletedDetails = '';
    if (deletedDrawings.isNotEmpty) {
      deletedDetails = 'deleted ${deletedDrawings.length} drawings: ${deletedDrawings.map((e) => e.id).toList()}, ';
    }

    return 'SketchDelta('
        'version: $version, '
        '$addedDetails'
        '$updatedBeforeDetails'
        '$updatedAfterDetails'
        '$deletedDetails'
        ')';
  }
}
