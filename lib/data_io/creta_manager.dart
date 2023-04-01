// ignore_for_file: prefer_final_fields, depend_on_referenced_packages

import 'package:hycop/hycop/enum/model_enums.dart';
import 'package:deep_collection/deep_collection.dart';
import 'package:hycop/hycop/utils/hycop_utils.dart';
//import 'package:sortedmap/sortedmap.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop/utils/hycop_exceptions.dart';
import 'package:hycop/hycop/database/abs_database.dart';
//import 'package:sortedmap/sortedmap.dart';
import 'package:hycop/hycop/hycop_factory.dart';
import 'package:mutex/mutex.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model_manager.dart';

import '../design_system/component/snippet.dart';
import '../design_system/menu/creta_popup_menu.dart';
import '../model/creta_model.dart';
import '../pages/studio/containees/frame/sticker/draggable_stickers.dart';
import '../pages/studio/studio_constant.dart';
import '../pages/studio/studio_variables.dart';

enum DBState {
  none,
  idle,
  querying,
}

enum TransState {
  end,
  start,
}

abstract class CretaManager extends AbsExModelManager {
  static const int maxTotalLimit = 500;
  static const int maxPageLimit = 200;
  static const int defaultPageLimit = 50;

  CretaModel cloneModel(CretaModel src);

  //SortedMap<double, CretaModel> _orderMap = SortedMap<double, CretaModel>();
  Map<double, CretaModel> _orderMap = {};

  static String modelPrefix(ExModelType type) {
    return '${type.name}=';
  }

  late String instanceId;
  CretaManager(String tableName) : super(tableName) {
    instanceId = const Uuid().v4();
    logger.finest('CretaManager instance created ()');
  }

  final _lock = Mutex();
  void lock() => _lock.acquire();
  void unlock() => _lock.release();

  int _pageCount = 0;
  int _totaltFetchedCount = 0;
  int _lastFetchedCount = 0;
  int _lastLimit = CretaManager.defaultPageLimit;
  List<Object>? _lastSortedObjectList;
  Map<String, OrderDirection> _currentSortAttr = {};

  DBState _dbState = DBState.none;
  TransState _transState = TransState.end;

  void startTransaction() {
    lock();
    logger.finest('startTransaction');
    _transState = TransState.start;
    unlock();
  }

  void endTransaction() {
    lock();
    logger.finest('endTransaction');
    _transState = TransState.end;

    unlock();
  }

  Map<String, QueryValue> _currentQuery = {};

  String _currentSearchStr = '';
  List<String> _currentLikeAttrList = [];
  void clearAll() {
    _currentSearchStr = '';
    _currentLikeAttrList.clear();
    _currentQuery.clear();
    //_transState = TransState.end;
    clearPage();
  }

  void clearPage() {
    _currentSortAttr.clear();
    if (_lastSortedObjectList != null) {
      _lastSortedObjectList!.clear();
      _lastSortedObjectList = null;
    }
    _dbState = DBState.none;
    //_transState = TransState.end;
    _pageCount = 0;
    lock();
    modelList.clear();
    unlock();
  }

  bool isApplyCreate = true;
  bool isApplyDelete = true;
  bool isApplyModify = true;
  bool isNotifyCreate = true;
  bool isNotifyDelete = true;
  bool isNotifyModify = true;

  //
  //  [ 소팅 관련
  //
  // void toSorted(String sortAttrName, {bool descending = false, Function? onModelSorted}) {
  //   SortedMap<String, CretaModel> sortedMap = SortedMap<String, CretaModel>();
  //   //sortedMap.clear();
  //   lock();

  //   for (AbsExModel ele in modelList) {
  //     //Map<String, dynamic> map = ele.toMap();
  //     // map.forEach((key, value) {
  //     //   logger.finest('key=$key');
  //     // });
  //     dynamic val = ele.toMap()[sortAttrName];
  //     if (val == null) {
  //       logger.severe('attribute ($sortAttrName) does not exist in colection ($collectionId)');
  //       continue;
  //     }
  //     String strVal = '';
  //     if (val is num) {
  //       strVal = val.toString().padLeft(20, '0');
  //     } else if (val is DateTime) {
  //       strVal = val.millisecondsSinceEpoch.toString();
  //     } else {
  //       strVal = val.toString();
  //     }
  //     // uniq key 로 만들기위해 뒤에 uid를 붙인다.
  //     strVal += const Uuid().v4();

