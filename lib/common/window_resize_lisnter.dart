import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:mutex/mutex.dart';

class WindowResizeListner with WidgetsBindingObserver {
  DateTime? _lastResizingTime;
  final _lock = Mutex();
  Timer? _timer;
  bool _isResizing = false;
  Function? onReizeStart;
  final Function onReizeComplete;
  int resizeDuration;

  WindowResizeListner(
      {required this.onReizeComplete, this.onReizeStart, this.resizeDuration = 100});

  bool isResizing() {
    bool retval = false;
    _lock.acquire();
    retval = _isResizing;
    _lock.release();
    return retval;
  }

  void setResizing(bool resize) {
    _lock.acquire();
    _isResizing = resize;
    _lock.release();
  }

  @override
  void didChangeMetrics() {
    if (_timer == null && onReizeStart != null) {
      logger.finest('onReizeStart');
      onReizeStart!.call();
    }
    setResizing(true);
    _lastResizingTime = DateTime.now();
    _timer ??= Timer.periodic(const Duration(milliseconds: 50), _timerFunction);
    super.didChangeMetrics();
  }

  void _timerFunction(Timer timer) {
    var now = DateTime.now();
    if (_lastResizingTime != null &&
        now.millisecondsSinceEpoch - _lastResizingTime!.millisecondsSinceEpoch < resizeDuration) {
      logger.finest('Resizing now');
      _lock.acquire();
      _isResizing = true;
      _lock.release();
    } else {
      _lock.acquire();
      if (_isResizing == true) {
        _isResizing = false;
        logger.finest('onReizeComplete');
        onReizeComplete.call();
        deleteTimer();
      }
      _lock.release();
    }
  }

  void deleteTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
      logger.finest('delete timer');
    }
  }
}
