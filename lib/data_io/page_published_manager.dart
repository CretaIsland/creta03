import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/database/abs_database.dart';

import 'package:creta_studio_model/model/book_model.dart';
import 'package:creta_common/model/creta_model.dart';
import 'package:creta_studio_model/model/page_model.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';
import 'frame_manager.dart';
import 'frame_published_manager.dart';
import 'page_manager.dart';

class PagePublishedManager extends CretaManager {
  final PageManager? pageManager;
  final BookModel? bookModel;

  static Map<String, String> oldNewMap = {}; // linkCopy 시에 필요하다.

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
  Future<int> copyBook(String newBookMid, String? newParentMid) async {
    lock();
    int counter = 0;
    for (var ele in pageManager!.modelList) {
      if (ele.isRemoved.value == true) {
        continue;
      }
      //PageModel model = ele as PageModel;
      AbsExModel newOne = await makeCopy(newBookMid, ele, newParentMid);
      oldNewMap[ele.mid] = newOne.mid;
    }
    for (var entry in oldNewMap.entries) {
      //print('publish page ${newOne.mid}, ${model.name.value}, ${model.isRemoved.value}');
      FrameManager? frameManager = pageManager!.findFrameManager(entry.key);
      if (frameManager == null) {
        continue;
      }
      FramePublishedManager publishedManager = FramePublishedManager(frameManager);
      await publishedManager.copyBook(newBookMid, entry.value);
      counter++;
    }
    oldNewMap.clear(); // LinkCopy 가 끝났으므로 지운다.
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
