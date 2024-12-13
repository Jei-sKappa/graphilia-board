import 'package:detailed_gesture_detector/detailed_gesture_detector.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:graphilia_board/src/core/extensions/extensions.dart';
import 'package:graphilia_board/src/core/helpers/helpers.dart';
import 'package:graphilia_board/src/models/models.dart';
import 'package:graphilia_board/src/presentation/interaction_controller/interaction_controller.dart';
import 'package:graphilia_board/src/presentation/notifier/notifier.dart';
import 'package:graphilia_board/src/presentation/state/state.dart';

export 'interaction_controller_base.dart';

const _shouldLog = false;

class InteractionController<T> extends InteractionControllerBase<T> {
  InteractionController({
    required this.notifier,
    required super.graphiliaBoardInteractions,
  });

  final BoardNotifier<T, BoardStateConfig> notifier;

  // TODO: Use a logging package
  void _log(String message) =>
      _shouldLog ? debugPrint('log | InteractionController | $message') : null;

  // MOUSE REGION CALLBACKS

  @override
  PointerExitEventListener get onPointerExit =>
      // Events triggered from a Listener or MouseRegion widget like this should
      // never be nullable because we want to provide basic interaction data to
      // the state
      (PointerExitEvent event) {
        // _log("onPointerExit called");
        // If the pointer device kind is not supported, ignore the event
        if (!notifier.config.isPointerDeviceKindSupported(event.kind)) return;

        // Delegate the event to the current state
        final validInteractions = graphiliaBoardInteractions
            .where((handler) => handler.handlePointerExitEvent != null);

        if (validInteractions.isNotEmpty) {
          // _log("onPointerExitHandler provided");
          for (final interaction in validInteractions) {
            final handled = interaction.handlePointerExitEvent!(
              event,
              notifier,
            );

            if (handled) {
              // _log("onPointerExit handled by ${interaction.runtimeType}");
              break;
            }
          }
        }

        // End the interaction
        notifier.setBoardState(
          state: notifier.value.removeInteractionData(
            event,
            notifier.config,
          ),
          shouldAddToHistory: false,
        );
      };

  // LISTENER CALLBACKS

  @override
  PointerHoverEventListener get onPointerHover =>
      // Events triggered from a Listener or MouseRegion widget like this should
      // never be nullable because we want to provide basic interaction data to
      // the state
      (PointerHoverEvent event) {
        // _log("onPointerHover called");
        // If the pointer device kind is not supported, ignore the event
        if (!notifier.config.isPointerDeviceKindSupported(event.kind)) return;

        // Track the pointer position
        notifier.setBoardState(
          state: notifier.value.trackPointerPosition(
            event,
            notifier.config,
          ),
          shouldAddToHistory: false,
        );

        // Delegate the event to the current state
        final validInteractions = graphiliaBoardInteractions
            .where((handler) => handler.handlePointerHoverEvent != null);

        if (validInteractions.isNotEmpty) {
          // _log("onPointerHoverHandler provided");
          for (final interaction in validInteractions) {
            final handled = interaction.handlePointerHoverEvent!(
              event,
              notifier,
            );

            if (handled) {
              // _log("onPointerHover handled by ${interaction.runtimeType}");
              break;
            }
          }
        }
      };

  @override
  PointerDownEventListener get onPointerDown =>
      // Events triggered from a Listener or MouseRegion widget like this should
      // never be nullable because we want to provide basic interaction data to
      // the state
      (PointerDownEvent event) {
        // _log("onPointerDown called");
        // If the pointer device kind is not supported, ignore the event
        if (!notifier.config.isPointerDeviceKindSupported(event.kind)) return;

        // Initialize the interaction data
        notifier.setBoardState(
          state: notifier.value.initializeInteractionData(
            event,
            notifier.config,
          ),
          shouldAddToHistory: false,
        );

        // Delegate the event to the current state
        final validInteractions = graphiliaBoardInteractions
            .where((handler) => handler.handlePointerDownEvent != null);

        if (validInteractions.isNotEmpty) {
          // _log("onPointerDownHandler provided");
          for (final interaction in validInteractions) {
            final handled = interaction.handlePointerDownEvent!(
              event,
              notifier,
            );

            if (handled) {
              // _log("onPointerDown handled by ${interaction.runtimeType}");
              break;
            }
          }
        }
      };

  @override
  PointerMoveEventListener get onPointerMove =>
      // Events triggered from a Listener or MouseRegion widget like this should
      // never be nullable because we want to provide basic interaction data to
      // the state
      (PointerMoveEvent event) {
        // _log("onPointerMove called");
        // If the pointer device kind is not supported, ignore the event
        if (!notifier.config.isPointerDeviceKindSupported(event.kind)) return;

        // Update the interaction data
        notifier.setBoardState(
          state: notifier.value.updateInteractionData(
            event,
            notifier.config,
          ),
          shouldAddToHistory: false,
        );

        // Delegate the event to the current state
        final validInteractions = graphiliaBoardInteractions
            .where((handler) => handler.handlePointerMoveEvent != null);

        if (validInteractions.isNotEmpty) {
          // _log("onPointerMoveHandler provided");
          for (final interaction in validInteractions) {
            final handled = interaction.handlePointerMoveEvent!(
              event,
              notifier,
            );

            if (handled) {
              // _log("onPointerMove handled by ${interaction.runtimeType}");
              break;
            }
          }
        }
      };

