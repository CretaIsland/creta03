import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import '../model/page_model.dart';
import 'creta_manager.dart';

TeamManager? pageManagerHolder;

class TeamManager extends CretaManager {
  TeamManager() : super('creta_page');
  @override
  AbsExModel newModel() => PageModel();
}
