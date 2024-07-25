// ignore_for_file: prefer_const_constructors

//import 'package:flutter/foundation.dart';
import 'package:creta_user_io/data_io/team_manager.dart';
import 'package:creta_user_io/data_io/user_property_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hycop/hycop.dart';
//import 'package:routemaster/routemaster.dart';

//import '../login_page.dart';
// import '../../routes.dart';
// import '../../design_system/component/snippet.dart';
// import '../../design_system/buttons/creta_button.dart';
// import '../../design_system/buttons/creta_button_wrapper.dart';
// import '../../design_system/buttons/creta_checkbox.dart';
// import '../../design_system/buttons/creta_radio_button.dart';
// import 'package:creta_common/common/creta_color.dart';
// import 'package:creta_common/common/creta_font.dart';
// import '../../design_system/dialog/creta_dialog.dart';
// import '../../design_system/menu/creta_drop_down_button.dart';
// import '../../design_system/menu/creta_popup_menu.dart';
// import '../../design_system/text_field/creta_text_field.dart';
// import 'package:creta_common/model/app_enums.dart';121
import '../../data_io/frame_manager.dart';
import '../../data_io/channel_manager.dart';
import '../../data_io/enterprise_manager.dart';
import 'package:creta_user_model/model/user_property_model.dart';
import 'package:creta_user_model/model/team_model.dart';
import '../../model/channel_model.dart';
import '../../model/enterprise_model.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import 'package:creta_studio_model/model/page_model.dart';
import 'package:creta_studio_model/model/book_model.dart';
import '../../pages/studio/studio_constant.dart';

class CretaAccountManager {
  // managers info
  static ChannelManager? _channelManagerHolder;
  static ChannelManager get channelManagerHolder => _channelManagerHolder!;

  static EnterpriseManager? _enterpriseManagerHolder;
  static EnterpriseManager get enterpriseManagerHolder => _enterpriseManagerHolder!;

  static FrameManager? _favFrameManagerHolder;
  //static FrameManager get frameManagerHolder => _favFrameManagerHolder!;

  //static TeamManager? TeamManager.teamManagerHolder;
  static TeamManager get teamManagerHolder => TeamManager.teamManagerHolder!;

  static UserPropertyManager? _userPropertyManagerHolder;
  static UserPropertyManager get userPropertyManagerHolder => _userPropertyManagerHolder!;

  // accounts info
  static UserModel get currentLoginUser => AccountManager.currentLoginUser;

  // static UserPropertyModel? _loginUserProperty;
  // static set setUserProperty(UserPropertyModel? model) => _loginUserProperty = model;
  static set setUserProperty(UserPropertyModel? model) =>
      UserPropertyManager.setUserProperty(model);
  static UserPropertyModel? get getUserProperty => UserPropertyManager.getUserProperty;

  //static TeamModel? getCurrentTeam;
  static TeamModel? get getCurrentTeam => TeamManager.getCurrentTeam;
  //static final Map<String, List<UserPropertyModel>> getTeamMemberMap = {};
  static Map<String, Set<UserPropertyModel>> get getTeamMemberMap => TeamManager.getTeamMemberMap;

  static ChannelModel? _loginChannel;
  static set setChannel(ChannelModel? model) => _loginChannel = model;
  static ChannelModel? get getChannel => _loginChannel;

  static EnterpriseModel? _loginEnterprise;
  static set setEnterprise(EnterpriseModel? model) => _loginEnterprise = model;
  static EnterpriseModel? get getEnterprise => _loginEnterprise;

  static EnterpriseModel? _cretaEnterprise;
  static EnterpriseModel? get getCretaEnterprise => _cretaEnterprise;

  static List<FrameModel> _loginFrameList = [];
  static set setFrameList(List<FrameModel> frameList) => _loginFrameList = [...frameList];
  static List<FrameModel> get getFrameList => _loginFrameList;

  // 무료 체험자를 검증하기 위한 bool type 추가
  // false일 경우 로그인 안함 && 체험하기도 아님 (=url로 바로 진입했을 때)
  // true일 경우 랜딩페이지에서 체험하기 버튼을 통해 진입했을 때
  static bool experienceWithoutLogin = false;

