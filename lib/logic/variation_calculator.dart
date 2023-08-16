import 'package:sensors_plus/sensors_plus.dart';

import 'accelerometer_variation.dart';

class VariationCalculator {
  AccelerometerVariation calculateAccelerometerVariation(
      List<AccelerometerEvent> events) {
    final x = _calculateVariation(events.map((e) => e.x).toList());
    final y = _calculateVariation(events.map((e) => e.y).toList());
    final z = _calculateVariation(events.map((e) => e.z).toList());

    return AccelerometerVariation(x, y, z);
  }

  double _calculateVariation(List<double> values) {
    final sum = values.reduce((value, element) => value + element);
    final average = sum / values.length;

    final sumOfSquares = values
        .map((value) => (value - average) * (value - average))
        .reduce((value, element) => value + element);

    return sumOfSquares / values.length;
  }
}
