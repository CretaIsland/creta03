import 'package:hycop/hycop.dart';
import '../design_system/menu/creta_popup_menu.dart';
import '../lang/creta_lang.dart';
import '../lang/creta_studio_lang.dart';
import '../model/app_enums.dart';
import '../model/book_model.dart';
import 'creta_manager.dart';

class BookManager extends CretaManager {
  BookManager() : super('creta_book') {
    saveManagerHolder?.registerManager('book', this);
  }

  @override
  AbsExModel newModel(String mid) => BookModel(mid);

  @override
  List<CretaMenuItem> getSortMenu(Function? onModelSorted) {
    return [
      CretaMenuItem(
          caption: CretaLang.basicBookSortFilter[0],
          onPressed: () {
            toSorted('updateTime', descending: true, onModelSorted: onModelSorted);
          },
          selected: true),
      CretaMenuItem(
          caption: CretaLang.basicBookSortFilter[1],
          onPressed: () {
            toSorted('name', onModelSorted: onModelSorted);
          },
          selected: false),
      CretaMenuItem(
          caption: CretaLang.basicBookSortFilter[2],
          onPressed: () {
            toSorted('likeCount', descending: true, onModelSorted: onModelSorted);
          },
          selected: false),
      CretaMenuItem(
          caption: CretaLang.basicBookSortFilter[3],
          onPressed: () {
            toSorted('viewCount', descending: true, onModelSorted: onModelSorted);
          },
          selected: false),
    ];
  }

  @override
  List<CretaMenuItem> getFilterMenu(Function? onModelFiltered) {
    return [
      CretaMenuItem(
          caption: CretaLang.basicBookFilter[0],
          onPressed: () {
            toFiltered(null, null, AccountManager.currentLoginUser.email,
                onModelFiltered: onModelFiltered);
          },
          selected: true),
      CretaMenuItem(
          caption: CretaLang.basicBookFilter[1],
          onPressed: () {
            toFiltered(
                'bookType', BookType.presentaion.index, AccountManager.currentLoginUser.email,
                onModelFiltered: onModelFiltered);
          },
          selected: false),
      CretaMenuItem(
          caption: CretaLang.basicBookFilter[2],
          onPressed: () {
            toFiltered('bookType', BookType.board.index, AccountManager.currentLoginUser.email,
                onModelFiltered: onModelFiltered);
          },
          selected: false),
      CretaMenuItem(
          caption: CretaLang.basicBookFilter[3],
          onPressed: () {
            toFiltered('bookType', BookType.signage.index, AccountManager.currentLoginUser.email,
                onModelFiltered: onModelFiltered);
          },
          selected: false),
      CretaMenuItem(
          caption: CretaLang.basicBookFilter[4],
          onPressed: () {
            toFiltered('bookType', BookType.etc.index, AccountManager.currentLoginUser.email,
                onModelFiltered: onModelFiltered);
          },
          selected: false),
    ];
  }

  @override
  void onSearch(String value, Function afterSearch) {
    search(['name', 'hashTag'], value, afterSearch);
  }

  BookModel createDefault({
    int width = 1920,
    int height = 1080,
  }) {
    BookModel defaultBook = BookModel.withName(CretaStudioLang.defaultBookName,
        creator: AccountManager.currentLoginUser.email,
        creatorName: AccountManager.currentLoginUser.name,
        imageUrl: "https://picsum.photos/200/?random=1");
    defaultBook.width.set(width, save: false, noUndo: true, dontChangeBookTime: true);
    defaultBook.height.set(height, save: false, noUndo: true, dontChangeBookTime: true);
    return defaultBook;
  }

  Future<BookModel> saveDefault(BookModel defaultBook) async {
    await createToDB(defaultBook);
    insert(defaultBook);
    return defaultBook;
  }

  Future<List<AbsExModel>> sharedData(String userId, {int? limit}) async {
    logger.finest('sharedData');
    Map<String, QueryValue> query = {};
    query['shares'] = QueryValue(value: userId, operType: OperType.arrayContains);
    query['isRemoved'] = QueryValue(value: false);
    final retval = await queryFromDB(query, limit: limit);
    return retval;
  }

  String prefix() => CretaManager.modelPrefix(ExModelType.book);
}