  //
  static Future<bool> initUserProperty({bool doGuestLogin = true}) async {
    if (_userPropertyManagerHolder == null) {
      _userPropertyManagerHolder = UserPropertyManager();
      _userPropertyManagerHolder?.configEvent();
      _userPropertyManagerHolder?.clearAll();
    }

    TeamManager.initTeamManagerHolder();

    if (_favFrameManagerHolder == null) {
      _favFrameManagerHolder =
          FrameManager(pageModel: PageModel('', BookModel('')), bookModel: BookModel(''));
      _favFrameManagerHolder?.configEvent();
      _favFrameManagerHolder?.clearAll();
    }
    if (_enterpriseManagerHolder == null) {
      _enterpriseManagerHolder = EnterpriseManager();
      _enterpriseManagerHolder?.configEvent();
      _enterpriseManagerHolder?.clearAll();
    }
    if (_channelManagerHolder == null) {
      _channelManagerHolder = ChannelManager();
      _channelManagerHolder?.configEvent();
      _channelManagerHolder?.clearAll();
    }
    if (getUserProperty != null) {
      return true;
    }
    // 현재 로그인정보로 사용자정보 가져옴
    bool isLogined = await _getUserProperty();
    if (isLogined == false) {
      logger.warning('login failed (_getUserProperty failed)');
      await logout(doGuestLogin: doGuestLogin);
      return false;
    }
    await _getFrameListFromDB();

    // team 및 ent 정보 가져움
    //await LoginPage.teamManagerHolder?.initTeam();
    await _initTeam();
    //await LoginPage.enterpriseHolder?.initEnterprise();
    await _initEnterprise();
    //await LoginPage.channelManagerHolder?.initChannel();
    await _initChannel();
    //if (LoginPage.teamManagerHolder!.modelList.isEmpty || LoginPage.enterpriseHolder!.modelList.isEmpty) {
    // team이 없거나, ent없으면 모든정보초기화
    if (_loginEnterprise == null) {
      // team이 없는건 가능, ent없으면 모든정보초기화
      logger.severe('login failed (_initEnterprise failed)');
      await logout();
      return false;
    }
    return true;
  }

  static void clear() {
    channelManagerHolder.clearAll();
    enterpriseManagerHolder.clearAll();
    _favFrameManagerHolder?.clearAll();
    teamManagerHolder.clearAll();
    userPropertyManagerHolder.clearAll();

    UserPropertyManager.setUserProperty(null);
    TeamManager.getTeamList.clear();
    _loginChannel = null;
    _loginEnterprise = null;
    _loginFrameList.clear();
  }

  static Future<bool> logout({bool doGuestLogin = true, bool doClear = true}) async {
    if (doClear) clear();
    await AccountManager.logout();
    if (doGuestLogin) await _guestUserLogin();
    return true;
  }

  static Future<bool> _getUserProperty() async {
    if (currentLoginUser.isLoginedUser == false && currentLoginUser.isGuestUser == false) {
      return false;
    }
    userPropertyManagerHolder.addWhereClause(
        'parentMid', QueryValue(value: currentLoginUser.userId));
    userPropertyManagerHolder.addWhereClause('isRemoved', QueryValue(value: false));
    await userPropertyManagerHolder.queryByAddedContitions();
    AbsExModel? model = userPropertyManagerHolder.onlyOne();
    UserPropertyManager.setUserProperty((model == null) ? null : model as UserPropertyModel);
    return (UserPropertyManager.getUserProperty != null);
  }

  static Future<List<FrameModel>> _getFrameListFromDB() async {
    if (getUserProperty!.latestUseFrames.isEmpty) {
      return await _getAnyLattestFrames();
    }
    _favFrameManagerHolder?.queryFromIdList(getUserProperty!.latestUseFrames);
    await _favFrameManagerHolder?.isGetListFromDBComplete();
    for (AbsExModel model in _favFrameManagerHolder?.modelList ?? []) {
      FrameModel frameModel = model as FrameModel;
      _loginFrameList.add(frameModel);
    }
    return _loginFrameList;
  }

