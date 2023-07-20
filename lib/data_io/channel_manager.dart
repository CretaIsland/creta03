import 'package:hycop/hycop.dart';
//import '../common/creta_utils.dart';
//import '../design_system/menu/creta_popup_menu.dart';
//import '../lang/creta_lang.dart';
//import '../lang/creta_studio_lang.dart';
//import '../model/app_enums.dart';
//import '../model/book_model.dart';
import '../model/creta_model.dart';
import '../model/channel_model.dart';
import 'creta_manager.dart';

class ChannelManager extends CretaManager {
  ChannelManager() : super('creta_channel', null) {
    saveManagerHolder?.registerManager('channel', this);
  }

  @override
  AbsExModel newModel(String mid) => ChannelModel(mid);

  @override
  CretaModel cloneModel(CretaModel src) {
    ChannelModel retval = newModel(src.mid) as ChannelModel;
    src.copyTo(retval);
    return retval;
  }

  String prefix() => CretaManager.modelPrefix(ExModelType.channel);
}
