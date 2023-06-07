import 'package:creta03/pages/studio/left_menu/image/apikey.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:hycop/common/util/logger.dart';

class Api {
  static final url = Uri.parse("$baseUrl/v1/images/generations");
  static final apikeys = apiOpenAIKey;

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
        logger.info('------ URLs are ready!!! ------');
      } else {
        logger.info('------ Cannot find Image URL ------');
      }
    } else {
      logger.warning("Fail to fetch image: ${res.statusCode}");
    }
    return resultUrl;
  }
}
