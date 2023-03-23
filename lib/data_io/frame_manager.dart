import 'package:flutter/material.dart';
import 'package:hycop/common/undo/save_manager.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/database/abs_database.dart';
import '../model/book_model.dart';
import '../model/creta_model.dart';
import '../model/frame_model.dart';
import '../model/page_model.dart';
import 'creta_manager.dart';

//FrameManager? frameManagerHolder;

class FrameManager extends CretaManager {
  PageModel pageModel;
  BookModel bookModel;
  //Map<String, ValueKey> frameKeyMap = {};
  Map<String, GlobalKey> frameKeyMap = {};

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
    updateLastOrder();
    FrameModel defaultFrame = FrameModel.makeSample(++lastOrder, pageModel.mid);
    await createToDB(defaultFrame);
    insert(defaultFrame, postion: getAvailLength());
    selectedMid = defaultFrame.mid;
    return defaultFrame;
  }

  Future<FrameModel> copyFrame(FrameModel src) async {
    updateLastOrder();
    FrameModel newModel = FrameModel('');
    newModel.copyFrom(src, newMid: newModel.mid);

    newModel.posX.set(src.posX.value + 20, save: false, noUndo: true);
    newModel.posY.set(src.posY.value + 20, save: false, noUndo: true);
    newModel.order.set(getMaxOrder() + 1, save: false, noUndo: true);

    logger.info('create new frame ${newModel.mid}');

    await createToDB(newModel);
    insert(newModel, postion: getAvailLength());
    selectedMid = newModel.mid;
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

    for (var ele in modelList) {
      if (ele.mid == 'frame=38a8223f-0da4-4821-beea-ffd78de763d6') {
        FrameModel model = ele as FrameModel;
        logger.fine(
            'x,y,w,h= ${model.posX.value}, ${model.posY.value}, ${model.width.value},${model.height.value}');
      }
    }

    updateLastOrder();
    return modelList.length;
  }
}
