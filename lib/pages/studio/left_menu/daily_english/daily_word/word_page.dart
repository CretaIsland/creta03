import 'dart:convert';
import 'package:creta_common/common/creta_snippet.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:creta_studio_model/model/frame_model.dart';
import '../../../../login/creta_account_manager.dart';
import 'models/word.dart';

var now = DateTime.now();
var formatter = DateFormat('yyyy-MM-dd');
String today = formatter.format(now);
String apiKey = CretaAccountManager.getEnterprise!.dailyWordApi;
final String url = 'https://api.wordnik.com/v4/words.json/wordOfTheDay?date=$today&api_key=$apiKey';

Future<Word> fetchWord() async {
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return Word.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load word.');
  }
}

class WordPage extends StatefulWidget {
  final double? width;
  final double? height;
  final FrameModel? frameModel;
  const WordPage({
    super.key,
    this.width,
    this.height,
    this.frameModel,
  });

  @override
  State<WordPage> createState() => _WordPageState();
}

class _WordPageState extends State<WordPage> {
  late Future<Word> futureWord;

  @override
  void initState() {
    super.initState();
    futureWord = fetchWord();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: widget.height,
        child: Card(
          margin: const EdgeInsets.all(8.0),
          elevation: 4.0,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: FutureBuilder<Word>(
              future: futureWord,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${snapshot.data!.word[0].toUpperCase()}${snapshot.data?.word.substring(1)}',
                        style: TextStyle(
                          fontSize: 32.0,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          color: CretaColor.text[700],
                        ),
                      ),
                      Text(
                        snapshot.data!.definitions[0].partOfSpeech,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          color: CretaColor.text[400],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Expanded(
                        child: Text(
                          snapshot.data!.definitions[0].text,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 18,
                            color: CretaColor.text[600],
                            fontWeight: FontWeight.w300,
                          ),
                          maxLines: 8,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  logger.severe('Error: ${snapshot.error}');
                  return const Text('Unable to fetch word of the day T.T ');
                }
                return Center(child: CretaSnippet.showWaitSign());
              },
            ),
          ),
        ),
      ),
    );
  }
}