  @override
  PointerUpEventListener get onPointerUp =>
      // Events triggered from a Listener or MouseRegion widget like this should
      // never be nullable because we want to provide basic interaction data to
      // the state
      (PointerUpEvent event) {
        // _log("onPointerUp called");
        // If the pointer device kind is not supported, ignore the event
        if (!notifier.config.isPointerDeviceKindSupported(event.kind)) return;

        // Delegate the event to the current state
        final validInteractions = graphiliaBoardInteractions
            .where((handler) => handler.handlePointerUpEvent != null);

        if (validInteractions.isNotEmpty) {
          // _log("onPointerUpHandler provided");
          for (final interaction in validInteractions) {
            final handled = interaction.handlePointerUpEvent!(
              event,
              notifier,
            );

            if (handled) {
              // _log("onPointerUp handled by ${interaction.runtimeType}");
              break;
            }
          }
        }

        // End the interaction
        notifier.setBoardState(
          state: notifier.value.removeInteractionData(
            event,
            notifier.config,
            keepPointerPosition: true,
          ),
          shouldAddToHistory: false,
        );
      };

  @override
  PointerCancelEventListener get onPointerCancel =>
      // Events triggered from a Listener or MouseRegion widget like this should
      // never be nullable because we want to provide basic interaction data to
      // the state
      (PointerCancelEvent event) {
        // _log("onPointerCancel called");
        // If the pointer device kind is not supported, ignore the event
        if (!notifier.config.isPointerDeviceKindSupported(event.kind)) return;

        // Delegate the event to the current state
        final validInteractions = graphiliaBoardInteractions
            .where((handler) => handler.handlePointerCancelEvent != null);

        if (validInteractions.isNotEmpty) {
          // _log("onPointerCancelHandler provided");
          for (final interaction in validInteractions) {
            final handled = interaction.handlePointerCancelEvent!(
              event,
              notifier,
            );

            if (handled) {
              // _log("onPointerCancel handled by ${interaction.runtimeType}");
              break;
            }
          }
        }

        // End the interaction
        notifier.setBoardState(
          state: notifier.value.removeInteractionData(
            event,
            notifier.config,
          ),
          shouldAddToHistory: false,
        );
      };

  @override
  PointerPanZoomStartEventListener get onPointerPanZoomStart =>
      // Events triggered from a Listener or MouseRegion widget like this should
      // never be nullable because we want to provide basic interaction data to
      // the state
      (PointerPanZoomStartEvent event) {
        // _log("onPointerPanZoomStart called");
        // If the pointer device kind is not supported, ignore the event
        if (!notifier.config.isPointerDeviceKindSupported(event.kind)) return;

        // Initialize the interaction data
        notifier.setBoardState(
          state: notifier.value.initializeInteractionData(
            event,
            notifier.config,
          ),
          shouldAddToHistory: false,
        );

        // Delegate the event to the current state
        final validInteractions = graphiliaBoardInteractions
            .where((handler) => handler.handlePointerPanZoomStartEvent != null);

        if (validInteractions.isNotEmpty) {
          // _log("onPointerPanZoomStartHandler provided");
          for (final interaction in validInteractions) {
            final handled = interaction.handlePointerPanZoomStartEvent!(
              event,
              notifier,
            );

            if (handled) {
              // _log("onPointerPanZoomStart handled by ${interaction.runtimeType}");
              break;
            }
          }
        }
      };

  @override
  PointerPanZoomUpdateEventListener get onPointerPanZoomUpdate =>
      // Events triggered from a Listener or MouseRegion widget like this should
      // never be nullable because we want to provide basic interaction data to
      // the state
      (PointerPanZoomUpdateEvent event) {
        // _log("onPointerPanZoomUpdate called");
        // If the pointer device kind is not supported, ignore the event
        if (!notifier.config.isPointerDeviceKindSupported(event.kind)) return;

        // Update the interaction data
        notifier.setBoardState(
          state: notifier.value.updateInteractionData(
            event,
            notifier.config,
          ),
          shouldAddToHistory: false,
        );

        // Delegate the event to the current state
        final validInteractions = graphiliaBoardInteractions.where(
            (handler) => handler.handlePointerPanZoomUpdateEvent != null);

        if (validInteractions.isNotEmpty) {
          // _log("onPointerPanZoomUpdateHandler provided");
          for (final interaction in validInteractions) {
            final handled = interaction.handlePointerPanZoomUpdateEvent!(
              event,
              notifier,
            );

            if (handled) {
              // _log("onPointerPanZoomUpdate handled by ${interaction.runtimeType}");
              break;
            }
          }
        }
      };