  //     sortedMap[strVal] = ele as CretaModel;
  //     logger.finest('${ele.key} , $strVal added');
  //     _currentSortAttr[sortAttrName] =
  //         descending ? OrderDirection.descending : OrderDirection.ascending;
  //   }
  //   if (sortedMap.isEmpty) {
  //     unlock();
  //     return;
  //   }
  //   modelList.clear();
  //   if (descending) {
  //     for (var ele in sortedMap.values.toList().reversed) {
  //       modelList.add(ele);
  //     }
  //   } else {
  //     for (var ele in sortedMap.values) {
  //       modelList.add(ele);
  //     }
  //   }
  //   unlock();
  //   if (onModelSorted != null) onModelSorted();
  //   return;
  // }

  void toSorted(String sortAttrName, {bool descending = false, Function? onModelSorted}) {
    logger.finest('toSorted');
    _currentSortAttr.clear();
    _currentSortAttr[sortAttrName] =
        descending ? OrderDirection.descending : OrderDirection.ascending;

    queryFromDB({..._currentQuery}).then((value) {
      if (_currentLikeAttrList.isNotEmpty && _currentSearchStr.isNotEmpty) {
        _search(_currentLikeAttrList, _currentSearchStr);
      }
      onModelSorted?.call();
    });
  }

  List<CretaMenuItem> getSortMenu(Function? onModelSorted) {
    return [];
  }

  void toFiltered(String? name, dynamic value, String userId, {Function? onModelFiltered}) {
    logger.finest('toFiltered');
    Map<String, QueryValue> query = {};
    if (name != null && value != null) {
      query[name] = QueryValue(value: value);
    }
    query['creator'] = QueryValue(value: userId);
    query['isRemoved'] = QueryValue(value: false);
    queryFromDB(query).then((value) {
      if (_currentLikeAttrList.isNotEmpty && _currentSearchStr.isNotEmpty) {
        _search(_currentLikeAttrList, _currentSearchStr);
      }
      onModelFiltered?.call();
    });
  }

  void reGet(String userId, {Function? onModelFiltered}) {
    int proper = properLimit();
    if (_lastLimit < proper) {
      _lastLimit = proper;
    }
    logger.finest('reGet');
    queryFromDB({..._currentQuery}).then((value) {
      if (_currentLikeAttrList.isNotEmpty && _currentSearchStr.isNotEmpty) {
        _search(_currentLikeAttrList, _currentSearchStr);
      }
      onModelFiltered?.call();
    });
  }

  List<CretaMenuItem> getFilterMenu(Function? onModelFiltered) {
    return [];
  }

  void onSearch(String value, Function afterSearch) {}

  void search(List<String> likeAttrList, String searchStr, Function afterSearch) {
    logger.finest('search ${_currentQuery.toString()}');
    queryFromDB({..._currentQuery}).then((value) {
      _search(likeAttrList, searchStr);
      _currentLikeAttrList.clear();
      _currentLikeAttrList.addAll(likeAttrList);
      _currentSearchStr = searchStr;
      afterSearch.call();
    });
  }

  void _search(List<String> likeAttrList, String searchStr) {
    List<CretaModel> resultList = [];
    lock();
    for (AbsExModel ele in modelList) {
      for (String attr in likeAttrList) {
        dynamic val = ele.toMap()[attr];
        if (val == null) {
          logger.severe('attribute ($attr) does not exist in colection ($collectionId)');
          continue;
        }
        String strVal = val.toString();
        if (strVal.contains(searchStr)) {
          resultList.add(ele as CretaModel);
          logger.finest('${ele.key} , $strVal added');
          break;
        }
      }
    }
    // if (resultList.isEmpty) {
    //   unlock();
    //   return;
    // }
    modelList.clear();
    for (var ele in resultList) {
      modelList.add(ele);
    }
    unlock();
  }
  //
  //   소팅 관련 end ]
  //

  //
  // [ get DB  관련
  //

  bool isNotEnd() {
    return _lastLimit == modelList.length;
  }

