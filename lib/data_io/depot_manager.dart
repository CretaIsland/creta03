// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
import 'package:creta_studio_model/model/book_model.dart';
import 'package:creta_studio_model/model/contents_model.dart';
import 'package:creta_common/model/creta_model.dart';
import 'package:creta_studio_model/model/depot_model.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import 'package:creta_studio_model/model/page_model.dart';
import '../pages/studio/book_main_page.dart';
import 'contents_manager.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';

enum DepotOrderEnum {
  latest,
  name,
}

class DepotManager extends CretaManager {
  DepotManager({
    required String userEmail,
    String? myTeamMid,
    String tableName = 'creta_depot',
  }) : super(
          tableName,
          myTeamMid ?? userEmail,
        ) {
    saveManagerHolder?.registerManager('depot', this, postfix: userEmail);
  }

  List<ContentsModel> filteredContents = [];

  @override
  AbsExModel newModel(String mid) => DepotModel(mid, parentMid!);

  @override
  CretaModel cloneModel(CretaModel src) {
    DepotModel retval = newModel(src.mid) as DepotModel;
    src.copyTo(retval);
    return retval;
  }

  bool _onceDBGetComplete = false;
  bool get onceDBGetComplete => _onceDBGetComplete;
  DepotOrderEnum depotOrder = DepotOrderEnum.latest;

  void removeContents(String contentsMid) {
    ContentsModel? target;
    for (var ele in filteredContents) {
      if (ele.mid == contentsMid) {
        target = ele;
        break;
      }
    }
    if (target != null) {
      filteredContents.remove(target);
      target.isRemoved.set(true, save: false);
      ContentsManager.dummyManager?.setToDB(target);
    }
  }

  double getMaxModelOrder() {
    double retval = 0;
    for (var model in modelList) {
      if (model.order.value > retval) {
        retval = model.order.value;
      }
    }
    return retval;
  }

  Future<DepotModel?> createNextDepot(
    String contentsMid,
    ContentsType contentsType,
    String? teamId, {
    bool doNotify = true,
  }) async {
    DepotModel? depoModel = await isExist(contentsMid, teamId);
    if (depoModel != null) {
      debugPrint('$contentsMid is already exist');
      depoModel.save();
      return null;
    }
    DepotModel model = DepotModel('', parentMid!);
    model.contentsMid = contentsMid;
    model.contentsType = contentsType;
    return await _createNextDepot(model, teamId, doNotify: doNotify);
  }

  Future<DepotModel> _createNextDepot(
    DepotModel model,
    String? teamId, {
    bool doNotify = true,
  }) async {
    logger.fine('createNextDepot()');

    model.order.set(getMaxModelOrder() + 1, save: false, noUndo: true);
    await createToDB(model);
    insert(model, postion: getLength(), doNotify: doNotify);
    MyChange<DepotModel> c = MyChange<DepotModel>(
      model,
      execute: () async {
        //await _createNextContents(model, doNotify);
      },
      redo: () async {
        await _redoCreateNextDepot(model, doNotify);
      },
      undo: (DepotModel oldModel) async {
        await _undoCreateNextDepot(oldModel, doNotify);
      },
    );
    mychangeStack.add(c);
    return model;
  }

  Future<DepotModel> _redoCreateNextDepot(DepotModel model, bool doNotify) async {
    model.isRemoved.set(false, noUndo: true, save: false);
    await setToDB(model);
    insert(model, postion: getLength(), doNotify: doNotify);

    logger.fine(
        '_redoCreateNextDepot complete ${model.contentsMid},${model.order.value},${model.isFavorite}');
    return model;
  }

  Future<DepotModel> _undoCreateNextDepot(DepotModel oldModel, bool doNotify) async {
    oldModel.isRemoved.set(true, noUndo: true, save: false);
    remove(oldModel);
    if (doNotify) {
      notify();
    }

    logger.fine(
        '_undoCreateNextDepot complete ${oldModel.contentsMid},${oldModel.order.value},${oldModel.isFavorite}');
    await setToDB(oldModel);
    return oldModel;
  }

  Future<void> removeDepots(DepotModel depot) async {
    debugPrint('----------1--------removeDepots----------');
    depot.isRemoved.set(
      true,
      save: false,
      doComplete: (val) {
        remove(depot);
      },
      undoComplete: (val) {
        insert(depot);
      },
    );
    await setToDB(depot);
    remove(depot);
    removeContents(depot.contentsMid);
    debugPrint('remove depotContents ${depot.contentsType}, ${depot.mid}');
  }

  String prefix() => CretaManager.modelPrefix(ExModelType.contents);

  Future<int> _getDepotList(ContentsType contentsType) async {
    int contentsCount = 0;
    startTransaction();
    try {
      Map<String, QueryValue> query = {};
      _onceDBGetComplete = true;
      query['parentMid'] = QueryValue(value: parentMid); // parentMid = userId
      if (contentsType != ContentsType.none) {
        query['contentsType'] = QueryValue(value: contentsType.index);
      }
      query['isRemoved'] = QueryValue(value: false);

      if (depotOrder == DepotOrderEnum.latest) {
        Map<String, OrderDirection> orderBy = {};
        orderBy['updateTime'] = OrderDirection.descending;
        await queryFromDB(query, orderBy: orderBy);
      } else {
        await queryFromDB(query);
      }

      contentsCount = modelList.length;
      logger.fine('contentsCount ${modelList.length}, contentsType: $contentsType');
      _onceDBGetComplete = true;
    } catch (e) {
      logger.finest('something wrong $e');
    }
    endTransaction();
    return contentsCount;
  }