  @override
  PointerPanZoomEndEventListener get onPointerPanZoomEnd =>
      // Events triggered from a Listener or MouseRegion widget like this should
      // never be nullable because we want to provide basic interaction data to
      // the state
      (PointerPanZoomEndEvent event) {
        // _log("onPointerPanZoomEnd called");
        // If the pointer device kind is not supported, ignore the event
        if (!notifier.config.isPointerDeviceKindSupported(event.kind)) return;

        // Delegate the event to the current state
        final validInteractions = graphiliaBoardInteractions
            .where((handler) => handler.handlePointerPanZoomEndEvent != null);

        if (validInteractions.isNotEmpty) {
          // _log("onPointerPanZoomEndHandler provided");
          for (final interaction in validInteractions) {
            final handled = interaction.handlePointerPanZoomEndEvent!(
              event,
              notifier,
            );

            if (handled) {
              // _log("onPointerPanZoomEnd handled by ${interaction.runtimeType}");
              break;
            }
          }
        }

        // End the interaction
        notifier.setBoardState(
          state: notifier.value.removeInteractionData(
            event,
            notifier.config,
          ),
          shouldAddToHistory: false,
        );
      };

  @override
  PointerSignalEventListener get onPointerSignal =>
      // Events triggered from a Listener or MouseRegion widget like this should
      // never be nullable because we want to provide basic interaction data to
      // the state
      (PointerSignalEvent event) {
        // _log("onPointerSignal called");
        // If the pointer device kind is not supported, ignore the event
        if (!notifier.config.isPointerDeviceKindSupported(event.kind)) return;

        // Update scale factor based on scroll delta
        notifier.setBoardState(
          state: notifier.value.maybeUpdateScaleFactorAndOrigin(
            event,
            notifier.config,
          ),
          shouldAddToHistory: false,
        );

        // Delegate the event to the current state
        final validInteractions = graphiliaBoardInteractions
            .where((handler) => handler.handlePointerSignalEvent != null);

        if (validInteractions.isNotEmpty) {
          // _log("onPointerSingnalHandler provided");
          for (final interaction in validInteractions) {
            final handled = interaction.handlePointerSignalEvent!(
              event,
              notifier,
            );

            if (handled) {
              // _log("onPointerSignal handled by ${interaction.runtimeType}");
              break;
            }
          }
        }
      };

  // DETAIL GESTURE DETECTOR CALLBACKS
  @override
  DetailedGestureTapDownCallback? get onTapDown {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnTapDown != null);

    if (validInteractions.isEmpty) return null;

    return (details, pointerDownEvent) {
      _log("handleOnTapDown called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(
        pointerDownEvent.kind,
      )) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnTapDown!(
          details,
          pointerDownEvent,
          notifier,
        );