  static Future<List<FrameModel>> _getAnyLattestFrames() async {
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

    for (var ele in resultList) {
      FrameModel model = FrameModel(ele['mid'] ?? '', ele['realTimeKey'] ?? '');
      model.fromMap(ele);

      logger.finest('ele = ${model.mid}');
      _loginFrameList.add(model);
      logger.finest('ele = ${model.mid}');
      getUserProperty!.latestUseFrames.add(model.mid);
      logger.finest('ele = ${model.mid}');
      if (_loginFrameList.length >= 4) {
        break;
      }
    }
    logger.finest('save ${_loginFrameList.length}');
    getUserProperty?.save();

    logger.finest('getAnyLattestFrames ${getUserProperty!.latestUseFrames.toString()}');
    return _loginFrameList;
  }

  static void addFavColor(Color color) {
    if (getUserProperty == null) {
      return;
    }
    getUserProperty!.latestUseColors.add(color);
    getUserProperty!.save();
  }

  static List<Color> getColorList() {
    if (getUserProperty == null) {
      return [];
    }
    return getUserProperty!.latestUseColors;
  }

  static void setMute(bool val) {
    if (getUserProperty != null) {
      getUserProperty!.mute = val;
      userPropertyManagerHolder.setToDB(getUserProperty!);
    }
  }

  static bool getMute() {
    if (getUserProperty == null) {
      return false;
    }
    return getUserProperty!.mute;
  }

  static String getDeviceColumnInfo() {
    if (getUserProperty == null) {
      return '';
    }
    return getUserProperty!.deviceColumnInfo;
  }

  static void setDeviceColumnInfo(String val) {
    if (getUserProperty != null) {
      getUserProperty!.deviceColumnInfo = val;
      userPropertyManagerHolder.setToDB(getUserProperty!);
    }
  }

  static String getUserColumnInfo() {
    if (getUserProperty == null) {
      return '';
    }
    return getUserProperty!.userColumnInfo;
  }

  static void setUserColumnInfo(String val) {
    if (getUserProperty != null) {
      getUserProperty!.userColumnInfo = val;
      userPropertyManagerHolder.setToDB(getUserProperty!);
    }
  }

  static void setAutoPlay(bool val) {
    if (getUserProperty != null) {
      getUserProperty!.autoPlay = val;
      userPropertyManagerHolder.setToDB(getUserProperty!);
    }
  }

  static bool getAutoPlay() {
    if (getUserProperty == null) {
      return false;
    }
    return getUserProperty!.autoPlay;
  }

  static Future<void> _initTeam() async {
    await _getTeamList();
    if (TeamManager.getTeamList.isNotEmpty) {
      setCurrentTeam(0);
    }
  }

  static Future<int> _getTeamList() async {
    try {
      teamManagerHolder.queryFromIdList(getUserProperty!.teams);
      await teamManagerHolder.isGetListFromDBComplete();
      Map<String, TeamModel> teamMap = {};
      for (var model in teamManagerHolder.modelList) {
        TeamModel teamModel = model as TeamModel;
        teamMap[teamModel.getMid] = teamModel;
        getTeamMemberMap[teamModel.getMid] =
            await _getTeamMembers(teamModel.getMid, teamModel.teamMembers);
      }
      for (String teamMid in getUserProperty!.teams) {
        TeamModel? teamModel = teamMap[teamMid];
        if (teamModel == null) continue;
        TeamManager.getTeamList.add(teamModel);
      }
      return TeamManager.getTeamList.length;
    } catch (error) {
      logger.fine('something wrong in teamManager >> $error');
      return 0;
    }
  }

  static Set<UserPropertyModel>? getMyTeamMembers() {
    return TeamManager.getMyTeamMembers();
  }

  static Future<Set<UserPropertyModel>> _getTeamMembers(
    String tmMid,
    List<String> memberEmailList,
    /*{int limit = 99}*/
  ) async {
    Set<UserPropertyModel> teamMemberList = {};
    try {
      userPropertyManagerHolder.queryFromIdList(memberEmailList);
      await userPropertyManagerHolder.isGetListFromDBComplete();
      for (var model in userPropertyManagerHolder.modelList) {
        UserPropertyModel memberUserModel = model as UserPropertyModel;
        teamMemberList.add(memberUserModel);
      }
      return teamMemberList;
    } catch (error) {
      logger.fine('something wrong in teamManager >> $error');
      return {};
    }
  }

