// ignore_for_file: prefer_final_fields

import 'dart:async';

import 'package:flutter/material.dart';
//import 'package:flutter_treeview/flutter_treeview.dart';
import '../design_system/component/tree/flutter_treeview.dart';
import 'package:hycop/common/undo/save_manager.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/database/abs_database.dart';
import '../lang/creta_lang.dart';
import '../model/book_model.dart';
import '../model/contents_model.dart';
import '../model/creta_model.dart';
import '../model/frame_model.dart';
import '../model/page_model.dart';
import '../pages/studio/book_main_page.dart';
import '../pages/studio/containees/containee_nofifier.dart';
//import '../pages/studio/containees/page/page_main.dart';
import '../pages/studio/left_menu/left_menu_page.dart';
import '../pages/studio/studio_constant.dart';
import '../pages/studio/studio_variables.dart';
import 'creta_manager.dart';
import 'book_manager.dart';
import 'frame_manager.dart';
import 'key_handler.dart';

//PageManager? pageManagerHolder;

class PageManager extends CretaManager {
  BookModel? bookModel;
  Map<String, FrameManager?> frameManagerMap = {};
  //Map<String, GlobalObjectKey> thumbKeyMap = {};
  Map<String, GlobalObjectKey> pageKeyMap = {};

  int updateContents(ContentsModel model) {
    int retval = 0;
    for (FrameManager? frameManager in frameManagerMap.values) {
      if (frameManager == null) continue;
      retval += frameManager.updateContents(model);
    }
    return retval;
  }

/////////////////////////////////////////////////////////
// thumnKeyHandler area start
/////////////////////////////////////////////////////////
  KeyHandler thumnKeyHandler = KeyHandler();

  String thumbKkeyMangler(String pageMid) {
    return 'Thumb$pageMid';
  }

  GlobalObjectKey<CretaState<StatefulWidget>> registerPageThumbnail(String pageMid) {
    String keyString = thumbKkeyMangler(pageMid);
    return thumnKeyHandler.registerKey(keyString);
  }

  bool invalidatThumbnail(String pageMid) {
    return thumnKeyHandler.invalidate(thumbKkeyMangler(pageMid));
  }

  Rect? getThumbArea() {
    PageModel? pageModel = getSelected() as PageModel?;
    if (pageModel == null) {
      return thumnKeyHandler.getFirstArea();
    }
    return thumnKeyHandler.getArea(thumbKkeyMangler(pageModel.mid));
  }

  Rect? getFirstThumbArea() {
    return thumnKeyHandler.getFirstArea();
  }
/////////////////////////////////////////////////////////
// thumnKeyHandler area end
/////////////////////////////////////////////////////////

  GlobalObjectKey createPageKey(String mid) {
    String key = 'PageRealMainKey$mid';
    GlobalObjectKey? retval = pageKeyMap[key];
    if (retval != null) {
      return retval;
    }
    retval = GlobalObjectKey(key);
    pageKeyMap[key] = retval;
    return retval;
  }

  GlobalObjectKey? findPageKey(String mid) {
    return pageKeyMap['PageRealMainKey$mid'];
  }

  PageModel? _prevModel;
  PageModel? get prevModel => _prevModel;
  bool _transitForward = true;
  bool get transitForward => _transitForward;

  final bool isPublishedMode;

  final Function? onGotoPrevBook;
  final Function? onGotoNextBook;

  static Map<String, String> oldNewMap = {}; // linkCopy 시에 필요하다.

  PageManager({
    String tableName = 'creta_page',
    this.isPublishedMode = false,
    this.onGotoPrevBook,
    this.onGotoNextBook,
  }) : super(tableName, null) {
    saveManagerHolder?.registerManager('page', this);
  }
  @override
  CretaModel cloneModel(CretaModel src) {
    PageModel retval = newModel(src.mid) as PageModel;
    src.copyTo(retval);
    return retval;
  }

  @override
  AbsExModel newModel(String mid) => PageModel(mid, bookModel!);

