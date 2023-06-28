import 'dart:math';

import 'package:creta03/data_io/page_manager.dart';
import 'package:hycop/hycop.dart';
import '../common/creta_utils.dart';
import '../design_system/menu/creta_popup_menu.dart';
import '../lang/creta_lang.dart';
import '../lang/creta_studio_lang.dart';
import '../model/app_enums.dart';
import '../model/book_model.dart';
import '../model/creta_model.dart';
import 'creta_manager.dart';
import 'page_published_manager.dart';

class BookPublishedManager extends CretaManager {
  BookPublishedManager() : super('creta_book_published', null) {
    saveManagerHolder?.registerManager('book_published', this);
  }

  @override
  AbsExModel newModel(String mid) => BookModel(mid);

  @override
  CretaModel cloneModel(CretaModel src) {
    BookModel retval = newModel(src.mid) as BookModel;
    src.copyTo(retval);
    return retval;
  }

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

  BookModel createSample({
    double width = 1920,
    double height = 1080,
  }) {
    final Random random = Random();
    int randomNumber = random.nextInt(100);
    String url = 'https://picsum.photos/200/?random=$randomNumber';

    String name = '${CretaStudioLang.sampleBookName} ';
    name += CretaUtils.getNowString(deli1: '', deli2: ' ', deli3: '', deli4: ' ');

    BookModel sampleBook = BookModel.withName(name,
        creator: AccountManager.currentLoginUser.email,
        creatorName: AccountManager.currentLoginUser.name,
        imageUrl: url);
    sampleBook.width.set(width, save: false, noUndo: true, dontChangeBookTime: true);
    sampleBook.height.set(height, save: false, noUndo: true, dontChangeBookTime: true);
    return sampleBook;
  }

  Future<BookModel> saveSample(BookModel sampleBook) async {
    await createToDB(sampleBook);
    insert(sampleBook);
    return sampleBook;
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

  Future<BookModel?> findPublished(String sourceMid) async {
    logger.info('findPublished');
    Map<String, QueryValue> query = {};
    query['sourceMid'] = QueryValue(value: sourceMid);
    query['isRemoved'] = QueryValue(value: false);
    List<AbsExModel> retval = await queryFromDB(query);
    if (retval.isEmpty) {
      return null;
    }
    return retval[0] as BookModel?;
  }

  Future<bool> publish({
    required BookModel src,
    required PageManager pageManager,
    void Function(bool)? onComplete,
  }) async {
    // 이미, publish 되어 있다면, 해당 mid 를 가져와야 한다.
    bool isNew = false;

    BookModel? published = await findPublished(src.mid);
    if (published == null) {
      isNew = true;
      published = BookModel('');
      src.publishMid = published.mid;
      src.save();
    }
    // creat_book_published data 를 만든다.
    published.copyFrom(src, newMid: published.mid, pMid: published.parentMid.value);
    published.sourceMid = src.mid;
    PagePublishedManager publishedManager = PagePublishedManager(pageManager, src);
    if (isNew) {
      await createToDB(published);
      logger.info('published created ${published.mid}, source=${published.sourceMid}');
    } else {
      await setToDB(published);
      logger.info('published updated ${published.mid}, , source=${published.sourceMid}');
    }
    await publishedManager.makeCopyAll(published.mid);
    onComplete?.call(isNew);
    return true;
  }
}