  Future<DepotModel?> getDepotCount(String contentsMid, String? teamId) async {
    try {
      Map<String, QueryValue> query = {};
      query['contentsMid'] = QueryValue(value: contentsMid);
      if (teamId != null) {
        // parentMid = userId
        query['parentMid'] = QueryValue(value: teamId);
      } // parentMid = userId
      query['isRemoved'] = QueryValue(value: false);
      await queryFromDB(query);
      if (modelList.isEmpty) {
        return null;
      }
      // print('modelList ${modelList.length}');
      return modelList.first as DepotModel?;
    } catch (err) {
      logger.severe('_getDepotCount error $err');
      return null;
    }
  }

  // Future<int> _getDepotList({int limit = 99}) async {
  //   print('Depot------getContents--------1-------');
  //   Map<String, QueryValue> query = {};
  //   query['parentMid'] = QueryValue(value: parentMid); // parentMid = userId
  //   query['isRemoved'] = QueryValue(value: false);
  //   Map<String, OrderDirection> orderBy = {};
  //   orderBy['order'] = OrderDirection.ascending;
  //   await queryFromDB(query, orderBy: orderBy, limit: limit);
  //   print('Depot------modelList.length: ${modelList.length}');
  //   return modelList.length;
  // }

  Future<List<ContentsModel>> getContentInfoList(
      {ContentsType contentsType = ContentsType.none}) async {
    //PageManager pageManager = BookMainPage.pageManagerHolder!;  // Current Selected Page's manager
    await _getDepotList(contentsType);
    BookModel? book = BookMainPage.bookManagerHolder!.onlyOne() as BookModel?;
    if (book == null) {
      return [];
    }
    // List<ContentsModel> contentsInfoList = [];
    Set<String> contentsMidSet = {};
    //print('getDepoList= ${modelList.length}');
    filteredContents.clear();
    for (var ele in modelList) {
      String contentsMid = (ele as DepotModel).contentsMid;
      //print('getDepot = ${ele.mid}, $contentsMid');
      // find contents manager for each contentsMid
      if (contentsMidSet.add(contentsMid)) {
        ContentsModel? model = await getContentsInfo(
            contentsMid: contentsMid, contentsManager: ContentsManager.dummyManager);
        if (model != null) {
          filteredContents.add(model);
        }
      }
    }
    if (depotOrder == DepotOrderEnum.name && filteredContents.isNotEmpty) {
      filteredContents.sort((a, b) => a.name.compareTo(b.name));
    }

    // print('----getContentInfoList-----${filteredContents.length}');
    contentsMidSet.clear();
    return filteredContents;
  }

  Future<DepotModel?> isExist(String contentsMid, String? teamId) async {
    // return null;
    DepotManager dummy = DepotManager(userEmail: AccountManager.currentLoginUser.email);
    return await dummy.getDepotCount(contentsMid, teamId);
  }

  // getContents Detail Info Using contents mid
  Future<ContentsModel?> getContentsInfo(
      {required String contentsMid, required ContentsManager? contentsManager}) async {
    logger.finest('getContentsInfo');
    if (contentsManager == null) {
      BookModel? book = BookMainPage.bookManagerHolder!.onlyOne() as BookModel?;
      if (book == null) {
        logger.severe('book is null');
        return null;
      }
      contentsManager =
          ContentsManager(pageModel: PageModel('', book), frameModel: FrameModel('', book.mid));
    }
    ContentsModel? retval = await contentsManager.getFromDB(contentsMid) as ContentsModel?;
    return retval;
  }

  DepotModel? getModelByContentsMid(String mid) {
    for (var ele in modelList) {
      if ((ele as DepotModel).contentsMid == mid) {
        return ele;
      }
    }
    return null;
  }

  void sort() {
    if (depotOrder == DepotOrderEnum.latest) {
      filteredContents.sort((a, b) => b.updateTime.compareTo(a.updateTime));
    } else if (depotOrder == DepotOrderEnum.name) {
      filteredContents.sort((a, b) => a.name.compareTo(b.name));
    }
  }

  Future<ContentsModel?> copyContents(DepotModel data, {String frameId = ''}) async {
    BookModel? book = BookMainPage.bookManagerHolder!.onlyOne() as BookModel?;
    if (book == null) {
      logger.severe('book is null');
      return null;
    }
    ContentsManager dummyManager = ContentsManager(
      pageModel: PageModel('', book),
      frameModel: FrameModel('', book.mid),
    );

    ContentsModel? model =
        await getContentsInfo(contentsMid: data.contentsMid, contentsManager: dummyManager);
    if (model == null || model.remoteUrl == null) {
      logger.severe('Contents ${data.contentsMid} is not founded');
      return null;
    }
    // model 은 새롭게 생성되어야 하므로, copy 해 주어야 한다.
    ContentsModel newModel = ContentsModel('', book.mid);
    newModel.copyFrom(model,
        newMid: newModel.mid, pMid: frameId); // 아직 프레임이 생성되지 않았으므로 parentMid 를 주지 않는다.
    mychangeStack.startTrans();
    newModel.isRemoved.set(false, save: false);
    newModel.isShow.set(true, save: false);
    mychangeStack.endTrans();
    return newModel;
  }
}
