
import 'package:creta03/model/user_property_model.dart';
import 'package:creta03/pages/login_page.dart';
import 'package:hycop/hycop.dart';
import '../model/creta_model.dart';
import '../model/team_model.dart';
import 'creta_manager.dart';

TeamManager? pageManagerHolder;

class TeamManager extends CretaManager {

  TeamModel? currentTeam;
  List<TeamModel> teamModelList = [];
  Map<String, List<UserPropertyModel>> teamMemberMap = {};


  TeamManager() : super('creta_team');
  @override
  AbsExModel newModel(String mid) => TeamModel(mid);

  @override
  CretaModel cloneModel(CretaModel src) {
    TeamModel retval = newModel(src.mid) as TeamModel;
    src.copyTo(retval);
    return retval;
  }

  Future<void> initTeam() async {
    clearAll();
    await getTeams(teamMids: LoginPage.userPropertyManagerHolder!.propertyModel!.teams);
    if(teamModelList.isNotEmpty) {
      selectedTeam(0);
    }
  }

  // create team object
  Future<TeamModel> createTeam({required String teamName, required String ownerId}) async {
    TeamModel newTeam = TeamModel.withName(name: teamName, owner: ownerId);

    await createToDB(newTeam);
    insert(newTeam, postion: getAvailLength());

    return newTeam;
  }

  // get team object
  Future<int> getTeams({required List<String> teamMids, int limit = 99}) async {
    int teamCount = 0;

    try {
      for(var mid in teamMids) {
        if(await _getTeam(teamMid: mid) == 1) {
          teamCount += 1;
        }
      }
    } catch (error) {
      logger.info("something wrong $error");
      return 0;
    }
    return teamCount;
  }

  Future<int> _getTeam({required String teamMid, int limit = 99}) async {
    startTransaction();

    try {
      Map<String, QueryValue> query = {};
      query["mid"] = QueryValue(value: teamMid);
      query["isRemoved"] = QueryValue(value: false);

      await queryFromDB(query, limit: limit);

      if(modelList.isNotEmpty && !teamModelList.contains(onlyOne() as TeamModel)) {
        teamModelList.add(onlyOne() as TeamModel);
        teamMemberMap[teamMid] = await getTeamMember(tmMid: teamMid, memberMids: teamModelList.last.teamMembers);
      }
    } catch (error) {
      logger.info("error! $error");
      return 0;
    }
    
    endTransaction();
    return modelList.length;
  }

  // get team Member object
  Future<List<UserPropertyModel>> getTeamMember({required String tmMid, required List<String> memberMids, int limit = 99}) async {
    List<UserPropertyModel> memberList = [];

    try {
      for(var mid in memberMids) {
        UserPropertyModel? property = UserPropertyModel(mid);
        property = await LoginPage.userPropertyManagerHolder!.getMemberProperty(memberMid: mid);
        if(property != null) {
          memberList.add(property);
        }
      }
    } catch (error) {
      logger.info("something wrong $error");
      return [];
    }
    return memberList;
  }

  void deleteMember(String memberMid) {
    try {
      if(currentTeam!.managers.contains(memberMid)) {
        currentTeam!.managers.remove(memberMid);
      } else {
        currentTeam!.generalMembers.remove(memberMid);
      }
      currentTeam!.teamMembers = [currentTeam!.owner, ...currentTeam!.managers, ...currentTeam!.generalMembers];
      currentTeam!.removedMembers.add(memberMid);
      
      teamModelList[teamModelList.indexWhere((element) => element.mid == currentTeam!.mid)] = currentTeam!;

      setToDB(currentTeam!);
    } catch (error) {
      logger.info(error);
    }
   
  }


  void selectedTeam(int index) {
    currentTeam = teamModelList[index];
  }







}
