import 'package:hycop/hycop.dart';

import 'package:creta03/data_io/creta_manager.dart';
import 'package:creta03/model/creta_model.dart';
import 'package:creta03/model/team_model.dart';
import 'package:creta03/model/user_property_model.dart';
import 'package:creta03/pages/login_page.dart';

class TeamManager extends CretaManager {
  TeamModel? currentTeam;
  List<TeamModel> teamModelList = [];
  Map<String, List<UserPropertyModel>> teamMemberMap = {};

  TeamManager() : super('creta_team', null);

  @override
  CretaModel cloneModel(CretaModel src) {
    TeamModel retval = newModel(src.mid) as TeamModel;
    src.copyTo(retval);
    return retval;
  }

  @override
  AbsExModel newModel(String mid) => TeamModel(mid);

  Future<void> initTeam() async {
    clearAll();
    await getTeam();
    if (teamModelList.isNotEmpty) {
      selectedTeam(0);
    }
  }

  Future<int> getTeam() async {
    int teamCount = 0;
    try {
      for (var teamMid in LoginPage.userPropertyManagerHolder!.userPropertyModel!.teams) {
        if (await _getTeam(teamMid: teamMid) > 0) {
          teamCount += 1;
        }
        // if(await _getTeam(teamMid: teamMid.keys.first) > 0) {
        //   teamCount += 1;
        // }
      }
      return teamCount;
    } catch (error) {
      logger.info('something wrong in teamManager >> $error');
      return teamCount;
    }
  }

  Future<int> _getTeam({required String teamMid, int limit = 99}) async {
    startTransaction();
    teamModelList.clear();
    try {
      Map<String, QueryValue> query = {};
      query['mid'] = QueryValue(value: teamMid);
      query['isRemoved'] = QueryValue(value: false);
      await queryFromDB(query, limit: limit);

      if (modelList.isNotEmpty) {
        TeamModel team = onlyOne() as TeamModel;
        if (teamModelList.contains(team) == false) {
          teamModelList.add(team);
          teamMemberMap[teamMid] =
              await getTeamMembers(tmMid: teamMid, memberMids: teamModelList.last.teamMembers);
        }
      }
    } catch (error) {
      logger.info('something wrong in teamManager >> $error');
      return 0;
    }

    endTransaction();
    return modelList.length;
  }

  List<UserPropertyModel>? getMyTeamMembers() {
    if (currentTeam == null) return null;
    return teamMemberMap[currentTeam!.mid];
  }

  Future<List<UserPropertyModel>> getTeamMembers(
      {required String tmMid, required List<String> memberMids, int limit = 99}) async {
    List<UserPropertyModel> teamMemberList = [];

    try {
      for (var memberMid in memberMids) {
        UserPropertyModel? memberProperty =
            await LoginPage.userPropertyManagerHolder!.getMemberProperty(email: memberMid);
        if (memberProperty != null) {
          teamMemberList.add(memberProperty);
        }
      }
      return teamMemberList;
    } catch (error) {
      logger.info('something wrong in teamManager >> $error');
      return [];
    }
  }

  void deleteTeamMember(String targetEmail, int permission) {
    if (permission == 1) {
      //manager
      currentTeam!.managers.remove(targetEmail);
    } else {
      // general
      currentTeam!.generalMembers.remove(targetEmail);
    }

    currentTeam!.teamMembers.remove(targetEmail);
    currentTeam!.removedMembers.add(targetEmail);

    teamMemberMap[currentTeam!.mid]!.removeWhere((element) => element.email == targetEmail);
    setToDB(currentTeam!);
  }

  void addTeamMember(String targetEmail) {
    currentTeam!.generalMembers.add(targetEmail);
    currentTeam!.teamMembers.add(targetEmail);
    if (currentTeam!.removedMembers.contains(targetEmail)) {
      currentTeam!.removedMembers.remove(targetEmail);
    }
    setToDB(currentTeam!);
    LoginPage.userPropertyManagerHolder!.emailToModel(targetEmail).then((value) {
      if (value != null) {
        teamMemberMap[currentTeam!.mid]!.add(value);
        notify();
      }
    });
  }

  void changePermission(String targetEmail, int presentPermission, int newPermission) {
    if (presentPermission == 1) {
      //manager
      currentTeam!.managers.remove(targetEmail);
    } else {
      // general
      currentTeam!.generalMembers.remove(targetEmail);
    }

    if (newPermission == 1) {
      //manager
      currentTeam!.managers.add(targetEmail);
    } else {
      // general
      currentTeam!.generalMembers.add(targetEmail);
    }
    setToDB(currentTeam!);
    notify();
  }

  void selectedTeam(int index) {
    currentTeam = teamModelList[index];
  }

  Future<TeamModel?> findTeamModel(String mid) async {
    for (var ele in teamModelList) {
      if (ele.mid == mid) {
        return ele;
      }
    }
    return await getFromDB(mid) as TeamModel?;
  }

  Future<TeamModel?> findTeamModelByName(String name, String enterpriseMid) async {
    for (var ele in teamModelList) {
      if (ele.name == name) {
        return ele;
      }
    }
    Map<String, QueryValue> query = {};
    query['name'] = QueryValue(value: name);
    query['isRemoved'] = QueryValue(value: false);
    query['parentMid'] = QueryValue(value: enterpriseMid);
    final teamList = await queryFromDB(query);
    for (var ele in teamList) {
      TeamModel team = ele as TeamModel;
      return team;
    }
    //print('no team named $name ------------------------------');
    return null;
  }
}
