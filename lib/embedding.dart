import 'dart:math';

List<double> getFakeEmbedding(String text) {
  final hash = text.hashCode;
  final rand = Random(hash);
  return List.generate(128, (_) => rand.nextDouble());
}