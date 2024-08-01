import 'dart:ui';

import 'package:creta03/data_io/frame_manager.dart';
import 'package:creta_common/model/creta_model.dart';
import 'package:creta_studio_model/model/book_model.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import 'package:creta_studio_model/model/page_model.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';
import 'package:hycop/hycop.dart';

import '../model/template_model.dart';
import 'contents_manager.dart';

class TemplateManager extends CretaManager {
  TemplateManager({
    String tableName = 'creta_template',
    bool hasRealTime = false,
  }) : super(tableName, null) {
    if (hasRealTime) {
      saveManagerHolder?.registerManager('template', this);
    }
  }

  @override
  CretaModel cloneModel(CretaModel src) {
    TemplateModel retval = newModel(src.mid) as TemplateModel;
    src.copyTo(retval);
    return retval;
  }

  @override
  AbsExModel newModel(String mid) => TemplateModel(mid);

  Future<List<TemplateModel>>? getTemplateList(String parentMid,
      {String? queryText, Size? bookSize, bool showAll = false}) async {
    //print('getTemplateList =====================================');
    List<TemplateModel> retval = [];

    await _getTemplateList(
        queryText: queryText,
        bookSize: bookSize,
        showAll: showAll,
        isNew: true,
        parentMid: parentMid); // 나의 템플릿

    for (var each in modelList) {
      logger.finest('each = ${each.toMap()}');
      retval.add(each as TemplateModel);
    }

    await _getTemplateList(queryText: queryText, isNew: true); // 공용 템플릿

    for (var each in modelList) {
      logger.finest('each = ${each.toMap()}');
      retval.add(each as TemplateModel);
    }
    //print('getTemplateList(${retval.length}) succeed ================');
    return retval;
  }

  Future<int> _getTemplateList(
      {String? queryText,
      Size? bookSize,
      bool showAll = false,
      bool isNew = true,
      String parentMid = 'TEMPLATE'}) async {
    //PageManager pageManager = BookMainPage.pageManagerHolder!;  // Current Selected Page's manager
    try {
      Map<String, QueryValue> query = {};
      if (showAll == false && bookSize != null) {
        query['width'] = QueryValue(value: bookSize.width); // parentMid = userId
        query['height'] = QueryValue(value: bookSize.height); // parentMid = userId
      }

      query['parentMid'] = QueryValue(value: parentMid); // parentMid = userId
      if (queryText != null && queryText.isNotEmpty) {
        query['name'] = QueryValue(value: queryText);
      }
      query['isRemoved'] = QueryValue(value: false);
      Map<String, OrderDirection> orderBy = {};
      orderBy['updateTime'] = OrderDirection.descending;
      await queryFromDB(query, orderBy: orderBy, isNew: isNew);
    } catch (e) {
      logger.finest('something wrong $e');
    }

    return modelList.length;
  }

  Future<String?> isAlreadyExis({required String realTimeKey, required String name}) async {
    String? retval = await _isAlreadyExis(
        realTimeKey: realTimeKey, name: name, parentMid: AccountManager.currentLoginUser.email);
    if (retval != null) {
      return retval;
    }
    return await _isAlreadyExis(realTimeKey: realTimeKey, name: name);
  }

  Future<String?> _isAlreadyExis(
      {required String realTimeKey, required String name, String parentMid = 'TEMPLATE'}) async {
    //PageManager pageManager = BookMainPage.pageManagerHolder!;  // Current Selected Page's manager
    try {
      Map<String, QueryValue> query = {};
      query['parentMid'] = QueryValue(value: parentMid); // parentMid = userId
      query['name'] = QueryValue(value: name); //
      query['realTimeKey'] = QueryValue(value: realTimeKey); // parentMid = pageModel.mid
      query['isRemoved'] = QueryValue(value: false);

      await queryFromDB(query);
    } catch (e) {
      logger.finest('something wrong $e');
    }

    if (modelList.isNotEmpty) {
      return modelList[0].mid;
    }
    return null;
  }

  @override
  Future<void> removeChild(String parentMid) async {
    BookModel book = BookModel('');
    PageModel page = PageModel(parentMid, book);
    FrameManager frameManager = FrameManager(
      pageModel: page,
      bookModel: book,
    );

    try {
      Map<String, QueryValue> query = {};
      query['parentMid'] = QueryValue(value: parentMid); // parentMid = userId
      query['isRemoved'] = QueryValue(value: false);
      List<AbsExModel> frameList = await frameManager.queryFromDB(query);

      if (frameList.isNotEmpty) {
        for (var each in frameList) {
          ContentsManager contentsManager = ContentsManager(
            pageModel: page,
            frameModel: each as FrameModel,
          );
          Map<String, QueryValue> query = {};
          query['parentMid'] = QueryValue(value: each.mid); // parentMid = userId
          query['isRemoved'] = QueryValue(value: false);
          await contentsManager.queryFromDB(query);
          contentsManager.removeAll();
        }
      }
    } catch (e) {
      logger.finest('something wrong $e');
    }

    await frameManager.removeAll();
  }

  void deleteModel(TemplateModel model) async {
    mychangeStack.startTrans();
    model.isRemoved.set(true);
    setToDB(model);
    await removeChild(model.mid);
    notify();
    mychangeStack.endTrans();
  }
}
