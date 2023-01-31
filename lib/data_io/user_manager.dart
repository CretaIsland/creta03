import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import '../model/page_model.dart';
import 'creta_manager.dart';

UserManager? pageManagerHolder;

class UserManager extends CretaManager {
  UserManager() : super('creta_page');
  @override
  AbsExModel newModel() => PageModel();
}
