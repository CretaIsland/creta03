import 'dart:math';

import 'package:flutter/material.dart';

import 'package:hycop/hycop.dart';

import 'package:creta03/data_io/creta_manager.dart';
import 'package:creta03/model/app_enums.dart';
import 'package:creta03/model/frame_model.dart';
import 'package:creta03/model/user_property_model.dart';
import 'package:creta03/pages/studio/studio_constant.dart';
import 'package:creta03/model/creta_model.dart';
import '../common/creta_utils.dart';
import '../design_system/creta_font.dart';
import '../lang/creta_lang.dart';
import '../model/team_model.dart';
import '../pages/login_page.dart';

class UserPropertyManager extends CretaManager {
  UserModel get userModel => AccountManager.currentLoginUser;
  final List<FrameModel> _frameModelList = [];
  UserPropertyModel? userPropertyModel;

  UserPropertyManager() : super('creta_user_property', null) {
    saveManagerHolder?.registerManager('user', this);
  }

  @override
  CretaModel cloneModel(CretaModel src) {
    UserPropertyModel retval = newModel(src.mid) as UserPropertyModel;
    src.copyTo(retval);
    return retval;
  }

  @override
  AbsExModel newModel(String mid) => UserPropertyModel(mid);

  void clearUserProperty() {
    userPropertyModel = null;
    _frameModelList.clear();
  }

  Future<void> initUserProperty() async {
    clearAll();
    if (AccountManager.currentLoginUser.isLoginedUser) {
      await getUserProperty();
    }
  }

  Future<int> getUserProperty() async {
    int userPropertyCount = 0;
    startTransaction();

    try {
      userPropertyCount = await _getUserProperty();
      if (userPropertyCount == 0) {
        await createUserProperty();
        userPropertyCount = 1;
      }
    } catch (error) {
      logger.severe('something wrong in userPropertyManager >> $error');
      //await createUserProperty();
      userPropertyCount = 1;
    }

    endTransaction();
    return userPropertyCount;
  }

  Future<int> _getUserProperty({int limit = 99}) async {
    Map<String, QueryValue> query = {};
    query['parentMid'] = QueryValue(value: userModel.userId);
    query['isRemoved'] = QueryValue(value: false);
    Map<String, OrderDirection> orderBy = {};
    orderBy['order'] = OrderDirection.ascending;
    await queryFromDB(query, orderBy: orderBy, limit: limit);

    userPropertyModel = onlyOne() as UserPropertyModel?;
    if (userPropertyModel != null) {
      await getLinkedObject();
    }

    return modelList.length;
  }

  Future<UserPropertyModel> createUserProperty() async {
    userPropertyModel = UserPropertyModel.withName(
        pparentMid: userModel.userId,
        email: userModel.email,
        nickname: userModel.name,
        phoneNumber: userModel.phone,
        cretaGrade: CretaGradeType.none,
        ratePlan: RatePlanType.none,
        profileImg: '',
        channelBannerImg: '',
        country: CountryType.none,
        language: LanguageType.none,
        job: JobType.none,
        freeSpace: 1042,
        bookCount: 0,
        bookViewCount: 0,
        bookViewTime: 0,
        likeCount: 0,
        commentCount: 0,
        useDigitalSignage: false,
        usePushNotice: false,
        useEmailNotice: false,
        isPublicProfile: true,
        theme: ThemeType.none,
        initPage: InitPageType.none,
        cookie: CookieType.none,
        autoPlay: true,
        mute: false,
        latestBook: '',
        latestUseFrames: const [],
        latestUseColors: const [
          Colors.white,
          Colors.black,
          Colors.red,
          Colors.blue,
          Colors.yellow,
          Colors.green,
          Colors.purple
        ],
        teams: const []);

    await createToDB(userPropertyModel!);
    insert(userPropertyModel!, postion: getAvailLength());
    selectedMid = userPropertyModel!.mid;
    await getLinkedObject();

    return userPropertyModel!;
  }

  Future<void> getLinkedObject() async {
    if (userPropertyModel != null) {
      await getFrameListFromDB();
    }
  }

  Future<FrameModel> _getFrameFromDB(String mid) async {
    try {
      FrameModel model = FrameModel(mid, '');
      model.fromMap(await HycopFactory.dataBase!.getData('creta_frame', mid));
      return model;
    } catch (e) {
      logger.severe('databaseError', e);
      throw HycopException(message: 'databaseError', exception: e as Exception);
    }
  }

