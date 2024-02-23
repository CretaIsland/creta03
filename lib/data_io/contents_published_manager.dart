import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/database/abs_database.dart';

import 'package:creta_studio_model/model/contents_model.dart';
import 'package:creta_common/model/creta_model.dart';
import 'contents_manager.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';
import 'link_manager.dart';
import 'link_published_manager.dart';

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
  Future<int> copyBook(String newBookMid, String? newParentMid) async {
    lock();
    int counter = 0;
    for (var ele in contentsManager!.modelList) {
      if (ele.isRemoved.value == true) {
        continue;
      }
      AbsExModel newOne = await makeCopy(newBookMid, ele, newParentMid);
      LinkManager? linkManager = contentsManager!.findLinkManager(ele.mid);
      if (linkManager == null) {
        continue;
      }
      LinkPublishedManager publishedManager = LinkPublishedManager(linkManager);
      await publishedManager.copyBook(newBookMid, newOne.mid);
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

      // link 도 지원준다.
      LinkPublishedManager childManager = LinkPublishedManager(null);
      childManager.removeChild(ele.parentMid.value);
    }
    modelList.clear();
  }
}