  bool isShort({int offset = 0}) {
    logger.finest('limit=$_lastLimit, modelList=${modelList.length}');
    int proper = properLimit();
    int modelLen = modelList.length + offset;
    return _lastLimit <= modelLen && proper > modelLen;
  }

  int properLimit() {
    if (StudioVariables.displaySize.width == 0 || StudioVariables.displaySize.height == 0) {
      return _lastLimit == 0 ? CretaManager.defaultPageLimit : _lastLimit;
    }
    double availWidth = StudioVariables.displaySize.width - CretaComponentLocation.TabBar.width;
    double availHeight = StudioVariables.displaySize.height - LayoutConst.cretaBannerMinHeight;

    double square = availHeight * availWidth;
    if (square <= 0) {
      return _lastLimit == 0 ? CretaManager.defaultPageLimit : _lastLimit;
    }
    double gridSize = (LayoutConst.bookThumbSize.width + LayoutConst.cretaPaddingPixel) *
        (LayoutConst.bookThumbSize.height + LayoutConst.cretaPaddingPixel);

    int retval = (square / gridSize).ceil();
    if (retval < 10) {
      retval = 10;
    }
    if (retval > CretaManager.maxPageLimit) {
      retval = CretaManager.maxPageLimit;
    }
    logger.finest('properLimit=$retval');
    return retval;
  }

  Future<List<AbsExModel>> isGetListFromDBComplete() async {
    return await _lock.protect(() async {
      logger.finest('transState=$_transState');
      while (_dbState == DBState.querying ||
          _dbState == DBState.none ||
          _transState == TransState.start) {
        await Future.delayed(const Duration(milliseconds: 500)).then((onValue) => true);
      }
      logger.finest('transState=$_transState');
      return modelList;
    });
  }

  @override
  Future<AbsExModel> getFromDB(String mid) async {
    logger.finest('my getFromDB($mid)');
    lock();
    _dbState = DBState.querying;
    AbsExModel retval = await super.getFromDB(mid);
    _dbState = DBState.idle;
    modelList.clear();
    modelList.add(retval);
    unlock();
    //reOrdering();
    return retval;
  }

  Future<List<AbsExModel>> myDataOnly(String userId, {int? limit}) async {
    logger.finest('myDataOnly');
    Map<String, QueryValue> query = {};
    query['creator'] = QueryValue(value: userId);
    query['isRemoved'] = QueryValue(value: false);
    logger.finest('myDataOnly 1');
    final retval = await queryFromDB(query, limit: limit);
    logger.finest('myDataOnly end');
    return retval;
  }

  Future<List<AbsExModel>> queryFromDB(
    Map<String, QueryValue> query, {
    int? limit,
    Map<String, OrderDirection>? orderBy,
    bool isNew = true,
  }) async {
    lock();
    _dbState = DBState.querying;

    if (limit == null || limit == 0) {
      limit = _lastLimit;
    }
    if (limit > CretaManager.maxPageLimit) {
      limit = CretaManager.maxPageLimit;
    }
    _lastLimit = limit;
    logger.finest('my queryFromDB($collectionId, ${query.toString()}, $isNew, $limit)');

    Map<String, OrderDirection> copyOrderBy = {};
    if (orderBy == null || orderBy.isEmpty) {
      if (_currentSortAttr.isNotEmpty) {
        copyOrderBy = Map.from(_currentSortAttr);
      }
    } else {
      copyOrderBy = Map.from(orderBy);
    }
    copyOrderBy['updateTime'] = OrderDirection.descending;

    if (isNew) {
      modelList.clear();
    }
    try {
      if (_lastSortedObjectList != null) {
        logger.finest('_lastSortedObjectList = ${_lastSortedObjectList.toString()}');
      }

      List resultList = await HycopFactory.dataBase!.queryPage(
        collectionId,
        where: query,
        orderBy: copyOrderBy,
        limit: limit,
        //offset: 1, // appwrite only
        startAfter: isNew
            ? null
            : _lastSortedObjectList, //[DateTime.parse('2022-08-04 12:00:01.000')], //firebase only
      );
      if (resultList.isEmpty) {
        logger.severe('no data founded...');
        _lastFetchedCount = 0;
        if (_lastSortedObjectList != null) {
          _lastSortedObjectList!.clear();
        } else {
          _lastSortedObjectList = [];
        }
        _dbState = DBState.idle;
        unlock();
        //reOrdering();
        return [];
      }

      List<AbsExModel> retval = resultList.map((ele) {
        AbsExModel model = newModel(ele['mid'] ?? '');
        model.fromMap(ele);
        modelList.add(model);
        return model;
      }).toList();

      _lastFetchedCount = retval.length;

      if (_lastSortedObjectList != null) {
        _lastSortedObjectList!.clear();
      } else {
        _lastSortedObjectList = [];
      }

      for (var ele in copyOrderBy.keys) {
        dynamic sortAttr = modelList.last.toMap()[ele];
        if (sortAttr != null) {
          _lastSortedObjectList!.add(sortAttr);
        }
      }

      if (isNew == false) {
        _pageCount++;
        _totaltFetchedCount += _lastFetchedCount;
      } else {
        _pageCount = 1;
        _totaltFetchedCount = _lastFetchedCount;
      }
      logger.finest(
          'data fetched count= $_lastFetchedCount, page=$_pageCount, total=$_totaltFetchedCount');

      _currentQuery.clear();
      _currentQuery.addAll(query);
      logger.finest('query=${query.toString()},_currentQuery=${_currentQuery.toString()}');
      _dbState = DBState.idle;
      unlock();
      //reOrdering();
      return retval;
    } catch (e) {
      logger.severe('databaseError $e');
      _dbState = DBState.idle;
      unlock();
      throw HycopException(message: 'databaseError', exception: e as Exception);
    }
  }

