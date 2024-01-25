import 'definition.dart';

class Word {
  final String word;
  final List<Definition> definitions;

  Word({required this.word, required this.definitions});

  factory Word.fromJson(Map<String, dynamic> json) {
    var list = json['definitions'] as List;
    List<Definition> definitionsList = list.map((i) => Definition.fromJson(i)).toList();

    return Word(
      word: json['word'],
      definitions: definitionsList,
    );
  }
}
