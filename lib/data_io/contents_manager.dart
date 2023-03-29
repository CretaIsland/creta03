// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
import '../model/contents_model.dart';
import '../model/creta_model.dart';
import '../model/frame_model.dart';
import '../model/page_model.dart';
import '../pages/studio/studio_variables.dart';
import 'creta_manager.dart';

class ContentsManager extends CretaManager {
  final PageModel pageModel;
  final FrameModel frameModel;

  ContentsManager({required this.pageModel, required this.frameModel}) : super('creta_contents') {
    saveManagerHolder?.registerManager('contents', this);
  }

  @override
  AbsExModel newModel(String mid) => ContentsModel(mid);

  @override
  CretaModel cloneModel(CretaModel src) {
    ContentsModel retval = newModel(src.mid) as ContentsModel;
    src.copyTo(retval);
    return retval;
  }

  Future<ContentsModel> create(ContentsModel model) async {
    await createToDB(model);
    insert(model);
    return model;
  }

  String prefix() => CretaManager.modelPrefix(ExModelType.contents);

  Future<int> getContents() async {
    int contentsCount = 0;
    startTransaction();
    try {
      contentsCount = await _getContents();
    } catch (e) {
      logger.finest('something wrong $e');
    }
    //reOrdering();
    endTransaction();
    return contentsCount;
  }

  Future<int> _getContents({int limit = 99}) async {
    logger.finest('getContents');
    Map<String, QueryValue> query = {};
    query['parentMid'] = QueryValue(value: frameModel.mid);
    query['isRemoved'] = QueryValue(value: false);
    Map<String, OrderDirection> orderBy = {};
    orderBy['order'] = OrderDirection.ascending;
    await queryFromDB(query, orderBy: orderBy, limit: limit);
    logger.finest('getContents ${modelList.length}');
    return modelList.length;
  }

  void resizeFrame(double ratio, {bool invalidate = true}) {
    // 원본에서 ratio = w / h 이다.
    //width 와 height 중 짧은 쪽을 기준으로 해서,
    // 반대편을 ratio 만큼 늘린다.
    if (ratio == 0) return;

    double w = frameModel.width.value;
    double h = frameModel.height.value;

    double pageHeight = pageModel.height.value;
    double pageWidth = pageModel.width.value;

    double dx = frameModel.posX.value;
    double dy = frameModel.posY.value;

    // ratio = w / h 이다.
    if (ratio >= 1) {
      // 콘텐츠의 가로가 더 길다.
      // 이 경우 페이지의 가로에 꽉차게 수정해준다.
      w = pageWidth;
      h = w / ratio;
      dx = 0;

      if (h > pageHeight) {
        h = pageHeight;
        w = h * ratio;
        dy = 0;
      }
      if (h == pageHeight) {
        dy = 0;
      }
    } else {
      // 콘텐츠의 세로가 더 길다.
      // 이 경우 페이지의 세로에 꽉차게 수정해준다.
      h = pageHeight;
      w = h * ratio;
      dy = 0;
      if (w > pageWidth) {
        w = pageWidth;
        h = w / ratio;
        dx = 0;
      }
      if (w == pageWidth) {
        dx = 0;
      }
    }

    mychangeStack.startTrans();
    frameModel.posX.set(dx, save: false);
    frameModel.posY.set(dy, save: false);
    frameModel.width.set(w, save: false);
    frameModel.height.set(h, save: false);
    frameModel.save();
    mychangeStack.endTrans();

    if (invalidate) {
      notify();
    }
  }

  Size getRealSize() {
    double width = StudioVariables.applyScale * frameModel.width.value;
    double height = StudioVariables.applyScale * frameModel.height.value;
    return Size(width, height);
  }
}
