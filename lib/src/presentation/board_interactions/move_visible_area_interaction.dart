import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/physics.dart';
import 'package:graphilia_board/src/core/helpers/helpers.dart';
import 'package:graphilia_board/src/models/models.dart';
import 'package:graphilia_board/src/presentation/notifier/notifier.dart';
import 'package:graphilia_board/src/presentation/board_interactions/board_interactions.dart';
import 'package:graphilia_board/src/presentation/state/state.dart';

class _MoveVisibleAreaInteractionState {
  _MoveVisibleAreaInteractionState() {
    initialize();
  }

  late Offset? initialInteractionPoint;
  late Offset? initialOriginOffset;
  late double? initialScaleFactor;
  late bool hasScaled;
  late Animation<Offset>? panAnimation;
  late void Function(Offset)? moveVisibleArea;

  void initialize() {
    initialInteractionPoint = null;
    initialOriginOffset = null;
    initialScaleFactor = null;
    hasScaled = false;
    panAnimation = null;
    moveVisibleArea = null;
  }
}

class MoveVisibleAreaInteraction extends BoardInteraction {
  MoveVisibleAreaInteraction({
    this.enabledDevices = BoardPointersHelper.all,
    required TickerProvider tickerProvider,
    this.frictionCoefficient = 0.0135,
    this.frictionCurve = Curves.easeOutCubic,
  })  : _interactionState = _MoveVisibleAreaInteractionState(),
        _panAnimationController = AnimationController(vsync: tickerProvider);

  final _MoveVisibleAreaInteractionState _interactionState;

  final Set<PointerDeviceKind> enabledDevices;

  final AnimationController _panAnimationController;

  final double frictionCoefficient;

  final Curve frictionCurve;

  bool _isDeviceEnabled(PointerDeviceKind deviceKind) => enabledDevices.contains(deviceKind);

  void initializeAll() {
    _interactionState.panAnimation?.removeListener(_onAnimate);
    _interactionState.initialize();
  }

  @override
  DetailedGestureScaleStartCallbackHandler get handleOnScaleStart => (
        ScaleStartDetails details,
        PointerEvent initialEvent,
        PointerEvent event,
        BoardNotifier notifier,
      ) {
        if (!_isDeviceEnabled(event.kind)) return false;

        if (_panAnimationController.isAnimating) {
          _panAnimationController.stop();
          _panAnimationController.reset();
        }

        // Initialize the interaction state
        initializeAll();

        final state = notifier.value;

        _interactionState.initialInteractionPoint = details.localFocalPoint;
        _interactionState.initialOriginOffset = state.originOffset;
        _interactionState.initialScaleFactor = state.scaleFactor;

        return true;
      };

  @override
  DetailedGestureScaleUpdateCallbackHandler get handleOnScaleUpdate => (
        ScaleUpdateDetails details,
        PointerEvent initialEvent,
        PointerEvent event,
        BoardNotifier notifier,
      ) {
        if (!_isDeviceEnabled(event.kind)) {
          initializeAll();

          return false;
        }

        final state = notifier.value;

        final updatedState = _updateVisibleArea(details, state);

        notifier.setBoardState(
          state: updatedState,
          shouldAddToHistory: false,
        );

        return true;
      };

