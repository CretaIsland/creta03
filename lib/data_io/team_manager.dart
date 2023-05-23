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

  TeamManager() : super('creta_team');

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

    try {
      Map<String, QueryValue> query = {};
      query['mid'] = QueryValue(value: teamMid);
      query['isRemoved'] = QueryValue(value: false);
      await queryFromDB(query, limit: limit);

      if (modelList.isNotEmpty) {
        teamModelList.add(onlyOne() as TeamModel);
        teamMemberMap[teamMid] =
            await getTeamMembers(tmMid: teamMid, memberMids: teamModelList.last.teamMembers);
      }
    } catch (error) {
      logger.info('something wrong in teamManager >> $error');
      return 0;
    }

    endTransaction();
    return modelList.length;
  }

  Future<List<UserPropertyModel>> getTeamMembers(
      {required String tmMid, required List<String> memberMids, int limit = 99}) async {
    List<UserPropertyModel> teamMemberList = [];

    try {
      for (var memberMid in memberMids) {
        UserPropertyModel? memberProperty =
            await LoginPage.userPropertyManagerHolder!.getMemberProperty(memberMid: memberMid);
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
    return null;
  }
}
