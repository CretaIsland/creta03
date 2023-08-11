// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async';
import 'package:hycop/hycop.dart';
import '../model/book_model.dart';
import '../model/contents_model.dart';
import '../model/creta_model.dart';
import '../model/depot_model.dart';
import '../model/favorites_model.dart';
import '../model/frame_model.dart';
import '../model/page_model.dart';
import '../pages/studio/book_main_page.dart';
import 'contents_manager.dart';
import 'creta_manager.dart';
import 'favorites_manager.dart';

class DepotManager extends CretaManager {
  Map<String, ContentsManager> contentsManagerMap = {};

  void setContentsManager(String contentsMid, ContentsManager c) {
    contentsManagerMap[contentsMid] = c;
  }

  ContentsManager? getContentsManager(String contentsMid) => contentsManagerMap[contentsMid];

  DepotManager({required String userId, String tableName = 'creta_depot'})
      : super(tableName, userId) {
    saveManagerHolder?.registerManager('depot', this, postfix: userId);
  }

  FavoritesManager favoritesManagerHolder = FavoritesManager();

  String choosenMid = '';
  String prevChoosendMid = '';

  DepotModel? _currentDepotModel;

  final Map<String, bool> _favoritesContentsMidMap = {};

  @override
  AbsExModel newModel(String mid) => DepotModel(mid);

  @override
  CretaModel cloneModel(CretaModel src) {
    DepotModel retval = newModel(src.mid) as DepotModel;
    src.copyTo(retval);
    return retval;
  }

  bool _onceDBGetComplete = false;
  bool get onceDBGetComplete => _onceDBGetComplete;

  // Map<String, LinkManager> linkManagerMap = {};

  double getMaxModelOrder() {
    double retval = 0;
    for (var model in modelList) {
      if (model.order.value > retval) {
        retval = model.order.value;
      }
    }
    return retval;
  }

