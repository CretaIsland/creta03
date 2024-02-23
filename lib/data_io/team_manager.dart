import 'user_property_manager.dart';
import 'package:hycop/hycop.dart';

import 'creta_manager.dart';
import 'package:creta_common/model/creta_model.dart';
import 'package:creta_user_model/model/team_model.dart';
import 'package:creta_user_model/model/user_property_model.dart';
//import 'package:creta03/pages/login_page.dart';

class TeamManager extends CretaManager {
  static TeamManager? _teamManagerHolder;
  static TeamManager? get teamManagerHolder => _teamManagerHolder!;
  static void initTeamManagerHolder() {
    if (_teamManagerHolder == null) {
      _teamManagerHolder = TeamManager();
      _teamManagerHolder?.configEvent();
      _teamManagerHolder?.clearAll();
    }
  }

  static TeamModel? _currentTeam;
  static TeamModel? get getCurrentTeam => _currentTeam;
  static void setCurrentTeam(TeamModel? t) {
    _currentTeam = t;
  }

  static final Map<String, List<UserPropertyModel>> _teamMemberMap = {};
  static Map<String, List<UserPropertyModel>> get getTeamMemberMap => _teamMemberMap;
  static List<UserPropertyModel>? getMyTeamMembers() {
    if (getCurrentTeam == null) return null;
    return getTeamMemberMap[getCurrentTeam!.getMid];
  }

  static List<TeamModel> _loginTeamList = [];
  static set setTeamList(List<TeamModel> teamList) => _loginTeamList = [...teamList];
  static List<TeamModel> get getTeamList => _loginTeamList;

  //TeamModel? currentTeam;

  //List<TeamModel> teamModelList = [];
  //Map<String, List<UserPropertyModel>> teamMemberMap = {};

  TeamManager() : super('creta_team', null);

  @override
  CretaModel cloneModel(CretaModel src) {
    TeamModel retval = newModel(src.mid) as TeamModel;
    src.copyTo(retval);
    return retval;
  }

  @override
  AbsExModel newModel(String mid) => TeamModel(mid);

  // Future<void> initTeam() async {
  //   clearAll();
  //   await getTeam();
  //   if (teamModelList.isNotEmpty) {
  //     selectedTeam(0);
  //   }
  // }

  TeamModel getNewTeam({
    required bool createAndSetToCurrent,
    required String username,
    required String userEmail,
  }) {
    TeamModel teamModel = TeamModel.withName(
      name: '$username Team',
      owner: userEmail,
      isPublicProfile: false,
      managers: [userEmail],
    );
    return teamModel;
  }

  Future<bool> createTeam(TeamModel teamModel) async {
    try {
      await createToDB(teamModel);
    } catch (error) {
      logger.fine('createTeam error >> $error');
      return false;
    }
    return true;
  }

  // Future<int> getTeam() async {
  //   int teamCount = 0;
  //   try {
  //     for (var teamMid in LoginPage.userPropertyManagerHolder!.userPropertyModel!.teams) {
  //       if (await _getTeam(teamMid: teamMid) > 0) {
  //         teamCount += 1;
  //       }
  //       // if(await _getTeam(teamMid: teamMid.keys.first) > 0) {
  //       //   teamCount += 1;
  //       // }
  //     }
  //     return teamCount;
  //   } catch (error) {
  //     logger.fine('something wrong in teamManager >> $error');
  //     return teamCount;
  //   }
  // }
  //
  // Future<int> _getTeam({required String teamMid, int limit = 99}) async {
  //   startTransaction();
  //   teamModelList.clear();
  //   try {
  //     Map<String, QueryValue> query = {};
  //     query['mid'] = QueryValue(value: teamMid);
  //     query['isRemoved'] = QueryValue(value: false);
  //     await queryFromDB(query, limit: limit);
  //
  //     if (modelList.isNotEmpty) {
  //       TeamModel team = onlyOne() as TeamModel;
  //       if (teamModelList.contains(team) == false) {
  //         teamModelList.add(team);
  //         teamMemberMap[teamMid] =
  //             await getTeamMembers(tmMid: teamMid, memberEmailList: teamModelList.last.teamMembers);
  //       }
  //     }
  //   } catch (error) {
  //     logger.fine('something wrong in teamManager >> $error');
  //     return 0;
  //   }
  //
  //   endTransaction();
  //   return modelList.length;
  // }
  //
  // List<UserPropertyModel>? getMyTeamMembers() {
  //   if (currentTeam == null) return null;
  //   return teamMemberMap[currentTeam!.mid];
  // }

