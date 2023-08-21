import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/database/abs_database.dart';

import '../model/book_model.dart';
import '../model/creta_model.dart';
import '../model/page_model.dart';
import 'creta_manager.dart';
import 'frame_manager.dart';
import 'frame_published_manager.dart';
import 'page_manager.dart';

class PagePublishedManager extends CretaManager {
  final PageManager? pageManager;
  final BookModel? bookModel;
  PagePublishedManager(this.pageManager, this.bookModel) : super('creta_page_published', null);

  @override
  CretaModel cloneModel(CretaModel src) {
    PageModel retval = newModel(src.mid) as PageModel;
    src.copyTo(retval);
    return retval;
  }

  @override
  AbsExModel newModel(String mid) => PageModel(mid, bookModel!);

  @override
  Future<int> makeCopyAll(String? newParentMid) async {
    lock();
    int counter = 0;
    for (var ele in pageManager!.modelList) {
      if (ele.isRemoved.value == true) {
        continue;
      }
      AbsExModel newOne = await makeCopy(ele, newParentMid);
      FrameManager? frameManager = pageManager!.findFrameManager(ele.mid);
      if (frameManager == null) {
        continue;
      }
      FramePublishedManager publishedManager = FramePublishedManager(frameManager);
      await publishedManager.makeCopyAll(newOne.mid);
      counter++;
    }
    unlock();
    return counter;
  }

  @override
  Future<void> removeChild(String parentMid) async {
    Map<String, QueryValue> query = {};
    query['parentMid'] = QueryValue(value: parentMid);
    query['isRemoved'] = QueryValue(value: false);
    final retval = await queryFromDB(query);
    for (var ele in retval) {
      //print('removeChild ${ele.mid}');

      FramePublishedManager childManager = FramePublishedManager(null);
      await childManager.removeChild(ele.mid);
      ele.isRemoved.set(true, save: false, noUndo: true);
      await setToDB(ele as CretaModel);

      // 여기서 Link 도 훗날 지워줘야 한다.
    }
    modelList.clear();
  }
}
