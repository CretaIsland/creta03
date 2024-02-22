import 'dart:math';

import 'package:creta03/data_io/page_manager.dart';
import 'package:hycop/hycop.dart';
import 'package:creta_common/common/creta_common_utils.dart';

import '../design_system/menu/creta_popup_menu.dart';
import 'package:creta_common/lang/creta_lang.dart';
import '../lang/creta_studio_lang.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/book_model.dart';
import 'package:creta_common/model/creta_model.dart';
import 'creta_manager.dart';
import 'page_published_manager.dart';

class BookPublishedManager extends CretaManager {
  BookPublishedManager() : super('creta_book_published', null) {
    saveManagerHolder?.registerManager('book_published', this);
  }

  //static String srcBackgroundMusicFrame = '';
  static String newbBackgroundMusicFrame = '';

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
    name += CretaCommonUtils.getNowString(deli1: '', deli2: ' ', deli3: '', deli4: ' ');

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
    //insert(sampleBook);
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

  // void queryBookFromList(List<String> bookIdList) {
  //   clearAll();
  //   clearConditions();
  //   if (bookIdList.isEmpty) {
  //     setState(DBState.idle);
  //     return;
  //   }
  //   addWhereClause('mid', QueryValue(value: bookIdList, operType: OperType.whereIn));
  //   queryByAddedContitions();
  // }
  //
  // void queryBooksFromMap(Map<String, String> bookIdMap) {
  //   clearAll();
  //   clearConditions();
  //   if (bookIdMap.isEmpty) {
  //     setState(DBState.idle);
  //     return;
  //   }
  //   final List<String> bookIdList = [];
  //   bookIdMap.forEach((key, value) => bookIdList.add(value));
  //   addWhereClause('mid', QueryValue(value: bookIdList, operType: OperType.whereIn));
  //   queryByAddedContitions();
  // }

  Future<BookModel?> findPublished(String sourceMid) async {
    logger.fine('findPublished');
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
    required BookModel? alreadyPublishedOne,
    required List<String> readers,
    required List<String> writers,
    required PageManager pageManager,
    void Function(bool, BookModel)? onComplete,
  }) async {
    // 이미, publish 되어 있다면, 해당 mid 를 가져와야 한다.
    bool isNew = false;

    //BookModel? oldOne = await findPublished(src.mid);
    BookModel? published;
    if (alreadyPublishedOne == null) {
      // 신규 생성이다.
      isNew = true;
      published = BookModel('');
      published.copyFrom(src, newMid: published.mid, pMid: published.parentMid.value);
    } else {
      // 이미 있다.
      published = alreadyPublishedOne;
      published.copyFrom(src, newMid: published.mid, pMid: published.parentMid.value);
    }

    published.sourceMid = src.mid;
    src.publishMid = published.mid;
    src.save();

    //srcBackgroundMusicFrame = src.backgroundMusicFrame.value;
    newbBackgroundMusicFrame = '';
    PagePublishedManager publishedManager = PagePublishedManager(pageManager, src);
    if (isNew) {
      await createToDB(published);
      await publishedManager.copyBook(published.mid, published.mid);
      published.backgroundMusicFrame.set(newbBackgroundMusicFrame, save: false);
      published.readers = [...readers];
      published.writers = [...writers];
      published.shares = published.getShares(published.owners, writers, readers);
      await setToDB(published);
      logger.info('published created ${published.mid}, source=${published.sourceMid}');
    } else {
      published.setUpdateTime();

      await setToDB(published);
      // 예전 자식은 모두 지우고
      await publishedManager.removeChild(published.mid);
      //print('delete old children');
      // 자식은 모두 새로 만든다.
      int count = await publishedManager.copyBook(published.mid, published.mid);
      published.backgroundMusicFrame.set(newbBackgroundMusicFrame, save: false);
      published.readers = [...readers];
      published.writers = [...writers];
      published.shares = published.getShares(published.owners, writers, readers);
      await setToDB(published);
      logger.info('published updated ${published.mid}, source=${published.sourceMid} $count');
    }
    onComplete?.call(isNew, published);

    return true;
  }
}
