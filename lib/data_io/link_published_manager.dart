import 'package:creta03/data_io/page_published_manager.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/database/abs_database.dart';

import '../model/frame_model.dart';
import '../model/link_model.dart';
import '../model/creta_model.dart';
import 'frame_published_manager.dart';
import 'link_manager.dart';
import 'creta_manager.dart';

class LinkPublishedManager extends CretaManager {
  final LinkManager? linkManager;
  LinkPublishedManager(this.linkManager) : super('creta_link_published', null);

  @override
  CretaModel cloneModel(CretaModel src) {
    LinkModel retval = newModel(src.mid) as LinkModel;
    src.copyTo(retval);
    return retval;
  }

  @override
  AbsExModel newModel(String mid) => LinkModel(mid, '');

  @override
  Future<int> copyBook(String newBookMid, String? newParentMid) async {
    lock();
    int counter = 0;
    for (var ele in linkManager!.modelList) {
      if (ele.isRemoved.value == true) {
        continue;
      }
      LinkModel oldOne = ele as LinkModel;
      LinkModel newOne = await makeCopy(newBookMid, oldOne, newParentMid) as LinkModel;
      if (newOne.connectedClass == 'page') {
        newOne.connectedMid = PagePublishedManager.oldNewMap[oldOne.connectedMid] ?? '';
      } else if (newOne.connectedClass == 'frame') {
        FrameModel? frame = FramePublishedManager.findNew(oldOne.connectedMid);
        if (frame != null) {
          newOne.connectedMid = frame.mid;
        } else {
          newOne.connectedMid = '';
        }
      }
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
      //print('removeChild ${ele.mid}');

      ele.isRemoved.set(true, save: false, noUndo: true);
      await setToDB(ele as CretaModel);
      // LinkPublishedManager childManager = LinkPublishedManager(null);
      // childManager.removeChild(ele.parentMid.value);
      // 여기서 Link 도 훗날 지워줘야 한다.
    }
    modelList.clear();
  }
}