  Future<DepotModel> createNextDepot(
    DepotModel model, {
    bool doNotify = true,
    bool isFavorite = false,
  }) async {
    logger.info('createNextDepot()');
    model.order.set(getMaxModelOrder() + 1, save: false, noUndo: true);
    await _createNextDepot(model, doNotify);

    if (isFavorite = true) {
      // have another favorit depot?! 
    }

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

  Future<DepotModel> _createNextDepot(DepotModel model, bool doNotify) async {
    logger.info('createNextDepot()');

    await createToDB(model);
    insert(model, postion: getLength(), doNotify: doNotify);
    choosenMid = model.contentsMid;
    // if (playTimer != null) {
    //   if (playTimer!.isInit()) {
    //     logger.info('prev exist =============================================');
    //     await playTimer?.rewind();
    //     await playTimer?.pause();
    //   }
    //   await playTimer?.reOrdering(isRewind: true);
    // } else {
    //   reOrdering();
    // }
    logger.info(
        '_createNextDepot complete ${model.contentsMid},${model.order.value},${model.isFavorite}');
    return model;
  }

  Future<DepotModel> _redoCreateNextDepot(DepotModel model, bool doNotify) async {
    model.isRemoved.set(false, noUndo: true, save: false);
    await setToDB(model);
    insert(model, postion: getLength(), doNotify: doNotify);
    choosenMid = model.contentsMid;
    // if (playTimer != null) {
    //   if (playTimer!.isInit()) {
    //     //logger.info('prev exist =============================================');
    //     await playTimer?.rewind();
    //     await playTimer?.pause();
    //   }
    //   await playTimer?.reOrdering(isRewind: true);
    // } else {
    //   reOrdering();
    // }
    logger.info(
        '_redoCreateNextDepot complete ${model.contentsMid},${model.order.value},${model.isFavorite}');
    return model;
  }

  Future<DepotModel> _undoCreateNextDepot(DepotModel oldModel, bool doNotify) async {
    oldModel.isRemoved.set(true, noUndo: true, save: false);
    remove(oldModel);
    if (doNotify) {
      notify();
    }
    if (choosenMid == oldModel.mid) {
      choosenMid = prevChoosendMid;
    }
    // if (playTimer != null) {
    //   if (playTimer!.isInit()) {
    //     //logger.info('prev exist =============================================');
    //     await playTimer?.rewind();
    //     await playTimer?.pause();
    //   }
    //   await playTimer?.reOrdering(isRewind: true);
    // } else {
    //   reOrdering();
    // }
    logger.info(
        '_undoCreateNextDepot complete ${oldModel.contentsMid},${oldModel.order.value},${oldModel.isFavorite}');
    await setToDB(oldModel);
    return oldModel;
  }

  String prefix() => CretaManager.modelPrefix(ExModelType.contents);

  Future<int> getContentMidList() async {
    int contentsCount = 0;
    startTransaction();
    try {
      contentsCount = await _getContentMidList();

      _onceDBGetComplete = true;
    } catch (e) {
      logger.finest('something wrong $e');
    }
    endTransaction();
    return contentsCount;
  }

  Future<int> _getContentMidList({int limit = 99}) async {
    logger.finest('getContents');
    Map<String, QueryValue> query = {};
    query['parentMid'] = QueryValue(value: parentMid); // parentMid = userId
    query['isRemoved'] = QueryValue(value: false);
    Map<String, OrderDirection> orderBy = {};
    orderBy['order'] = OrderDirection.ascending;
    await queryFromDB(query, orderBy: orderBy, limit: limit);
    logger.finest('getContents ${modelList.length}');
    return modelList.length;
  }

  Future<List<ContentsModel>> getContentInfoList() async {
    //PageManager pageManager = BookMainPage.pageManagerHolder!;  // Current Selected Page's manager
    await getContentMidList();
    BookModel? book = BookMainPage.bookManagerHolder!.onlyOne() as BookModel?;
    if (book == null) {
      return [];
    }
    List<ContentsModel> contentsInfoList = [];
    ContentsManager dummyManager =
        ContentsManager(pageModel: PageModel('', book), frameModel: FrameModel('', book.mid));
    for (var ele in modelList) {
      String contentsMid = ele.mid;
      // find contents manager for each contentsMid
      ContentsModel model =
          await _getContentsInfo(contentsMid: contentsMid, contentsManager: dummyManager);
      contentsInfoList.add(model);
    }
    return contentsInfoList;
  }

  // getContents Detail Info Using contents mid
  Future<ContentsModel> _getContentsInfo(
      {required String contentsMid, required ContentsManager contentsManager}) async {
    logger.finest('getContents');
    ContentsModel contentsModel = contentsManager.getFromDB(contentsMid) as ContentsModel;
    return contentsModel;
  }

  void _getFavoritesFromDB(List<AbsExModel> modelList) {
    logger.info('_getFavoritesFromDB');
    if (_currentDepotModel == null) {
      favoritesManagerHolder.setState(DBState.idle);
      return;
    }
    favoritesManagerHolder.queryFavoritesFromDepotModelList(modelList);
  }

  void _resultFavoritesFromDB(List<AbsExModel> modelList) {
    logger.info('favoritesManagerHolder.modelList.length=${modelList.length}');
    for (var model in modelList) {
      FavoritesModel fModel = model as FavoritesModel;
      logger.info('_favoritesBookIdMap[${fModel.bookId}] = true');
      _favoritesContentsMidMap[fModel.bookId] = true;
    }
  }

  // LinkManager newLinkManager(String contentsId) {
  //   logger.info('newLinkManager()*******$contentsId');

  //   LinkManager? retval = linkManagerMap[contentsId];
  //   if (retval == null) {
  //     retval = LinkManager(
  //       contentsId,
  //       frameModel!.realTimeKey,
  //     );
  //     linkManagerMap[contentsId] = retval;
  //   }
  //   return retval;
  // }

  // LinkManager? findLinkManager(String contentsId) {
  //   LinkManager? retval = linkManagerMap[contentsId];
  //   logger.fine('findLinkManager()*******');
  //   if (retval == null) {
  //     retval = LinkManager(contentsId, frameModel!.realTimeKey);
  //     linkManagerMap[contentsId] = retval;
  //   }
  //   return linkManagerMap[contentsId];
  // }
}
