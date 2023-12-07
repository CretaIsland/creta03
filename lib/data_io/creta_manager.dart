// ignore_for_file: prefer_final_fields, depend_on_referenced_packages

import 'package:hycop/hycop.dart';
import 'package:deep_collection/deep_collection.dart';
//import 'package:sortedmap/sortedmap.dart';
import 'package:flutter/material.dart';
//import 'package:sortedmap/sortedmap.dart';
import 'package:mutex/mutex.dart';

import '../design_system/component/snippet.dart';
import '../design_system/menu/creta_popup_menu.dart';
import '../model/app_enums.dart';
import '../model/creta_model.dart';
import '../pages/studio/book_main_page.dart';
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

  String get getMidFieldName => 'mid';

  //SortedMap<double, CretaModel> _orderMap = SortedMap<double, CretaModel>();
  Map<double, CretaModel> _orderMap = {};

  static String modelPrefix(ExModelType type) {
    return '${type.name}=';
  }

  String? instanceId;
  String? parentMid;
  void setParentMid(String p) {
    parentMid = p;
  }

  CretaManager(String tableName, this.parentMid) : super(tableName) {
    //instanceId = const Uuid().v4();
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

  void setState(DBState state) => (_dbState = state);

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

  static Future<AbsExModel?> getModelFromDB(
      String mid, String collectionId, AbsExModel model) async {
    //print('getModelFromDB $collectionId, $mid');
    try {
      Map<String, dynamic> map = await HycopFactory.dataBase!.getData(collectionId, mid);
      //print('map=${map.toString()}');
      if (map.isEmpty) {
        logger.severe('no data founded $collectionId, $mid');
        return null;
      }
      model.fromMap(map);
      return model;
    } catch (e) {
      logger.severe('databaseError', e);
      //throw HycopException(message: 'databaseError', exception: e as Exception);
      return null;
    }
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
  Future<AbsExModel?> getFromDB(String mid) async {
    logger.finest('my getFromDB($mid)');
    lock();
    _dbState = DBState.querying;
    AbsExModel? retval = await super.getFromDB(mid);
    _dbState = DBState.idle;
    modelList.clear();
    if (retval != null) {
      modelList.add(retval);
    }
    unlock();
    //reOrdering();
    return retval;
  }

  Future<AbsExModel> getFromAnotherCollection(String mid, String pcollectionId) async {
    try {
      AbsExModel model = newModel(mid);
      model.fromMap(await HycopFactory.dataBase!.getData(pcollectionId, mid));
      return model;
    } catch (e) {
      logger.severe('databaseError', e);
      throw HycopException(message: 'databaseError', exception: e as Exception);
    }
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
    bool useLocking = true,
  }) async {
    if (useLocking) {
      lock();
      _dbState = DBState.querying;
    }

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
        logger.fine('no data founded...');
        _lastFetchedCount = 0;
        if (_lastSortedObjectList != null) {
          _lastSortedObjectList!.clear();
        } else {
          _lastSortedObjectList = [];
        }
        if (useLocking) {
          _dbState = DBState.idle;
          unlock();
        }
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
      if (useLocking) {
        _dbState = DBState.idle;
        unlock();
      }
      //reOrdering();
      return retval;
    } catch (e) {
      logger.severe('databaseError $collectionId $e ');
      if (useLocking) {
        _dbState = DBState.idle;
        unlock();
      }
      throw HycopException(message: 'databaseError $collectionId', exception: e as Exception);
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
    //print('createToDB(${model.mid}, ${model.isRemoved.value})');
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
  void realTimeCallback(
      String listenerId, String directive, String userId, Map<String, dynamic> dataMap) {
    //print('--------------------realTimeCallback invoker($directive, $userId)');

    // if (parentMid == null) {
    //   return;
    // }
    // print('parentMid($parentMid), listnerId($listenerId)');
    // if (parentMid != listenerId) {
    //   print('parentMid($parentMid)!=listnerId($listenerId)');
    //   return;
    // }

    bool isFilteredOut = false;
    if (_currentQuery.isNotEmpty) {
      isFilteredOut = true;
      for (var key in _currentQuery.keys) {
        dynamic data = dataMap[key];

        if (data != null) {
          // print('${_currentQuery[key]!.value}..............................');
          if (data == _currentQuery[key]!.value) {
            isFilteredOut = false;
            break;
          }
        }
      }
    }

    if (isFilteredOut) {
      logger.finest('${dataMap["mid"] ?? ''} filter out');
      //print('${dataMap["mid"] ?? ''} filter out');
      return;
    }

    if (isApplyCreate && directive == 'create') {
      String mid = dataMap["mid"] ?? '';
      AbsExModel model = newModel(mid);
      model.fromMap(dataMap);
      insert(model as CretaModel, postion: 0);
      //print('#########${model.mid} realtime added');
      if (isNotifyCreate) {
        reOrdering();
        notifyListeners();
      }
    } else if (isApplyModify && directive == 'set') {
      String mid = dataMap["mid"] ?? '';
      if (mid.isEmpty) {
        // print('---mid is empty');
        return;
      }
      for (AbsExModel model in modelList) {
        if (model.mid == mid) {
          model.fromMap(dataMap);
          //print('*******${model.mid} realtime changed');
          if (isNotifyModify) {
            reOrdering();
            //print('notify');
            notifyListeners();
          }
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
          //print('${model.mid} realtime removed');
          if (isNotifyDelete) {
            reOrdering();
            notifyListeners();
          }
        }
      }
    }
    return;
  }

  void addRealTimeListen(String instId) {
    //print('addRealTimeListen($instanceId, $collectionId, )^^^^^^^^^^^^^^^^^^^^');
    instanceId = instId;
    HycopFactory.realtime!.addListener(instanceId!, collectionId, realTimeCallback);
  }

  void removeRealTimeListen() {
    if (instanceId != null) {
      HycopFactory.realtime!.removeListener(instanceId!, collectionId);
    }
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

  AbsExModel? getNth(double order) {
    return _orderMap[order];
  }

  String? getNthMid(double order) {
    AbsExModel? model = _orderMap[order];
    if (model == null) {
      return null;
    }
    return model.mid;
  }

  Iterable<CretaModel> orderValues() {
    return _orderMap.deepSortByKey().values;
  }

  Iterable<double> orderKeys() {
    return _orderMap.deepSortByKey().keys;
  }

  Iterable<MapEntry> orderEntries() {
    return _orderMap.deepSortByKey().entries;
  }

  double lastOrder() {
    if (isNotEmpty()) {
      return orderKeys().last;
    }
    return -1;
  }

  // 최소한 0을 리턴한다.
  double safeLastOrder() {
    double retval = lastOrder();
    if (retval < 0) {
      return 0;
    }
    return retval;
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

  List<T> reverseMapIterator<T>(T Function(AbsExModel) toElement) {
    List<T> retval = [];
    for (var model in _orderMap.deepSortByKey().values.toList().reversed) {
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

  // 해당 객체가 몇번째에 있는지를 알려준다.
  int? getSelectedNumber() {
    if (selectedMid.isEmpty) {
      return null;
    }
    int retval = 1;
    for (var ele in _orderMap.deepSortByKey().values) {
      if (ele.mid == selectedMid) {
        break;
      }
      retval++;
    }
    return retval;
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

  String getSelectedMid() {
    return selectedMid;
  }

  bool isSelected(String mid) {
    //rlogHolder.log('isPageSelected($mid)');
    return selectedMid == mid;
  }

  bool isEmptySelected() {
    //rlogHolder.log('isPageSelected($mid)');
    return selectedMid.isEmpty;
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
    if (className != 'frame' && className != 'contents') {
      DraggableStickers.frameSelectNotifier?.set("");
    }
    logger.fine('selected1=$selectedMid, prev=$prevSelectedMid');
  }

  Future<void> setSelectedMid(String mid, {bool doNotify = true}) async {
    prevSelectedMid = selectedMid;
    selectedMid = mid;
    logger.fine('selected2=$selectedMid, prev=$prevSelectedMid');

    String className = HycopUtils.getClassName(selectedMid);
    if (className != 'frame' && className != 'contents') {
      DraggableStickers.frameSelectNotifier?.set("", doNotify: doNotify); // clear 한다는뜻.
    }
    if (doNotify) {
      notify();
    }
  }

  Future<void> clearSelectedMid() async {
    prevSelectedMid = selectedMid;
    selectedMid = "";
    logger.finest('unselected, prev=$prevSelectedMid');
    DraggableStickers.frameSelectNotifier?.set("", doNotify: true);
    BookMainPage.miniMenuNotifier?.set(false, doNoti: true);
    //notify();
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

  double getSelectedOrder() {
    if (selectedMid.isEmpty) {
      logger.severe('No selected mid');
      return -1;
    }
    for (var ele in modelList) {
      if (ele.mid == selectedMid) {
        logger.fine('selected mid=$selectedMid, order=${ele.order.value}');
        return ele.order.value;
      }
    }
    logger.severe('No matched mid');
    return -2;
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
        model.updateFrom(newModel);
        logger.fine('updateModel ${newModel.mid}');
        //print('updateModel ${newModel.mid}');
        retval = true;
        break;
      }
    }
    unlock();
    return retval;
  }

  Future<void> removeChild(String parentMid) async {
    //print('------------------------');
  }

  Future<void> removeAll() async {
    for (var model in modelList) {
      model.isRemoved.set(
        true,
        //save: false,
        doComplete: (val) => reOrdering(),
        undoComplete: (val) => reOrdering(),
        dontRealTime: true, //  child 를 지울때는 realTime 을 하지 않는다.  엄마가 없기 때문에 할 필요가 없다.
      );

      //await setToDB(model);
      logger.fine('${model.mid} removed');
      await removeChild(model.mid);
    }
    //print('removeAll end');
    reOrdering();
  }

  Future<AbsExModel> makeCopy(String newBookMid, AbsExModel src, String? newParentMid) async {
    // 이미, publish 되어 있다면, 해당 mid 를 가져와야 한다.
    AbsExModel newOne = newModel('');
    // creat_book_published data 를 만든다.
    newOne.copyFrom(src, newMid: newOne.mid, pMid: newParentMid ?? newOne.parentMid.value);
    newOne.setRealTimeKey(newBookMid);
    //print('makeCopy : newMid=${newOne.mid}, parent=$newParentMid');

    await createToDB(newOne);
    return newOne;
  }

  Future<int> copyBook(String newBookMid, String? newParentMid) async {
    // 이미, publish 되어 있다면, 해당 mid 를 가져와야 한다.
    lock();
    int counter = 0;
    for (var ele in modelList) {
      if (ele.isRemoved.value == true) {
        continue;
      }
      await makeCopy(newBookMid, ele, newParentMid);
      counter++;
    }
    unlock();
    return counter;
  }

  int getIndex(String mid) {
    int count = 1;
    for (var ele in _orderMap.deepSortByKey().values) {
      if (ele.mid == mid) {
        return count;
      }
      count++;
    }
    return -1;
  }

  // static Future<bool> _reOdering(CretaManager manager) async {
  //   await manager.reOrdering();
  //   return true;
  // }

  // static FutureBuilder<bool> waitReorder({
  //   required CretaManager manager,
  //   required Widget child,
  // }) {
  //   return FutureBuilder<bool>(
  //       future: _reOdering(manager),
  //       builder: (context, AsyncSnapshot<bool> snapshot) {
  //         if (snapshot.hasError) {
  //           //error가 발생하게 될 경우 반환하게 되는 부분
  //           logger.severe("data fetch error(WaitDatum)");
  //           return const Center(child: Text('data fetch error(WaitDatum)'));
  //         }
  //         if (snapshot.hasData == false) {
  //           logger.fine("wait data ...(WaitData)");
  //           return Center(
  //             child: Snippet.showWaitSign(),
  //           );
  //         }
  //         if (snapshot.connectionState == ConnectionState.done) {
  //           logger.fine("founded ${snapshot.data!}");
  //           return child;
  //         }
  //         return const SizedBox.shrink();
  //       });
  // }

  Map<String, QueryValue> _whereCaluse = {};
  Map<String, OrderDirection> _orderBy = {};
  String _keyOnWheneIn = '';
  List<String>? _listValueOnWheneIn;
  String _keyOnContainsAny = '';
  List<String>? _listValueOnContainsAny; //skpark

  void clearConditions() {
    _whereCaluse = {};
    _orderBy = {};
    _keyOnWheneIn = '';
    _keyOnContainsAny = '';
    _listValueOnWheneIn = null;
  }

  void addWhereClause(String key, QueryValue queryValue) {
    if (queryValue.operType == OperType.whereIn && queryValue.value is List<String>) {
      List<String> stringList = queryValue.value as List<String>;
      if (stringList.length > 10 || HycopFactory.serverType == ServerType.appwrite) {
        _keyOnWheneIn = key;
        _listValueOnWheneIn = stringList;
        return;
      }
    }
    //skpark add , appwrite case
    if (HycopFactory.serverType == ServerType.appwrite) {
      if (queryValue.operType == OperType.arrayContainsAny && queryValue.value is List<String>) {
        //print('--value = ${queryValue.value.toString()}-----------------------------');
        _keyOnContainsAny = key;
        List<String> replacedList = [];
        for (String ele in queryValue.value) {
          String replaced = '"$ele"';
          replacedList.add(replaced);
        }
        _listValueOnContainsAny = replacedList;
        return;
      }
    }
    _whereCaluse[key] = queryValue;
  }

  void addOrderBy(String key, OrderDirection orderBy) {
    _orderBy[key] = orderBy;
  }

  void addCretaFilters({
    final BookType? bookType,
    final BookSort? bookSort,
    final OrderDirection? sortOrderDirection,
    final PermissionType? permissionType,
    final String searchKeyword = '', // searchKeyword, hashtag 둘중 하나만 사용
    final String hashtag = '', // searchKeyword, hashtag 둘중 하나만 사용
    final bool isRemoved = false,
    String? userId, // default value is {AccountManager.currentLoginUser.userId}
    String sortTimeName = 'updateTime',
  }) {
    // make query
    addWhereClause('isRemoved', QueryValue(value: isRemoved));
    // default user is {AccountManager.currentLoginUser}
    userId ??= AccountManager.currentLoginUser.email;
    // bookType
    if ((bookType?.index ?? 0) > 0) {
      addWhereClause('bookType', QueryValue(value: bookType!.index));
    }
    // permission
    if (permissionType != null) {
      final List<String> sharesList = [];
      if (permissionType == PermissionType.owner) {
        sharesList.add('<${PermissionType.owner.name}>$userId');
        //sharesList.add('<${PermissionType.owner.name}>public'); // <owner>public 은 없음
      } else if (permissionType == PermissionType.writer) {
        sharesList.add('<${PermissionType.owner.name}>$userId');
        //sharesList.add('<${PermissionType.owner.name}>public'); // <owner>public 은 없음
        sharesList.add('<${PermissionType.writer.name}>$userId');
        sharesList.add('<${PermissionType.writer.name}>public');
      } else /*if (widget.filterPermissionType == PermissionType.reader)*/ {
        sharesList.add('<${PermissionType.owner.name}>$userId');
        //sharesList.add('<${PermissionType.owner.name}>public'); // <owner>public 은 없음
        sharesList.add('<${PermissionType.writer.name}>$userId');
        sharesList.add('<${PermissionType.writer.name}>public');
        sharesList.add('<${PermissionType.reader.name}>$userId');
        sharesList.add('<${PermissionType.reader.name}>public');
      }
      addWhereClause('shares', QueryValue(value: sharesList, operType: OperType.arrayContainsAny));
    }
    // search keyword
    if (searchKeyword.isNotEmpty) {
      // Elasticsearch 될때까지 막아둠
      //query['name'] = QueryValue(value: widget.filterSearchKeyword, operType: OperType.like ??? );
      addWhereClause('name', QueryValue(value: searchKeyword, operType: OperType.textSearch));
    } else if (hashtag.isNotEmpty) {
      // Elasticsearch 될때까지 막아둠
      //query['name'] = QueryValue(value: widget.filterSearchKeyword, operType: OperType.like ??? );
      addWhereClause('hashTag', QueryValue(value: hashtag, operType: OperType.textSearch));
    }
    // sort order
    if (bookSort != null) {
      switch (bookSort) {
        case BookSort.name:
          addOrderBy('name', sortOrderDirection ?? OrderDirection.ascending);
          break;
        case BookSort.likeCount:
          addOrderBy('likeCount', sortOrderDirection ?? OrderDirection.descending);
          break;
        case BookSort.viewCount:
          addOrderBy('viewCount', sortOrderDirection ?? OrderDirection.descending);
          break;
        case BookSort.updateTime:
        default:
          addOrderBy(sortTimeName, sortOrderDirection ?? OrderDirection.descending);
          break;
      }
    }
  }

  Future<List<AbsExModel>> queryByAddedContitions() async {
    if (_listValueOnWheneIn != null) {
      // whereIn query
      int totalCount = _listValueOnWheneIn!.length;
      int count = 0;
      List<String> valueList = [];
      modelList.clear();
      lock();
      _dbState = DBState.querying;
      for (var value in _listValueOnWheneIn!) {
        count++;
        valueList.add(value);
        if ((count % 10) == 0 || count == totalCount) {
          Map<String, QueryValue> newCond = {..._whereCaluse};
          newCond[_keyOnWheneIn] = QueryValue(value: valueList, operType: OperType.whereIn);
          await queryFromDB(
            newCond,
            orderBy: _orderBy,
            isNew: false,
            useLocking: false,
          );
          valueList.clear();
        }
      }
      _dbState = DBState.idle;
      unlock();
      clearConditions();
      return modelList;
    }
    //skpark appwrite case for arrayContainsAny,
    if (_listValueOnContainsAny != null) {
      // arrayContainsAny query
      modelList.clear();
      lock();
      _dbState = DBState.querying;
      for (var value in _listValueOnContainsAny!) {
        Map<String, QueryValue> newCond = {..._whereCaluse};
        newCond[_keyOnContainsAny] = QueryValue(value: value, operType: OperType.arrayContainsAny);
        await queryFromDB(
          newCond,
          orderBy: _orderBy,
          isNew: false,
          useLocking: false,
        );
        // for (var ele in modelList) {
        //   print('---------------model is founded(${ele.mid})');
        // }
      }
      _dbState = DBState.idle;
      unlock();
      clearConditions();

      return modelList;
    }
    // normal query
    List<AbsExModel> retVal = await queryFromDB(
      _whereCaluse,
      //limit: ,
      orderBy: _orderBy,
    ).whenComplete(() => clearConditions());
    return retVal;
  }

  void queryFromIdList(List<String> idList,
      {bool isRemoved = false, bool clearPrevCondition = true}) {
    if (clearPrevCondition) {
      clearAll();
      clearConditions();
    }
    if (idList.isEmpty) {
      setState(DBState.idle);
      return;
    }
    addWhereClause('isRemoved', QueryValue(value: isRemoved));
    addWhereClause(getMidFieldName, QueryValue(value: idList, operType: OperType.whereIn));
    queryByAddedContitions();
  }

  void queryFromIdMap(Map<String, String> idMap, {bool clear = true}) {
    if (clear) {
      clearAll();
      clearConditions();
    }
    if (idMap.isEmpty) {
      setState(DBState.idle);
      return;
    }
    final List<String> idList = [];
    idMap.forEach((key, value) => idList.add(value));
    addWhereClause('isRemoved', QueryValue(value: false));
    addWhereClause(getMidFieldName, QueryValue(value: idList, operType: OperType.whereIn));
    queryByAddedContitions();
  }

  // static Future<bool> join(List<CretaManager> managerList, List<Function> queryFuncList, List<Function(List<AbsExModel>)?> resultFuncList) async {
  //   if (managerList.length != queryFuncList.length || queryFuncList.length != resultFuncList.length) {
  //     return false;
  //   }
  //   for (int i = 0; i < queryFuncList.length; i++) {
  //     queryFuncList[i].call();
  //     List<AbsExModel> value = await managerList[i].isGetListFromDBComplete();
  //     resultFuncList[i]?.call(value);
  //   }
  //   return true;
  // }

  static Future<bool> startQueries(
      {required List<QuerySet> joinList, Function? completeFunc}) async {
    List<AbsExModel> value = [];
    for (var joinValue in joinList) {
      joinValue.queryFunc.call(value);
      value = await joinValue.manager.isGetListFromDBComplete();
      joinValue.resultFunc?.call(value);
    }
    completeFunc?.call();
    return true;
  }

  Iterable<CretaModel> getReversed() => _orderMap.deepSortByKey().values.toList().reversed;
  Iterable<CretaModel> getOrdered() => _orderMap.deepSortByKey().values;
}

class QuerySet {
  const QuerySet(
    this.manager,
    this.queryFunc,
    this.resultFunc,
  );
  final CretaManager manager;
  final Function(List<AbsExModel> prevResult) queryFunc;
  final Function(List<AbsExModel> result)? resultFunc;
}