  @override
  DetailedGestureScaleEndCallbackHandler get handleOnScaleEnd => (
        ScaleEndDetails details,
        PointerEvent initialEvent,
        PointerEvent event,
        BoardNotifier notifier,
      ) {
        _interactionState.panAnimation?.removeListener(_onAnimate);
        _panAnimationController.reset();

        if (!_isDeviceEnabled(event.kind)) return false;

        final hasScaled = _interactionState.hasScaled;

        // Do not animate when the user has scaled the interface
        if (hasScaled) return true;

        final pixelsPerSecond = Offset(
          -details.velocity.pixelsPerSecond.dx / notifier.value.scaleFactor,
          -details.velocity.pixelsPerSecond.dy / notifier.value.scaleFactor,
        );

        if (pixelsPerSecond.distance == 0) return true;

        final FrictionSimulation frictionSimulationX = FrictionSimulation(
          frictionCoefficient,
          notifier.value.originOffset.dx,
          pixelsPerSecond.dx,
        );
        final FrictionSimulation frictionSimulationY = FrictionSimulation(
          frictionCoefficient,
          notifier.value.originOffset.dy,
          pixelsPerSecond.dy,
        );

        final tFinal = _getFinalTime(pixelsPerSecond.distance, frictionCoefficient);
        _interactionState.panAnimation = Tween<Offset>(
          begin: notifier.value.originOffset,
          end: Offset(
            frictionSimulationX.finalX,
            frictionSimulationY.finalX,
          ),
        ).animate(
          CurvedAnimation(
            parent: _panAnimationController,
            curve: frictionCurve,
          ),
        );

        _interactionState.moveVisibleArea = (offset) {
          notifier.setBoardState(
            state: notifier.value.copyWith(
              originOffset: offset,
            ),
            shouldAddToHistory: false,
          );
        };
        _panAnimationController.duration = Duration(milliseconds: (tFinal * 1000).round());
        _interactionState.panAnimation!.addListener(_onAnimate);
        _panAnimationController.forward();

        return true;
      };

  @override
  PointerCancelEventListenerHandler get handlePointerCancelEvent => (
        PointerCancelEvent event,
        BoardNotifier notifier,
      ) {
        if (!_isDeviceEnabled(event.kind)) return false;

        initializeAll();

        return true;
      };

  BoardState _updateVisibleArea(
    ScaleUpdateDetails scaleUpdateDetails,
    BoardState state,
  ) {
    final scale = scaleUpdateDetails.scale;
    final point = Point.fromOffset(scaleUpdateDetails.localFocalPoint);

    late final Offset newOriginOffset;
    late final double newScaleFactor;
    if (scale == 1.0) {
      newOriginOffset = calculateOriginOffsetFromDelta(
        scaleUpdateDetails.focalPointDelta,
        originOffset: state.originOffset,
        scaleFactor: state.scaleFactor,
      );

      // Leave the scale factor as is.
      newScaleFactor = state.scaleFactor;
    } else {
      _interactionState.hasScaled = true;

      final result = calculateOriginOffsetAndScaleFactorFromRelativeScale(
        scale,
        point: point,
        initialInteractionPoint: _interactionState.initialInteractionPoint!,
        initialOriginOffset: _interactionState.initialOriginOffset!,
        initialScaleFactor: _interactionState.initialScaleFactor!,
      );

      newOriginOffset = result.originOffset;
      newScaleFactor = result.scaleFactor;
    }

    final updatedState = state.copyWith(
      originOffset: newOriginOffset,
      scaleFactor: newScaleFactor,
    );

    return updatedState;
  }

  // Adapted from Flutter's [InteractiveViewer]: https://github.com/flutter/flutter/blob/stable/packages/flutter/lib/src/widgets/interactive_viewer.dart#L1322
  // ---
  // Copyright 2014 The Flutter Authors. All rights reserved.
  // Use of this source code is governed by a BSD-style license that can be
  // found in the LICENSE file.
  // ---
  // Given a velocity and drag, calculate the time at which motion will come to
  // a stop, within the margin of effectivelyMotionless.
  double _getFinalTime(
    double velocity,
    double drag, {
    double effectivelyMotionless = 10,
  }) {
    return log(effectivelyMotionless / velocity) / log(drag / 100);
  }

  void _onAnimate() {
    if (!_panAnimationController.isAnimating) {
      _interactionState.panAnimation?.removeListener(_onAnimate);
      _interactionState.panAnimation = null;
      _panAnimationController.reset();
      return;
    }

    final stepOffset = _interactionState.panAnimation!.value;

    _interactionState.moveVisibleArea!.call(stepOffset);
  }
}
