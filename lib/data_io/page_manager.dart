// ignore_for_file: prefer_final_fields

import 'package:hycop/common/undo/save_manager.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/database/abs_database.dart';
import '../model/book_model.dart';
import '../model/creta_model.dart';
import '../model/frame_model.dart';
import '../model/page_model.dart';
import 'creta_manager.dart';
import 'frame_manager.dart';

//PageManager? pageManagerHolder;

class PageManager extends CretaManager {
  BookModel? bookModel;
  Map<String, FrameManager?> frameManagerList = {};

  PageManager() : super('creta_page') {
    saveManagerHolder?.registerManager('page', this);
  }
  void setBook(BookModel book) {
    bookModel = book;
  }

  Future<void> initPage(BookModel bookModel) async {
    setBook(bookModel);
    clearAll();
    addRealTimeListen();
    await getPages();
    setSelected(0);
  }

  void clearFrame() {
    logger.severe('clearFrame');
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

  FrameManager newFrame(BookModel bookModel, PageModel pageModel) {
    FrameManager retval = FrameManager(
      bookModel: bookModel,
      pageModel: pageModel,
    );
    frameManagerList[pageModel.mid] = retval;
    return retval;
  }

  Future<void> initFrame(FrameManager frameManager) async {
    frameManager.clearAll();
    frameManager.addRealTimeListen();
    await frameManager.getFrames();
    frameManager.setSelected(0);
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
      return null;
    }
    FrameManager? frameManager = frameManagerList[pageModel.mid];
    return frameManager;
  }

  @override
  CretaModel cloneModel(CretaModel src) {
    PageModel retval = newModel(src.mid) as PageModel;
    src.copyTo(retval);
    return retval;
  }

  @override
  AbsExModel newModel(String mid) => PageModel(mid);

  Future<PageModel> createNextPage() async {
    updateLastOrder();
    PageModel defaultPage = PageModel.makeSample(++lastOrder, bookModel!.mid);
    await createToDB(defaultPage);
    insert(defaultPage, postion: getAvailLength());
    selectedMid = defaultPage.mid;
    return defaultPage;
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
    updateLastOrder();
    return modelList.length;
  }
}
