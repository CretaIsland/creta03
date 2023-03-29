import 'package:flutter/material.dart';
import 'package:hycop/common/undo/save_manager.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/database/abs_database.dart';
import '../model/book_model.dart';
import '../model/contents_model.dart';
import '../model/creta_model.dart';
import '../model/frame_model.dart';
import '../model/page_model.dart';
import 'contents_manager.dart';
import 'creta_manager.dart';

//FrameManager? frameManagerHolder;

class FrameManager extends CretaManager {
  PageModel pageModel;
  BookModel bookModel;
  //Map<String, ValueKey> frameKeyMap = {};
  Map<String, GlobalKey> frameKeyMap = {};

  ContentsManager? contentsManager;

  FrameManager({required this.pageModel, required this.bookModel}) : super('creta_frame') {
    saveManagerHolder?.registerManager('frame', this, postfix: pageModel.mid);
  }

  @override
  AbsExModel newModel(String mid) => FrameModel(mid);

  @override
  CretaModel cloneModel(CretaModel src) {
    FrameModel retval = newModel(src.mid) as FrameModel;
    src.copyTo(retval);
    return retval;
  }

  Future<FrameModel> createNextFrame() async {
    FrameModel defaultFrame = FrameModel.makeSample(lastOrder() + 1, pageModel.mid);
    await createToDB(defaultFrame);
    insert(defaultFrame, postion: getAvailLength());
    selectedMid = defaultFrame.mid;
    //reOrdering();
    return defaultFrame;
  }

  Future<FrameModel> copyFrame(FrameModel src) async {
    FrameModel newModel = FrameModel('');
    newModel.copyFrom(src, newMid: newModel.mid);

    newModel.posX.set(src.posX.value + 20, save: false, noUndo: true);
    newModel.posY.set(src.posY.value + 20, save: false, noUndo: true);
    newModel.order.set(lastOrder() + 1, save: false, noUndo: true);

    logger.info('create new frame ${newModel.mid}');

    await createToDB(newModel);
    insert(newModel, postion: getAvailLength());
    selectedMid = newModel.mid;
    //reOrdering();
    return newModel;
  }

  Future<int> getFrames() async {
    int frameCount = 0;
    startTransaction();
    try {
      frameCount = await _getFrames();
      if (frameCount == 0) {
        await createNextFrame();
        frameCount = 1;
      }
    } catch (e) {
      logger.finest('something wrong $e');
      await createNextFrame();
      frameCount = 1;
    }
    //reOrdering();
    endTransaction();
    return frameCount;
  }

  Future<int> _getFrames({int limit = 99}) async {
    logger.finest('getFrames');
    Map<String, QueryValue> query = {};
    query['parentMid'] = QueryValue(value: pageModel.mid);
    query['isRemoved'] = QueryValue(value: false);
    Map<String, OrderDirection> orderBy = {};
    orderBy['order'] = OrderDirection.ascending;
    await queryFromDB(query, orderBy: orderBy, limit: limit);
    logger.finest('getFrames ${modelList.length}');
    return modelList.length;
  }

  ContentsManager newContentsManager(FrameModel frameModel) {
    contentsManager ??= ContentsManager(
      pageModel: pageModel,
      frameModel: frameModel,
    );
    return contentsManager!;
  }

  ContentsModel? getSelectedContents() {
    if (contentsManager == null) {
      return null;
    }
    return contentsManager?.getSelected() as ContentsModel?;
  }
}
