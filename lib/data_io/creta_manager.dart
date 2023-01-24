// ignore_for_file: prefer_final_fields, depend_on_referenced_packages

import 'dart:io';
import 'package:hycop/hycop/utils/hycop_exceptions.dart';
import 'package:uuid/uuid.dart';
//import 'package:sortedmap/sortedmap.dart';
import 'package:hycop/hycop/hycop_factory.dart';
import 'package:mutex/mutex.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model_manager.dart';
import 'package:sortedmap/sortedmap.dart';

import '../design_system/menu/creta_popup_menu.dart';
import '../model/creta_model.dart';

abstract class CretaManager extends AbsExModelManager {
  CretaManager(String tableName) : super(tableName);

  final _lock = Mutex();
  void lock() => _lock.acquire();
  void unlock() => _lock.release();

  String _currentSearchStr = '';
  List<String> _currentLikeAttrList = [];
  void clearSearch() {
    _currentSearchStr = '';
    _currentLikeAttrList.clear();
  }

  //
  //  [ 소팅 관련
  //
  void toSorted(String sortAttrName, {bool descending = false, Function? onModelSorted}) {
    SortedMap<String, CretaModel> sortedMap = SortedMap<String, CretaModel>();
    //sortedMap.clear();
    lock();

    for (AbsExModel ele in modelList) {
      //Map<String, dynamic> map = ele.toMap();
      // map.forEach((key, value) {
      //   logger.finest('key=$key');
      // });
      dynamic val = ele.toMap()[sortAttrName];
      if (val == null) {
        logger.severe('attribute ($sortAttrName) does not exist in colection ($collectionId)');
        continue;
      }
      String strVal = '';
      if (val is num) {
        strVal = val.toString().padLeft(20, '0');
      } else if (val is DateTime) {
        strVal = val.millisecondsSinceEpoch.toString();
      } else {
        strVal = val.toString();
      }
      // uniq key 로 만들기위해 뒤에 uid를 붙인다.
      strVal += const Uuid().v4();

      sortedMap[strVal] = ele as CretaModel;
      logger.finest('${ele.key} , $strVal added');
    }
    if (sortedMap.isEmpty) {
      unlock();
      return;
    }
    modelList.clear();
    if (descending) {
      for (var ele in sortedMap.values.toList().reversed) {
        modelList.add(ele);
      }
    } else {
      for (var ele in sortedMap.values) {
        modelList.add(ele);
      }
    }
    unlock();
    if (onModelSorted != null) onModelSorted();
    return;
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
  bool isFetched = false;
  Map<String, dynamic> _currentQuery = {};

  Future<List<AbsExModel>> isGetListFromDBComplete() async {
    return await _lock.protect(() async {
      while (!isFetched) {
        sleep(const Duration(milliseconds: 100));
      }
      return modelList;
    });
  }

  @override
  Future<List<AbsExModel>> getListFromDB(String userId) async {
    logger.finest('my override getListFromDB');
    lock();
    isFetched = false;
    final retval = await super.getListFromDB(userId);
    _currentQuery.clear();
    _currentQuery['creator'] = userId;
    _currentQuery['isRemoved'] = false;
    isFetched = true;
    unlock();
    return retval;
  }

  Future<List<AbsExModel>> queryFromDB(Map<String, dynamic> query) async {
    logger.finest('my queryFromDB(${query.toString()})');
    lock();
    isFetched = false;

    modelList.clear();
    try {
      List resultList = await HycopFactory.dataBase!.queryData(
        collectionId,
        where: query,
        orderBy: 'updateTime',
        //limit: 2,
        //offset: 1, // appwrite only
        //startAfter: [DateTime.parse('2022-08-04 12:00:01.000')], //firebase only
      );
      var retval = resultList.map((ele) {
        AbsExModel model = newModel();
        model.fromMap(ele);
        modelList.add(model);
        return model;
      }).toList();
      isFetched = true;
      _currentQuery.clear();
      _currentQuery.addAll(query);
      logger.finest('query=${query.toString()},_currentQuery=${_currentQuery.toString()}');
      unlock();
      return retval;
    } catch (e) {
      logger.severe('databaseError', e);
      unlock();
      throw HycopException(message: 'databaseError', exception: e as Exception);
    }
  }

  //
  //  get DB  관련  ]
  //

  //
  //  [ 이벤트 필터링 관련
  //

  bool isApplyCreate = true;
  bool isApplyDelete = true;
  bool isApplyModify = true;
  bool isNotifyCreate = true;
  bool isNotifyDelete = true;
  bool isNotifyModify = true;

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
          unlock();
          return;
        }
        if (data != value) {
          isFilteredOut = true;
          unlock();
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
  }

  void addRealTimeListen() {
    HycopFactory.realtime!.addListener(collectionId, realTimeCallback);
  }

  void removeRealTimeListen() {
    HycopFactory.realtime!.removeListener(collectionId);
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
