import 'dart:ui';

import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import '../model/creta_model.dart';
import '../model/user_propery_model.dart';
import 'creta_manager.dart';

UserPropertyManager? userPropertyManagerHolder;

class UserPropertyManager extends CretaManager {
  UserPropertyManager() : super('creta_user_property');
  @override
  AbsExModel newModel(String mid) => UserPropertyModel(mid);

  @override
  CretaModel cloneModel(CretaModel src) {
    UserPropertyModel retval = newModel(src.mid) as UserPropertyModel;
    src.copyTo(retval);
    return retval;
  }

  void addFavColor(Color color) {
    UserPropertyModel? aModel = onlyOne() as UserPropertyModel?;
    if (aModel == null) {
      return;
    }
    aModel.bgColorList1.add(color);
    aModel.save();
  }

  List<Color> getColorList() {
    UserPropertyModel? aModel = onlyOne() as UserPropertyModel?;
    if (aModel == null) {
      return [];
    }
    return aModel.bgColorList1;
  }
}