  void setBook(BookModel book) {
    bookModel = book;
    parentMid = book.mid;
  }

  Future<void> initPage(BookModel bookModel) async {
    setBook(bookModel);
    clearAll();
    addRealTimeListen(bookModel.mid);
    await getPages();
    setSelected(0);
    subcribe();
  }

  void clearFrameManager() {
    logger.info('clearFrameManager');
    for (FrameManager? ele in frameManagerMap.values) {
      ele?.removeRealTimeListen();
    }
    for (String mid in frameManagerMap.keys) {
      saveManagerHolder?.unregisterManager('frame', postfix: mid);
    }
  }

  FrameManager? findFrameManager(String pageMid) {
    return frameManagerMap[pageMid];
  }

  FrameManager? findSelectedFrameManager() {
    String mid = getSelectedMid();
    return frameManagerMap[mid];
  }

  FrameModel? findFrameModel(String frameMid) {
    // frameMid 만 가지고, 해당  frameModel 을 찾아야 한다.
    FrameModel? retval;
    for (var ele in modelList) {
      if (ele.isRemoved.value == true) {
        continue;
      }
      PageModel pageModel = ele as PageModel;
      FrameManager? frameManager = findFrameManager(pageModel.mid);
      if (frameManager != null) {
        continue;
      }
      retval = frameManager!.getModel(frameMid) as FrameModel?;
      if (retval != null) {
        return retval;
      }
    }
    return null;
  }

  FrameManager? findCurrentFrameManager() {
    PageModel? pageModel = getSelected() as PageModel?;
    if (pageModel == null) {
      return null;
    }
    return findFrameManager(pageModel.mid);
  }

  FrameManager newFrameManager(BookModel bookModel, PageModel pageModel) {
    //print('newFrameManager');
    FrameManager retval = FrameManager(
      bookModel: bookModel,
      pageModel: pageModel,
      tableName: isPublishedMode ? 'creta_frame_published' : 'creta_frame',
      isPublishedMode: isPublishedMode,
    );
    frameManagerMap[pageModel.mid] = retval;
    return retval;
  }

  Future<void> findOrInitAllFrameManager(BookModel bookModel) async {
    for (var ele in modelList) {
      if (ele.isRemoved.value == true) {
        continue;
      }
      PageModel pageModel = ele as PageModel;
      FrameManager? frameManager = findFrameManager(pageModel.mid);
      if (frameManager != null) {
        continue;
      }

      // 이곳에서 frameManagerMap  에 등록되었다.
      frameManager = newFrameManager(bookModel, pageModel);
      // 프레임을  DB  에서 가져온다.
      await initFrameManager(frameManager, ele.mid);
      // 이 for문은 여기까지만 해야한다.  overlay 원본이 뒤쪽 페이지에 있을수도 있으므로
      // 여기까지만 하고,  아래와 같이  for 문을 다시 돌아야한다.
    }

    //   등록된  frameManager 에 대해서,  ContentsManager 를 등록한다.
    // 반드시  이렇게 for 문을 나누어서 별도로 진행해야 한다.
    // 모든 page 가  initialize 가 된다음 contents 를 가져와야 하기 때문이다.
    for (FrameManager? frameManager in frameManagerMap.values.toList()) {
      await frameManager?.findOrInitContentsManager();
      frameManager?.addOverlay();
    }
    // for (var frameManager in frameManagerMap.values.toList()) {
    //   await initFrameManager(frameManager!);
    //   await frameManager.findOrInitContentsManager();
    // }
    return;
  }

  Future<void> initFrameManager(FrameManager frameManager, String pageMid) async {
    frameManager.clearAll();
    frameManager.addRealTimeListen(pageMid);
    await frameManager.getFrames();
    frameManager.reOrdering();
    logger.fine('frameManager init complete');
    //frameManager.setSelected(0);  처음에 프레임에 선택되어 있지 않다.
  }

