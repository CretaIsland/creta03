import 'package:creta03/lang/creta_studio_lang.dart';

class CategoryModel {
  String? categoryName;
}

List<CategoryModel> getCategories() {
  List<CategoryModel> myCategories = [];

  for (var i = 0; i < CretaStudioLang.newsCategories.length; i++) {
    CategoryModel categoryModel = CategoryModel();
    categoryModel.categoryName = CretaStudioLang.newsCategories.keys.toList()[i];
    myCategories.add(categoryModel);
  }

  return myCategories;
}
