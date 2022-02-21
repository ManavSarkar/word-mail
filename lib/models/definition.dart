class Definition {
  String? definition;
  String? example;
  List<String>? synonyms;
  List<String>? antonyms;

  Definition({this.definition, this.example, this.synonyms, this.antonyms});
  Definition.fromMap(Map<String, dynamic> json)
      : this(
          definition: json["definition"],
          example: json["example"],
          synonyms: getSynsAnts(json["synonyms"] ?? []),
          antonyms: getSynsAnts(json["antonyms"] ?? []),
        );
}

List<String> getSynsAnts(List<dynamic> data) {
  return List.generate(data.length, (index) => data[index]);
}