  FrameModel? getSelectedFrame() {
    PageModel? pageModel = getSelected() as PageModel?;
    if (pageModel == null) {
      return null;
    }
    FrameManager? frameManager = frameManagerMap[pageModel.mid];
    if (frameManager == null) {
      return null;
    }
    return frameManager.getSelected() as FrameModel?;
  }

  FrameManager? getSelectedFrameManager() {
    PageModel? pageModel = getSelected() as PageModel?;
    if (pageModel == null) {
      logger.severe('pageModel is null');
      return null;
    }
    FrameManager? frameManager = frameManagerMap[pageModel.mid];
    if (frameManager == null) {
      logger.severe('frameManager is null');
      return null;
    }
    FrameModel? frameModel = frameManager.getSelected() as FrameModel?;
    if (frameModel != null && frameModel.isOverlay.value == true
        //&& frameModel.parentMid.value == pageModel.mid
        ) {
      // overlay 의 경우이다.
      logger.warning('this is overlay case');
      frameManager = frameManagerMap[frameModel.parentMid.value];
    }

    return frameManager;
  }

  Future<PageModel> createNextPage(int pageIndex) async {
    PageModel defaultPage =
        PageModel.makeSample(bookModel!, safeLastOrder() + 1, bookModel!.mid, pageIndex);
    await _createNextPage(defaultPage);
    MyChange<PageModel> c = MyChange<PageModel>(
      defaultPage,
      execute: () async {},
      redo: () async {
        await _redoCreateNextPage(defaultPage);
      },
      undo: (PageModel old) async {
        await _undoCreateNextPage(old);
      },
    );
    mychangeStack.add(c);
    return defaultPage;
  }

  Future<PageModel> _createNextPage(PageModel defaultPage) async {
    //PageModel defaultPage = PageModel.makeSample(safeLastOrder() + 1, bookModel!.mid);
    defaultPage.isRemoved.set(false, noUndo: true, save: false);
    await createToDB(defaultPage);
    insert(defaultPage, postion: getLength());
    //selectedMid = defaultPage.mid;
    setSelectedMid(defaultPage.mid);
    return defaultPage;
  }

  Future<PageModel> _redoCreateNextPage(PageModel defaultPage) async {
    //PageModel defaultPage = PageModel.makeSample(safeLastOrder() + 1, bookModel!.mid);
    defaultPage.isRemoved.set(false, noUndo: true, save: false);
    await setToDB(defaultPage);
    insert(defaultPage, postion: getLength());
    //selectedMid = defaultPage.mid;
    setSelectedMid(defaultPage.mid);
    return defaultPage;
  }

  Future<PageModel> _undoCreateNextPage(PageModel old) async {
    //PageModel defaultPage = PageModel.makeSample(safeLastOrder() + 1, bookModel!.mid);
    old.isRemoved.set(true, noUndo: true, save: false);
    if (selectedMid == old.mid) {
      gotoPrev();
    }
    // 반드시 gotoPrev 하고 나서 remove 해야 함.
    remove(old);
    await setToDB(old);
    return old;
  }

  bool gotoFirst() {
    String? mid = getFirstMid();
    if (mid != null) {
      //if (selectedMid != mid) {
      setSelectedMid(mid, doNotify: false);
      return true;
      //}
    }
    return false;
  }

  bool gotoNext({bool loop = true}) {
    _prevModel = getSelected() as PageModel?;
    _transitForward = true;

    String? mid = getNextMid(loop: loop);
    return _movePage(mid);
  }

  bool gotoPrev({bool loop = true}) {
    _prevModel = getSelected() as PageModel?;
    _transitForward = false;

    String? mid = getPrevMid(loop: loop);
    return _movePage(mid);
  }

