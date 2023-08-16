import 'dart:async';
import 'dart:developer';

import 'package:rxdart/rxdart.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'accelerometer_variation.dart';
import 'variation_calculator.dart';

class SensorMonitor {
  final double _variationTreshold = 2.0;
  final int _bufferSize = 10;
  final VariationCalculator _variationCalculator = VariationCalculator();
  final List<AccelerometerEvent> _buffer = [];

  final List<Function()> listeners = [];

  StreamSubscription<AccelerometerEvent>? _subscription;

  void _processNewPoint(AccelerometerEvent point) {
    log("New point: $point");
    if (_buffer.length < _bufferSize) {
      _addToBuffer(point);
      final variation = _calculateVariation();
      final shouldActivateSignal = _checkVariation(variation);
      if (shouldActivateSignal) {
        log("Activate signal");
        log("Variation: $variation");
        _callListeners();
        _clearBuffer();
        stopMinitoring();
      }
    } else {
      _clearBuffer();
    }
  }

  void _callListeners() {
    for (final listener in listeners) {
      listener();
    }
  }

  AccelerometerVariation _calculateVariation() {
    return _variationCalculator.calculateAccelerometerVariation(_buffer);
  }

  bool _checkVariation(AccelerometerVariation variation) {
    return variation.x > _variationTreshold ||
        variation.y > _variationTreshold ||
        variation.z > _variationTreshold;
  }

  void _addToBuffer(AccelerometerEvent point) {
    _buffer.add(point);
  }

  void _clearBuffer() {
    log("Clear buffer");
    _buffer.clear();
  }

  void startMonitoring() {
    _subscription ??= accelerometerEvents
        .interval(const Duration(milliseconds: 10))
        .listen(_processNewPoint);
  }

  void addListener(Function() listener) {
    listeners.add(listener);
  }

  void removeListener(Function() listener) {
    listeners.remove(listener);
  }

  void stopMinitoring() {
    _subscription?.cancel();
    _subscription = null;
  }
}