  static void deleteTeamMember(String targetEmail) {
    if (getCurrentTeam == null) return;
    getCurrentTeam!.managers.remove(targetEmail);
    getCurrentTeam!.generalMembers.remove(targetEmail);

    getCurrentTeam!.teamMembers.remove(targetEmail);
    getCurrentTeam!.removedMembers.add(targetEmail);

    getTeamMemberMap[getCurrentTeam!.mid]!.removeWhere((element) => element.email == targetEmail);
    teamManagerHolder.setToDB(getCurrentTeam!);
  }

  static void addTeamMember(String targetEmail) {
    teamManagerHolder.addTeamMember(targetEmail, userPropertyManagerHolder);
    // if (getCurrentTeam == null) return;
    // getCurrentTeam!.generalMembers.add(targetEmail);
    // getCurrentTeam!.teamMembers.add(targetEmail);
    // if (getCurrentTeam!.removedMembers.contains(targetEmail)) {
    //   getCurrentTeam!.removedMembers.remove(targetEmail);
    // }
    // teamManagerHolder.setToDB(getCurrentTeam!);
    // userPropertyManagerHolder.emailToModel(targetEmail).then((value) {
    //   if (value != null) {
    //     getTeamMemberMap[getCurrentTeam!.mid]!.add(value);
    //     teamManagerHolder.notify();
    //   }
    // });
  }

  static void changePermission(String targetEmail, int presentPermission, int newPermission) {
    if (getCurrentTeam == null) return;
    if (presentPermission == 1) {
      //manager
      getCurrentTeam!.managers.remove(targetEmail);
    } else {
      // general
      getCurrentTeam!.generalMembers.remove(targetEmail);
    }

    if (newPermission == 1) {
      //manager
      getCurrentTeam!.managers.add(targetEmail);
    } else {
      // general
      getCurrentTeam!.generalMembers.add(targetEmail);
    }
    teamManagerHolder.setToDB(getCurrentTeam!);
    teamManagerHolder.notify();
  }

  static bool setCurrentTeam(int index) {
    if (index >= TeamManager.getTeamList.length) {
      return false;
    }
    TeamManager.setCurrentTeam(TeamManager.getTeamList[index]);
    return true;
  }

  static Future<TeamModel?> findTeamModel(String mid) async {
    return await teamManagerHolder.findTeamModel(mid);
    // for (var ele in TeamManager.getTeamList) {
    //   if (ele.mid == mid) {
    //     return ele;
    //   }
    // }
    // return await teamManagerHolder.getFromDB(mid) as TeamModel?;
  }

  static Future<TeamModel?> findTeamModelByName(String name, String enterpriseMid) async {
    for (var teamModel in TeamManager.getTeamList) {
      if (teamModel.name == name) {
        return teamModel;
      }
    }
    Map<String, QueryValue> query = {};
    query['name'] = QueryValue(value: name);
    query['isRemoved'] = QueryValue(value: false);
    query['parentMid'] = QueryValue(value: enterpriseMid);
    final teamList = await teamManagerHolder.queryFromDB(query);
    for (var ele in teamList) {
      TeamModel team = ele as TeamModel;
      return team;
    }
    //print('no team named $name ------------------------------');
    return null;
  }

  static Future<bool> _initEnterprise() async {
    String enterprise = getUserProperty!.enterprise;
    if (getUserProperty!.enterprise.isEmpty) {
      enterprise = UserPropertyModel.defaultEnterprise;
    }
    await enterpriseManagerHolder.myDataOnly(enterprise);
    _loginEnterprise = enterpriseManagerHolder.onlyOne() as EnterpriseModel?;

    if (enterprise == UserPropertyModel.defaultEnterprise) {
      _cretaEnterprise = enterpriseManagerHolder.onlyOne() as EnterpriseModel?;
      createOrphanEnterprise();
    } else {
      _initCretaEnterprise().then((_) {
        createOrphanEnterprise();
      });
    }
    return (_loginEnterprise != null);
  }

