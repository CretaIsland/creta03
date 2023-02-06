import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import '../model/creta_model.dart';
import '../model/frame_model.dart';
import 'creta_manager.dart';

FrameManager? frameManagerHolder;

class FrameManager extends CretaManager {
  FrameManager() : super('hycop_frame');
  @override
  AbsExModel newModel(String mid) => FrameModel(mid);

  @override
  CretaModel cloneModel(CretaModel src) {
    FrameModel retval = newModel(src.mid) as FrameModel;
    src.copyTo(retval);
    return retval;
  }
}
