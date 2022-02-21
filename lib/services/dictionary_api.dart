import 'dart:convert';

import 'package:word_mail/constraints.dart';

import '../models/word.dart';
import 'package:http/http.dart' as http;

class DictionaryApi {
  Future<Word?> getMeaning(String word) async {
    var url = Uri.parse(dictApi + word);
    final res = await http.get(url);

    if (res.statusCode != 200) return null;
    Word result = Word.fromMap(jsonDecode(res.body)[0]);
    return result;
  }
}