  Future<bool> next() async {
    if (_dbState == DBState.idle &&
        _lastFetchedCount >= _lastLimit &&
        _totaltFetchedCount <= CretaManager.maxTotalLimit) {
      int proper = properLimit();
      if (_lastLimit < proper) {
        _lastLimit = proper;
      }
      await queryFromDB({..._currentQuery},
          limit: _lastLimit == 0 ? CretaManager.defaultPageLimit : _lastLimit, isNew: false);
      return true;
    }
    return false;
  }

  Future<bool> showNext(ScrollController controller) async {
    double scrollOffset = controller.offset;
    double nextPageTrigger = 0.8 * controller.position.maxScrollExtent;
    if (controller.position.pixels > nextPageTrigger) {
      logger.finest(
          'end of page(model count=${modelList.length},$scrollOffset, ${controller.position.pixels}, $nextPageTrigger)');
      return await next();
    }
    return false;
  }

  @override
  Future<void> createToDB(AbsExModel model) async {
    lock();
    _dbState = DBState.querying;
    await super.createToDB(model);
    _dbState = DBState.idle;
    unlock();
    //reOrdering();
  }

  //
  //  [ 이벤트 필터링 관련
  //

  void configEvent(
      {bool applyCreate = true,
      bool applyDelete = true,
      bool applyModify = true,
      bool notifyCreate = true,
      bool notifyDelete = true,
      bool notifyModify = true}) {
    isApplyCreate = applyCreate;
    isApplyDelete = applyDelete;
    isApplyModify = applyModify;
    isNotifyCreate = notifyCreate;
    isNotifyDelete = notifyDelete;
    isNotifyModify = notifyModify;
  }

  @override
  void realTimeCallback(String directive, String userId, Map<String, dynamic> dataMap) {
    logger.finest('realTimeCallback invoker($directive, $userId)');

    bool isFilteredOut = false;
    if (_currentQuery.isNotEmpty) {
      _currentQuery.forEach((key, value) {
        dynamic data = dataMap[key];
        if (data == null) {
          isFilteredOut = true;
          return;
        }
        if (data != value) {
          isFilteredOut = true;
          return;
        }
      });
    }

    if (isFilteredOut) {
      logger.finest('${dataMap["mid"] ?? ''} filter out');
      return;
    }

    if (isApplyCreate && directive == 'create') {
      String mid = dataMap["mid"] ?? '';
      AbsExModel model = newModel(mid);
      model.fromMap(dataMap);
      insert(model as CretaModel, postion: 0);
      logger.finest('${model.mid} realtime added');
      if (isNotifyCreate) notifyListeners();
    } else if (isApplyModify && directive == 'set') {
      String mid = dataMap["mid"] ?? '';
      if (mid.isEmpty) {
        return;
      }
      for (AbsExModel model in modelList) {
        if (model.mid == mid) {
          model.fromMap(dataMap);
          logger.finest('${model.mid} realtime changed');
          if (isNotifyModify) notifyListeners();
        }
      }
    } else if (isApplyDelete && directive == 'remove') {
      String mid = dataMap["mid"] ?? '';
      logger.finest('removed mid = $mid');
      if (mid.isEmpty) {
        return;
      }
      for (AbsExModel model in modelList) {
        if (model.mid == mid) {
          remove(model as CretaModel);
          logger.finest('${model.mid} realtime removed');
          if (isNotifyDelete) notifyListeners();
        }
      }
    }
    return;
  }

