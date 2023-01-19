// ignore_for_file: prefer_final_fields

import 'dart:io';
import 'package:sortedmap/sortedmap.dart';
import 'package:hycop/hycop/hycop_factory.dart';
import 'package:mutex/mutex.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model_manager.dart';

import '../model/creta_model.dart';

abstract class CretaManager extends AbsExModelManager {
  CretaManager(String tableName) : super(tableName);

  final _lock = Mutex();
  void lock() => _lock.acquire();
  void unlock() => _lock.release();

  bool isFetched = false;

  String? _sortedField;
  SortedMap<String, CretaModel> _sortedMap = SortedMap<String, CretaModel>();
  void toSorted(String sortAttrName,
      {bool descending = false, void Function(String sortedAttribute)? onModelSorted}) {
    _sortedMap.clear();
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
      _sortedMap[strVal] = ele as CretaModel;
      logger.finest('${ele.key} , $strVal added');
    }
    if (_sortedMap.isNotEmpty) {
      _sortedField = sortAttrName;
      lock();
      modelList.clear();
      if (descending) {
        for (var ele in _sortedMap.values.toList().reversed) {
          modelList.add(ele);
        }
      } else {
        for (var ele in _sortedMap.values) {
          modelList.add(ele);
        }
      }
      unlock();
      if (onModelSorted != null) onModelSorted(_sortedField!);
    }
  }

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
    isFetched = true;
    unlock();
    return retval;
  }

  @override
  void realTimeCallback(String directive, String userId, Map<String, dynamic> dataMap) {
    logger.finest('realTimeCallback invoker($directive, $userId)');
    if (isApplyCreate && directive == 'create') {
      AbsExModel model = newModel();
      model.fromMap(dataMap);
      modelList.insert(0, model);
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
          modelList.remove(model);
          logger.finest('${model.mid} realtime removed');
          if (isNotifyDelete) notifyListeners();
        }
      }
    }
  }

  void addRealTimeListen() {
    HycopFactory.realtime!.addListener(collectionId, realTimeCallback);
  }

  void removeRealTimeListen() {
    HycopFactory.realtime!.removeListener(collectionId);
  }
}
