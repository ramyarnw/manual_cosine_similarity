import 'package:objectbox/objectbox.dart';

@Entity()
class TextEntry {
  int id = 0;
  String content;
  List<double> embedding;

  TextEntry({required this.content, required this.embedding});
}

