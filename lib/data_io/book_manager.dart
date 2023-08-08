import 'dart:math';

import 'package:creta03/model/user_property_model.dart';
import 'package:hycop/hycop.dart';
import '../common/creta_utils.dart';
import '../design_system/component/tree/src/models/node.dart';
import '../design_system/menu/creta_popup_menu.dart';
import '../lang/creta_lang.dart';
import '../lang/creta_studio_lang.dart';
import '../model/app_enums.dart';
import '../model/book_model.dart';
import '../model/creta_model.dart';
import '../model/page_model.dart';
import '../model/team_model.dart';
import '../pages/login_page.dart';
import 'creta_manager.dart';
import 'page_manager.dart';

class BookManager extends CretaManager {
  BookManager({String tableName = 'creta_book'}) : super(tableName, null) {
    saveManagerHolder?.registerManager('book', this);
  }

  @override
  AbsExModel newModel(String mid) {
    parentMid = mid;
    return BookModel(mid);
  }

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

    //print('old mid = ${onlyOne()!.mid}');
    BookModel sampleBook = BookModel.withName(name,
        creator: AccountManager.currentLoginUser.email,
        creatorName: AccountManager.currentLoginUser.name,
        imageUrl: url);
    sampleBook.order.set(getMaxOrder() + 1, save: false, noUndo: true, dontChangeBookTime: true);
    sampleBook.width.set(width, save: false, noUndo: true, dontChangeBookTime: true);
    sampleBook.height.set(height, save: false, noUndo: true, dontChangeBookTime: true);
    sampleBook.thumbnailUrl.set(url, save: false, noUndo: true, dontChangeBookTime: true);
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
    List<String> queryVal = [
      '<${PermissionType.reader.name}>$userId',
      '<${PermissionType.writer.name}>$userId',
      '<${PermissionType.owner.name}>$userId',
      '<${PermissionType.owner.name}>public',
    ];
    TeamModel? myTeam = LoginPage.teamManagerHolder!.currentTeam;
    if (myTeam != null) {
      String myTeamId = myTeam.name;
      queryVal.add('<${PermissionType.reader.name}>$myTeamId');
      queryVal.add('<${PermissionType.writer.name}>$myTeamId');
      queryVal.add('<${PermissionType.owner.name}>$myTeamId');
    }

    query['shares'] = QueryValue(value: queryVal, operType: OperType.arrayContainsAny);
    //query['creator'] = QueryValue(value: userId, operType: OperType.isNotEqualTo);
    query['isRemoved'] = QueryValue(value: false);
    final retval = await queryFromDB(query, limit: limit);
    // 자기것은 빼고 나온다
    for (var ele in retval) {
      BookModel book = ele as BookModel;
      if (book.creator == userId) {
        remove(book);
      }
    }
    return modelList;
  }

  Future<List<AbsExModel>> teamData({int? limit}) async {
    logger.finest('teamData');
    Map<String, QueryValue> query = {};
    List<String> creators = [];
    List<String> queryVal = [];
    TeamModel? myTeam = LoginPage.teamManagerHolder!.currentTeam;
    if (myTeam != null) {
      String myTeamId = myTeam.name;
      queryVal.add('<${PermissionType.reader.name}>$myTeamId');
      queryVal.add('<${PermissionType.writer.name}>$myTeamId');
      queryVal.add('<${PermissionType.owner.name}>$myTeamId');
    }

    List<UserPropertyModel>? myMembers = LoginPage.teamManagerHolder!.getMyTeamMembers();
    if (myMembers == null) {
      return [];
    }
    for (UserPropertyModel ele in myMembers) {
      creators.add(ele.email);
      queryVal.add('<${PermissionType.reader.name}>${ele.email}');
      queryVal.add('<${PermissionType.writer.name}>${ele.email}');
      queryVal.add('<${PermissionType.owner.name}>${ele.email}');
    }
    query['creator'] = QueryValue(value: creators, operType: OperType.whereIn);
    //query['shares'] = QueryValue(value: queryVal, operType: OperType.arrayContainsAny);
    query['isRemoved'] = QueryValue(value: false);
    final bookList = await queryFromDB(query, limit: limit);
    List<BookModel> retval = [];
    for (var ele in bookList) {
      BookModel book = ele as BookModel;
      // books 의 shared 에서 creator 와 같은놈은 제거해야 한다.
      // 그렇지 않으면 자신은 자기 팀원이기 때문에, 무조건 권한을 갖게된다.
      book.shares.remove('<${PermissionType.owner.name}>${book.creator}');
      book.shares.remove('<${PermissionType.reader.name}>${book.creator}');
      book.shares.remove('<${PermissionType.writer.name}>${book.creator}');
      for (String authStr in queryVal) {
        if (book.shares.contains(authStr) == true) {
          //print('$authStr=${book.shares.toString()}');
          retval.add(book);
          break;
        }
      }
    }
    modelList.clear();
    modelList = [...retval];
    //print('total=${modelList.length}------------------------------');
    return modelList;
  }

  String prefix() => CretaManager.modelPrefix(ExModelType.book);

  @override
  Future<AbsExModel> makeCopy(AbsExModel src, String? newParentMid) async {
    // 이미, publish 되어 있다면, 해당 mid 를 가져와야 한다.

    BookModel newOne = BookModel('');
    BookModel srcModel = src as BookModel;
    // creat_book_published data 를 만든다.
    newOne.copyFrom(srcModel, newMid: newOne.mid, pMid: newParentMid ?? newOne.parentMid.value);
    newOne.name.set('${srcModel.name.value}${CretaLang.copyOf}');
    newOne.sourceMid = "";
    newOne.publishMid = "";
    if (LoginPage.userPropertyManagerHolder!.userPropertyModel != null) {
      newOne.creator = LoginPage.userPropertyManagerHolder!.userPropertyModel!.email;
    }
    await createToDB(newOne);
    logger.info('newBook created ${newOne.mid}, source=${newOne.sourceMid}');
    return newOne;
  }

  Future<void> removeBook(BookModel thisOne, PageManager pageManager) async {
    logger.info('removeBook()');
    pageManager.removeAll();
    thisOne.isRemoved.set(true, save: false, noUndo: true);
    await setToDB(thisOne);
    remove(thisOne);
  }

  Future<void> removeChildren(BookModel book) async {
    PageManager pageManager = PageManager();
    pageManager.setBook(book);
    Map<String, QueryValue> query = {};
    query['parentMid'] = QueryValue(value: book.mid);
    query['isRemoved'] = QueryValue(value: false);
    await pageManager.queryFromDB(query);
    await pageManager.removeAll();
  }

  List<Node> toNodes(BookModel model, PageManager pageManager) {
    //print('invoke pageMangaer.toNodes()');
    List<Node> nodes = [];
    List<Node> childNodes = [];
    PageModel? selectedModel = pageManager.getSelected() as PageModel?;
    if (selectedModel != null) {
      childNodes = pageManager.toNodes(selectedModel);
    }
    nodes.add(Node<CretaModel>(
      key: model.mid,
      label: 'CretaBook ${model.name.value}',
      data: model,
      expanded: model.expanded,
      children: childNodes,
      root: model.mid,
    ));

    return nodes;
  }
}
