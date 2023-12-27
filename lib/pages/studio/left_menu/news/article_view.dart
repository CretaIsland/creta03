import 'package:flutter/material.dart';

import '../../../../design_system/component/snippet.dart';
import 'article_model.dart';
import 'news_api.dart';
import 'news_tile.dart';

class ArticleView extends StatefulWidget {
  final String selectedCategory;
  const ArticleView({super.key, required this.selectedCategory});

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  late Future<List<Article>> _newsList;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _newsList = getNews(widget.selectedCategory);
    _scrollController = ScrollController();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _startAutoScroll() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 120),
      curve: Curves.linear,
    );
  }

  Future<List<Article>> getNews(String category) async {
    NewsForCategories news = NewsForCategories();
    await news.getNewsForCategory(category);
    return news.news;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _newsList,
      builder: (context, AsyncSnapshot<List<Article>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: 350.0,
            child: Center(
              child: Snippet.showWaitSign(),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error loading data: ${snapshot.error}'),
          );
        } else {
          List<Article> newslist = snapshot.data!;
          return newsArticle(newslist);
        }
      },
    );
  }

  // News Article
  Widget newsArticle(List<Article> newslist) {
    return SingleChildScrollView(
      child: Container(
        height: 480.0,
        padding: const EdgeInsets.only(top: 16),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: newslist.length,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            return NewsTile(
              imgUrl: newslist[index].urlToImage ?? "",
              title: newslist[index].title ?? "",
              desc: newslist[index].description ?? "",
              content: newslist[index].content ?? "",
              posturl: newslist[index].articleUrl ?? "",
            );
          },
        ),
      ),
    );
  }
}