  void addRealTimeListen() {
    HycopFactory.realtime!.addListener(instanceId, collectionId, realTimeCallback);
  }

  void removeRealTimeListen() {
    HycopFactory.realtime!.removeListener(instanceId, collectionId);
  }

  void insert(CretaModel model, {int postion = 0, bool doNotify = true}) {
    lock();
    modelList.insert(postion, model);
    if (doNotify) {
      notify();
    }
    unlock();
    //reOrdering();
  }

  void remove(CretaModel removedItem) {
    lock();
    modelList.remove(removedItem);
    notify();
    unlock();
    //reOrdering();
  }

  CretaModel? findByIndex(int index) {
    CretaModel? retval;
    lock();
    retval = modelList[index] as CretaModel?;
    unlock();
    return retval;
  }

  int getLength() {
    int retval = 0;
    lock();
    retval = modelList.length;
    unlock();
    return retval;
  }

  int getAvailLength() {
    int retval = 0;
    lock();
    retval = _orderMap.length;
    unlock();
    return retval;
  }

  List<T> listIterator<T>(T Function(AbsExModel) toElement) {
    lock();
    List<T> retval = [];
    for (var model in modelList) {
      var ele = toElement(model);
      retval.add(ele);
    }
    unlock();
    return retval;
  }

  ///
  ///
  ///  Order 관련
  ///
  ///
  ///

  int length() => _orderMap.length;
  bool isEmpty() => _orderMap.isEmpty;
  bool isNotEmpty() => _orderMap.isNotEmpty;
  double firstOrder() {
    if (_orderMap.isNotEmpty) {
      return _orderMap.deepSortByKey().keys.first;
    }
    return -1;
  }

  double lastOrder() {
    if (_orderMap.isNotEmpty) {
      return _orderMap.deepSortByKey().keys.last;
    }
    return -1;
  }

  double nextOrder(double currentOrder) {
    bool matched = false;
    for (double ele in _orderMap.deepSortByKey().keys) {
      if (matched == true) {
        return ele;
      }
      if (ele == currentOrder) {
        matched = true;
        continue;
      }
    }
    if (matched == true) {
      // 끝까지 온것이다.  처음으로 돌아간다.
      return _orderMap.deepSortByKey().keys.first;
    }
    return -1;
  }

  void reOrdering() {
    lock();
    _orderMap.clear();
    for (var ele in modelList) {
      if (ele.isRemoved.value == true) {
        continue;
      }
      _orderMap[ele.order.value] = ele as CretaModel;
    }
    logger.finest('reOrdering  ${_orderMap.length}');

    unlock();
    return;
  }

  List<T> orderMapIterator<T>(T Function(AbsExModel) toElement) {
    List<T> retval = [];
    for (var model in _orderMap.deepSortByKey().values) {
      var ele = toElement(model);
      retval.add(ele);
    }
    return retval;
  }

  CretaModel? getNthOrder(double order) {
    return _orderMap[order];
  }

  CretaModel? getNthModel(int index) {
    int count = 0;
    lock();
    for (MapEntry e in _orderMap.deepSortByKey().entries) {
      if (count == index) {
        unlock();
        return e.value;
      }
      count++;
    }
    unlock();
    return null;
  }

  //CretaModel? getOrderedModel(double order) => _orderMap[order];

  double getMaxOrder() {
    if (_orderMap.isEmpty) return 1;
    double retval = 0;
    lock();
    for (var ele in modelList) {
      if (ele.order.value > retval) {
        retval = ele.order.value;
      }
    }
    unlock();
    return retval;
  }

