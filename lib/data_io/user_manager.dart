import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import '../model/creta_model.dart';
import '../model/user_model.dart';
import 'creta_manager.dart';

UserManager? pageManagerHolder;

class UserManager extends CretaManager {
  UserManager() : super('creta_page');
  @override
  AbsExModel newModel(String mid) => UserModel(mid);

  @override
  CretaModel cloneModel(CretaModel src) {
    UserModel retval = newModel(src.mid) as UserModel;
    src.copyTo(retval);
    return retval;
  }
}
