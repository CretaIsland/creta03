import 'package:cached_network_image/cached_network_image.dart';
import 'package:creta03/pages/studio/left_menu/left_menu_ele_button.dart';
import 'package:creta03/pages/studio/studio_variables.dart';
import 'package:flutter/material.dart';
import 'package:creta03/design_system/component/snippet.dart';
import 'package:hycop/common/undo/undo.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../lang/creta_studio_lang.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/page_model.dart';
import '../../book_main_page.dart';
import '../../studio_constant.dart';
import 'get_categories.dart';
import 'article_model.dart';
import 'news_api.dart';

class LeftMenuNews extends StatefulWidget {
  final String title;
  final TextStyle titleStyle;
  final TextStyle dataStyle;

  const LeftMenuNews({
    super.key,
    required this.title,
    required this.titleStyle,
    required this.dataStyle,
  });

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

  // static String _selectedType = CretaStudioLang.newsCategories.values.first;

  // String _getCurrentTypes() {
  //   int index = 0;
  //   String currentSelectedType = _selectedType;
  //   List<String> types = CretaStudioLang.newsCategories.values.toList();
  //   for (String ele in types) {
  //     if (currentSelectedType == ele) {
  //       return types[index];
  //     }
  //     index++;
  //   }
  //   return CretaStudioLang.newsCategories.values.toString()[0];
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 24.0),
          child: Text(widget.title, style: widget.dataStyle),
        ),
        FutureBuilder(
          future: Future.wait([_categoriesFuture, _newsFuture]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
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
              List<CategoryModel> categories = snapshot.data![0] as List<CategoryModel>;
              // List<Article> newslist = snapshot.data![1] as List<Article>;
              return Column(
                children: [
                  newsCategories(categories),
                  // newsArticle(newslist),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  // Categories
  Widget newsCategories(List<CategoryModel> categories) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: StudioVariables.workHeight - 148,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          crossAxisCount: 2,
          childAspectRatio: 2 / 1,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return LeftMenuEleButton(
            width: 160.0,
            height: 80.0,
            onPressed: () async {
              await _createNewsFrame(FrameType.news, categories[index].categoryName!);
              BookMainPage.pageManagerHolder!.notify();
            },
            child: CategoryCard(
              categoryName: categories[index].categoryName!,
              imageAssetUrl: categories[index].imageAssetUrl!,
            ),
          );
        },
      ),
    );
  }

  // Widget newsCategories() {
  //   return Padding(
  //     padding: EdgeInsets.only(
  //       top: verticalPadding,
  //       bottom: verticalPadding,
  //       right: 2.0,
  //     ),
  //     child: CretaTabButton(
  //       defaultString: _getCurrentTypes(),
  //       onEditComplete: (value) {
  //         int idx = 0;
  //         for (String val in CretaStudioLang.newsCategories.values) {
  //           if (value == val) {
  //             setState(() {
  //               _selectedType = CretaStudioLang.newsCategories.values.toList()[idx];
  //               _newsFuture = getNews(value);
  //             });
  //           }
  //           idx++;
  //         }
  //       },
  //       autoWidth: true,
  //       height: 32,
  //       selectedTextColor: Colors.white,
  //       unSelectedTextColor: CretaColor.primary,
  //       selectedColor: CretaColor.primary,
  //       unSelectedColor: Colors.white,
  //       unSelectedBorderColor: CretaColor.primary,
  //       buttonLables: CretaStudioLang.newsCategories.keys.toList(),
  //       buttonValues: CretaStudioLang.newsCategories.values.toList(),
  //     ),
  //   );
  // }

  // News Article
  // Widget newsArticle(List<Article> newslist) {
  //   return SingleChildScrollView(
  //     child: Container(
  //       height: 480.0,
  //       padding: const EdgeInsets.only(top: 16),
  //       child: ListView.builder(
  //         itemCount: newslist.length,
  //         shrinkWrap: true,
  //         physics: const ClampingScrollPhysics(),
  //         itemBuilder: (context, index) {
  //           return NewsTile(
  //             imgUrl: newslist[index].urlToImage ?? "",
  //             title: newslist[index].title ?? "",
  //             desc: newslist[index].description ?? "",
  //             content: newslist[index].content ?? "",
  //             posturl: newslist[index].articleUrl ?? "",
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }

  double x = 80;
  double y = 160;

  Future<void> _createNewsFrame(FrameType frameType, String selectedCategory) async {
    PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
    if (pageModel == null) return;

    int frameCounter = 1;

    //페이지폭의 50% 로 만든다. 세로는 가로의 1/6 이다.
    Size newsFrameSize = StudioConst.newsFrameSize[0];
    // double width = pageModel.width.value * 0.35;
    // double height = pageModel.height.value * 0.6;

    x += frameCounter * 40.0;
    y += frameCounter * 40.0;

    FrameManager? frameManager = BookMainPage.pageManagerHolder!.getSelectedFrameManager();
    if (frameManager == null) {
      return;
    }

    // int defaultSubType = -1;
    int defaultSubType = CretaStudioLang.newsCategories.keys.toList().indexOf(selectedCategory);

    mychangeStack.startTrans();
    await frameManager.createNextFrame(
      doNotify: false,
      size: newsFrameSize, //Size(widthBig, heightBig),
      pos: Offset(x, y),
      bgColor1: Colors.transparent,
      type: frameType,
      subType: defaultSubType,
    );

    frameCounter++;
    mychangeStack.endTrans();
  }
}

class CategoryCard extends StatelessWidget {
  final String? categoryName;
  final String? imageAssetUrl;

  const CategoryCard({super.key, this.categoryName, this.imageAssetUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CachedNetworkImage(
          imageUrl: imageAssetUrl!,
          height: 80,
          width: 160,
          fit: BoxFit.cover,
        ),
        Container(
          height: 80,
          width: 160,
          color: Colors.black54,
        ),
        Container(
          alignment: Alignment.center,
          height: 80,
          width: 160,
          child: Text(
            categoryName!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
