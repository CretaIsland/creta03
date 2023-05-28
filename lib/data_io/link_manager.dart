import 'package:hycop/hycop.dart';

import 'package:creta03/data_io/creta_manager.dart';
import 'package:creta03/model/creta_model.dart';

import '../model/link_model.dart';

class LinkManager extends CretaManager {
  LinkManager() : super('creta_link');

  @override
  CretaModel cloneModel(CretaModel src) {
    LinkModel retval = newModel(src.mid) as LinkModel;
    src.copyTo(retval);
    return retval;
  }

  @override
  AbsExModel newModel(String mid) => LinkModel(mid);

  Future<int> getLink({required String frameId}) async {
    startTransaction();
    try {
      Map<String, QueryValue> query = {};
      query['parentMid'] = QueryValue(value: frameId);
      query['isRemoved'] = QueryValue(value: false);
      await queryFromDB(query);
    } catch (error) {
      logger.info('something wrong in LinkManager >> $error');
      return 0;
    }
    endTransaction();
    return modelList.length;
  }

  Future<LinkModel> createNext({
    required String frameId,
    required double posX,
    required double posY,
    String? name,
    String? connectedMid,
    String? connectedClass,
    bool doNotify = true,
  }) async {
    logger.info('createNext()');
    LinkModel link = LinkModel('');
    link.parentMid.set(frameId, save: false, noUndo: true);
    link.posX = posX;
    link.posY = posY;
    link.name = name ?? '';
    link.conenctedMid = connectedMid ?? '';
    link.connectedClass = connectedClass ?? '';

    await createToDB(link);
    insert(link, postion: getLength(), doNotify: doNotify);
    selectedMid = link.mid;
    return link;
  }
}
