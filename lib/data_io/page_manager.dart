// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:hycop/common/undo/save_manager.dart';
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

  PageManager({required this.bookModel}) : super('creta_page') {
    saveManagerHolder?.registerManager('page', this);
  }

  @override
  AbsExModel newModel(String mid) => PageModel(mid);

  bool isPageSelected(String mid) {
    //rlogHolder.log('isPageSelected($mid)');
    return _selectedMid == mid;
  }

  Future<PageModel> createNextPage() async {
    updateLastOrder();
    PageModel defaultPage = PageModel.makeSample(++lastOrder, bookModel.mid);
    await createToDB(defaultPage);
    insert(defaultPage, postion: getAvailLength());
    _selectedMid = defaultPage.mid;
    return defaultPage;
  }

  Future<int> getPages({int limit = 99}) async {
    logger.finest('getPages');
    Map<String, QueryValue> query = {};
    query['parentMid'] = QueryValue(value: bookModel.mid);
    query['isRemoved'] = QueryValue(value: false);
    Map<String, OrderDirection> orderBy = {};
    orderBy['order'] = OrderDirection.ascending;
    await queryFromDB(query, orderBy: orderBy, limit: limit);
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

  Future<void> setSelectedIndex(BuildContext context, String mid) async {
    _selectedMid = mid;
    notify();
    //setAsPage(); //setAsPage contain notify();
    // PageModel? page = getSelected();
    // if (page != null) {
    //   await page.waitPageBuild(); // 페이지가 완전히 빌드 될때까지 기둘린다.
    //   notify();
    //   // ignore: use_build_context_synchronously
    //   accManagerHolder!.showPages(context, mid); // page 가 완전히 노출된 후에 ACC 를 그린다.
    // }
  }

  PageModel? getSelected() {
    if (_selectedMid.isEmpty) {
      return null;
    }
    for (var ele in modelList) {
      if (ele.mid == _selectedMid) {
        return ele as PageModel;
      }
    }
    return null;
  }

  void printLog() {
    lock();
    for (var ele in modelList) {
      logger.finer('${ele.mid}, isRemoved=${ele.isRemoved.value}');
    }
    unlock();
  }
}
