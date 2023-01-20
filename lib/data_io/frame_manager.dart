import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import '../model/frame_model.dart';
import 'creta_manager.dart';

FrameManager? frameManagerHolder;

class FrameManager extends CretaManager {
  FrameManager() : super('hycop_frame');
  @override
  AbsExModel newModel() => FrameModel();
}
