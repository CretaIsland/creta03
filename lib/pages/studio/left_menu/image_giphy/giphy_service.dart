import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../login/creta_account_manager.dart';

class GiphyService {
  static String apiKey = CretaAccountManager.getEnterprise!.giphyApiKey;
  static const String baseUrl = 'https://api.giphy.com/v1/gifs/search';

  static Future<List<dynamic>> searchGifs(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl?api_key=$apiKey&q=$query'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> gifs = data['data'];
      return gifs.map((gif) {
        return gif['images']['original']['url'];
      }).toList();
    } else {
      throw Exception('Failed to load GIFs');
    }
  }
}
