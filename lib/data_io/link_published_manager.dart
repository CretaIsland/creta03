import 'package:creta03/data_io/page_published_manager.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/database/abs_database.dart';

import 'package:creta_studio_model/model/frame_model.dart';
import 'package:creta_studio_model/model/link_model.dart';
import 'package:creta_common/model/creta_model.dart';
import 'frame_published_manager.dart';
import 'link_manager.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';

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
      await makeCopy(newBookMid, ele, newParentMid) as LinkModel;
      counter++;
    }
    unlock();
    return counter;
  }

  @override
  Future<AbsExModel> makeCopy(String newBookMid, AbsExModel src, String? newParentMid) async {
    // 이미, publish 되어 있다면, 해당 mid 를 가져와야 한다.
    LinkModel newOne = newModel('') as LinkModel;

    // creat_book_published data 를 만든다.
    newOne.copyFrom(src, newMid: newOne.mid, pMid: newParentMid ?? newOne.parentMid.value);
    newOne.setRealTimeKey(newBookMid);
    //print('makeCopy : newMid=${newOne.mid}, parent=$newParentMid');

    LinkModel oldOne = src as LinkModel;

    //print('connectedClass = ${newOne.connectedClass}, ${oldOne.connectedClass}');

    if (oldOne.connectedClass == 'page') {
      newOne.connectedMid = PagePublishedManager.oldNewMap[oldOne.connectedMid] ?? '';
      //print('page link connectedMid = ${oldOne.connectedMid} --> ${newOne.connectedMid}');
    } else if (oldOne.connectedClass == 'frame') {
      FrameModel? frame = FramePublishedManager.findNew(oldOne.connectedMid);
      if (frame != null) {
        newOne.connectedMid = frame.mid;
      } else {
        newOne.connectedMid = '';
      }
      //print('frame link connectedMid = ${oldOne.connectedMid} --> ${newOne.connectedMid}');
    }

    await createToDB(newOne);
    return newOne;
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