  Future<List<FrameModel>> getFrameListFromDB() async {
    if (userPropertyModel!.latestUseFrames.isEmpty) {
      return await _getAnyLattestFrames();
    }

    for (String mid in userPropertyModel!.latestUseFrames) {
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

    if (userPropertyModel == null) {
      logger.severe('propertyModel == null');
      return _frameModelList;
    }

    for (var ele in resultList) {
      FrameModel model = FrameModel(ele['mid'] ?? '', ele['realTimeKey'] ?? '');
      model.fromMap(ele);

      logger.finest('ele = ${model.mid}');
      _frameModelList.add(model);
      logger.finest('ele = ${model.mid}');
      userPropertyModel!.latestUseFrames.add(model.mid);
      logger.finest('ele = ${model.mid}');
      if (_frameModelList.length >= 4) {
        break;
      }
    }
    logger.finest('save ${_frameModelList.length}');
    userPropertyModel?.save();

    logger.finest('getAnyLattestFrames ${userPropertyModel!.latestUseFrames.toString()}');
    return _frameModelList;
  }

  void addFavColor(Color color) {
    if (userPropertyModel == null) {
      return;
    }
    userPropertyModel!.latestUseColors.add(color);
    userPropertyModel!.save();
  }

  List<Color> getColorList() {
    if (userPropertyModel == null) {
      return [];
    }
    return userPropertyModel!.latestUseColors;
  }

  void setMute(bool val) {
    if (userPropertyModel != null) {
      userPropertyModel!.mute = val;
      setToDB(userPropertyModel!);
    }
  }

  bool getMute() {
    if (userPropertyModel == null) {
      return false;
    }
    return userPropertyModel!.mute;
  }

  void setAutoPlay(bool val) {
    if (userPropertyModel != null) {
      userPropertyModel!.autoPlay = val;
      setToDB(userPropertyModel!);
    }
  }

  bool getAutoPlay() {
    if (userPropertyModel == null) {
      return false;
    }
    return userPropertyModel!.autoPlay;
  }

  Future<UserPropertyModel?> getMemberProperty({required String memberMid, int limit = 99}) async {
    startTransaction();
    try {
      Map<String, QueryValue> query = {};
      query['email'] = QueryValue(value: memberMid);
      query['isRemoved'] = QueryValue(value: false);
      Map<String, OrderDirection> orderBy = {};
      orderBy['order'] = OrderDirection.ascending;
      await queryFromDB(query, orderBy: orderBy, limit: limit);
      logger.finest('getProperty ${modelList.length}');

      if (modelList.isNotEmpty) {
        return onlyOne() as UserPropertyModel;
      }
    } catch (error) {
      logger.info('something wrong in userPropertyManager >> $error');
      return null;
    }
    endTransaction();
    return null;
  }

  Future<List<UserPropertyModel>> getUserPropertyFromEmail(List<String> emailList) async {
    List<UserPropertyModel> userModelList = [];
    for (String email in emailList) {
      if (email == "public") {
        userModelList.add(makeDummyModel(null));
      } else if (CretaUtils.isValidEmail(email)) {
        UserPropertyModel? user = await emailToModel(email);
        if (user != null) {
          userModelList.add(user);
        }
      } else {
        // 팀 mid 라고 생각한다. 보통 자기 팀이므로, 자기팀에서 먼저 찾는다.
        TeamModel? team = await LoginPage.teamManagerHolder!.findTeamModel(email);
        if (team != null) {
          userModelList.add(makeDummyModel(team));
        }
      }
    }
    return userModelList;
  }

  UserPropertyModel makeDummyModel(TeamModel? team) {
    UserPropertyModel user = UserPropertyModel('');
    user.nickname = team == null ? CretaLang.entire : team.name;
    user.email = team == null ? 'public' : team.mid;
    if (team != null) user.profileImg = team.profileImg;
    return user;
  }

  Future<UserPropertyModel?> emailToModel(String email) async {
    Map<String, QueryValue> query = {};
    query['email'] = QueryValue(value: email);
    query['isRemoved'] = QueryValue(value: false);
    final userList = await queryFromDB(query);
    for (var ele in userList) {
      UserPropertyModel user = ele as UserPropertyModel;
      return user;
    }
    return null;
  }

  Widget profileImageBox({UserPropertyModel? model, Color? color, double radius = 200}) {
    model ??= userPropertyModel;
    return imageCircle(model!.profileImg, model.nickname, radius: radius, color: color);
  }

  Widget imageCircle(String img, String name, {Color? color, double radius = 200}) {
    return CircleAvatar(
        radius: radius,
        backgroundColor: color ?? Colors.primaries[Random().nextInt(Colors.primaries.length)],
        backgroundImage: img == '' ? null : Image.network(img).image,
        child: img == ''
            ? Center(
                child: Text(name.substring(0, 1),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: CretaFont.semiBold,
                        fontSize: (64 / 200) * radius,
                        color: Colors.white)))
            : Container());
  }
}
