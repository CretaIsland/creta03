// ignore_for_file: prefer_const_constructors

//import 'package:flutter/foundation.dart';
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
// import '../../design_system/creta_color.dart';
// import '../../design_system/creta_font.dart';
// import '../../design_system/dialog/creta_dialog.dart';
// import '../../design_system/menu/creta_drop_down_button.dart';
// import '../../design_system/menu/creta_popup_menu.dart';
// import '../../design_system/text_field/creta_text_field.dart';
// import '../../model/app_enums.dart';
import '../../data_io/user_property_manager.dart';
import '../../data_io/team_manager.dart';
import '../../data_io/frame_manager.dart';
import '../../data_io/channel_manager.dart';
import '../../data_io/enterprise_manager.dart';
import '../../model/user_property_model.dart';
import '../../model/team_model.dart';
import '../../model/channel_model.dart';
import '../../model/enterprise_model.dart';
import '../../model/frame_model.dart';
import '../../pages/studio/studio_constant.dart';

class CretaAccountManager {
  // managers info
  static ChannelManager? _channelManagerHolder;
  static ChannelManager get channelManagerHolder => _channelManagerHolder!;

  static EnterpriseManager? _enterpriseManagerHolder;
  static EnterpriseManager get enterpriseManagerHolder => _enterpriseManagerHolder!;

  static FrameManager? _frameManagerHolder;
  static FrameManager get frameManagerHolder => _frameManagerHolder!;

  static TeamManager? _teamManagerHolder;
  static TeamManager get teamManagerHolder => _teamManagerHolder!;

  static UserPropertyManager? _userPropertyManagerHolder;
  static UserPropertyManager get userPropertyManagerHolder => _userPropertyManagerHolder!;

  // accounts info
  static UserModel get currentLoginUser => AccountManager.currentLoginUser;

  static UserPropertyModel? _loginUserProperty;
  static set setUserProperty(UserPropertyModel? model) => _loginUserProperty = model;
  static UserPropertyModel? get getUserProperty => _loginUserProperty;

  static List<TeamModel> _loginTeamList = [];
  static set setTeamList(List<TeamModel> teamList) => _loginTeamList = [...teamList];
  static List<TeamModel> get getTeamList => _loginTeamList;

  static TeamModel? _currentTeam;
  static TeamModel? get getCurentTeam => _currentTeam;
  static final Map<String, List<UserPropertyModel>> _teamMemberMap = {};
  static Map<String, List<UserPropertyModel>> get getTeamMemberMap => _teamMemberMap;

  static ChannelModel? _loginChannel;
  static set setChannel(ChannelModel? model) => _loginChannel = model;
  static ChannelModel? get getChannel => _loginChannel;

  static EnterpriseModel? _loginEnterprise;
  static set setEnterprise(EnterpriseModel? model) => _loginEnterprise = model;
  static EnterpriseModel? get getEnterprise => _loginEnterprise;

  static List<FrameModel> _loginFrameList = [];
  static set setFrameList(List<FrameModel> frameList) => _loginFrameList = [...frameList];
  static List<FrameModel> get getFrameList => _loginFrameList;

  //
  static Future<bool> initUserProperty() async {
    if (_userPropertyManagerHolder == null) {
      _userPropertyManagerHolder = UserPropertyManager();
      _userPropertyManagerHolder?.configEvent();
      _userPropertyManagerHolder?.clearAll();
    }
    if (_teamManagerHolder == null) {
      _teamManagerHolder = TeamManager();
      _teamManagerHolder?.configEvent();
      _teamManagerHolder?.clearAll();
    }
    if (_teamManagerHolder == null) {
      _teamManagerHolder = TeamManager();
      _teamManagerHolder?.configEvent();
      _teamManagerHolder?.clearAll();
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
      await logout();
      return false;
    }
    await _getFrameListFromDB();

    // team 및 ent 정보 가져움
    //await LoginPage.teamManagerHolder?.initTeam();
    await _initTeam();
    //await LoginPage.enterpriseHolder?.initEnterprise();
    await _initEnterprise();
    //await LoginPage.channelManagerHolder?.initChannel();
    _initChannel();
    //if (LoginPage.teamManagerHolder!.modelList.isEmpty || LoginPage.enterpriseHolder!.modelList.isEmpty) {
    // team이 없거나, ent없으면 모든정보초기화
    if (_loginEnterprise == null) {
      // team이 없는건 가능, ent없으면 모든정보초기화
      await logout();
      return false;
    }
    return true;
  }

  static Future<bool> logout() async {
    channelManagerHolder.clearAll();
    enterpriseManagerHolder.clearAll();
    frameManagerHolder.clearAll();
    teamManagerHolder.clearAll();
    userPropertyManagerHolder.clearAll();

    _loginUserProperty = null;
    _loginTeamList.clear();
    _loginChannel = null;
    _loginEnterprise = null;
    _loginFrameList.clear();

    await AccountManager.logout();
    return true;
  }

  static Future<bool> _getUserProperty() async {
    if (currentLoginUser.isLoginedUser == false) {
      return false;
    }
    userPropertyManagerHolder.addWhereClause('parentMid', QueryValue(value: currentLoginUser.userId));
    userPropertyManagerHolder.addWhereClause('isRemoved', QueryValue(value: false));
    await userPropertyManagerHolder.queryByAddedContitions();
    _loginUserProperty = userPropertyManagerHolder.onlyOne() as UserPropertyModel;
    return (_loginUserProperty != null);
  }


