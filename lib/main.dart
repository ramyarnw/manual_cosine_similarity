import 'dart:math';
import 'package:flutter/material.dart';
import 'package:manual_cosine_similarity/text_entry.dart';

import 'cosine_similarity.dart';
import 'embedding.dart';
import 'objectbox.g.dart';

late Store store;
late Box<TextEntry> textBox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  store = await openStore();
  textBox = store.box<TextEntry>();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: Text("Manual Cosine Similarity")),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(labelText: "Enter text"),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      final text = controller.text;
                      final embedding = getFakeEmbedding(text);
                      print('Embedding text -> $embedding');
                      textBox.put(TextEntry(content: text, embedding: embedding));
                    },
                    child: Text("Save Entry"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final query = controller.text;
                      final queryVec = getFakeEmbedding(query);
                      final allEntries = textBox.getAll();

                      final results =
                          allEntries
                              .map(
                                (entry) => MapEntry(
                                  entry,
                                  cosineSimilarity(entry.embedding, queryVec),
                                ),
                              )
                              .toList()
                            ..sort((a, b) => b.value.compareTo(a.value));

                      showDialog(
                        context: context,
                        builder:
                            (_) => AlertDialog(
                              title: Text("Top Matches"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children:
                                    results
                                        .take(5)
                                        .map(
                                          (e) => Text(
                                            "${e.key.content} (sim=${e.value.toStringAsFixed(2)})",
                                          ),
                                        )
                                        .toList(),
                              ),
                            ),
                      );
                    },
                    child: Text("Find Similar"),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}