  bool _movePage(String? mid) {
    if (mid != null) {
      //DraggableStickers.isFrontBackHover = false;
      //notify();
      if (StudioVariables.isPreview == true) {
        // 프리뷰 모드에서만, pageTransition 이 동작한다.
        // PageModel? model = getModelByMid(mid) as PageModel?;
        // if (model != null &&
        //     (model.transitionEffect.value > 0 || model.transitionEffect2.value > 0)) {
        //   Future.delayed(model.getPageDuration(), () {
        //     setSelectedMid(mid);
        //   });
        //   return true;
        // }
      }
      setSelectedMid(mid);
      return true;
    }
    return false;
  }

  String? getFirstMid() {
    Iterable<double> keys = orderKeys().toList();
    for (double ele in keys) {
      PageModel? pageModel = getNth(ele) as PageModel?;
      if (pageModel == null) {
        continue;
      }
      if (pageModel.isShow.value == false) {
        continue;
      }
      return getNthMid(ele);
    }
    // for (double ele in keys) {
    //   PageModel? pageModel = getNth(ele) as PageModel?;
    //   if (pageModel == null) {
    //     continue;
    //   }
    //   return getNthMid(ele);
    // }
    return null;
  }

  String? getNextMid({bool loop = true}) {
    double selectedOrder = getSelectedOrder();
    String? retval = _getNextMid(selectedOrder, false);
    if (retval != null) {
      return retval;
    }
    // 처음부터 다시 시작한다.
    if (loop) {
      if (onGotoNextBook != null) {
        onGotoNextBook?.call();
        return null;
      }
      return _getNextMid(-1, true);
    }
    return null;
  }

  String? _getNextMid(double selectedOrder, bool startToFirst) {
    bool matched = startToFirst;
    logger.fine('selectedOrder=$selectedOrder');
    // if (selectedOrder < 0) {
    //   return null;
    // }
    Iterable<double> keys = orderKeys().toList();
    for (double ele in keys) {
      if (matched == true) {
        PageModel? pageModel = getNth(ele) as PageModel?;
        if (pageModel == null) {
          continue;
        }
        if (BookMainPage.filterManagerHolder!.isVisible(pageModel) == false) {
          continue;
        }

        if (pageModel.isShow.value == false) {
          if (pageModel.isTempVisible == false) {
            continue;
          }
          if (pageModel.mid != LinkParams.connectedMid) {
            continue;
          }
        }

        return getNthMid(ele);
      }
      if (selectedOrder > 0 && ele == selectedOrder) {
        matched = true;
        continue;
      }
    }
    if (matched == true) {
      // 끝까지 온것이다.  이 경우는 페이지를 넘기는 것이기 때문에 돌지 않는다.
      //      return getNthMid(keys.first);
      return null;
    }
    return null;
  }

  String? getPrevMid({bool loop = true}) {
    double selectedOrder = getSelectedOrder();
    String? retval = _getPrevMid(selectedOrder, false);
    if (retval != null) {
      return retval;
    }
    // 마지막으로 돌아간다
    if (loop) {
      if (onGotoPrevBook != null) {
        onGotoPrevBook?.call();
        return null;
      }
      return _getPrevMid(-1, true);
    }
    return null;
  }

  String? _getPrevMid(double selectedOrder, bool startToFirst) {
    bool matched = startToFirst;
    //double selectedOrder = getSelectedOrder();
    // if (selectedOrder < 0) {
    //   return null;
    // }
    Iterable<double> keys = orderKeys().toList().reversed;
    for (double ele in keys) {
      if (matched == true) {
        PageModel? pageModel = getNth(ele) as PageModel?;
        if (pageModel == null) {
          continue;
        }
        if (BookMainPage.filterManagerHolder!.isVisible(pageModel) == false) {
          continue;
        }

        if (pageModel.isShow.value == false) {
          continue;
        }
        return pageModel.mid;
      }
      if (selectedOrder > 0 && ele == selectedOrder) {
        matched = true;
        continue;
      }
    }
    if (matched == true) {
      // 끝까지 온것이다.  이 경우는 페이지를 넘기는 것이기 때문에 돌지 않는다.
      //      return getNthMid(keys.first);
      return null;
    }
    return null;
  }