  static Future<List<FrameModel>> _getFrameListFromDB() async {
    if (getUserProperty!.latestUseFrames.isEmpty) {
      return await _getAnyLattestFrames();
    }
    frameManagerHolder.queryFromIdList(getUserProperty!.latestUseFrames);
    await frameManagerHolder.isGetListFromDBComplete();
    for (AbsExModel model in frameManagerHolder.modelList) {
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
    if (getTeamList.isNotEmpty) {
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
        _teamMemberMap[teamModel.getMid] = await _getTeamMembers(teamModel.getMid, teamModel.teamMembers);
      }
      for(String teamMid in getUserProperty!.teams) {
        TeamModel? teamModel = teamMap[teamMid];
        if (teamModel == null) continue;
        _loginTeamList.add(teamModel);
      }
      return _loginTeamList.length;
    } catch (error) {
      logger.info('something wrong in teamManager >> $error');
      return 0;
    }
  }

  static List<UserPropertyModel>? getMyTeamMembers() {
    if (_currentTeam == null) return null;
    return _teamMemberMap[_currentTeam!.getMid];
  }

  static Future<List<UserPropertyModel>> _getTeamMembers(String tmMid, List<String> memberEmailList,/*{int limit = 99}*/) async {
    List<UserPropertyModel> teamMemberList = [];
    try {
      userPropertyManagerHolder.queryFromIdList(memberEmailList);
      await userPropertyManagerHolder.isGetListFromDBComplete();
      for (var model in userPropertyManagerHolder.modelList) {
        UserPropertyModel memberUserModel = model as UserPropertyModel;
        teamMemberList.add(memberUserModel);
      }
      return teamMemberList;
    } catch (error) {
      logger.info('something wrong in teamManager >> $error');
      return [];
    }
  }

  static void deleteTeamMember(String targetEmail, int permission) {
    if (_currentTeam == null) return;
    if (permission == 1) {
      //manager
      _currentTeam!.managers.remove(targetEmail);
    } else {
      // general
      _currentTeam!.generalMembers.remove(targetEmail);
    }

    _currentTeam!.teamMembers.remove(targetEmail);
    _currentTeam!.removedMembers.add(targetEmail);

    _teamMemberMap[_currentTeam!.mid]!.removeWhere((element) => element.email == targetEmail);
    teamManagerHolder.setToDB(_currentTeam!);
  }

  static void addTeamMember(String targetEmail) {
    if (_currentTeam == null) return;
    _currentTeam!.generalMembers.add(targetEmail);
    _currentTeam!.teamMembers.add(targetEmail);
    if (_currentTeam!.removedMembers.contains(targetEmail)) {
      _currentTeam!.removedMembers.remove(targetEmail);
    }
    teamManagerHolder.setToDB(_currentTeam!);
    userPropertyManagerHolder.emailToModel(targetEmail).then((value) {
      if (value != null) {
        _teamMemberMap[_currentTeam!.mid]!.add(value);
        teamManagerHolder.notify();
      }
    });
  }

  static void changePermission(String targetEmail, int presentPermission, int newPermission) {
    if (_currentTeam == null) return;
    if (presentPermission == 1) {
      //manager
      _currentTeam!.managers.remove(targetEmail);
    } else {
      // general
      _currentTeam!.generalMembers.remove(targetEmail);
    }

    if (newPermission == 1) {
      //manager
      _currentTeam!.managers.add(targetEmail);
    } else {
      // general
      _currentTeam!.generalMembers.add(targetEmail);
    }
    teamManagerHolder.setToDB(_currentTeam!);
    teamManagerHolder.notify();
  }

  static bool setCurrentTeam(int index) {
    if (index >= _loginTeamList.length) {
      return false;
    }
    _currentTeam = _loginTeamList[index];
    return true;
  }

  static Future<TeamModel?> findTeamModel(String mid) async {
    for (var ele in _loginTeamList) {
      if (ele.mid == mid) {
        return ele;
      }
    }
    return await teamManagerHolder.getFromDB(mid) as TeamModel?;
  }

  static Future<TeamModel?> findTeamModelByName(String name, String enterpriseMid) async {
    for (var teamModel in _loginTeamList) {
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

  static Future<bool> _initEnterprise({int limit = 99}) async {
    Map<String, QueryValue> query = {};
    query['name'] = QueryValue(value: getUserProperty!.enterprise);
    query['isRemoved'] = QueryValue(value: false);
    Map<String, OrderDirection> orderBy = {};
    orderBy['order'] = OrderDirection.ascending;
    await enterpriseManagerHolder.queryFromDB(query, orderBy: orderBy, limit: limit);
    _loginEnterprise = enterpriseManagerHolder.onlyOne() as EnterpriseModel?;
    return (_loginEnterprise != null);
  }

  static Future<void> _initChannel() async {
    if (_loginUserProperty == null) return;
    // get user's channel
    bool isChannelExist = false;
    String channelId = _loginUserProperty!.channelId;
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
      _loginChannel = channelManagerHolder.getNewChannel(userId: _loginUserProperty!.getMid);
      await channelManagerHolder.createChannel(_loginChannel!);
      _loginUserProperty!.channelId = _loginChannel!.getMid;
      await userPropertyManagerHolder.setToDB(_loginUserProperty!);
    }
    // get my teams's channel
    for (var teamModel in _loginTeamList)
    {
      //bool isChannelExist = false;
      String channelId = teamModel.channelId;
      if (channelId.isEmpty) {
        // not exist team-channelId
        ChannelModel newChannelModel = channelManagerHolder.getNewChannel(teamId: teamModel.mid);
        await channelManagerHolder.createChannel(newChannelModel);
        teamModel.channelId = newChannelModel.mid;
        await teamManagerHolder.setToDB(teamModel);
      }
    }
  }

}
