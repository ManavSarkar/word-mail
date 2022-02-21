import 'package:word_mail/models/meaning.dart';

class Word {
  String? word;
  List<Meaning>? meanings;
  Word({this.word, this.meanings});
  Word.fromMap(Map<String, dynamic> json)
      : this(
          word: json["word"],
          meanings: getMeanings(json["meanings"]),
        );
}

List<Meaning> getMeanings(List<dynamic> data) {
  return List.generate(data.length, (index) => Meaning.fromMap(data[index]));
}
