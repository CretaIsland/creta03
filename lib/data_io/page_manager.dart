// ignore_for_file: prefer_final_fields

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hycop/common/undo/save_manager.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/database/abs_database.dart';
import '../model/book_model.dart';
import '../model/creta_model.dart';
import '../model/frame_model.dart';
import '../model/page_model.dart';
import '../pages/studio/book_main_page.dart';
import '../pages/studio/studio_variables.dart';
import 'creta_manager.dart';
import 'frame_manager.dart';

//PageManager? pageManagerHolder;

class PageManager extends CretaManager {
  BookModel? bookModel;
  Map<String, FrameManager?> frameManagerList = {};

  PageManager({String tableName = 'creta_page'}) : super(tableName) {
    saveManagerHolder?.registerManager('page', this);
  }
  @override
  CretaModel cloneModel(CretaModel src) {
    PageModel retval = newModel(src.mid) as PageModel;
    src.copyTo(retval);
    return retval;
  }

  @override
  AbsExModel newModel(String mid) => PageModel(mid);

  void setBook(BookModel book) {
    bookModel = book;
  }

  Future<void> initPage(BookModel bookModel) async {
    setBook(bookModel);
    clearAll();
    addRealTimeListen();
    await getPages();
    setSelected(0);
    subcribe();
  }

  void clearFrameManager() {
    logger.severe('clearFrameManager');
    for (FrameManager? ele in frameManagerList.values) {
      ele?.removeRealTimeListen();
    }
    for (String mid in frameManagerList.keys) {
      saveManagerHolder?.unregisterManager('frame', postfix: mid);
    }
  }

  FrameManager? findFrameManager(String pageMid) {
    return frameManagerList[pageMid];
  }

  FrameManager newFrameManager(BookModel bookModel, PageModel pageModel) {
    FrameManager retval = FrameManager(
      bookModel: bookModel,
      pageModel: pageModel,
    );
    frameManagerList[pageModel.mid] = retval;
    return retval;
  }

  Future<void> findOrInitAllFrameManager(BookModel bookModel) async {
    for (var ele in modelList) {
      if (ele.isRemoved.value == true) {
        continue;
      }
      PageModel pageModel = ele as PageModel;
      FrameManager? frameManager = BookMainPage.pageManagerHolder!.findFrameManager(pageModel.mid);
      if (frameManager != null) {
        continue;
      }
      frameManager = BookMainPage.pageManagerHolder!.newFrameManager(
        bookModel,
        pageModel,
      );
    }
    for (var frameManager in frameManagerList.values.toList()) {
      await initFrameManager(frameManager!);
      await frameManager.findOrInitContentsManager();
    }
    return;
  }

  Future<void> initFrameManager(FrameManager frameManager) async {
    frameManager.clearAll();
    frameManager.addRealTimeListen();
    await frameManager.getFrames();
    frameManager.reOrdering();
    logger.info('frameManager init complete');
    //frameManager.setSelected(0);  처음에 프레임에 선택되어 있지 않다.
  }

  FrameModel? getSelectedFrame() {
    PageModel? pageModel = getSelected() as PageModel?;
    if (pageModel == null) {
      return null;
    }
    FrameManager? frameManager = frameManagerList[pageModel.mid];
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
    FrameManager? frameManager = frameManagerList[pageModel.mid];
    if (frameManager == null) {
      logger.severe('frameManager is null');
      return null;
    }
    return frameManager;
  }

  Future<PageModel> createNextPage() async {
    PageModel defaultPage = PageModel.makeSample(safeLastOrder() + 1, bookModel!.mid);
    await createToDB(defaultPage);
    insert(defaultPage, postion: getLength());
    selectedMid = defaultPage.mid;
    return defaultPage;
  }

  bool gotoFirst() {
    logger.info('gotoFirst');
    String? mid = getFirstMid();
    if (mid != null) {
      //if (selectedMid != mid) {
      setSelectedMid(mid, doNotify: false);
      return true;
      //}
    }
    return false;
  }

  void gotoNext() {
    logger.info('gotoNext');
    String? mid = getNextMid();
    if (mid != null) {
      setSelectedMid(mid);
    }
  }

  void gotoPrev() {
    logger.info('gotoPrev');
    String? mid = getPrevMid();
    if (mid != null) {
      setSelectedMid(mid);
    }
  }

  String? getFirstMid() {
    Iterable<double> keys = keyEntries().toList();
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

  String? getNextMid() {
    bool matched = false;
    double selectedOrder = getSelectedOrder();
    logger.info('selectedOrder=$selectedOrder');
    if (selectedOrder < 0) {
      return null;
    }
    Iterable<double> keys = keyEntries().toList();
    for (double ele in keys) {
      if (matched == true) {
        PageModel? pageModel = getNth(ele) as PageModel?;
        if (pageModel == null) {
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
      if (ele == selectedOrder) {
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

  String? getPrevMid() {
    bool matched = false;
    double selectedOrder = getSelectedOrder();
    if (selectedOrder < 0) {
      return null;
    }
    logger.info('selectedOrder=$selectedOrder');
    Iterable<double> keys = keyEntries().toList().reversed;
    for (double ele in keys) {
      if (matched == true) {
        PageModel? pageModel = getNth(ele) as PageModel?;
        if (pageModel == null) {
          continue;
        }
        if (pageModel.isShow.value == false) {
          continue;
        }
        return getNthMid(ele);
      }
      if (ele == selectedOrder) {
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
        await createNextPage();
        pageCount = 1;
      }
    } catch (e) {
      logger.finest('something wrong $e');
      await createNextPage();
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
    FrameManager? frameManager = frameManagerList[parentMid];
    await frameManager?.removeAll();
  }

  @override
  Future<int> makeCopyAll(String? newParentMid) async {
    // 이미, publish 되어 있다면, 해당 mid 를 가져와야 한다.
    lock();
    int counter = 0;
    for (var ele in modelList) {
      if (ele.isRemoved.value == true) {
        continue;
      }
      AbsExModel newOne = await makeCopy(ele, newParentMid);
      FrameManager? frameManager = findFrameManager(ele.mid);
      await frameManager?.makeCopyAll(newOne.mid);
      counter++;
    }
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
}
