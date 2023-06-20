import 'package:hycop/hycop.dart';
//import '../common/creta_utils.dart';
//import '../design_system/menu/creta_popup_menu.dart';
//import '../lang/creta_lang.dart';
//import '../lang/creta_studio_lang.dart';
//import '../model/app_enums.dart';
//import '../model/book_model.dart';
import '../model/favorites_model.dart';
import '../model/book_model.dart';
import '../model/creta_model.dart';
import 'creta_manager.dart';

class FavoritesManager extends CretaManager {
  FavoritesManager() : super('creta_favorites') {
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
    Map<String, QueryValue> query = {};
    query['isRemoved'] = QueryValue(value: false);
    query['bookId'] = QueryValue(value: bookIdList, operType: OperType.whereIn);
    return queryFromDB(
      query,
      //limit: ,
      //orderBy: orderBy,
    );
  }

  Future<List<AbsExModel>> queryFavoritesFromBookIdList(List<String> bookIdList) {
    if (bookIdList.isEmpty) {
      setState(DBState.idle);
      return Future.value([]);
    }
    Map<String, QueryValue> query = {};
    query['isRemoved'] = QueryValue(value: false);
    query['bookId'] = QueryValue(value: bookIdList, operType: OperType.whereIn);
    return queryFromDB(
      query,
      //limit: ,
      //orderBy: orderBy,
    );
  }

  Future<String> addFavoritesToDB(String bookId, String userId) async {
    // check already exist
    Map<String, QueryValue> query = {};
    query['isRemoved'] = QueryValue(value: false);
    query['userId'] = QueryValue(value: userId);
    query['bookId'] = QueryValue(value: bookId);
    queryFromDB(query);
    List<AbsExModel> list = await isGetListFromDBComplete().catchError((error, stackTrace) =>
        throw HycopUtils.getHycopException(error: error, defaultMessage: 'addFavoritesToDB Failed !!!'));
    if (list.isNotEmpty) {
      // already exist in DB
      FavoritesModel favModel = list[0] as FavoritesModel; // 1개만 있다고 가정
      return favModel.mid;
    }
    // not exist in DB => add to DB
    FavoritesModel favModel = FavoritesModel.withName(
      userId: userId,
      bookId: bookId,
      lastUpdateTime: DateTime.now(),
    );
    createToDB(favModel);
    await isGetListFromDBComplete().catchError((error, stackTrace) =>
        throw HycopUtils.getHycopException(error: error, defaultMessage: 'addFavoritesToDB Failed !!!'));
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
        throw HycopUtils.getHycopException(error: error, defaultMessage: 'removeFavoritesFromDB Failed !!!'));
    if (list.isEmpty) {
      // already not exist in DB
      return true;
    }
    // not exist in DB => add to DB
    FavoritesModel favModel = list[0] as FavoritesModel; // 무조건 1개만 있다고 가정
    removeToDB(favModel.mid);
    await isGetListFromDBComplete().catchError((error, stackTrace) =>
        throw HycopUtils.getHycopException(error: error, defaultMessage: 'addFavoritesToDB Failed !!!'));
    return true;
  }

  String prefix() => CretaManager.modelPrefix(ExModelType.favorites);
}
