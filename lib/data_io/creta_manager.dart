// ignore_for_file: prefer_final_fields, depend_on_referenced_packages

import 'dart:io';
import 'package:hycop/hycop/enum/model_enums.dart';
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

import '../design_system/menu/creta_popup_menu.dart';
import '../model/creta_model.dart';

enum DBState {
  idle,
  querying,
}

abstract class CretaManager extends AbsExModelManager {
  static const int maxTotalLimit = 500;
  static const int maxPageLimit = 100;
  static const int defaultPageLimit = 50;

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
  int _lastLimit = 0;
  List<Object>? _lastSortedObjectList;
  Map<String, OrderDirection> _currentSortAttr = {};

  DBState _dbState = DBState.idle;
  Map<String, dynamic> _currentQuery = {};

  String _currentSearchStr = '';
  List<String> _currentLikeAttrList = [];
  void clearAll() {
    _currentSearchStr = '';
    _currentLikeAttrList.clear();
    _currentQuery.clear();
    clearPage();
  }

  void clearPage() {
    _currentSortAttr.clear();
    if (_lastSortedObjectList != null) {
      _lastSortedObjectList!.clear();
      _lastSortedObjectList = null;
    }
    _dbState = DBState.idle;
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
    logger.finest('toFiltered');
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
    Map<String, dynamic> query = {};
    if (name != null && value != null) {
      query[name] = value;
    }
    query['creator'] = userId;
    query['isRemoved'] = false;
    queryFromDB(query).then((value) {
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

  Future<List<AbsExModel>> isGetListFromDBComplete() async {
    return await _lock.protect(() async {
      while (_dbState == DBState.querying) {
        sleep(const Duration(milliseconds: 100));
      }
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
    return retval;
  }

  Future<List<AbsExModel>> myDataOnly(String userId,
      {int limit = CretaManager.defaultPageLimit}) async {
    logger.finest('my override myDataOnly');
    Map<String, dynamic> query = {};
    query['creator'] = userId;
    query['isRemoved'] = false;
    final retval = await queryFromDB(query, limit: limit);
    return retval;
  }

  Future<List<AbsExModel>> queryFromDB(
    Map<String, dynamic> query, {
    int limit = CretaManager.defaultPageLimit,
    Map<String, OrderDirection>? orderBy,
    bool isNew = true,
  }) async {
    logger.finest('my queryFromDB(${query.toString()})');
    lock();
    _dbState = DBState.querying;

    if (limit > CretaManager.maxPageLimit) {
      limit = CretaManager.maxPageLimit;
    }
    _lastLimit = limit;

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
      List<AbsExModel> retval = resultList.map((ele) {
        AbsExModel model = newModel();
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
      return retval;
    } catch (e) {
      logger.severe('databaseError', e);
      _dbState = DBState.idle;
      unlock();
      throw HycopException(message: 'databaseError', exception: e as Exception);
    }
  }

  Future<bool> next() async {
    if (_dbState == DBState.idle &&
        _lastFetchedCount >= _lastLimit &&
        _totaltFetchedCount <= CretaManager.maxTotalLimit) {
      await queryFromDB({..._currentQuery},
          limit: _lastLimit == 0 ? CretaManager.defaultPageLimit : _lastLimit, isNew: false);
      return true;
    }
    return false;
  }

  Future<bool> scrollListener(ScrollController controller) async {
    double scrollOffset = controller.offset;
    double nextPageTrigger = 0.8 * controller.position.maxScrollExtent;
    if (controller.position.pixels > nextPageTrigger) {
      logger.finest('end of page($scrollOffset, ${controller.position.pixels}, $nextPageTrigger)');
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

    lock();

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
      unlock();
      return;
    }

    if (isApplyCreate && directive == 'create') {
      AbsExModel model = newModel();
      model.fromMap(dataMap);
      modelList.insert(0, model);
      logger.finest('${model.mid} realtime added');
      if (isNotifyCreate) notifyListeners();
    } else if (isApplyModify && directive == 'set') {
      String mid = dataMap["mid"] ?? '';
      if (mid.isEmpty) {
        unlock();
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
        unlock();
        return;
      }
      for (AbsExModel model in modelList) {
        if (model.mid == mid) {
          modelList.remove(model);
          logger.finest('${model.mid} realtime removed');
          if (isNotifyDelete) notifyListeners();
        }
      }
    }
    unlock();
    return;
  }

  void addRealTimeListen() {
    HycopFactory.realtime!.addListener(instanceId, collectionId, realTimeCallback);
  }

  void removeRealTimeListen() {
    HycopFactory.realtime!.removeListener(instanceId, collectionId);
  }

  void insert(CretaModel model) {
    lock();
    modelList.insert(0, model);
    notify();
    unlock();
  }

  void remove(CretaModel removedItem) {
    lock();
    modelList.remove(removedItem);
    notify();
    unlock();
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
  //
  //  realtime 이벤트 관련 end ]
  //

}
