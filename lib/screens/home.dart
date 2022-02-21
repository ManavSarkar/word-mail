import 'package:flutter/material.dart';
import 'package:word_mail/models/definition.dart';
import 'package:word_mail/models/meaning.dart';
import 'package:word_mail/models/word.dart';
import 'package:word_mail/services/dictionary_api.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = false;
  TextEditingController searchController = TextEditingController();
  Word? word;

  TextStyle definitionTextStyle = const TextStyle(
    fontSize: 24.0,
  );
  getMeaning() async {
    if (searchController.text.isEmpty) {
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          content: const Text("Please Enter a word!"),
          actions: [
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).clearMaterialBanners();
              },
              child: const Text("Close"),
            )
          ],
        ),
      );
      return;
    }
    setState(() {
      loading = true;
    });
    var word = await DictionaryApi().getMeaning(searchController.text);
    if (word != null) {
      setState(() {
        this.word = word;
      });
    } else {
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          backgroundColor: Colors.redAccent,
          contentTextStyle: const TextStyle(color: Colors.white),
          content: const Text(
              """The entered word is not available in the dictionary. Kindly Check the word entered."""),
          actions: [
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).clearMaterialBanners();
              },
              child: const Text(
                "Close",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      );
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Word Mail"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    15.0,
                  ),
                ),
              ),
              onSubmitted: (str) {
                getMeaning();
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              getMeaning();
            },
            child: const Text("Search"),
          ),
          Expanded(
            child: Visibility(
              visible: !loading,
              replacement: const Center(child: CircularProgressIndicator()),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: wordWidget(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget wordWidget() {
    return word == null
        ? Container()
        : ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: Text(
                  capsTheFirst(word!.word ?? "Error"),
                  style: const TextStyle(
                    fontSize: 32.0,
                  ),
                ),
              ),
              for (var meaning in word!.meanings ?? []) meaningWidget(meaning)
            ],
          );
  }

  Widget meaningWidget(Meaning meaning) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      padding: const EdgeInsets.all(5.0),
      color: Colors.blueGrey.shade200,
      child: Column(
        children: [
          ListTile(
            title: Text(
              "Meaning",
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          ListTile(
            leading: Text(
              "Part of Speech:",
              style: Theme.of(context).textTheme.bodyText1,
            ),
            title: Text(
              capsTheFirst(meaning.partsOfSpeech ?? ""),
              style: Theme.of(context).textTheme.bodyText1,
            ),
            onTap: () {
              copyToClipboard(capsTheFirst(meaning.partsOfSpeech ?? ""));
            },
          ),
          for (var definition in meaning.definitions ?? [])
            definitionWidget(definition)
        ],
      ),
    );
  }

  Widget definitionWidget(Definition definition) {
    String synonyms = "";
    for (var syn in definition.synonyms ?? []) {
      synonyms += capsTheFirst(syn) + " ,";
    }
    String antonyms = "";
    for (var ant in definition.antonyms ?? []) {
      antonyms += capsTheFirst(ant) + " ,";
    }
    if (synonyms.isNotEmpty) {
      synonyms = synonyms.substring(0, synonyms.length - 1);
    }
    if (antonyms.isNotEmpty) {
      antonyms = antonyms.substring(0, antonyms.length - 1);
    }
    return Container(
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade300,
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              "Definition",
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          ListTile(
            leading: Text(
              "Definition: ",
              style: Theme.of(context).textTheme.bodyText1,
            ),
            title: Text(
              capsTheFirst(definition.definition ?? ""),
              style: Theme.of(context).textTheme.bodyText1,
            ),
            onTap: () {
              copyToClipboard(capsTheFirst(definition.definition ?? ""));
            },
          ),
          ListTile(
            leading: Text(
              "Example: ",
              style: Theme.of(context).textTheme.bodyText1,
            ),
            title: Text(
              capsTheFirst(definition.example ?? ""),
              style: Theme.of(context).textTheme.bodyText1,
            ),
            onTap: () {
              copyToClipboard(capsTheFirst(definition.example ?? ""));
            },
          ),
          ListTile(
            leading: Text(
              "Synonyms: ",
              style: Theme.of(context).textTheme.bodyText1,
            ),
            title: Text(
              synonyms,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            onTap: () {
              copyToClipboard(synonyms);
            },
          ),
          ListTile(
            leading: Text(
              "Antonyms: ",
              style: Theme.of(context).textTheme.bodyText1,
            ),
            title: Text(
              antonyms,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            onTap: () {
              copyToClipboard(antonyms);
            },
          ),
        ],
      ),
    );
  }

  copyToClipboard(String text) async {
    ClipboardData data = ClipboardData(text: text);
    await Clipboard.setData(data);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Copied to clipboard."),
      ),
    );
  }

  capsTheFirst(String text) {
    if (text.isEmpty) return "";
    return text.substring(0, 1).toUpperCase() + text.substring(1);
  }
}