  bool isVisible(double order) {
    return true;
  }

  Future<int> getPages() async {
    int pageCount = 0;
    startTransaction();
    try {
      pageCount = await _getPages();
      if (pageCount == 0) {
        await createNextPage(1);
        pageCount = 1;
      }
    } catch (e) {
      logger.finest('something wrong $e');
      await createNextPage(1);
      pageCount = 1;
    }
    endTransaction();
    return pageCount;
  }

  Future<int> _getPages({int limit = 99}) async {
    logger.finest('getPages');
    Map<String, QueryValue> query = {};
    query['parentMid'] = QueryValue(value: bookModel!.mid);
    query['isRemoved'] = QueryValue(value: false);
    Map<String, OrderDirection> orderBy = {};
    orderBy['order'] = OrderDirection.ascending;
    await queryFromDB(query, orderBy: orderBy, limit: limit);
    logger.finest('getPages ${modelList.length}');
    return modelList.length;
  }

  void subcribe() {
    lock();
    for (var ele in modelList) {
      PageModel model = ele as PageModel;
      BookMainPage.clickEventHandler.subscribeList(
        model.eventReceive.value,
        model,
        null,
        this,
      );
    }
    unlock();
  }

  void resetPageSize() {
    lock();
    if (bookModel == null) return;
    for (var ele in modelList) {
      PageModel pageModel = ele as PageModel;
      pageModel.width.set(bookModel!.width.value, save: false, noUndo: true);
      pageModel.height.set(bookModel!.height.value, save: false, noUndo: true);
    }
    unlock();
  }

  @override
  Future<void> removeChild(String parentMid) async {
    FrameManager? frameManager = frameManagerMap[parentMid];
    await frameManager?.removeAll();
    removeLink(parentMid);
  }

  @override
  Future<int> copyBook(String newBookMid, String? newParentMid) async {
    // 이미, publish 되어 있다면, 해당 mid 를 가져와야 한다.
    lock();
    int counter = 0;
    oldNewMap.clear();
    for (var ele in modelList) {
      if (ele.isRemoved.value == true) {
        continue;
      }
      AbsExModel newOne = await makeCopy(newBookMid, ele, newParentMid);
      oldNewMap[ele.mid] = newOne.mid;
    }
    for (var entry in oldNewMap.entries) {
      FrameManager? frameManager = findFrameManager(entry.key);
      await frameManager?.copyBook(newBookMid, entry.value);
      counter++;
    }
    oldNewMap.clear();
    unlock();
    return counter;
  }

  FrameModel? findFrameByPos(Offset pos) {
    PageModel? pageModel = getSelected() as PageModel?;
    if (pageModel == null) {
      return null;
    }
    FrameManager? frameManager = findFrameManager(pageModel.mid);
    if (frameManager == null) {
      return null;
    }
    return frameManager.findFrameByPos(pos);
  }

  void removeLink(String mid) {
    logger.fine('removeLink---------------FrameManager');
    for (var manager in frameManagerMap.values) {
      manager?.removeLink(mid);
    }
  }

  // FrameManager? getMainFrame() {
  //   // mian frame 이 지정되어 있지 않다면, show 된 것 중 가장 앞에 있는 것을 리턴한다.
  //   PageModel? pageModel = getSelected() as PageModel?;
  //   if (pageModel == null) {
  //     return null;
  //   }
  //   FrameManager? frameManager = findFrameManager(pageModel.mid);
  //   if (frameManager == null) {
  //     return null;
  //   }
  //   FrameModel? frame = frameManager.getMainFrame();
  //   if (frame == null) {
  //     return null;
  //   }
  //   ContentsManager? contentsManager = frameManager.getContentsManager(frame.mid);

  //   return null;
  // }

