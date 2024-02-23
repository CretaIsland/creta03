import 'package:creta03/pages/studio/studio_constant.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:flutter/material.dart';
import 'package:creta_common/common/creta_snippet.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import 'article_model.dart';
import 'news_api.dart';
import 'news_tile.dart';

class ArticleView extends StatefulWidget {
  final String selectedCategory;
  final double? width;
  final double? height;
  final FrameModel frameModel;
  const ArticleView({
    super.key,
    required this.selectedCategory,
    required this.frameModel,
    this.width,
    this.height,
  });

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  late Future<List<Article>> _newsList;
  final ScrollController _scrollController = ScrollController();
  final double itemHeight = 336.0;
  final int verDuration = 5;
  final int horDuration = 3;

  @override
  void initState() {
    super.initState();
    _newsList = getNews(widget.selectedCategory);
    Size frameSize = Size(widget.frameModel.width.value, widget.frameModel.height.value);
    int index = 0;
    for (Size ele in StudioConst.newsFrameSize) {
      if (frameSize == ele) {
        widget.frameModel.newsSizeType = NewsSizeEnum.values[index];
      }
      index++;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  Future<void> _startAutoScroll() async {
    await Future.delayed(const Duration(milliseconds: 200));

    while (true) {
      if (_scrollController.hasClients) {
        List<Article> newsList = await _newsList;

        for (int index = 0; index < newsList.length; index++) {
          await Future.delayed(
            Duration(
                seconds: widget.frameModel.newsSizeType == NewsSizeEnum.Small
                    ? horDuration
                    : verDuration),
          );
          _scrollController.animateTo(
            index * _getItemHeight(),
            duration: const Duration(milliseconds: 200),
            curve: Curves.linear,
          );
        }
      }
      await Future.delayed(const Duration(seconds: 5));
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0.0);
      }
    }
  }

  double _getItemHeight() {
    switch (widget.frameModel.newsSizeType) {
      case NewsSizeEnum.Big:
        return itemHeight;
      case NewsSizeEnum.Medium:
        return itemHeight * 0.45;
      case NewsSizeEnum.Small:
        return itemHeight * 2.5;
      default:
        return itemHeight;
    }
  }

  Future<List<Article>> getNews(String category) async {
    NewsForCategories news = NewsForCategories();
    await news.getNewsForCategory(category);
    return news.news;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Article>>(
      initialData: const [],
      future: _newsList,
      builder: (context, AsyncSnapshot<List<Article>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: 150,
            child: Center(
              child: CretaSnippet.showWaitSign(),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error loading data: ${snapshot.error}'),
          );
        } else {
          List<Article> newslist = snapshot.data!;
          // _startAutoScroll();
          return newsArticle(newslist, widget.frameModel);
        }
      },
    );
  }

  // News Article
  Widget newsArticle(List<Article> newslist, FrameModel frameModel) {
    return Container(
      height: widget.height,
      width: widget.width,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection:
            widget.frameModel.newsSizeType == NewsSizeEnum.Small ? Axis.horizontal : Axis.vertical,
        itemCount: newslist.length,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          return SizedBox(
            width: widget.frameModel.newsSizeType == NewsSizeEnum.Small ? _getItemHeight() : null,
            height: widget.frameModel.newsSizeType != NewsSizeEnum.Small ? _getItemHeight() : null,
            child: NewsTile(
              frameModel: frameModel,
              imgUrl: newslist[index].urlToImage ?? "",
              title: newslist[index].title ?? "",
              desc: newslist[index].description ?? "",
              content: newslist[index].content ?? "",
              posturl: newslist[index].articleUrl ?? "",
            ),
          );
        },
      ),
    );
  }
}
