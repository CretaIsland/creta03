import 'package:creta03/pages/login_page.dart';
import 'package:hycop/hycop.dart';
import '../model/creta_model.dart';
import '../model/team_model.dart';
import 'creta_manager.dart';

TeamManager? pageManagerHolder;

class TeamManager extends CretaManager {

  TeamModel? nowTeam;
  List<TeamModel> teamModelList = [];

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

    logger.info("initTeam 종료");
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
      }
    } catch (error) {
      logger.info("error! $error");
      return 0;
    }
    
    endTransaction();
    return modelList.length;
  }







}
