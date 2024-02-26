import 'dart:ui';

import 'package:creta_studio_io/data_io/base_link_manager.dart';
import 'package:hycop/hycop.dart';

//import 'package:creta_user_io/data_io/creta_manager.dart';
import 'package:creta_common/model/creta_model.dart';
import '../design_system/component/tree/flutter_treeview.dart' as tree;

import 'package:creta_studio_model/model/book_model.dart';
import 'package:creta_studio_model/model/contents_model.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import 'package:creta_studio_model/model/link_model.dart';
import 'package:creta_studio_model/model/page_model.dart';
import '../pages/studio/book_main_page.dart';
import '../pages/studio/containees/containee_nofifier.dart';
import '../pages/studio/left_menu/left_menu_page.dart';
import 'book_manager.dart';
import 'frame_manager.dart';
import 'page_manager.dart';

class LinkManager extends BaseLinkManager {
  // final String bookMid;
  // final PageModel pageModel;
  // final FrameModel frameModel;
  // final bool isPublishedMode;
  LinkManager(
    String contentsMid,
    String bookMid,
    PageModel pageModel,
    FrameModel frameModel, {
    String tableName = 'creta_link',
    super.isPublishedMode = false,
  }) : super(contentsMid, bookMid, pageModel, frameModel, tableName: tableName) {
    //saveManagerHolder?.registerManager('link', this, postfix: contentsMid);
  }

  // @override
  // CretaModel cloneModel(CretaModel src) {
  //   LinkModel retval = newModel(src.mid) as LinkModel;
  //   src.copyTo(retval);
  //   return retval;
  // }

  @override
  Future<int> copyBook(String newBookMid, String? newParentMid) async {
    lock();
    int counter = 0;
    for (var ele in modelList) {
      if (ele.isRemoved.value == true) {
        continue;
      }
      await makeCopy(newBookMid, ele, newParentMid) as LinkModel;
    }
    unlock();
    return counter;
  }

  @override
  Future<AbsExModel> makeCopy(String newBookMid, AbsExModel src, String? newParentMid) async {
    // 이미, publish 되어 있다면, 해당 mid 를 가져와야 한다.
    LinkModel newOne = newModel('') as LinkModel;

    // creat_book_published data 를 만든다.
    newOne.copyFrom(src, newMid: newOne.mid, pMid: newParentMid ?? newOne.parentMid.value);
    newOne.setRealTimeKey(newBookMid);
    //print('makeCopy : newMid=${newOne.mid}, parent=$newParentMid');

    LinkModel oldOne = src as LinkModel;

    //print('connectedClass = ${newOne.connectedClass}, ${oldOne.connectedClass}');

    if (oldOne.connectedClass == 'page') {
      newOne.connectedMid = PageManager.oldNewMap[oldOne.connectedMid] ?? '';
      //print('page link connectedMid = ${oldOne.connectedMid} --> ${newOne.connectedMid}');
    } else if (oldOne.connectedClass == 'frame') {
      FrameModel? frame = FrameManager.findNew(oldOne.connectedMid);
      if (frame != null) {
        newOne.connectedMid = frame.mid;
      } else {
        newOne.connectedMid = '';
      }
      //print('frame link connectedMid = ${oldOne.connectedMid} --> ${newOne.connectedMid}');
    }

    await createToDB(newOne);
    return newOne;
  }

  // @override
  // AbsExModel newModel(String mid) => LinkModel(mid, bookMid);

  Future<int> getLink({required String contentsId}) async {
    startTransaction();
    try {
      Map<String, QueryValue> query = {};
      query['parentMid'] = QueryValue(value: contentsId);
      query['isRemoved'] = QueryValue(value: false);
      await queryFromDB(query);
      reOrdering();
    } catch (error) {
      logger.fine('something wrong in LinkManager >> $error');
      return 0;
    }
    endTransaction();
    return modelList.length;
  }

  Future<LinkModel> createNextLink({
    required ContentsModel contentsModel,
    required double posX,
    required double posY,
    String? name,
    String? connectedMid,
    String? connectedClass,
    bool doNotify = true,
    required void Function(bool, ContentsModel, Offset) onComplete,
  }) async {
    logger.fine('createNext()');
    LinkModel link = LinkModel('', contentsModel.realTimeKey);
    link.parentMid.set(contentsModel.mid, save: false, noUndo: true);
    link.posX.set(posX, save: false, noUndo: true);
    link.posY.set(posY, save: false, noUndo: true);
    link.name = name ?? '';
    link.connectedMid = connectedMid ?? '';
    link.connectedClass = connectedClass ?? '';
    link.order.set(getMaxOrder() + 1, save: false, noUndo: true);

    await createToDB(link);
    insert(link, postion: getLength(), doNotify: doNotify);
    //selectedMid = link.mid;
    //if (doNotify) notify();
    reOrdering();
    setSelectedMid(link.mid, doNotify: doNotify);
    BookMainPage.containeeNotifier!.set(ContaineeEnum.Link, doNoti: true);
    LeftMenuPage.initTreeNodes();
    LeftMenuPage.treeInvalidate();

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
    logger.fine('update()');
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
    logger.fine('update()');
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
      logger.fine('${model.connectedMid} ?? $frameOrPageMid');

      if (model.connectedMid == frameOrPageMid) {
        logger.fine('${model.mid} deleted--------------------$frameOrPageMid');
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
      logger.fine('create new Link ${newModel.mid}');
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

  Future<bool> makeClone(
    BookModel newBook, {
    bool cloneToPublishedBook = false,
  }) async {
    for (var link in modelList) {
      String parentContentsMid = BookManager.cloneContentsIdMap[link.parentMid.value] ?? '';
      logger.severe('find: (${link.parentMid.value}) => ($parentContentsMid)');
      AbsExModel newModel = await makeCopy(newBook.mid, link, parentContentsMid);
      logger.severe('clone is created ($collectionId.${newModel.mid}) from (source:${link.mid})');
      BookManager.cloneLinkIdMap[link.mid] = newModel.mid;
    }
    return true;
  }

  List<tree.Node> toNodes() {
    //print('invoke contentsManager.toNodes()');
    List<tree.Node> conNodes = [];
    for (var ele in orderValues()) {
      LinkModel model = ele as LinkModel;
      if (model.isRemoved.value == true) {
        continue;
      }
      //print('model.name=${model.name}');

      String name = model.name;
      conNodes.add(tree.Node<CretaModel>(
          key: '${pageModel.mid}/${frameModel.mid}/${model.parentMid.value}/${model.mid}',
          keyType: ContaineeEnum.Link,
          label: 'link To $name',
          expanded: model.expanded || isSelected(model.mid),
          data: model,
          root: pageModel.mid));
    }
    return conNodes;
  }
}