  double nextOrder(double currentOrder, {bool alwaysOneExist = false}) {
    bool matched = false;

    late Iterable<double> keys = orderKeys();

    for (double ele in keys) {
      if (matched == true) {
        return ele;
      }
      if (ele == currentOrder) {
        matched = true;
        continue;
      }
    }
    if (matched == true) {
      // 끝까지 온것이다.  처음으로 돌아간다.
      return keys.first;
    }
    return -1;
  }

  double prevOrder(double currentOrder) {
    bool matched = false;
    late Iterable<double> keys = orderKeys().toList().reversed;

    for (double ele in keys) {
      if (matched == true) {
        return ele;
      }
      if (ele == currentOrder) {
        matched = true;
        continue;
      }
    }
    if (matched == true) {
      return keys.first;
    }
    return -1;
  }

  Future<PageModel> copyPage(PageModel src,
      {PageManager? srcPageManager, double? targetOrder}) async {
    //print('copyPage**************--------------------------');

    PageModel newModel = PageModel('', bookModel!);
    newModel.copyFrom(src, newMid: newModel.mid);

    double srcOrder = src.order.value;
    if (targetOrder != null) {
      srcOrder = targetOrder;
    }

    double nextOrderVal = nextOrder(srcOrder);
    if (nextOrderVal <= srcOrder) {
      nextOrderVal = srcOrder + 1;
    } else {
      nextOrderVal = (nextOrderVal + srcOrder) / 2;
    }

    newModel.order.set(nextOrderVal, save: false, noUndo: false);
    //newModel.isRemoved.set(false, save: false, noUndo: true);
    newModel.name.set('${src.name.value}${CretaLang.copyOf}', save: false, noUndo: false);
    logger.fine('create new page ${newModel.mid}');

    if (srcPageManager != null) {
      FrameManager? frameManager = srcPageManager.findFrameManager(src.mid);
      await frameManager?.copyFrames(newModel.mid, bookModel!.mid, samePage: false);
    } else {
      FrameManager? frameManager = findFrameManager(src.mid);
      await frameManager?.copyFrames(newModel.mid, bookModel!.mid);
    }

    await _createNextPage(newModel);
    MyChange<PageModel> c = MyChange<PageModel>(
      newModel,
      execute: () async {},
      redo: () async {
        await _redoCreateNextPage(newModel);
      },
      undo: (PageModel old) async {
        await _undoCreateNextPage(old);
      },
    );
    mychangeStack.add(c);

    // await createToDB(newModel);
    // insert(newModel, postion: getLength());
    // selectedMid = newModel.mid;
    return newModel;
  }

  List<Node> toNodes(PageModel? selectedModel) {
    //print('invoke pageMangaer.toNodes()');
    List<Node> nodes = [];
    //  Node(
    //       label: 'documents',
    //       key: 'docs',
    //       expanded: docsOpen,
    //       // ignore: dead_code
    //       icon: docsOpen ? Icons.folder_open : Icons.folder,
    //       children: [ ]
    //  );
    int pageNo = 1;
    for (var ele in orderValues()) {
      PageModel model = ele as PageModel;
      if (model.isRemoved.value == true) {
        continue;
      }
      //String pageNo = (model.order.value + 1).toString().padLeft(2, '0');
      String desc = model.name.value;
      List<Node> accNodes = [];
      FrameManager? frameManager = findFrameManager(model.mid);
      if (frameManager != null) {
        accNodes = frameManager.toNodes(model);
      }
      nodes.add(Node<CretaModel>(
        key: model.mid,
        keyType: ContaineeEnum.Page,
        label: 'Page ${pageNo.toString().padLeft(2, '0')}. $desc',
        data: model,
        expanded: (selectedModel != null && model.mid == selectedModel.mid) || model.expanded,
        children: accNodes,
        root: model.mid,
      ));
      pageNo++;
    }
    return nodes;
  }

