import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import '../model/creta_model.dart';
import '../model/team_model.dart';
import 'creta_manager.dart';

TeamManager? pageManagerHolder;

class TeamManager extends CretaManager {
  TeamManager() : super('creta_page');
  @override
  AbsExModel newModel(String mid) => TeamModel(mid);

  @override
  CretaModel cloneModel(CretaModel src) {
    TeamModel retval = newModel(src.mid) as TeamModel;
    src.copyTo(retval);
    return retval;
  }
}
