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

  Future<int> getLink({required String contentsId}) async {
    startTransaction();
    try {
      Map<String, QueryValue> query = {};
      query['parentMid'] = QueryValue(value: contentsId);
      query['isRemoved'] = QueryValue(value: false);
      await queryFromDB(query);
      reOrdering();
    } catch (error) {
      logger.info('something wrong in LinkManager >> $error');
      return 0;
    }
    endTransaction();
    return modelList.length;
  }

  Future<LinkModel> createNext({
    required String contentsId,
    required double posX,
    required double posY,
    String? name,
    String? connectedMid,
    String? connectedClass,
    bool doNotify = true,
  }) async {
    logger.info('createNext()');
    LinkModel link = LinkModel('');
    link.parentMid.set(contentsId, save: false, noUndo: true);
    link.posX = posX;
    link.posY = posY;
    link.name = name ?? '';
    link.conenctedMid = connectedMid ?? '';
    link.connectedClass = connectedClass ?? '';
    link.order.set(getMaxOrder() + 1, save: false, noUndo: true);

    await createToDB(link);
    insert(link, postion: getLength(), doNotify: doNotify);
    selectedMid = link.mid;

    if (doNotify) notify();

    return link;
  }

  Future<LinkModel> update({
    required LinkModel link,
    bool doNotify = true,
  }) async {
    logger.info('update()');
    await setToDB(link);
    updateModel(link);
    selectedMid = link.mid;
    if (doNotify) notify();

    return link;
  }

  Future<LinkModel> delete({
    required LinkModel link,
    bool doNotify = true,
  }) async {
    logger.info('update()');
    link.isRemoved.set(true, save: false);
    await setToDB(link);
    updateModel(link);
    selectedMid = link.mid;

    if (doNotify) notify();

    return link;
  }
}