  static Future<void> createOrphanEnterprise() async {
    //print('createOrphanEnterprise--------------------------');
    EnterpriseManager dummy = EnterpriseManager();
    await dummy.myDataOnly(UserPropertyModel.orphanEnterprise);
    if (dummy.onlyOne() == null) {
      await EnterpriseManager.instance.createEnterprise(
        name: UserPropertyModel.orphanEnterprise,
        description: "Orphan Enterprise",
        enterpriseUrl: '',
        adminEmail: CretaAccountManager.getCretaEnterprise!.admins.first,
        mediaApiUrl: CretaAccountManager.getCretaEnterprise?.mediaApiUrl ?? '',
      );
    }
  }

  static Future<void> _initCretaEnterprise() async {
    EnterpriseManager dummy = EnterpriseManager();
    await dummy.myDataOnly(UserPropertyModel.defaultEnterprise);
    _cretaEnterprise = dummy.onlyOne() as EnterpriseModel?;
  }

  static Future<void> _initChannel() async {
    if (getUserProperty == null) return;
    // get user's channel
    bool isChannelExist = false;
    String channelId = getUserProperty!.channelId;
    if (channelId.isNotEmpty) {
      // exist channelId ==> get from DB
      channelManagerHolder.addWhereClause('isRemoved', QueryValue(value: false));
      channelManagerHolder.addWhereClause('mid', QueryValue(value: channelId));
      List<AbsExModel> retList = await channelManagerHolder.queryByAddedContitions();
      if (retList.isNotEmpty) {
        _loginChannel = channelManagerHolder.onlyOne() as ChannelModel;
        isChannelExist = true;
      }
    }
    if (isChannelExist == false) {
      // not exist channelId ==> create to DB
      _loginChannel = channelManagerHolder.makeNewChannel(userId: getUserProperty!.getMid);
      await channelManagerHolder.createChannel(_loginChannel!);
      getUserProperty!.channelId = _loginChannel!.getMid;
      await userPropertyManagerHolder.setToDB(getUserProperty!);
    }
    // get my teams's channel
    for (var teamModel in TeamManager.getTeamList) {
      //bool isChannelExist = false;
      String channelId = teamModel.channelId;
      if (channelId.isEmpty) {
        // not exist team-channelId
        ChannelModel newChannelModel = channelManagerHolder.makeNewChannel(teamId: teamModel.mid);
        await channelManagerHolder.createChannel(newChannelModel);
        teamModel.channelId = newChannelModel.mid;
        await teamManagerHolder.setToDB(teamModel);
      }
    }
  }

  static void setChannelBannerImg(ChannelModel targetModel) {
    channelManagerHolder.setToDB(targetModel);
    channelManagerHolder.notify();
  }

  static void setChannelDescription(ChannelModel targetModel) {
    channelManagerHolder.setToDB(targetModel);
    channelManagerHolder.notify();
  }

  static Future<bool> _guestUserLogin() async {
    logger.finest('_login pressed');
    await AccountManager.login(myConfig!.config.guestUserId, myConfig!.config.guestUserPassword)
        .then((value) async {
      HycopFactory.setBucketId();
      await CretaAccountManager.initUserProperty(doGuestLogin: false).then((value) {
        if (value) {
          // success !!!
          //Navigator.of(widget.context).pop();
          //Routemaster.of(widget.getBuildContext.call()).push(AppRoutes.intro);
          //widget.doAfterLogin?.call();
        } else {
          // fail
          throw HycopUtils.getHycopException(defaultMessage: 'Login failed !!!');
        }
      });
    }).onError((error, stackTrace) {
      String errMsg;
      if (error is HycopException) {
        HycopException ex = error;
        logger.severe(ex.message);
        errMsg = '로그인에 실패하였습니다. 가입된 정보를 확인해보세요.';
      } else {
        errMsg = 'Unknown DB Error !!!';
        logger.severe(errMsg);
      }
      //widget.onErrorReport?.call(errMsg);
    });
    return (AccountManager.currentLoginUser.isGuestUser);
  }

  static Future<UserPropertyModel?> getUserPropertyModel(String email) async {
    UserPropertyManager dummy = UserPropertyManager();
    return await dummy.emailToModel(email);
  }

  static Future<bool> isUserExist(String email) async {
    UserPropertyManager dummy = UserPropertyManager();
    return (await dummy.emailToModel(email) != null);
  }
}