        if (handled) {
          _log("handleOnTapDown handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureTapUpCallback? get onTapUp {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnTapUp != null);

    if (validInteractions.isEmpty) return null;

    return (details, pointerDownEvent, pointerUpEvent) {
      _log("handleOnTapUp called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(
        pointerDownEvent.kind,
      )) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnTapUp!(
          details,
          pointerDownEvent,
          pointerUpEvent,
          notifier,
        );

        if (handled) {
          _log("handleOnTapUp handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureTapCallback? get onTap {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnTap != null);

    if (validInteractions.isEmpty) return null;

    return (pointerDownEvent, pointerUpEvent) {
      _log("handleOnTap called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(
        pointerDownEvent.kind,
      )) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnTap!(
          pointerDownEvent,
          pointerUpEvent,
          notifier,
        );

        if (handled) {
          _log("handleOnTap handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureTapCancelCallback? get onTapCancel {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnTapCancel != null);

    if (validInteractions.isEmpty) return null;

    return (pointerDownEvent, cancelEvent, reason) {
      _log("handleOnTapCancel called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(
        pointerDownEvent.kind,
      )) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnTapCancel!(
          pointerDownEvent,
          cancelEvent,
          reason,
          notifier,
        );

        if (handled) {
          _log("handleOnTapCancel handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureTapCallback? get onSecondaryTap {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnSecondaryTap != null);

    if (validInteractions.isEmpty) return null;

    return (pointerDownEvent, pointerUpEvent) {
      _log("handleOnSecondaryTap called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(
        pointerDownEvent.kind,
      )) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnSecondaryTap!(
          pointerDownEvent,
          pointerUpEvent,
          notifier,
        );

        if (handled) {
          _log("handleOnSecondaryTap handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureTapDownCallback? get onSecondaryTapDown {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnSecondaryTapDown != null);

    if (validInteractions.isEmpty) return null;

    return (details, pointerDownEvent) {
      _log("handleOnSecondaryTapDown called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(
        pointerDownEvent.kind,
      )) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnSecondaryTapDown!(
          details,
          pointerDownEvent,
          notifier,
        );

        if (handled) {
          _log(
              "handleOnSecondaryTapDown handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureTapUpCallback? get onSecondaryTapUp {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnSecondaryTapUp != null);

    if (validInteractions.isEmpty) return null;

    return (details, pointerDownEvent, pointerUpEvent) {
      _log("handleOnSecondaryTapUp called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(
        pointerDownEvent.kind,
      )) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnSecondaryTapUp!(
          details,
          pointerDownEvent,
          pointerUpEvent,
          notifier,
        );

        if (handled) {
          _log("handleOnSecondaryTapUp handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureTapCancelCallback? get onSecondaryTapCancel {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnSecondaryTapCancel != null);

    if (validInteractions.isEmpty) return null;

    return (pointerDownEvent, cancelEvent, reason) {
      _log("handleOnSecondaryTapCancel called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(
        pointerDownEvent.kind,
      )) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnSecondaryTapCancel!(
          pointerDownEvent,
          cancelEvent,
          reason,
          notifier,
        );

        if (handled) {
          _log(
              "handleOnSecondaryTapCancel handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureTapDownCallback? get onTertiaryTapDown {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnTertiaryTapDown != null);

    if (validInteractions.isEmpty) return null;

    return (details, pointerDownEvent) {
      _log("handleOnTertiaryTapDown called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(
        pointerDownEvent.kind,
      )) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnTertiaryTapDown!(
          details,
          pointerDownEvent,
          notifier,
        );

        if (handled) {
          _log("handleOnTertiaryTapDown handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureTapUpCallback? get onTertiaryTapUp {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnTertiaryTapUp != null);

    if (validInteractions.isEmpty) return null;

    return (details, pointerDownEvent, pointerUpEvent) {
      _log("handleOnTertiaryTapUp called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(
        pointerDownEvent.kind,
      )) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnTertiaryTapUp!(
          details,
          pointerDownEvent,
          pointerUpEvent,
          notifier,
        );

        if (handled) {
          _log("handleOnTertiaryTapUp handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureTapCancelCallback? get onTertiaryTapCancel {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnTertiaryTapCancel != null);

    if (validInteractions.isEmpty) return null;

    return (pointerDownEvent, cancelEvent, reason) {
      _log("handleOnTertiaryTapCancel called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(
        pointerDownEvent.kind,
      )) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnTertiaryTapCancel!(
          pointerDownEvent,
          cancelEvent,
          reason,
          notifier,
        );

        if (handled) {
          _log(
              "handleOnTertiaryTapCancel handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureDoubleTapDownCallback? get onDoubleTapDown {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnDoubleTapDown != null);

    if (validInteractions.isEmpty) return null;

    return (details, firstEvent, secondEvent) {
      _log("handleOnDoubleTapDown called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(
        firstEvent.kind,
      )) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnDoubleTapDown!(
          details,
          firstEvent,
          secondEvent,
          notifier,
        );

        if (handled) {
          _log("handleOnDoubleTapDown handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureDoubleTapCallback? get onDoubleTap {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnDoubleTap != null);

    if (validInteractions.isEmpty) return null;

    return (firstEvent, secondEvent) {
      _log("handleOnDoubleTap called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(
        firstEvent.kind,
      )) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnDoubleTap!(
          firstEvent,
          secondEvent,
          notifier,
        );

        if (handled) {
          _log("handleOnDoubleTap handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureDoubleTapCancelCallback? get onDoubleTapCancel {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnDoubleTapCancel != null);

    if (validInteractions.isEmpty) return null;

    return (firstEvent, cancelEvent) {
      _log("handleOnDoubleTapCancel called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(
        firstEvent.kind,
      )) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnDoubleTapCancel!(
          firstEvent,
          cancelEvent,
          notifier,
        );

        if (handled) {
          _log("handleOnDoubleTapCancel handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureLongPressDownCallback? get onLongPressDown {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnLongPressDown != null);

    if (validInteractions.isEmpty) return null;

    return (details, event) {
      _log("handleOnLongPressDown called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(event.kind)) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnLongPressDown!(
          details,
          event,
          notifier,
        );

        if (handled) {
          _log("handleOnLongPressDown handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureLongPressCancelCallback? get onLongPressCancel {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnLongPressCancel != null);

    if (validInteractions.isEmpty) return null;

    return (firstEvent, event) {
      _log("handleOnLongPressCancel called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(
        firstEvent.kind,
      )) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnLongPressCancel!(
          firstEvent,
          event,
          notifier,
        );

        if (handled) {
          _log("handleOnLongPressCancel handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureLongPressCallback? get onLongPress {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnLongPress != null);

    if (validInteractions.isEmpty) return null;

    return (event) {
      _log("handleOnLongPress called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(event.kind)) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnLongPress!(
          event,
          notifier,
        );

        if (handled) {
          _log("handleOnLongPress handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureLongPressStartCallback? get onLongPressStart {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnLongPressStart != null);

    if (validInteractions.isEmpty) return null;

    return (details, event) {
      _log("handleOnLongPressStart called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(event.kind)) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnLongPressStart!(
          details,
          event,
          notifier,
        );

        if (handled) {
          _log("handleOnLongPressStart handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureLongPressMoveUpdateCallback? get onLongPressMoveUpdate {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnLongPressMoveUpdate != null);

    if (validInteractions.isEmpty) return null;

    return (details, initialEvent, event) {
      _log("handleOnLongPressMoveUpdate called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(
        initialEvent.kind,
      )) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnLongPressMoveUpdate!(
          details,
          initialEvent,
          event,
          notifier,
        );

        if (handled) {
          _log(
              "handleOnLongPressMoveUpdate handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureLongPressUpCallback? get onLongPressUp {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnLongPressUp != null);

    if (validInteractions.isEmpty) return null;

    return (initialEvent, event) {
      _log("handleOnLongPressUp called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(
        initialEvent.kind,
      )) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnLongPressUp!(
          initialEvent,
          event,
          notifier,
        );

        if (handled) {
          _log("handleOnLongPressUp handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureLongPressEndCallback? get onLongPressEnd {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnLongPressEnd != null);

    if (validInteractions.isEmpty) return null;

    return (details, initialEvent, event) {
      _log("handleOnLongPressEnd called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(
        initialEvent.kind,
      )) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnLongPressEnd!(
          details,
          initialEvent,
          event,
          notifier,
        );

        if (handled) {
          _log("handleOnLongPressEnd handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureLongPressDownCallback? get onSecondaryLongPressDown {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnSecondaryLongPressDown != null);

    if (validInteractions.isEmpty) return null;

    return (details, event) {
      _log("handleOnSecondaryLongPressDown called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(event.kind)) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnSecondaryLongPressDown!(
          details,
          event,
          notifier,
        );

        if (handled) {
          _log(
              "handleOnSecondaryLongPressDown handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureLongPressCancelCallback? get onSecondaryLongPressCancel {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnSecondaryLongPressCancel != null);

    if (validInteractions.isEmpty) return null;

    return (firstEvent, event) {
      _log("handleOnSecondaryLongPressCancel called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(
        firstEvent.kind,
      )) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnSecondaryLongPressCancel!(
          firstEvent,
          event,
          notifier,
        );

        if (handled) {
          _log(
              "handleOnSecondaryLongPressCancel handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureLongPressCallback? get onSecondaryLongPress {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnSecondaryLongPress != null);

    if (validInteractions.isEmpty) return null;

    return (event) {
      _log("handleOnSecondaryLongPress called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(event.kind)) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnSecondaryLongPress!(
          event,
          notifier,
        );

        if (handled) {
          _log(
              "handleOnSecondaryLongPress handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureLongPressStartCallback? get onSecondaryLongPressStart {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnSecondaryLongPressStart != null);

    if (validInteractions.isEmpty) return null;

    return (details, event) {
      _log("handleOnSecondaryLongPressStart called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(event.kind)) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnSecondaryLongPressStart!(
          details,
          event,
          notifier,
        );

        if (handled) {
          _log(
              "handleOnSecondaryLongPressStart handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureLongPressMoveUpdateCallback?
      get onSecondaryLongPressMoveUpdate {
    final validInteractions = graphiliaBoardInteractions.where(
        (handler) => handler.handleOnSecondaryLongPressMoveUpdate != null);

    if (validInteractions.isEmpty) return null;

    return (details, initialEvent, event) {
      _log("handleOnSecondaryLongPressMoveUpdate called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(
        initialEvent.kind,
      )) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnSecondaryLongPressMoveUpdate!(
          details,
          initialEvent,
          event,
          notifier,
        );

        if (handled) {
          _log(
              "handleOnSecondaryLongPressMoveUpdate handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureLongPressUpCallback? get onSecondaryLongPressUp {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnSecondaryLongPressUp != null);

    if (validInteractions.isEmpty) return null;

    return (initialEvent, event) {
      _log("handleOnSecondaryLongPressUp called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(
        initialEvent.kind,
      )) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnSecondaryLongPressUp!(
          initialEvent,
          event,
          notifier,
        );

        if (handled) {
          _log(
              "handleOnSecondaryLongPressUp handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureLongPressEndCallback? get onSecondaryLongPressEnd {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnSecondaryLongPressEnd != null);

    if (validInteractions.isEmpty) return null;

    return (details, initialEvent, event) {
      _log("handleOnSecondaryLongPressEnd called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(
        initialEvent.kind,
      )) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnSecondaryLongPressEnd!(
          details,
          initialEvent,
          event,
          notifier,
        );

        if (handled) {
          _log(
              "handleOnSecondaryLongPressEnd handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureLongPressDownCallback? get onTertiaryLongPressDown {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnTertiaryLongPressDown != null);

    if (validInteractions.isEmpty) return null;

    return (details, event) {
      _log("handleOnTertiaryLongPressDown called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(event.kind)) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnTertiaryLongPressDown!(
          details,
          event,
          notifier,
        );

        if (handled) {
          _log(
              "handleOnTertiaryLongPressDown handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureLongPressCancelCallback? get onTertiaryLongPressCancel {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnTertiaryLongPressCancel != null);

    if (validInteractions.isEmpty) return null;

    return (firstEvent, event) {
      _log("handleOnTertiaryLongPressCancel called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(
        firstEvent.kind,
      )) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnTertiaryLongPressCancel!(
          firstEvent,
          event,
          notifier,
        );

        if (handled) {
          _log(
              "handleOnTertiaryLongPressCancel handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureLongPressCallback? get onTertiaryLongPress {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnTertiaryLongPress != null);

    if (validInteractions.isEmpty) return null;

    return (event) {
      _log("handleOnTertiaryLongPress called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(event.kind)) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnTertiaryLongPress!(
          event,
          notifier,
        );

        if (handled) {
          _log(
              "handleOnTertiaryLongPress handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureLongPressStartCallback? get onTertiaryLongPressStart {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnTertiaryLongPressStart != null);

    if (validInteractions.isEmpty) return null;

    return (details, event) {
      _log("handleOnTertiaryLongPressStart called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(event.kind)) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnTertiaryLongPressStart!(
          details,
          event,
          notifier,
        );

        if (handled) {
          _log(
              "handleOnTertiaryLongPressStart handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureLongPressMoveUpdateCallback?
      get onTertiaryLongPressMoveUpdate {
    final validInteractions = graphiliaBoardInteractions.where(
        (handler) => handler.handleOnTertiaryLongPressMoveUpdate != null);

    if (validInteractions.isEmpty) return null;

    return (details, initialEvent, event) {
      _log("handleOnTertiaryLongPressMoveUpdate called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(
        initialEvent.kind,
      )) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnTertiaryLongPressMoveUpdate!(
          details,
          initialEvent,
          event,
          notifier,
        );

        if (handled) {
          _log(
              "handleOnTertiaryLongPressMoveUpdate handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureLongPressUpCallback? get onTertiaryLongPressUp {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnTertiaryLongPressUp != null);

    if (validInteractions.isEmpty) return null;

    return (initialEvent, event) {
      _log("handleOnTertiaryLongPressUp called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(
        initialEvent.kind,
      )) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnTertiaryLongPressUp!(
          initialEvent,
          event,
          notifier,
        );

        if (handled) {
          _log(
              "handleOnTertiaryLongPressUp handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureLongPressEndCallback? get onTertiaryLongPressEnd {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnTertiaryLongPressEnd != null);

    if (validInteractions.isEmpty) return null;

    return (details, initialEvent, event) {
      _log("handleOnTertiaryLongPressEnd called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(
        initialEvent.kind,
      )) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnTertiaryLongPressEnd!(
          details,
          initialEvent,
          event,
          notifier,
        );

        if (handled) {
          _log(
              "handleOnTertiaryLongPressEnd handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureDragDownCallback? get onVerticalDragDown {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnVerticalDragDown != null);

    if (validInteractions.isEmpty) return null;

    return (details, event) {
      _log("handleOnVerticalDragDown called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(event.kind)) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnVerticalDragDown!(
          details,
          event,
          notifier,
        );

        if (handled) {
          _log(
              "handleOnVerticalDragDown handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureDragStartCallback? get onVerticalDragStart {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnVerticalDragStart != null);

    if (validInteractions.isEmpty) return null;

    return (details, event) {
      _log("handleOnVerticalDragStart called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(event.kind)) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnVerticalDragStart!(
          details,
          event,
          notifier,
        );

        if (handled) {
          _log(
              "handleOnVerticalDragStart handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureDragUpdateCallback? get onVerticalDragUpdate {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnVerticalDragUpdate != null);

    if (validInteractions.isEmpty) return null;

    return (details, initialEvent, event) {
      _log("handleOnVerticalDragUpdate called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(
        initialEvent.kind,
      )) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnVerticalDragUpdate!(
          details,
          initialEvent,
          event,
          notifier,
        );

        if (handled) {
          _log(
              "handleOnVerticalDragUpdate handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureDragEndCallback? get onVerticalDragEnd {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnVerticalDragEnd != null);

    if (validInteractions.isEmpty) return null;

    return (details, event) {
      _log("handleOnVerticalDragEnd called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(event.kind)) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnVerticalDragEnd!(
          details,
          event,
          notifier,
        );

        if (handled) {
          _log("handleOnVerticalDragEnd handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureDragCancelCallback? get onVerticalDragCancel {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnVerticalDragCancel != null);

    if (validInteractions.isEmpty) return null;

    return (initialEvent, finalEvent) {
      _log("handleOnVerticalDragCancel called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(
        initialEvent.kind,
      )) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnVerticalDragCancel!(
          initialEvent,
          finalEvent,
          notifier,
        );

        if (handled) {
          _log(
              "handleOnVerticalDragCancel handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureDragDownCallback? get onHorizontalDragDown {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnHorizontalDragDown != null);

    if (validInteractions.isEmpty) return null;

    return (details, event) {
      _log("handleOnHorizontalDragDown called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(event.kind)) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnHorizontalDragDown!(
          details,
          event,
          notifier,
        );

        if (handled) {
          _log(
              "handleOnHorizontalDragDown handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureDragStartCallback? get onHorizontalDragStart {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnHorizontalDragStart != null);

    if (validInteractions.isEmpty) return null;

    return (details, event) {
      _log("handleOnHorizontalDragStart called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(event.kind)) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnHorizontalDragStart!(
          details,
          event,
          notifier,
        );

        if (handled) {
          _log(
              "handleOnHorizontalDragStart handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureDragUpdateCallback? get onHorizontalDragUpdate {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnHorizontalDragUpdate != null);

    if (validInteractions.isEmpty) return null;

    return (details, initialEvent, event) {
      _log("handleOnHorizontalDragUpdate called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(
        initialEvent.kind,
      )) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnHorizontalDragUpdate!(
          details,
          initialEvent,
          event,
          notifier,
        );

        if (handled) {
          _log(
              "handleOnHorizontalDragUpdate handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureDragEndCallback? get onHorizontalDragEnd {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnHorizontalDragEnd != null);

    if (validInteractions.isEmpty) return null;

    return (details, event) {
      _log("handleOnHorizontalDragEnd called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(event.kind)) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnHorizontalDragEnd!(
          details,
          event,
          notifier,
        );

        if (handled) {
          _log(
              "handleOnHorizontalDragEnd handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureDragCancelCallback? get onHorizontalDragCancel {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnHorizontalDragCancel != null);

    if (validInteractions.isEmpty) return null;

    return (initialEvent, finalEvent) {
      _log("handleOnHorizontalDragCancel called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(
        initialEvent.kind,
      )) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnHorizontalDragCancel!(
          initialEvent,
          finalEvent,
          notifier,
        );

        if (handled) {
          _log(
              "handleOnHorizontalDragCancel handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureDragDownCallback? get onPanDown {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnPanDown != null);

    if (validInteractions.isEmpty) return null;

    return (details, event) {
      _log("handleOnPanDown called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(event.kind)) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnPanDown!(
          details,
          event,
          notifier,
        );

        if (handled) {
          _log("handleOnPanDown handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureDragStartCallback? get onPanStart {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnPanStart != null);

    if (validInteractions.isEmpty) return null;

    return (details, event) {
      _log("handleOnPanStart called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(event.kind)) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnPanStart!(
          details,
          event,
          notifier,
        );

        if (handled) {
          _log("handleOnPanStart handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureDragUpdateCallback? get onPanUpdate {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnPanUpdate != null);

    if (validInteractions.isEmpty) return null;

    return (details, initialEvent, event) {
      _log("handleOnPanUpdate called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(
        initialEvent.kind,
      )) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnPanUpdate!(
          details,
          initialEvent,
          event,
          notifier,
        );

        if (handled) {
          _log("handleOnPanUpdate handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureDragEndCallback? get onPanEnd {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnPanEnd != null);

    if (validInteractions.isEmpty) return null;

    return (details, event) {
      _log("handleOnPanEnd called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(event.kind)) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnPanEnd!(
          details,
          event,
          notifier,
        );

        if (handled) {
          _log("handleOnPanEnd handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureDragCancelCallback? get onPanCancel {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnPanCancel != null);

    if (validInteractions.isEmpty) return null;

    return (initialEvent, event) {
      _log("handleOnPanCancel called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(
        initialEvent.kind,
      )) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnPanCancel!(
          initialEvent,
          event,
          notifier,
        );

        if (handled) {
          _log("handleOnPanCancel handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureScaleStartCallback? get onScaleStart {
    final validInteractions = graphiliaBoardInteractions.where((handler) => handler.handleOnScaleStart != null);

    if (validInteractions.isEmpty) return null;

    return (details, initialEvent, event) {
      _log("handleOnScaleStart called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(
        initialEvent.kind,
      )) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnScaleStart!(
          details,
          initialEvent,
          event,
          notifier,
        );

        if (handled) {
          _log("handleOnScaleStart handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureScaleUpdateCallback? get onScaleUpdate {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnScaleUpdate != null);

    if (validInteractions.isEmpty) return null;

    return (details, initialEvent, event) {
      // _log("handleOnScaleUpdate called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(
        initialEvent.kind,
      )) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnScaleUpdate!(
          details,
          initialEvent,
          event,
          notifier,
        );

        if (handled) {
          // _log("handleOnScaleUpdate handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureScaleEndCallback? get onScaleEnd {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnScaleEnd != null);

    if (validInteractions.isEmpty) return null;

    return (details, initialEvent, event) {
      _log("handleOnScaleEnd called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(
        initialEvent.kind,
      )) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnScaleEnd!(
          details,
          initialEvent,
          event,
          notifier,
        );

        if (handled) {
          _log("handleOnScaleEnd handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureForcePressStartCallback? get onForcePressStart {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnForcePressStart != null);

    if (validInteractions.isEmpty) return null;

    return (details, event) {
      _log("handleOnForcePressStart called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(event.kind)) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnForcePressStart!(
          details,
          event,
          notifier,
        );

        if (handled) {
          _log("handleOnForcePressStart handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureForcePressPeakCallback? get onForcePressPeak {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnForcePressPeak != null);

    if (validInteractions.isEmpty) return null;

    return (details, event) {
      _log("handleOnForcePressPeak called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(event.kind)) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnForcePressPeak!(
          details,
          event,
          notifier,
        );

        if (handled) {
          _log("handleOnForcePressPeak handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureForcePressUpdateCallback? get onForcePressUpdate {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnForcePressUpdate != null);

    if (validInteractions.isEmpty) return null;

    return (details, event) {
      _log("handleOnForcePressUpdate called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(event.kind)) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnForcePressUpdate!(
          details,
          event,
          notifier,
        );

        if (handled) {
          _log(
              "handleOnForcePressUpdate handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }

  @override
  DetailedGestureForcePressEndCallback? get onForcePressEnd {
    final validInteractions = graphiliaBoardInteractions
        .where((handler) => handler.handleOnForcePressEnd != null);

    if (validInteractions.isEmpty) return null;

    return (details, event) {
      _log("handleOnForcePressEnd called");
      // If the pointer device kind is not supported, ignore the event
      if (!notifier.config.isPointerDeviceKindSupported(event.kind)) return;

      for (final interaction in validInteractions) {
        final handled = interaction.handleOnForcePressEnd!(
          details,
          event,
          notifier,
        );

        if (handled) {
          _log("handleOnForcePressEnd handled by ${interaction.runtimeType}");
          break;
        }
      }
    };
  }
}

extension _InteractionDataHelper<T> on BoardState<T, BoardStateConfig> {
  BoardState<T, BoardStateConfig> trackPointerPosition(
    PointerEvent event,
    BoardStateConfig config,
  ) {
    final point = relativeToOriginFromState(
      event.getPoint(config.pointPressureCurve),
      this,
    );

    return copyWith(
      pointerPosition: point,
    );
  }

  BoardState<T, BoardStateConfig> initializeInteractionData(
    PointerEvent event,
    BoardStateConfig config,
  ) {
    final point = relativeToOriginFromState(
      event.getPoint(config.pointPressureCurve),
      this,
    );

    return copyWith(
      pointerPosition: point,
      activePointerIds: [
        ...activePointerIds,
        event.pointer,
      ],
      strokePoints: [
        point,
      ],
    );
  }

  BoardState<T, BoardStateConfig> updateInteractionData(
    PointerEvent event,
    BoardStateConfig config,
  ) {
    final point = relativeToOriginFromState(
      event.getPoint(config.pointPressureCurve),
      this,
    );

    return copyWith(
      pointerPosition: point,
      strokePoints: [
        ...strokePoints,
        point,
      ],
    );
  }

  BoardState<T, BoardStateConfig> removeInteractionData(
    PointerEvent event,
    BoardStateConfig config, {
    bool keepPointerPosition = false,
  }) {
    late final Point? pointerPosition;

    if (keepPointerPosition) {
      pointerPosition = relativeToOriginFromState(
        event.getPoint(config.pointPressureCurve),
        this,
      );
    } else {
      pointerPosition = null;
    }

    return copyWith(
      pointerPosition: pointerPosition,
      activePointerIds: [...activePointerIds]..remove(event.pointer),
      strokePoints: [],
    );
  }

  BoardState<T, BoardStateConfig> maybeUpdateScaleFactorAndOrigin(
    PointerSignalEvent event,
    BoardStateConfig config,
  ) {
    if (event is PointerScrollEvent) {
      var newOriginOffset = originOffset;
      var newScaleFactor = scaleFactor;

      // If control is pressed, zoom in/out
      if (HardwareKeyboard.instance.isControlPressed) {
        final point = Point.fromOffset(event.localPosition);
        final scale = 1.0 + (-event.scrollDelta.dy / 500);

        final result = calculateOriginOffsetAndScaleFactorFromScale(
          scale,
          point: point,
          originOffset: originOffset,
          scaleFactor: scaleFactor,
        );

        newOriginOffset = result.originOffset;
        newScaleFactor = result.scaleFactor;
      }
      // If shift is pressed, scroll horizontally
      else if (HardwareKeyboard.instance.isShiftPressed) {
        final x = -event.scrollDelta.dy;
        final delta = Offset(x, 0);
        newOriginOffset = calculateOriginOffsetFromDelta(
          delta,
          originOffset: originOffset,
          scaleFactor: scaleFactor,
        );
      }
      // If no valid modifier is pressed, scroll vertically
      else {
        final y = -event.scrollDelta.dy;
        final delta = Offset(0, y);
        newOriginOffset = calculateOriginOffsetFromDelta(
          delta,
          originOffset: originOffset,
          scaleFactor: scaleFactor,
        );
      }

      return copyWith(
        originOffset: newOriginOffset,
        scaleFactor: newScaleFactor,
      );
    }

    return this;
  }
}
