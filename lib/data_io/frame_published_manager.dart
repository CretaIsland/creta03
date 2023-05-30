import 'package:hycop/hycop/absModel/abs_ex_model.dart';

import '../model/creta_model.dart';
import '../model/frame_model.dart';
import 'contents_manager.dart';
import 'contents_published_manager.dart';
import 'creta_manager.dart';
import 'frame_manager.dart';

class FramePublishedManager extends CretaManager {
  final FrameManager frameManager;
  FramePublishedManager(this.frameManager) : super('creta_frame_published');

  @override
  CretaModel cloneModel(CretaModel src) {
    FrameModel retval = newModel(src.mid) as FrameModel;
    src.copyTo(retval);
    return retval;
  }

  @override
  AbsExModel newModel(String mid) => FrameModel(mid);

  @override
  Future<int> makeCopyAll(String? newParentMid) async {
    lock();
    int counter = 0;
    for (var ele in frameManager.modelList) {
      if (ele.isRemoved.value == true) {
        continue;
      }
      AbsExModel newOne = await makeCopy(ele, newParentMid);
      ContentsManager? contentsManager = frameManager.findContentsManager(ele.mid);
      if (contentsManager == null) {
        continue;
      }
      ContentsPublishedManager publishedManager = ContentsPublishedManager(contentsManager);
      await publishedManager.makeCopyAll(newOne.mid);
      counter++;
    }
    unlock();
    return counter;
  }
}