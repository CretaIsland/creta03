import 'package:hycop/common/undo/save_manager.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/database/abs_database.dart';
import '../model/book_model.dart';
import '../model/creta_model.dart';
import '../model/frame_model.dart';
import '../model/page_model.dart';
import 'creta_manager.dart';

//FrameManager? frameManagerHolder;

class FrameManager extends CretaManager {
  PageModel? pageModel;
  BookModel? bookModel;

  void setBookAndPage(BookModel? book, PageModel? page) {
    bookModel = book;
    pageModel = page;
  }

  FrameManager() : super('creta_frame') {
    saveManagerHolder?.registerManager('frame', this);
  }

  @override
  AbsExModel newModel(String mid) => FrameModel(mid);

  @override
  CretaModel cloneModel(CretaModel src) {
    FrameModel retval = newModel(src.mid) as FrameModel;
    src.copyTo(retval);
    return retval;
  }

  Future<FrameModel> createNextFrame() async {
    updateLastOrder();
    FrameModel defaultFrame = FrameModel.makeSample(++lastOrder, pageModel!.mid);
    await createToDB(defaultFrame);
    insert(defaultFrame, postion: getAvailLength());
    selectedMid = defaultFrame.mid;
    return defaultFrame;
  }

  Future<int> getFrames({int limit = 99}) async {
    logger.finest('getFrames');
    Map<String, QueryValue> query = {};
    query['parentMid'] = QueryValue(value: pageModel!.mid);
    query['isRemoved'] = QueryValue(value: false);
    Map<String, OrderDirection> orderBy = {};
    orderBy['order'] = OrderDirection.ascending;
    await queryFromDB(query, orderBy: orderBy, limit: limit);
    logger.finest('getFrames ${modelList.length}');
    updateLastOrder();
    return modelList.length;
  }
}
