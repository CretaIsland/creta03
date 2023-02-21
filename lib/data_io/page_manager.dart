// ignore_for_file: prefer_final_fields

import 'package:hycop/common/undo/save_manager.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/database/abs_database.dart';
import '../model/book_model.dart';
import '../model/creta_model.dart';
import '../model/page_model.dart';
import 'creta_manager.dart';

//PageManager? pageManagerHolder;

class PageManager extends CretaManager {
  BookModel? bookModel;

  PageManager() : super('creta_page') {
    saveManagerHolder?.registerManager('page', this);
  }
  void setBook(BookModel book) {
    bookModel = book;
  }

  @override
  CretaModel cloneModel(CretaModel src) {
    PageModel retval = newModel(src.mid) as PageModel;
    src.copyTo(retval);
    return retval;
  }

  @override
  AbsExModel newModel(String mid) => PageModel(mid);

  Future<PageModel> createNextPage() async {
    updateLastOrder();
    PageModel defaultPage = PageModel.makeSample(++lastOrder, bookModel!.mid);
    await createToDB(defaultPage);
    insert(defaultPage, postion: getAvailLength());
    selectedMid = defaultPage.mid;
    return defaultPage;
  }

  Future<int> getPages({int limit = 99}) async {
    logger.finest('getPages');
    Map<String, QueryValue> query = {};
    query['parentMid'] = QueryValue(value: bookModel!.mid);
    query['isRemoved'] = QueryValue(value: false);
    Map<String, OrderDirection> orderBy = {};
    orderBy['order'] = OrderDirection.ascending;
    await queryFromDB(query, orderBy: orderBy, limit: limit);
    logger.finest('getPages ${modelList.length}');
    updateLastOrder();
    return modelList.length;
  }
}
