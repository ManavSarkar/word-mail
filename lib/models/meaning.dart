import 'package:word_mail/models/definition.dart';

class Meaning {
  String? partsOfSpeech;
  List<Definition>? definitions;
  Meaning({this.partsOfSpeech, this.definitions});
  Meaning.fromMap(Map<String, dynamic> json)
      : this(
          partsOfSpeech: json["partOfSpeech"],
          definitions: getDefinitions(json["definitions"]),
        );
}

List<Definition> getDefinitions(List<dynamic> definitions) {
  return List.generate(
      definitions.length, (index) => Definition.fromMap(definitions[index]));
}
