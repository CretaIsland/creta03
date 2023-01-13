import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model_manager.dart';
import '../model/page_model.dart';

PageManager? pageManagerHolder;

class PageManager extends AbsExModelManager {
  PageManager() : super('hycop_page');
  @override
  AbsExModel newModel() => PageModel();

  @override
  void realTimeCallback(String directive, String userId, Map<String, dynamic> dataMap) {
    logger.finest('realTimeCallback invoker($directive, $userId)');
    if (directive == 'create') {
      PageModel page = PageModel();
      page.fromMap(dataMap);
      modelList.insert(0, page);
      logger.finest('${page.mid} realtime added');
      notifyListeners();
    } else if (directive == 'set') {
      String mid = dataMap["mid"] ?? '';
      if (mid.isEmpty) {
        return;
      }
      for (AbsExModel model in modelList) {
        if (model.mid == mid) {
          model.fromMap(dataMap);
          logger.finest('${model.mid} realtime changed');
          notifyListeners();
        }
      }
    } else if (directive == 'remove') {
      String mid = dataMap["mid"] ?? '';
      logger.finest('removed mid = $mid');
      if (mid.isEmpty) {
        return;
      }
      for (AbsExModel model in modelList) {
        if (model.mid == mid) {
          modelList.remove(model);
          logger.finest('${model.mid} realtime removed');
          notifyListeners();
        }
      }
    }
  }
}
