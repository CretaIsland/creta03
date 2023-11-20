import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:hycop/common/util/logger.dart';
import '../../../login/creta_account_manager.dart';

class Api {
  static final url = Uri.parse("https://api.openai.com/v1/images/generations");
  static final apikeys = CretaAccountManager.getEnterprise!.openAiKey;

  static final headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer $apikeys",
  };

  static Future<List<String>> generateImageAI(String text, int numImg) async {
    List<String> resultUrl = [];

    var res = await http.post(url,
        headers: headers,
        body: jsonEncode({
          "prompt": text,
          "n": numImg,
          "size": "512x512",
        }));

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body.toString());
      // check if the data value is null
      if (data['data'] != null) {
        for (var imageData in data['data']) {
          if (imageData['url'] != null) {
            resultUrl.add(imageData['url'].toString());
            // ignore: avoid_print
            // print(imageData);
          }
        }
        logger.fine('------ AI image URLs are ready!!! ------');
      } else {
        logger.fine('------ Cannot find Image URL ------');
      }
    } else {
      logger.warning("Fail to fetch image: ${res.statusCode}");
    }
    return resultUrl;
  }
}
