import 'package:creta_studio_model/model/depot_model.dart';
import 'package:hycop/hycop.dart';
//import '../common/creta_utils.dart';
//import '../design_system/menu/creta_popup_menu.dart';
//import 'package:creta_common/lang/creta_lang.dart';
//import '../lang/creta_studio_lang.dart';
//import 'package:creta_common/model/app_enums.dart';
//import 'package:creta_studio_model/model/book_model.dart';
import '../model/favorites_model.dart';
import 'package:creta_studio_model/model/book_model.dart';
import 'package:creta_common/model/creta_model.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';

class FavoritesManager extends CretaManager {
  FavoritesManager() : super('creta_favorites', null) {
    saveManagerHolder?.registerManager('favorites', this);
  }

  @override
  AbsExModel newModel(String mid) => FavoritesModel(mid);

  @override
  CretaModel cloneModel(CretaModel src) {
    FavoritesModel retval = newModel(src.mid) as FavoritesModel;
    src.copyTo(retval);
    return retval;
  }

  Future<List<AbsExModel>> queryFavoritesFromBookModelList(List<AbsExModel> bookModelList) {
    if (bookModelList.isEmpty) {
      setState(DBState.idle);
      return Future.value([]);
    }
    List<String> bookIdList = [];
    for (var exModel in bookModelList) {
      BookModel bookModel = exModel as BookModel;
      bookIdList.add(bookModel.mid);
    }
    if (bookIdList.isEmpty) {
      setState(DBState.idle);
      return Future.value([]);
    }
    // Map<String, QueryValue> query = {};
    // query['isRemoved'] = QueryValue(value: false);
    // query['bookId'] = QueryValue(value: bookIdList, operType: OperType.whereIn);
    // query['userId'] = QueryValue(value: AccountManager.currentLoginUser.email);
    // return queryFromDB(
    //   query,
    //   //limit: ,
    //   //orderBy: orderBy,
    // );
    addWhereClause('isRemoved', QueryValue(value: false));
    addWhereClause('bookId', QueryValue(value: bookIdList, operType: OperType.whereIn));
    addWhereClause('userId', QueryValue(value: AccountManager.currentLoginUser.email));
    return queryByAddedContitions();
  }

  Future<List<AbsExModel>> queryFavoritesFromBookIdList(List<String> bookIdList) {
    if (bookIdList.isEmpty) {
      setState(DBState.idle);
      return Future.value([]);
    }
    // Map<String, QueryValue> query = {};
    // query['isRemoved'] = QueryValue(value: false);
    // query['bookId'] = QueryValue(value: bookIdList, operType: OperType.whereIn);
    // return queryFromDB(
    //   query,
    //   //limit: ,
    //   //orderBy: orderBy,
    // );
    addWhereClause('isRemoved', QueryValue(value: false));
    addWhereClause('bookId', QueryValue(value: bookIdList, operType: OperType.whereIn));
    return queryByAddedContitions();
  }

  Future<List<AbsExModel>> queryFavoritesFromDepotModelList(List<AbsExModel> depotModelList) {
    if (depotModelList.isEmpty) {
      setState(DBState.idle);
      return Future.value([]);
    }
    List<String> depotIdList = [];
    for (var exModel in depotModelList) {
      DepotModel depotModel = exModel as DepotModel;
      depotIdList.add(depotModel.mid);
    }
    if (depotModelList.isEmpty) {
      setState(DBState.idle);
      return Future.value([]);
    }
    // Map<String, QueryValue> query = {};
    // query['isRemoved'] = QueryValue(value: false);
    // query['parentId'] = QueryValue(value: depotIdList, operType: OperType.whereIn);
    // query['userId'] = QueryValue(value: AccountManager.currentLoginUser.email);
    // return queryFromDB(
    //   query,
    //   //limit: ,
    //   //orderBy: orderBy,
    // );
    addWhereClause('isRemoved', QueryValue(value: false));
    addWhereClause('parentId', QueryValue(value: depotIdList, operType: OperType.whereIn));
    addWhereClause('userId', QueryValue(value: AccountManager.currentLoginUser.email));
    return queryByAddedContitions();
  }

  Future<List<AbsExModel>> queryFavoritesFromContentsMidList(List<String> contentsMidList) {
    if (contentsMidList.isEmpty) {
      setState(DBState.idle);
      return Future.value([]);
    }
    // Map<String, QueryValue> query = {};
    // query['isRemoved'] = QueryValue(value: false);
    // query['bookId'] = QueryValue(value: contentsMidList, operType: OperType.whereIn);
    // return queryFromDB(
    //   query,
    //   //limit: ,
    //   //orderBy: orderBy,
    // );
    addWhereClause('isRemoved', QueryValue(value: false));
    addWhereClause('bookId', QueryValue(value: contentsMidList, operType: OperType.whereIn));
    return queryByAddedContitions();
  }

  Future<String> addFavoritesToDB(String bookId, String userId) async {
    // check already exist
    Map<String, QueryValue> query = {};
    query['isRemoved'] = QueryValue(value: false);
    query['userId'] = QueryValue(value: userId);
    query['bookId'] = QueryValue(value: bookId);
    queryFromDB(query);
    List<AbsExModel> list = await isGetListFromDBComplete().catchError((error, stackTrace) =>
        throw HycopUtils.getHycopException(
            error: error, defaultMessage: 'addFavoritesToDB Failed !!!'));
    if (list.isNotEmpty) {
      // already exist in DB
      FavoritesModel favModel = list[0] as FavoritesModel; // 1개만 있다고 가정
      return favModel.mid;
    }
    // not exist in DB => add to DB
    FavoritesModel favModel = FavoritesModel.withName(
      userId: userId,
      bookId: bookId,
      //lastUpdateTime: DateTime.now(),
    );
    createToDB(favModel);
    await isGetListFromDBComplete().catchError((error, stackTrace) =>
        throw HycopUtils.getHycopException(
            error: error, defaultMessage: 'addFavoritesToDB Failed !!!'));
    return favModel.mid;
  }

  Future<bool> removeFavoritesFromDB(String bookId, String userId) async {
    // check already exist
    Map<String, QueryValue> query = {};
    query['isRemoved'] = QueryValue(value: false);
    query['userId'] = QueryValue(value: userId);
    query['bookId'] = QueryValue(value: bookId);
    queryFromDB(query);
    List<AbsExModel> list = await isGetListFromDBComplete().catchError((error, stackTrace) =>
        throw HycopUtils.getHycopException(
            error: error, defaultMessage: 'removeFavoritesFromDB Failed !!!'));
    if (list.isEmpty) {
      // already not exist in DB
      return true;
    }
    // not exist in DB => add to DB
    FavoritesModel favModel = list[0] as FavoritesModel; // 무조건 1개만 있다고 가정
    removeToDB(favModel.mid);
    await isGetListFromDBComplete().catchError((error, stackTrace) =>
        throw HycopUtils.getHycopException(
            error: error, defaultMessage: 'addFavoritesToDB Failed !!!'));
    return true;
  }

  String prefix() => CretaManager.modelPrefix(ExModelType.favorites);
}