  String toJson() {
    BookManager.contentsUrlMap.clear();
    if (getAvailLength() == 0) {
      return ',\n\t"pages" : []\n';
    }
    String jsonStr = '';
    int pageCount = 0;
    jsonStr += ',\n\t"pages" : [\n';
    orderMapIterator((val) {
      PageModel page = val as PageModel;
      String pageStr = page.toJson(tab: '\t');
      if (pageCount > 0) {
        jsonStr += ',\n';
      }
      FrameManager? frameManager = findFrameManager(page.mid);
      if (frameManager != null) {
        pageStr += frameManager.toJson();
      }
      jsonStr += '\t{\n$pageStr\n\t}';
      pageCount++;
      return null;
    });
    jsonStr += '\n\t]\n';
    return jsonStr;
  }

  void removePage(PageModel model) {
    model.isRemoved.set(true);
    if (isSelected(model.mid)) {
      if (gotoNext(loop: false) == false) {
        gotoPrev();
      }
    } else {
      notify();
    }
    BookMainPage.containeeNotifier!.set(ContaineeEnum.Page);
    LeftMenuPage.treeInvalidate();

    //mychangeStack.startTrans();
    // model.isRemoved.set(
    //   true,
    //   doComplete: (val) {
    //     print('removePage doComplete');
    //     if (isSelected(model.mid)) {
    //       if (gotoNext(loop: false) == false) {
    //         gotoPrev();
    //       }
    //     }
    //   },
    // );
    // removeChild(model.mid).then((value) {
    //   mychangeStack.endTrans();
    //   if (isSelected(model.mid)) {
    //     if (gotoNext(loop: false) == false) {
    //       gotoPrev();
    //     }
    //   }
    //   //print('removePage');
    //   notify();
    //   LeftMenuPage.treeInvalidate();
    //   return;
    // });

    return;
  }

  int getPageIndex(String pageMid) {
    int pageIndex = -1;

    late Iterable<CretaModel> values = orderValues();

    for (CretaModel ele in values) {
      pageIndex++;
      if (ele.mid == pageMid) {
        break;
      }
    }
    return pageIndex;
  }

  Future<bool> removeSelected(BuildContext context) async {
    PageModel? model = getSelected() as PageModel?;
    if (model == null) {
      showSnackBar(context, CretaLang.pageNotSelected, duration: StudioConst.snackBarDuration);
      await Future.delayed(StudioConst.snackBarDuration);
      return false;
    }

    mychangeStack.startTrans();
    model.isRemoved.set(true);
    await removeChild(model.mid);
    BookMainPage.containeeNotifier!.set(ContaineeEnum.Book, doNoti: true);
    BookMainPage.pageManagerHolder!.notify();
    mychangeStack.endTrans();
    return true;
  }

  Future<bool> makeClone(
    BookModel newBook, {
    bool cloneToPublishedBook = false,
  }) async {
    for (var page in modelList) {
      AbsExModel newModel = await makeCopy(newBook.mid, page, newBook.mid);
      logger.info('clone is created ($collectionId.${newModel.mid}) from (source:${page.mid})');
      BookManager.clonePageIdMap[page.mid] = newModel.mid;
      logger.info('page: (${page.mid}) => (${newModel.mid})');
    }
    final BookModel dummyBook = BookModel('');
    final PageModel dummyPage = PageModel('', dummyBook);
    final FrameManager copyFrameManagerHolder = cloneToPublishedBook
        ? FrameManager(
            bookModel: dummyBook,
            pageModel: dummyPage,
            tableName: 'creta_frame_published',
            isPublishedMode: true)
        : FrameManager(bookModel: dummyBook, pageModel: dummyPage, isPublishedMode: true);
    //frameManagerMap.forEach((key, value) { }); ==> forEach는 await 처리가 불가능
    for (MapEntry entry in frameManagerMap.entries) {
      if (entry.value != null) {
        copyFrameManagerHolder.modelList = [...entry.value.modelList];
        copyFrameManagerHolder.contentsManagerMap = Map.from(entry.value.contentsManagerMap);
        await copyFrameManagerHolder.makeClone(
          newBook,
          cloneToPublishedBook: cloneToPublishedBook,
        );
      }
    }
    return true;
  }
}
