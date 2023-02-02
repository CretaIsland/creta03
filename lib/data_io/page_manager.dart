// ignore_for_file: prefer_final_fields

import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/database/abs_database.dart';
import '../model/book_model.dart';
import '../model/page_model.dart';
import 'creta_manager.dart';

PageManager? pageManagerHolder;

class PageManager extends CretaManager {
  final BookModel bookModel;
  double lastOrder = 0;
  String _selectedMid = '';

  PageManager({required this.bookModel}) : super('creta_page');
  @override
  AbsExModel newModel() => PageModel();

  bool isPageSelected(String mid) {
    //rlogHolder.log('isPageSelected($mid)');
    return _selectedMid == mid;
  }

  Future<PageModel> createNextPage() async {
    PageModel defaultPage = PageModel.makeSample(lastOrder, bookModel.mid);
    await createToDB(defaultPage);
    insert(defaultPage);
    updateLastOrder();
    _selectedMid = defaultPage.mid;
    return defaultPage;
  }

  Future<int> getPages({int limit = 99}) async {
    logger.finest('getPages');
    Map<String, QueryValue> query = {};
    query['parentMid'] = QueryValue(value: bookModel.mid);
    query['isRemoved'] = QueryValue(value: false);
    await queryFromDB(query, limit: limit);
    logger.finest('getPages ${modelList.length}');
    updateLastOrder();
    return modelList.length;
  }

  void updateLastOrder() {
    lock();
    for (var ele in modelList) {
      if (ele.order.value > lastOrder) {
        lastOrder = ele.order.value;
      }
    }
    unlock();
  }
}
