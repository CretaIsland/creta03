import 'dart:ui';

import 'package:hycop/hycop.dart';

import 'package:creta03/data_io/creta_manager.dart';
import 'package:creta03/model/creta_model.dart';

import '../model/contents_model.dart';
import '../model/link_model.dart';

class LinkManager extends CretaManager {
  final String bookMid;
  LinkManager(String contentsMid, this.bookMid) : super('creta_link', contentsMid) {
    saveManagerHolder?.registerManager('link', this, postfix: contentsMid);
  }

  @override
  CretaModel cloneModel(CretaModel src) {
    LinkModel retval = newModel(src.mid) as LinkModel;
    src.copyTo(retval);
    return retval;
  }

  @override
  AbsExModel newModel(String mid) => LinkModel(mid, bookMid);

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
    required ContentsModel contentsModel,
    required double posX,
    required double posY,
    String? name,
    String? connectedMid,
    String? connectedClass,
    bool doNotify = true,
    required void Function(bool, ContentsModel, Offset) onComplete,
  }) async {
    logger.info('createNext()');
    LinkModel link = LinkModel('', contentsModel.realTimeKey);
    link.parentMid.set(contentsModel.mid, save: false, noUndo: true);
    link.posX = posX;
    link.posY = posY;
    link.name = name ?? '';
    link.connectedMid = connectedMid ?? '';
    link.connectedClass = connectedClass ?? '';
    link.order.set(getMaxOrder() + 1, save: false, noUndo: true);

    await createToDB(link);
    insert(link, postion: getLength(), doNotify: doNotify);
    selectedMid = link.mid;
    if (doNotify) notify();
    onComplete.call(false, contentsModel, Offset(posX, posY));

    MyChange<LinkModel> c = MyChange<LinkModel>(
      link,
      execute: () {},
      redo: () async {
        link.isRemoved.set(false, noUndo: true);
        insert(link, postion: getLength(), doNotify: doNotify);
        selectedMid = link.mid;
        onComplete.call(false, contentsModel, Offset(posX, posY));
      },
      undo: (LinkModel old) async {
        link.isRemoved.set(true, noUndo: true);
        remove(link);
        selectedMid = '';
        onComplete.call(true, contentsModel, Offset(posX, posY));
      },
    );
    mychangeStack.add(c);

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

  void removeLink(String frameOrPageMid) {
    for (var ele in modelList) {
      LinkModel model = ele as LinkModel;
      logger.info('${model.connectedMid} ?? $frameOrPageMid');

      if (model.connectedMid == frameOrPageMid) {
        logger.info('${model.mid} deleted--------------------$frameOrPageMid');
        model.isRemoved.set(true);
      }
    }
  }

  Future<void> copyLinks(String contentsMid, String bookMid) async {
    double order = 1;
    for (var ele in modelList) {
      LinkModel org = ele as LinkModel;
      if (org.isRemoved.value == true) continue;
      LinkModel newModel = LinkModel('', bookMid);
      newModel.copyFrom(org, newMid: newModel.mid, pMid: contentsMid);
      newModel.order.set(order++, save: false, noUndo: true);
      logger.info('create new Link ${newModel.mid}');
      await createToDB(newModel);
    }
  }

  String toJson() {
    if (getAvailLength() == 0) {
      return ',\n\t\t\t\t"links" : []\n';
    }
    int linkCount = 0;
    String jsonStr = '';
    jsonStr += ',\n\t\t\t\t"links" : [\n';
    orderMapIterator((val) {
      LinkModel link = val as LinkModel;
      String linkStr = link.toJson(tab: '\t\t\t\t');
      if (linkCount > 0) {
        jsonStr += ',\n';
      }
      jsonStr += '\t\t\t\t{\n$linkStr\n\t\t\t\t}';
      linkCount++;
      return null;
    });
    jsonStr += '\n\t\t\t\t]\n';
    return jsonStr;
  }
}
