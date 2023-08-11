import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/database/abs_database.dart';

import '../model/contents_model.dart';
import '../model/creta_model.dart';
import 'contents_manager.dart';
import 'creta_manager.dart';

class ContentsPublishedManager extends CretaManager {
  final ContentsManager? contentsManager;
  ContentsPublishedManager(this.contentsManager) : super('creta_contents_published', null);

  @override
  CretaModel cloneModel(CretaModel src) {
    ContentsModel retval = newModel(src.mid) as ContentsModel;
    src.copyTo(retval);
    return retval;
  }

  @override
  AbsExModel newModel(String mid) => ContentsModel(mid, '');

  @override
  Future<int> makeCopyAll(String? newParentMid) async {
    lock();
    int counter = 0;
    for (var ele in contentsManager!.modelList) {
      if (ele.isRemoved.value == true) {
        continue;
      }
      await makeCopy(ele, newParentMid);
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
    // ignore: unused_local_variable
    final retval = await queryFromDB(query);
    for (var ele in retval) {
      print('removeChild ${ele.mid}');

      ele.isRemoved.set(true, save: false, noUndo: true);
      await setToDB(ele as CretaModel);
      // ContentsPublishedManager childManager = ContentsPublishedManager(null);
      // childManager.removeChild(ele.parentMid.value);
      // 여기서 Link 도 훗날 지워줘야 한다.
    }
    modelList.clear();
  }
}