  // Future<List<UserPropertyModel>> getTeamMembers(
  //     {required String tmMid, required List<String> memberEmailList, int limit = 99}) async {
  //   List<UserPropertyModel> teamMemberList = [];
  //
  //   try {
  //     for (var memberEmail in memberEmailList) {
  //       UserPropertyModel? memberProperty =
  //           await LoginPage.userPropertyManagerHolder!.getMemberProperty(email: memberEmail);
  //       if (memberProperty != null) {
  //         teamMemberList.add(memberProperty);
  //       }
  //     }
  //     return teamMemberList;
  //   } catch (error) {
  //     logger.fine('something wrong in teamManager >> $error');
  //     return [];
  //   }
  // }
  //
  // void deleteTeamMember(String targetEmail, int permission) {
  //   if (permission == 1) {
  //     //manager
  //     currentTeam!.managers.remove(targetEmail);
  //   } else {
  //     // general
  //     currentTeam!.generalMembers.remove(targetEmail);
  //   }
  //
  //   currentTeam!.teamMembers.remove(targetEmail);
  //   currentTeam!.removedMembers.add(targetEmail);
  //
  //   teamMemberMap[currentTeam!.mid]!.removeWhere((element) => element.email == targetEmail);
  //   setToDB(currentTeam!);
  // }
  //
  // void addTeamMember(String targetEmail) {
  //   currentTeam!.generalMembers.add(targetEmail);
  //   currentTeam!.teamMembers.add(targetEmail);
  //   if (currentTeam!.removedMembers.contains(targetEmail)) {
  //     currentTeam!.removedMembers.remove(targetEmail);
  //   }
  //   setToDB(currentTeam!);
  //   LoginPage.userPropertyManagerHolder!.emailToModel(targetEmail).then((value) {
  //     if (value != null) {
  //       teamMemberMap[currentTeam!.mid]!.add(value);
  //       notify();
  //     }
  //   });
  // }
  //
  // void changePermission(String targetEmail, int presentPermission, int newPermission) {
  //   if (presentPermission == 1) {
  //     //manager
  //     currentTeam!.managers.remove(targetEmail);
  //   } else {
  //     // general
  //     currentTeam!.generalMembers.remove(targetEmail);
  //   }
  //
  //   if (newPermission == 1) {
  //     //manager
  //     currentTeam!.managers.add(targetEmail);
  //   } else {
  //     // general
  //     currentTeam!.generalMembers.add(targetEmail);
  //   }
  //   setToDB(currentTeam!);
  //   notify();
  // }
  //
  // void selectedTeam(int index) {
  //   currentTeam = teamModelList[index];
  // }
  //
  // Future<TeamModel?> findTeamModel(String mid) async {
  //   for (var ele in teamModelList) {
  //     if (ele.mid == mid) {
  //       return ele;
  //     }
  //   }
  //   return await getFromDB(mid) as TeamModel?;
  // }
  //
  // Future<TeamModel?> findTeamModelByName(String name, String enterpriseMid) async {
  //   for (var ele in teamModelList) {
  //     if (ele.name == name) {
  //       return ele;
  //     }
  //   }
  //   Map<String, QueryValue> query = {};
  //   query['name'] = QueryValue(value: name);
  //   query['isRemoved'] = QueryValue(value: false);
  //   query['parentMid'] = QueryValue(value: enterpriseMid);
  //   final teamList = await queryFromDB(query);
  //   for (var ele in teamList) {
  //     TeamModel team = ele as TeamModel;
  //     return team;
  //   }
  //   //print('no team named $name ------------------------------');
  //   return null;
  // }

  // void queryTeamsFromMap(Map<String, String> teamIdMap) {
  //   clearAll();
  //   clearConditions();
  //   if (teamIdMap.isEmpty) {
  //     setState(DBState.idle);
  //     return;
  //   }
  //   final List<String> teamIdList = [];
  //   teamIdMap.forEach((key, value) => teamIdList.add(value));
  //   addWhereClause('mid', QueryValue(value: teamIdList, operType: OperType.whereIn));
  //   queryByAddedContitions();
  // }

  TeamModel? get currentTeam => TeamManager.getCurrentTeam;

  Map<String, List<UserPropertyModel>> get teamMemberMap => TeamManager.getTeamMemberMap;

  List<TeamModel> get teamModelList => TeamManager.getTeamList;

  // void addTeamMember(String targetEmail) {
  //   CretaAccountManager.addTeamMember(targetEmail);
  // }

  // void deleteTeamMember(String targetEmail, int permission) {
  //   CretaAccountManager.deleteTeamMember(targetEmail, permission);
  // }

  // void changePermission(String targetEmail, int presentPermission, int newPermission) {
  //   CretaAccountManager.changePermission(targetEmail, presentPermission, newPermission);
  // }

  void deleteTeamMember(String targetEmail, int permission) {
    if (getCurrentTeam == null) return;
    if (permission == 1) {
      //manager
      getCurrentTeam!.managers.remove(targetEmail);
    } else {
      // general
      getCurrentTeam!.generalMembers.remove(targetEmail);
    }

    getCurrentTeam!.teamMembers.remove(targetEmail);
    getCurrentTeam!.removedMembers.add(targetEmail);

    getTeamMemberMap[getCurrentTeam!.mid]!.removeWhere((element) => element.email == targetEmail);
    setToDB(getCurrentTeam!);
  }

  void addTeamMember(String targetEmail, UserPropertyManager userPropertyManagerHolder) {
    if (getCurrentTeam == null) return;
    getCurrentTeam!.generalMembers.add(targetEmail);
    getCurrentTeam!.teamMembers.add(targetEmail);
    if (getCurrentTeam!.removedMembers.contains(targetEmail)) {
      getCurrentTeam!.removedMembers.remove(targetEmail);
    }
    setToDB(getCurrentTeam!);
    userPropertyManagerHolder.emailToModel(targetEmail).then((value) {
      if (value != null) {
        getTeamMemberMap[getCurrentTeam!.mid]!.add(value);
        notify();
      }
    });
  }

  void changePermission(String targetEmail, int presentPermission, int newPermission) {
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
    setToDB(getCurrentTeam!);
    notify();
  }

  Future<TeamModel?> findTeamModel(String mid) async {
    for (var ele in TeamManager.getTeamList) {
      if (ele.mid == mid) {
        return ele;
      }
    }
    return await getFromDB(mid) as TeamModel?;
  }
}
