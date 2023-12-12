// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:creta03/model/user_property_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
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
//import '../pages/login_page.dart';
import '../pages/login/creta_account_manager.dart';
import '../pages/studio/containees/containee_nofifier.dart';
import 'creta_manager.dart';
import 'page_manager.dart';
//import 'frame_manager.dart';
//import 'contents_manager.dart';

class BookManager extends CretaManager {
  // contents 들의 url 모음, 다운로드 버튼을 눌렀을 때 생성된다.
  static Set<String> contentsSet = {};

  static String newbBackgroundMusicFrame = '';

  Timer? _downloadReceivetimer;

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
    List<String> users = [
      '<${PermissionType.reader.name}>$userId',
      '<${PermissionType.writer.name}>$userId',
      '<${PermissionType.owner.name}>$userId',
      '<${PermissionType.owner.name}>public',
    ];
    TeamModel? myTeam = CretaAccountManager.getCurrentTeam;
    if (myTeam != null) {
      String myTeamId = myTeam.name;
      users.add('<${PermissionType.reader.name}>$myTeamId');
      users.add('<${PermissionType.writer.name}>$myTeamId');
      users.add('<${PermissionType.owner.name}>$myTeamId');
    }

    modelList.clear();

    for (var user in users) {
      query['shares'] = QueryValue(value: user, operType: OperType.arrayContainsAny);
      //query['creator'] = QueryValue(value: userId, operType: OperType.isNotEqualTo);
      query['isRemoved'] = QueryValue(value: false);
      final retval = await queryFromDB(query, limit: limit, isNew: false);
      // 자기것은 빼고 나온다
      for (var ele in retval) {
        BookModel book = ele as BookModel;
        if (book.creator == userId) {
          remove(book);
        }
      }
    }

