import 'package:hycop/hycop/absModel/abs_ex_model.dart';

import '../model/creta_model.dart';
import '../model/depot_model.dart';
import 'depot_manager.dart';
import 'creta_manager.dart';

class DepotPublishedManager extends CretaManager {
  final DepotManager depotManager;
  DepotPublishedManager(this.depotManager) : super('creta_depot_published', null);

  @override
  CretaModel cloneModel(CretaModel src) {
    DepotModel retval = newModel(src.mid) as DepotModel;
    src.copyTo(retval);
    return retval;
  }

  @override
  AbsExModel newModel(String mid) => DepotModel(mid);

  @override
  Future<int> makeCopyAll(String? newParentMid) async {
    lock();
    int counter = 0;
    for (var ele in depotManager.modelList) {
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