  double getMinOrder() {
    if (_orderMap.isEmpty) return 1;
    double retval = 1;
    lock();
    for (var ele in modelList) {
      if (ele.order.value < retval) {
        retval = ele.order.value;
      }
    }
    unlock();
    return retval;
  }

  double getBetweenOrder(int nth) {
    if (nth < 0) return getMinOrder();
    if (nth == 0) {
      double min = getMinOrder();
      if (min > 2) {
        return min - 1;
      }
      return min - StudioConst.orderVar;
    }
    int len = _orderMap.length;
    if (len == 0) return 1;
    if (nth >= len) {
      logger.severe('1. this cant be happen $nth, $len');
      return getMaxOrder() + 1;
    }

    // nth 는 0보다는 크고, len 보다는 작은 수다.
    int count = 0;
    double firstValue = -1;
    double secondValue = -1;
    lock();
    for (MapEntry e in _orderMap.deepSortByKey().entries) {
      if (count == nth - 1) {
        firstValue = e.value.order.value;
      } else if (count == nth) {
        secondValue = e.value.order.value;
        unlock();
        return (firstValue + secondValue) / 2.0;
      }
      count++;
    }
    unlock();
    // 있을수 없다,. 에러다.
    logger.severe('3. this cant be happen $nth, $len');
    return getMaxOrder() + 1;
  }

  List<CretaModel> copyOrderMap() {
    List<CretaModel> retval = [];
    lock();
    for (var e in _orderMap.deepSortByKey().values) {
      retval.add(e);
    }
    unlock();
    return retval;
  }

  AbsExModel? onlyOne() {
    if (modelList.isEmpty) return null;
    return modelList.first;
  }

  ///
  ///  select 관련
  ///
  ///
  ///
  @protected
  //double lastOrder = 0;
  @protected
  String selectedMid = '';
  @protected
  String prevSelectedMid = '';

  bool isSelectedChanged() {
    bool retval = (prevSelectedMid != selectedMid);
    prevSelectedMid = selectedMid;
    return retval;
  }

  bool isSelected(String mid) {
    //rlogHolder.log('isPageSelected($mid)');
    return selectedMid == mid;
  }

  // void updateLastOrder() {
  //   lock();
  //   for (var ele in modelList) {
  //     if (ele.order.value > lastOrder) {
  //       lastOrder = ele.order.value;
  //     }
  //   }
  //   unlock();
  // }

  void setSelected(int index) {
    prevSelectedMid = selectedMid;
    selectedMid = modelList[0].mid;
    String className = HycopUtils.getClassName(selectedMid);
    if (className != 'frame' && className != 'content') {
      DraggableStickers.selectedAssetId = "";
    }
    logger.finest('selected1=$selectedMid, prev=$prevSelectedMid');
  }

  Future<void> setSelectedMid(String mid) async {
    prevSelectedMid = selectedMid;
    selectedMid = mid;
    logger.finest('selected2=$selectedMid, prev=$prevSelectedMid');

    String className = HycopUtils.getClassName(selectedMid);
    if (className != 'frame' && className != 'content') {
      DraggableStickers.selectedAssetId = "";
    }

    notify();
  }

  Future<void> clearSelectedMid() async {
    prevSelectedMid = selectedMid;
    selectedMid = "";
    logger.finest('unselected, prev=$prevSelectedMid');
    DraggableStickers.selectedAssetId = "";

    notify();
  }

  AbsExModel? getSelected() {
    if (selectedMid.isEmpty) {
      return null;
    }
    for (var ele in modelList) {
      if (ele.mid == selectedMid) {
        return ele;
      }
    }
    return null;
  }

  void printLog() {
    lock();
    for (var ele in modelList) {
      logger.finer('${ele.mid}, isRemoved=${ele.isRemoved.value}');
    }
    unlock();
  }

  bool updateModel(CretaModel newModel) {
    lock();
    bool retval = false;
    for (var ele in modelList) {
      CretaModel model = ele as CretaModel;
      if (model.mid == newModel.mid) {
        newModel.copyTo(model);
        logger.finer('copy ${newModel.mid}');
        retval = true;
        break;
      }
    }
    unlock();
    return retval;
  }
}
