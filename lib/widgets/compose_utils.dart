import 'dart:async';

import 'package:flutter/foundation.dart';

/// Debounced click callback. Ported from Z-Editor-master ComposeUtils.kt
/// Returns a callback that ignores rapid repeated calls within [waitMs].
VoidCallback debouncedClick({int waitMs = 500, required VoidCallback onClick}) {
  var lastClickTime = 0;
  return () {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - lastClickTime > waitMs) {
      lastClickTime = now;
      onClick();
    }
  };
}

/// Creates a debouncer that delays execution until [duration] has passed
/// without further calls.
class Debouncer {
  Debouncer({this.duration = const Duration(milliseconds: 500)});

  final Duration duration;
  Timer? _timer;

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
  }
}
