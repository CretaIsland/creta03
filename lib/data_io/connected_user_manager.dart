import 'package:hycop/hycop.dart';

import 'package:creta03/data_io/creta_manager.dart';
import 'package:creta03/model/creta_model.dart';
import '../common/creta_utils.dart';
import '../model/connected_user_model.dart';
import '../model/user_property_model.dart';

class ConnectedUserManager extends CretaManager {
  static int monitorPerid = 10; //sec

  String? bookMid;
  ConnectedUserManager() : super('creta_connected_user', null) {
    // parentMid 는 bookMid 이다.
  }

  void setBook(String book) {
    // parentMid 는 bookMid 이다.
    bookMid = book;
    saveManagerHolder?.registerManager(ExModelType.connected_user.name, this, postfix: bookMid!);
  }

  @override
  CretaModel cloneModel(CretaModel src) {
    ConnectedUserModel retval = newModel(src.mid) as ConnectedUserModel;
    src.copyTo(retval);
    return retval;
  }

  @override
  AbsExModel newModel(String mid) => ConnectedUserModel.withBook(mid);

  Future<int> getConnectedUser() async {
    // parentMid 는 bookMid 이다.
    startTransaction();
    try {
      Map<String, QueryValue> query = {};
      query['parentMid'] = QueryValue(value: bookMid);
      query['isRemoved'] = QueryValue(value: false);
      // query['updateTime'] = QueryValue(
      //     value: CretaUtils.getTimeSecondsAgo(monitorPerid),
      //     operType: OperType.isGreaterThanOrEqualTo);
      await queryFromDB(query);
      reOrdering();
    } catch (error) {
      logger.info('something wrong in ConnectedUserManager >> $error');
      return 0;
    }
    endTransaction();
    //print('${modelList.length} founded-----------------');
    addRealTimeListen(bookMid!);
    return modelList.length;
  }

  Future<ConnectedUserModel?> createNext({
    required UserPropertyModel user,
    bool doNotify = true,
    void Function(bool, String)? onComplete,
  }) async {
    logger.info('createNext()');

    if (bookMid == null) return null;

    ConnectedUserModel connectedUser = ConnectedUserModel.withBook(bookMid!);
    connectedUser.name = user.nickname;
    connectedUser.imageUrl = user.profileImg;
    connectedUser.email = user.email;

    await createToDB(connectedUser);
    insert(connectedUser, postion: getLength(), doNotify: doNotify);
    selectedMid = connectedUser.mid;
    if (doNotify) notify();
    onComplete?.call(false, bookMid!);

    MyChange<ConnectedUserModel> c = MyChange<ConnectedUserModel>(
      connectedUser,
      execute: () {},
      redo: () async {
        connectedUser.isRemoved.set(false, noUndo: true);
        insert(connectedUser, postion: getLength(), doNotify: doNotify);
        selectedMid = connectedUser.mid;
        onComplete?.call(false, bookMid!);
      },
      undo: (ConnectedUserModel old) async {
        connectedUser.isRemoved.set(true, noUndo: true);
        remove(connectedUser);
        selectedMid = '';
        onComplete?.call(true, bookMid!);
      },
    );
    mychangeStack.add(c);

    return connectedUser;
  }

  Future<ConnectedUserModel?> update({
    required ConnectedUserModel connectedUser,
    bool doNotify = true,
  }) async {
    if (bookMid == null) return null;

    //logger.info('update()');
    await setToDB(connectedUser);
    updateModel(connectedUser);
    selectedMid = connectedUser.mid;
    if (doNotify) notify();

    return connectedUser;
  }

  Future<ConnectedUserModel> delete({
    required ConnectedUserModel connectedUser,
    bool doNotify = true,
  }) async {
    logger.info('delete()');
    connectedUser.isRemoved.set(true, save: false);
    await setToDB(connectedUser);
    updateModel(connectedUser);
    selectedMid = connectedUser.mid;

    if (doNotify) notify();

    return connectedUser;
  }

  Set<ConnectedUserModel> getConnectedUserSet(String me) {
    Set<ConnectedUserModel> retval = {};
    for (var ele in modelList) {
      if (ele.isRemoved.value == true) {
        continue;
      }
      // print('lastUpdateTime = ${ele.updateTime.toString()}');
      if (ele.updateTime.isBefore(CretaUtils.getTimeSecondsAgo(monitorPerid))) {
        continue;
      }
      ConnectedUserModel model = ele as ConnectedUserModel;
      //print('getConnectedUserList ${model.name}');
      if (model.name == me) continue;
      retval.add(model);
    }
    return retval;
  }

  ConnectedUserModel? aleadyCreated(String name) {
    for (var ele in modelList) {
      if (ele.isRemoved.value == true) {
        continue;
      }
      ConnectedUserModel model = ele as ConnectedUserModel;
      if (model.name == name) return model;
    }
    return null;
  }

  ConnectedUserModel? findConnectedUser(String name) {
    for (var ele in modelList) {
      if (ele.isRemoved.value == true) {
        continue;
      }
      ConnectedUserModel model = ele as ConnectedUserModel;
      if (name == model.name) {
        return model;
      }
    }
    return null;
  }

  bool isDup(String name) {
    for (var ele in modelList) {
      if (ele.isRemoved.value == true) {
        continue;
      }
      ConnectedUserModel model = ele as ConnectedUserModel;
      if (name == model.name) {
        return true;
      }
    }
    return false;
  }

  int removeOld(String myName) {
    int counter = 0;
    for (var ele in modelList) {
      if (ele.isRemoved.value == true) {
        continue;
      }
      ConnectedUserModel model = ele as ConnectedUserModel;
      if (model.name == myName) {
        continue;
      }
      //print('${model.name} lastUpdateTime = ${model.updateTime.toString()}');
      if (model.updateTime.isBefore(CretaUtils.getTimeSecondsAgo(monitorPerid))) {
        counter++;
        model.isRemoved.set(true, noUndo: true);
        //print('ele.mid is old, deleted!!!');
        continue;
      }
    }
    if (counter > 0) {
      //print('ele.mid is old, deleted!!! notify');
      notify();
    }
    return counter;
  }
}
