import 'dart:convert';
import 'package:creta03/pages/studio/left_menu/news/article_model.dart';
import 'package:http/http.dart' as http;
import '../../../login/creta_account_manager.dart';

String apiKey = CretaAccountManager.getEnterprise!.newsApiKey;

class NewsForCategories {
  List<Article> news = [];
  Future<void> getNewsForCategory(String category) async {
    String baseUrl = "http://newsapi.org/v2/top-headlines?country=kr&category=$category";
    var response = await http.get(Uri.parse('$baseUrl&apiKey=$apiKey'));
    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == "ok") {
      jsonData["articles"].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          Article article = Article(
            title: element['title'],
            author: element['author'],
            description: element['description'],
            urlToImage: element['urlToImage'],
            publishedAt: DateTime.parse(element['publishedAt']),
            content: element["content"],
            articleUrl: element["url"],
          );
          news.add(article);
        }
      });
    }
  }
}
