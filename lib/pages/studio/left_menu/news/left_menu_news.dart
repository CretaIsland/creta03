import 'package:flutter/material.dart';
import 'package:creta03/design_system/component/snippet.dart';
import '../../../../design_system/buttons/creta_tab_button.dart';
import '../../../../design_system/creta_color.dart';
import '../../../../lang/creta_studio_lang.dart';
import 'get_categories.dart';
import 'news_tile.dart';
import 'article_model.dart';
import 'news_api.dart';

class LeftMenuNews extends StatefulWidget {
  const LeftMenuNews({Key? key}) : super(key: key);

  @override
  State<LeftMenuNews> createState() => _LeftMenuNewsState();
}

class _LeftMenuNewsState extends State<LeftMenuNews> {
  late Future<List<CategoryModel>> _categoriesFuture;
  late Future<List<Article>> _newsFuture;

  final double verticalPadding = 16;
  String selectedCategory = CretaStudioLang.newsCategories.values.first;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = fetchCategories();
    _newsFuture = getNews(selectedCategory);
  }

  Future<List<CategoryModel>> fetchCategories() async {
    List<CategoryModel> categoryModels = getCategories();
    return categoryModels;
  }

  Future<List<Article>> getNews(String category) async {
    NewsForCategories news = NewsForCategories();
    await news.getNewsForCategory(category);
    return news.news;
  }

  static String _selectedType = CretaStudioLang.newsCategories.values.first;

  String _getCurrentTypes() {
    int index = 0;
    String currentSelectedType = _selectedType;
    List<String> types = CretaStudioLang.newsCategories.values.toList();
    for (String ele in types) {
      if (currentSelectedType == ele) {
        return types[index];
      }
      index++;
    }
    return CretaStudioLang.newsCategories.values.toString()[0];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([_categoriesFuture, _newsFuture]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Snippet.showWaitSign(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error loading data: ${snapshot.error}'),
          );
        } else {
          // List<CategoryModel> categories = snapshot.data![0] as List<CategoryModel>;
          List<Article> newslist = snapshot.data![1] as List<Article>;
          return Column(
            children: [
              newsCategories(),
              newsArticle(newslist),
            ],
          );
        }
      },
    );
  }

  // Categories
  // Widget newsCategories(List<CategoryModel> categories) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 20),
  //     height: 70,
  //     child: ListView.builder(
  //       itemCount: categories.length,
  //       scrollDirection: Axis.horizontal,
  //       itemBuilder: (context, index) {
  //         return CategoryCard(
  //           categoryName: categories[index].categoryName!,
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget newsCategories() {
    return Padding(
      padding: EdgeInsets.only(
        top: verticalPadding,
        bottom: verticalPadding,
        right: 2.0,
      ),
      child: CretaTabButton(
        defaultString: _getCurrentTypes(),
        onEditComplete: (value) {
          int idx = 0;
          for (String val in CretaStudioLang.newsCategories.values) {
            if (value == val) {
              setState(() {
                _selectedType = CretaStudioLang.newsCategories.values.toList()[idx];
                _newsFuture = getNews(value);
              });
            }
            idx++;
          }
        },
        autoWidth: true,
        height: 32,
        selectedTextColor: Colors.white,
        unSelectedTextColor: CretaColor.primary,
        selectedColor: CretaColor.primary,
        unSelectedColor: Colors.white,
        unSelectedBorderColor: CretaColor.primary,
        buttonLables: CretaStudioLang.newsCategories.keys.toList(),
        buttonValues: CretaStudioLang.newsCategories.values.toList(),
      ),
    );
  }

  // News Article
  Widget newsArticle(List<Article> newslist) {
    return SingleChildScrollView(
      child: Container(
        height: 480.0,
        padding: const EdgeInsets.only(top: 16),
        child: ListView.builder(
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

class CategoryCard extends StatelessWidget {
  final String? categoryName;

  const CategoryCard({super.key, this.categoryName});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        alignment: Alignment.center,
        height: 80,
        width: 80,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.black26),
        child: Text(
          categoryName!,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
