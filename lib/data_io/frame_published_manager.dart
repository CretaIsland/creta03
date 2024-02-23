import 'package:creta03/data_io/book_published_manager.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/database/abs_database.dart';

import 'package:creta_common/model/creta_model.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import 'contents_manager.dart';
import 'contents_published_manager.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';
import 'frame_manager.dart';

class FramePublishedManager extends CretaManager {
  final FrameManager? frameManager;
  FramePublishedManager(this.frameManager) : super('creta_frame_published', null);

  static Map<FrameModel, FrameModel> oldNewMap = {}; // linkCopy 시에 필요하다.
  static FrameModel? findNew(String oldMid) {
    for (var ele in oldNewMap.entries) {
      if (ele.key.mid == oldMid) {
        return ele.value;
      }
    }
    return null;
  }

  @override
  CretaModel cloneModel(CretaModel src) {
    FrameModel retval = newModel(src.mid) as FrameModel;
    src.copyTo(retval);
    return retval;
  }

  @override
  AbsExModel newModel(String mid) => FrameModel(mid, '');

  @override
  Future<int> copyBook(String newBookMid, String? newParentMid) async {
    lock();
    int counter = 0;
    oldNewMap.clear(); // LinkCopy 가 끝났으므로 지운다.
    for (var ele in frameManager!.modelList) {
      if (ele.isRemoved.value == true) {
        continue;
      }
      if (ele is FrameModel) {
        if (ele.isOverlay.value == true && ele.parentMid.value != frameManager?.pageModel.mid) {
          // parentMid(page)가 다른 page에서 overlay-frame은 복사하지 않는다  sevenstone
          continue;
        }
      }
      AbsExModel newOne = await makeCopy(newBookMid, ele, newParentMid);
      oldNewMap[ele as FrameModel] = newOne as FrameModel;
      //if (ele.mid == BookPublishedManager.srcBackgroundMusicFrame) {
      if (frameManager != null) {
        if (ele.mid == frameManager!.bookModel.backgroundMusicFrame.value) {
          BookPublishedManager.newbBackgroundMusicFrame = newOne.mid;
        }
      }
    }
    for (var entry in oldNewMap.entries) {
      ContentsManager contentsManager = frameManager!.findOrCreateContentsManager(entry.key);
      // if (contentsManager == null) {
      //   continue;
      // }
      ContentsPublishedManager publishedManager = ContentsPublishedManager(contentsManager);
      await publishedManager.copyBook(newBookMid, entry.value.mid);
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
      ContentsPublishedManager childManager = ContentsPublishedManager(null);
      await childManager.removeChild(ele.mid);
      ele.isRemoved.set(true, save: false, noUndo: true);
      await setToDB(ele as CretaModel);
    }
    modelList.clear();
  }
}
