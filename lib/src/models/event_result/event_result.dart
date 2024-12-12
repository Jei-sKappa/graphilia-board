export 'tap_event_sketch_result.dart';

/// {@template event_result}
/// The result of a event
///
/// - `handled` indicates whether the event was handled
/// - `result` is the eventual result of the event.
///
/// If `result` isn't null then `handled` is guaranteed to be `true`
/// {@endtemplate}
class EventResult<T> {
  /// {@macro event_result}
  ///
  /// Automatically sets `handled` to `true`
  const EventResult.handled(this.result, {this.skipRemainingHandlers = true}) : handled = true;

  const EventResult.ignored({this.skipRemainingHandlers = false})
      : handled = false,
        result = null;

  final bool handled;
  final bool skipRemainingHandlers;
  final T? result;
}
