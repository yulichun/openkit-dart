import 'dart:math';
import '../../api/RandomNumberProvider.dart';

/// Default random number provider implementation
class DefaultRandomNumberProvider implements RandomNumberProvider {
  final Random _random = Random();

  @override
  int nextPositiveInteger() {
    return _random.nextInt(0x7FFFFFFF);
  }

  @override
  double nextRandom() {
    return _random.nextDouble();
  }

  @override
  int nextInt(int min, int max) {
    return min + _random.nextInt(max - min + 1);
  }
}
