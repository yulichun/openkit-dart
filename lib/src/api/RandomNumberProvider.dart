/// Interface for random number generation
abstract class RandomNumberProvider {
  /// Generate next positive integer
  int nextPositiveInteger();
  
  /// Generate next random number between 0.0 and 1.0
  double nextRandom();
  
  /// Generate next random integer in range [min, max]
  int nextInt(int min, int max);
}
