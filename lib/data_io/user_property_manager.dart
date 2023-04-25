// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:creta03/model/app_enums.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/undo/save_manager.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/account/account_manager.dart';
import 'package:hycop/hycop/database/abs_database.dart';
import 'package:hycop/hycop/hycop_factory.dart';
import 'package:hycop/hycop/model/user_model.dart';
import 'package:hycop/hycop/utils/hycop_exceptions.dart';
import '../model/creta_model.dart';
import '../model/frame_model.dart';
import '../model/user_property_model.dart';
import '../pages/studio/studio_constant.dart';
import 'creta_manager.dart';

class UserPropertyManager extends CretaManager {
  late UserModel userModel;
  final List<FrameModel> _frameModelList = [];
  UserPropertyModel? propertyModel;

  UserPropertyManager() : super('creta_user_property') {
    userModel = AccountManager.currentLoginUser;
    saveManagerHolder?.registerManager('user', this);
  }
  @override
  AbsExModel newModel(String mid) => UserPropertyModel(mid);

  @override
  CretaModel cloneModel(CretaModel src) {
    UserPropertyModel retval = newModel(src.mid) as UserPropertyModel;
    src.copyTo(retval);
    return retval;
  }

  Future<void> initUserProperty() async {
    clearAll();
    await getUserProperty();
  }

  Future<int> getUserProperty() async {
    int userCount = 0;
    startTransaction();
    try {
      userCount = await getProperty();
      if (userCount == 0) {
        await createNext();
        userCount = 1;
      }
    } catch (e) {
      logger.finest('something wrong $e');
      await createNext();
      userCount = 1;
    }
    endTransaction(); 
    return userCount;
  }

  void addFavColor(Color color) {
    if (propertyModel == null) {
      return;
    }
    propertyModel!.lastestUseColors.add(color);
    propertyModel!.save();
  }

  List<Color> getColorList() {
    if (propertyModel == null) {
      return [];
    }
    return propertyModel!.lastestUseColors;
  }

  Future<UserPropertyModel> createNext() async {
    //updateLastOrder();
    propertyModel = UserPropertyModel.withName(
      pparentMid: userModel.userId,
      email: userModel.email,
      nickname: userModel.name,
      phoneNumber: userModel.phone,
      profileImg: '',
      teamMembers: [],
      country: Country.none,
      language: Language.none,
      job: Job.none,
      cretaGrade: CretaGrade.none,
      ratePlan: RatePlan.none,
      freeSpace: 0,
      bookCount: 0,
      bookViewCount: 0,
      bookViewTime: 0,
      likeCount: 0,
      commentCount: 0,
      lastestBook: '',
      lastestUseFrames: [],
      lastestUseColors: [
        Colors.white,
        Colors.black,
        Colors.red,
        Colors.blue,
        Colors.yellow,
        Colors.green,
        Colors.purple,
      ]
    );
    await createToDB(propertyModel!);
    insert(propertyModel!, postion: getAvailLength());
    selectedMid = propertyModel!.mid;
    await getLinkedObject();
    return propertyModel!;
  }

  Future<int> getProperty({int limit = 99}) async {
    logger.finest('getProperty ${userModel.userId}');
    Map<String, QueryValue> query = {};
    query['parentMid'] = QueryValue(value: userModel.userId);
    query['isRemoved'] = QueryValue(value: false);
    Map<String, OrderDirection> orderBy = {};
    orderBy['order'] = OrderDirection.ascending;
    await queryFromDB(query, orderBy: orderBy, limit: limit);
    logger.finest('getProperty ${modelList.length}');
    //updateLastOrder();

    propertyModel = onlyOne() as UserPropertyModel?;
    await getLinkedObject();

    return modelList.length;
  }

  Future<void> getLinkedObject() async {
    if (propertyModel != null) {
      await getFrameListFromDB();
    }
  }

  Future<FrameModel> _getFrameFromDB(String mid) async {
    try {
      FrameModel model = FrameModel(mid);
      model.fromMap(await HycopFactory.dataBase!.getData('creta_frame', mid));
      return model;
    } catch (e) {
      logger.severe('databaseError', e);
      throw HycopException(message: 'databaseError', exception: e as Exception);
    }
  }

  Future<List<FrameModel>> getFrameListFromDB() async {
    if (propertyModel!.lastestUseFrames.isEmpty) {
      return await _getAnyLattestFrames();
    }

    for (String mid in propertyModel!.lastestUseFrames) {
      FrameModel model = await _getFrameFromDB(mid);
      _frameModelList.add(model);
    }
    return _frameModelList;
  }

  List<FrameModel> getFrameList() {
    return _frameModelList;
  }

  Future<List<FrameModel>> _getAnyLattestFrames() async {
    logger.finest('_getAnyLattestFrames');
    Map<String, QueryValue> query = {};
    query['parentMid'] = QueryValue(value: 'TEMPLATE');
    query['isRemoved'] = QueryValue(value: false);

    Map<String, OrderDirection> orderBy = {'updateTime': OrderDirection.descending};

    List resultList = await HycopFactory.dataBase!.queryPage(
      'creta_frame',
      where: query,
      orderBy: orderBy,
      limit: StudioConst.maxMyFavFrame,
    );

    logger.finest('_getAnyLattestFrames ${resultList.length}');

    if (propertyModel == null) {
      logger.severe('propertyModel == null');
      return _frameModelList;
    }

    for (var ele in resultList) {
      FrameModel model = FrameModel(ele['mid'] ?? '');
      model.fromMap(ele);

      logger.finest('ele = ${model.mid}');
      _frameModelList.add(model);
      logger.finest('ele = ${model.mid}');
      propertyModel!.lastestUseFrames.add(model.mid);
      logger.finest('ele = ${model.mid}');
      if (_frameModelList.length >= 4) {
        break;
      }
    }
    logger.finest('save ${_frameModelList.length}');
    propertyModel?.save();

    logger.finest('getAnyLattestFrames ${propertyModel!.lastestUseFrames.toString()}');
    return _frameModelList;
  }
}
