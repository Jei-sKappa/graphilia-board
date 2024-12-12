import 'dart:async';

import 'package:flutter/foundation.dart';

class ValueListenableDebouncer<T> extends ValueNotifier<T> {
  ValueListenableDebouncer(
    this.listenable, {
    required this.debounceDuration,
  }) : super(listenable.value) {
    startPeriodicTimer();
    listenable.addListener(onListenableUpdate);
  }

  final ValueListenable<T> listenable;
  final Duration debounceDuration;

  bool hasPendingUpdate = false;

  void startPeriodicTimer() {
    Timer.periodic(debounceDuration, (_) {
      if (hasPendingUpdate) {
        hasPendingUpdate = false;
        super.value = listenable.value;
      }
    });
  }

  void onListenableUpdate() {
    hasPendingUpdate = true;
  }

  @override
  void dispose() {
    listenable.removeListener(onListenableUpdate);
    super.dispose();
  }
}