    return modelList;
  }

  Future<List<AbsExModel>> teamData({int? limit}) async {
    logger.finest('teamData');
    Map<String, QueryValue> query = {};
    List<String> creators = [];
    List<String> queryVal = [];
    TeamModel? myTeam = CretaAccountManager.getCurrentTeam;
    if (myTeam != null) {
      String myTeamId = myTeam.name;
      queryVal.add('<${PermissionType.reader.name}>$myTeamId');
      queryVal.add('<${PermissionType.writer.name}>$myTeamId');
      queryVal.add('<${PermissionType.owner.name}>$myTeamId');
    }

    List<UserPropertyModel>? myMembers = CretaAccountManager.getMyTeamMembers();
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
  Future<AbsExModel> makeCopy(String newBookMid, AbsExModel src, String? newParentMid) async {

    BookModel newOne = BookModel('');
    BookModel srcModel = src as BookModel;
    // creat_book_published data 를 만든다.
    newOne.copyFrom(srcModel, newMid: newOne.mid, pMid: newParentMid ?? newOne.parentMid.value);

    // 여기서 newName 이 이미 있는지를 검색해야 한다.
    String newName = await makeCopyName('${srcModel.name.value}${CretaLang.copyOf}');

    newOne.name.set(newName);
    newOne.sourceMid = "";
    newOne.publishMid = "";
    newOne.setRealTimeKey(newBookMid);
    if (CretaAccountManager.getUserProperty != null) {
      newOne.creator = CretaAccountManager.getUserProperty!.email;
    }
    await createToDB(newOne);
    logger.fine('newBook created ${newOne.mid}, source=${newOne.sourceMid}');
    return newOne;
  }

  Future<void> removeBook(BookModel thisOne, PageManager pageManager) async {
    logger.fine('removeBook()');
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
      keyType: ContaineeEnum.Book,
      label: 'CretaBook ${model.name.value}',
      data: model,
      expanded: model.expanded,
      children: childNodes,
      root: model.mid,
    ));

    return nodes;
  }

  String? toJson(PageManager? pageManager, BookModel book) {
    String bookStr = book.toJson();
    BookManager.contentsSet.clear();
    if (pageManager != null) {
      bookStr += pageManager.toJson();
    }
    if (BookManager.contentsSet.isEmpty) {
      bookStr += '\n\t,"contentsUrl": []';
    } else {
      bookStr += '\n\t,"contentsUrl": [';
      int count = 0;
      for (var ele in BookManager.contentsSet) {
        if (count > 0) {
          bookStr += ",";
        }
        bookStr += '\n\t\t"$ele"';
        count++;
      }
      bookStr += '\n\t]';
    }
    return bookStr;
  }

  Future<bool> download(BuildContext context, PageManager? pageManager, bool shouldDownload) async {
    BookModel? book = onlyOne() as BookModel?;
    if (book == null) {
      return false;
    }
    String? jsonStr = toJson(pageManager, book);
    if (jsonStr == null) {
      return false;
    }
    String retval = '{\n$jsonStr\n}';

    if (shouldDownload == false) {
      CretaUtils.saveLogToFile(retval, "${book.mid}.json");
    }

    //base64 encoding 필요
    String encodedJson = base64Encode(utf8.encode(retval));

    Map<String, dynamic> body = {
      "bucketId": '"${myConfig!.serverConfig!.storageConnInfo.bucketId}"',
      "encodeJson": '"$encodedJson"',
      "cloudType": '"${HycopFactory.toServerTypeString()}"',
    };

    String apiServer = CretaAccountManager.getEnterprise!.mediaApiUrl;
    //'https://devcreta.com:444/';
    String url = '$apiServer/downloadZip';

    Response? res = await CretaUtils.post(url, body, onError: (code) {
      showSnackBar(context, '${CretaStudioLang.zipRequestFailed}($code)');
    }, onException: (e) {
      showSnackBar(context, '${CretaStudioLang.zipRequestFailed}($e)');
    });

    if (res == null) {
      return false;
    }

    logger.fine('zipRequest succeed');
    _waitDownload(apiServer, book.mid, context);
    showSnackBar(context, '${CretaStudioLang.zipStarting}(${res.statusCode})');
    return true;
  }

  Future<void> _waitDownload(String apiServer, String bookMid, BuildContext context) async {
    _downloadReceivetimer?.cancel();
    _downloadReceivetimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      String url = '$apiServer/downloadZipCheck';

      Map<String, dynamic> body = {
        "bucketId": '"${myConfig!.serverConfig!.storageConnInfo.bucketId}"',
        "bookId": '"$bookMid"',
        "cloudType": '"${HycopFactory.toServerTypeString()}"',
      }; // 'appwrite' or 'firebase'

      Response? res = await CretaUtils.post(url, body, onError: (code) {
        showSnackBar(context, '${CretaStudioLang.zipCompleteFailed}($code)');
      }, onException: (e) {
        showSnackBar(context, '${CretaStudioLang.zipCompleteFailed}($e)');
      });

      if (res == null) {
        return;
      }
      _downloadReceivetimer?.cancel();

      Map<String, dynamic> responseBody = json.decode(res.body);
      String? status = responseBody['status']; // API 응답에서 URL 추출
      String? fileId = responseBody['fileId']; // API 응답에서 URL 추출

      if (status == null || status != 'success') {
        showSnackBar(context, '${CretaStudioLang.zipCompleteFailed}(status=$status)');
        return;
      }
      if (fileId == null || fileId.isEmpty) {
        showSnackBar(context, '${CretaStudioLang.zipCompleteFailed}($fileId is null)');
        return;
      }

      //print('fileId = $fileId');

      HycopFactory.storage!.downloadFile(fileId, '$bookMid.zip').then((bool succeed) {
        //HycopFactory.storage!.downloadFile(zipUrl, bookMid).then((bool succeed) {
        showSnackBar(context, '${CretaStudioLang.fileDownloading}(${res.statusCode})');
        //});
        return;
      });
    });
  }

  static final Map<String, String> cloneBookIdMap = {}; // <old, new>
  static final Map<String, String> clonePageIdMap = {}; // <old, new>
  static final Map<String, String> cloneFrameIdMap = {}; // <old, new>
  static final Map<String, String> cloneContentsIdMap = {}; // <old, new>
  static final Map<String, String> cloneLinkIdMap = {}; // <old, new>
  Future<BookModel?> makeClone(
    BookModel srcBook, {
    bool srcIsPublishedBook = true,
    bool cloneToPublishedBook = false,
  }) async {
    // make book-clone
    BookModel? newBook;
    try {
      // init id-map
      cloneBookIdMap.clear();
      clonePageIdMap.clear();
      cloneFrameIdMap.clear();
      cloneContentsIdMap.clear();
      cloneLinkIdMap.clear();
      // page loading
      final PageManager srcPageManagerHolder = PageManager(
        tableName: srcIsPublishedBook ? 'creta_page_published' : 'creta_page',
        isPublishedMode: true,
      );
      await srcPageManagerHolder.initPage(srcBook);
      await srcPageManagerHolder.findOrInitAllFrameManager(srcBook);
      // make clone of Book
      newBook = BookModel('');
      cloneBookIdMap[srcBook.mid] = newBook.mid;
      newBook.copyFrom(srcBook, newMid: newBook.mid);
      newBook.parentMid.set(newBook.mid);
      newBook.name.set('${srcBook.name.value}${CretaLang.copyOf}');
      newBook.sourceMid = "";
      newBook.publishMid = "";
      if (CretaAccountManager.getUserProperty != null) {
        newBook.creator = CretaAccountManager.getUserProperty!.email;
        newBook.owners = [CretaAccountManager.getUserProperty!.email];
      }
      // make clone of Pages
      final PageManager pageManager = cloneToPublishedBook
          ? PageManager(tableName: 'creta_page_published', isPublishedMode: true)
          : PageManager(isPublishedMode: true);
      pageManager.setBook(newBook);
      pageManager.modelList = [...srcPageManagerHolder.modelList];
      pageManager.frameManagerMap = Map.from(srcPageManagerHolder.frameManagerMap);
      await pageManager.makeClone(
        newBook,
        cloneToPublishedBook: cloneToPublishedBook,
      );
      await createToDB(newBook);
      logger.info('clone is created (${newBook.mid}) from (source:${srcBook.mid}');
    } catch (e) {
      logger.severe('book-clone is failed (source:${srcBook.mid})');
      newBook = null;
    }
    return newBook;
  }
}
