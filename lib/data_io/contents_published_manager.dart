import 'package:hycop/hycop/absModel/abs_ex_model.dart';

import '../model/contents_model.dart';
import '../model/creta_model.dart';
import 'contents_manager.dart';
import 'creta_manager.dart';

class ContentsPublishedManager extends CretaManager {
  final ContentsManager contentsManager;
  ContentsPublishedManager(this.contentsManager) : super('creta_contents_published');

  @override
  CretaModel cloneModel(CretaModel src) {
    ContentsModel retval = newModel(src.mid) as ContentsModel;
    src.copyTo(retval);
    return retval;
  }

  @override
  AbsExModel newModel(String mid) => ContentsModel(mid);

  @override
  Future<int> makeCopyAll(String? newParentMid) async {
    lock();
    int counter = 0;
    for (var ele in contentsManager.modelList) {
      if (ele.isRemoved.value == true) {
        continue;
      }
      await makeCopy(ele, newParentMid);
      counter++;
    }
    unlock();
    return counter;
  }
}
