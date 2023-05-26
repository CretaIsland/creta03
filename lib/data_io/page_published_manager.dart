import 'package:hycop/hycop/absModel/abs_ex_model.dart';

import '../model/creta_model.dart';
import '../model/page_model.dart';
import 'creta_manager.dart';
import 'frame_manager.dart';
import 'frame_published_manager.dart';
import 'page_manager.dart';

class PagePublishedManager extends CretaManager {
  final PageManager pageManager;
  PagePublishedManager(this.pageManager) : super('creta_page_published');

  @override
  CretaModel cloneModel(CretaModel src) {
    PageModel retval = newModel(src.mid) as PageModel;
    src.copyTo(retval);
    return retval;
  }

  @override
  AbsExModel newModel(String mid) => PageModel(mid);

  @override
  Future<int> makeCopyAll(String? newParentMid) async {
    lock();
    int counter = 0;
    for (var ele in pageManager.modelList) {
      if (ele.isRemoved.value == true) {
        continue;
      }
      AbsExModel newOne = await makeCopy(ele, newParentMid);
      FrameManager? frameManager = pageManager.findFrameManager(ele.mid);
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
}
