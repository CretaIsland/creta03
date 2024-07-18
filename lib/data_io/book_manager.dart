// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:creta_common/common/creta_common_utils.dart';
import 'package:creta_common/common/creta_vars.dart';
import 'package:creta_studio_io/data_io/base_book_manager.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';
import 'package:creta_user_io/data_io/team_manager.dart';
import 'package:creta_user_model/model/user_property_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:hycop/hycop.dart';
import '../common/creta_utils.dart';
import '../design_system/component/tree/src/models/node.dart';
import 'package:creta_common/lang/creta_lang.dart';
import '../lang/creta_studio_lang.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/book_model.dart';
import 'package:creta_studio_model/model/contents_model.dart';
import 'package:creta_common/model/creta_model.dart';
import 'package:creta_studio_model/model/page_model.dart';
import 'package:creta_user_model/model/team_model.dart';
//import '../pages/login_page.dart';
import '../pages/login/creta_account_manager.dart';
import '../pages/studio/book_main_page.dart';
import '../pages/studio/containees/containee_nofifier.dart';
import '../pages/studio/studio_constant.dart';
import '../pages/studio/studio_variables.dart';
import 'page_manager.dart';
//import 'frame_manager.dart';
//import 'contents_manager.dart';

class BookManager extends BaseBookManager {
  // contents 들의 url 모음, 다운로드 버튼을 눌렀을 때 생성된다.
  static Map<ContentsModel, String> contentsUrlMap = {};

  static String newbBackgroundMusicFrame = '';

  Timer? _downloadReceivetimer;

  BookManager({String tableName = 'creta_book'}) : super(tableName: tableName) {
    //saveManagerHolder?.registerManager('book', this);
  }

  // @override
  // AbsExModel newModel(String mid) {
  //   parentMid = mid;
  //   return BookModel(mid);
  // }

  // @override
  // CretaModel cloneModel(CretaModel src) {
  //   BookModel retval = newModel(src.mid) as BookModel;
  //   src.copyTo(retval);
  //   return retval;
  // }

  @override
  void onSearch(String value, Function afterSearch) {
    search(['name', 'hashTag'], value, afterSearch);
  }

  BookModel createSample({
    double? width,
    double? height,
  }) {
    width ??= CretaVars.instance.defaultSize().width;
    height ??= CretaVars.instance.defaultSize().height;

    final Random random = Random();
    int randomNumber = random.nextInt(100);
    String url = 'https://picsum.photos/200/?random=$randomNumber';

    String name = '${CretaLang['sampleBookName']!} ';
    name += CretaCommonUtils.getNowString(deli1: '', deli2: ' ', deli3: '', deli4: ' ');

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
      '<${PermissionType.owner.name}>${UserPropertyModel.defaultEmail}',
    ];
    TeamModel? myTeam = TeamManager.getCurrentTeam;
    if (myTeam != null) {
      String myTeamId = myTeam.name;
      users.add('<${PermissionType.reader.name}>$myTeamId');
      users.add('<${PermissionType.writer.name}>$myTeamId');
      users.add('<${PermissionType.owner.name}>$myTeamId');
    }

    BookType bookType = CretaVars.instance.defaultBookType();
    if (bookType != BookType.none) {
      query['bookType'] = QueryValue(value: bookType.index);
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
    TeamModel? myTeam = TeamManager.getCurrentTeam;
    if (myTeam != null) {
      String myTeamId = myTeam.name;
      queryVal.add('<${PermissionType.reader.name}>$myTeamId');
      queryVal.add('<${PermissionType.writer.name}>$myTeamId');
      queryVal.add('<${PermissionType.owner.name}>$myTeamId');
    }

    Set<UserPropertyModel>? myMembers = CretaAccountManager.getMyTeamMembers();
    if (myMembers == null) {
      return [];
    }
    for (UserPropertyModel ele in myMembers) {
      creators.add(ele.email);
      queryVal.add('<${PermissionType.reader.name}>${ele.email}');
      queryVal.add('<${PermissionType.writer.name}>${ele.email}');
      queryVal.add('<${PermissionType.owner.name}>${ele.email}');
    }

    BookType bookType = CretaVars.instance.defaultBookType();
    if (bookType != BookType.none) {
      query['bookType'] = QueryValue(value: bookType.index);
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
    String newName = await makeCopyName('${srcModel.name.value}${CretaLang['copyOf']!}');

    // FileModel? res = (await HycopFactory.storage!.copyFile(srcModel.thumbnailUrl.value));
    // if (res != null) {
    //   newOne.thumbnailUrl.set(res.url);
    // }

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
    if (pageManager != null) {
      bookStr += pageManager.toJson();
    }
    if (BookManager.contentsUrlMap.isEmpty) {
      bookStr += '\n\t,"contentsUrl": []';
    } else {
      bookStr += '\n\t,"contentsUrl": [';
      int count = 0;
      for (var ele in BookManager.contentsUrlMap.values) {
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

  bool uploadCompleteTest(PageManager? pageManager, BookModel book) {
    book.toJson();
    if (pageManager != null) {
      pageManager.toJson();
    }
    if (BookManager.contentsUrlMap.isEmpty) {
      return true;
    }

    for (var ele in BookManager.contentsUrlMap.values) {
      //print('***************************************ele=$ele');
      if (ele.contains('blob:')) {
        logger.severe('uploading is not ending yet ($ele)');
        return false;
      }
    }

    return true;
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
      CretaCommonUtils.saveLogToFile(retval, "${book.mid}.json");
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
      showSnackBar(context, '${CretaStudioLang['zipRequestFailed']!}($code)');
    }, onException: (e) {
      showSnackBar(context, '${CretaStudioLang['zipRequestFailed']!}($e)');
    });

    if (res == null) {
      return false;
    }

    logger.fine('zipRequest succeed');
    _waitDownload(apiServer, book.mid, context);
    showSnackBar(context, '${CretaStudioLang['zipStarting']!}(${res.statusCode})');
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
        showSnackBar(context, '1.${CretaStudioLang['zipCompleteFailed']!}($code)');
      }, onException: (e) {
        showSnackBar(context, '2.${CretaStudioLang['zipCompleteFailed']!}($e)');
      });

      if (res == null) {
        return;
      }
      _downloadReceivetimer?.cancel();

      Map<String, dynamic> responseBody = json.decode(res.body);
      String? status = responseBody['status']; // API 응답에서 URL 추출
      String? fileId = responseBody['fileId']; // API 응답에서 URL 추출

      if (status == null || status != 'success') {
        showSnackBar(context, '3.${CretaStudioLang['zipCompleteFailed']!}(status=$status)');
        return;
      }
      if (fileId == null || fileId.isEmpty) {
        showSnackBar(context, '4.${CretaStudioLang['zipCompleteFailed']!}($fileId is null)');
        return;
      }

      //print('fileId = $fileId');

      HycopFactory.storage!.downloadFile(fileId, '$bookMid.zip').then((bool succeed) {
        //HycopFactory.storage!.downloadFile(zipUrl, bookMid).then((bool succeed) {
        showSnackBar(context, '${CretaStudioLang['fileDownloading']!}(${res.statusCode})');
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
      newBook.name.set('${srcBook.name.value}${CretaLang['copyOf']!}');
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

  Future<BookModel> createNewBook(BookModel book) async {
    // final Random random = Random();
    // int randomNumber = random.nextInt(1000);
    // int modelIdx = randomNumber % 10;
    // BookModel book = BookModel.withName(
    //   '${CretaStudioLang['newBook']!}_$randomNumber',
    //   creator: AccountManager.currentLoginUser.email,
    //   creatorName: AccountManager.currentLoginUser.name,
    //   imageUrl: 'https://picsum.photos/200/?random=$modelIdx',
    //   viewCount: randomNumber,
    //   likeCount: 1000 - randomNumber,
    //   bookTypeVal: BookType.fromInt(randomNumber % 4 + 1),
    //   ownerList: const [],
    //   readerList: const [],
    //   writerList: const [],
    //   desc: SampleData.sampleDesc[randomNumber % SampleData.sampleDesc.length],
    // );

    // book.hashTag.set('#${randomNumber}tag');

    await createToDB(book);
    insert(book);
    return book;
  }

  Future<void> userChanged() async {
    // 로그인하지 않고 사용하던 유저가 Studio Book 안으로 들어온 다음,
    // 로그인을 했기 때문에,  Book 과 Contents file 을 모두 이 새로운 사람의
    // id 로 소유권을 옮겨야 한다.

    BookModel? book = onlyOne() as BookModel?;
    if (book == null) {
      return;
    }

    String newUserId = AccountManager.currentLoginUser.email;
    book.creator = newUserId;
    book.owners.clear();
    book.owners.add(newUserId);

    await setToDB(book);

    // 버킷을 모두 옯겨줘야 한다.

    // 옮길 콘텐츠 URL 을 모두 가져온다.
    // 쎔네일도 바꾸어야 한다.
    BookMainPage.pageManagerHolder?.toJson();

    //print('skpark BookManager.contentsUrlMap.entries=${BookManager.contentsUrlMap.entries.length}');
    for (var ele in BookManager.contentsUrlMap.entries) {
      // <-- moveFile 로 변경해야함.
      //print('skpark url=${ele.value}');
      //print(
      //    'skpark targetThumbnailUrl=${ele.key.thumbnailUrl != null ? ele.key.thumbnailUrl! : ""}');

      // Hycop(0.4.24) 기존 파일 이동 코드
      // Map<String, String> urlParse = HycopFactory.storage!.parseFileUrl(ele.value);
      // HycopFactory.storage!
      //     .moveFile(urlParse["bucketId"]!, urlParse["fileId"]!)
      //     .then((newFileModel) {
      //   if (newFileModel != null) {
      //     ele.key.remoteUrl = newFileModel.url;
      //     ele.key.thumbnailUrl = newFileModel.thumbnailUrl;

      //     BookMainPage.pageManagerHolder?.updateContents(ele.key);
      //     //print('skpark ele.key.remoteUrl=${ele.key.remoteUrl}');
      //     setToDB(ele.key);
      //   }
      //   return null;
      // });

      // 20240520 - Hycop(0.4.25) 새로운 파일 이동 코드 (url 파싱 없이 이동 가능)
      HycopFactory.storage!.moveFileFromUrl(ele.value).then((newFileModel) {
        if (newFileModel != null) {
          ele.key.remoteUrl = newFileModel.url;
          ele.key.thumbnailUrl = newFileModel.thumbnailUrl;

          BookMainPage.pageManagerHolder?.updateContents(ele.key);
          //print('skpark ele.key.remoteUrl=${ele.key.remoteUrl}');
          setToDB(ele.key);
        }
        return null;
      });

      // 20240118-nr.han 수정. copyFile의 파라미터가 바뀌면서 사용방법이 바뀌었습니다.
      // 아래 주석처리된 코드가 이전 코드고, 위에 있는 코드가 변경사항에 맞춘 코드입니다.
      // HycopFactory.storage!
      //     .copyFile(
      //   ele.value,
      //   targetThumbnailUrl: ele.key.thumbnailUrl != null ? ele.key.thumbnailUrl! : '',
      // )
      //     .then((newFileModel) {
      //   //print('skpark copyFile end----------------------');
      //   // 여기서 컨텐츠의 url 을 교체해주어야 한다.
      //   if (newFileModel != null) {
      //     ele.key.remoteUrl = newFileModel.url;
      //     ele.key.thumbnailUrl = newFileModel.thumbnailUrl;

      //     //print('skpark ele.key.remoteUrl=${ele.key.remoteUrl}');
      //     setToDB(ele.key);
      //   }
      //   return null;
      // });
    }
  }

  Offset getPageIndexOffset() {
    BookModel? book = onlyOne() as BookModel?;
    if (book == null) {
      return Offset.zero;
    }
    //int pageIndex = BookMainPage.pageManagerHolder!.getSelectedPageIndex();
    // const int pageIndex = 1;
    // if (pageIndex < 0) {
    //   return Offset.zero;
    // }
    //print('pageIndex=$pageIndex');
    return Offset(
      (StudioVariables.virtualWidth - (book.width.value * StudioVariables.applyScale)) / 2,
      (StudioVariables.virtualHeight - (book.height.value * StudioVariables.applyScale)) / 2,
      //StudioVariables.availHeight * pageIndex +
      //((StudioVariables.availHeight - (book.height.value * StudioVariables.applyScale)) / 2),
    );
  }

  Offset positionInPage(Offset localPosition, double? applyScale,
      {bool applyStickerOffset = true}) {
    applyScale ??= StudioVariables.applyScale;
    double margin = applyStickerOffset ? (LayoutConst.stikerOffset / 2) : 0;
    double dx = (localPosition.dx - BookMainPage.pageOffset.dx + margin) / applyScale;
    double dy = (localPosition.dy - BookMainPage.pageOffset.dy + margin) / applyScale;
    //print('localPosition.dy=${localPosition.dy}');
    //print('dy=$dy');

    return Offset(dx, dy);
  }
}
