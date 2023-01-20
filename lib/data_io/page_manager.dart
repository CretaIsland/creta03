import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import '../model/page_model.dart';
import 'creta_manager.dart';

PageManager? pageManagerHolder;

class PageManager extends CretaManager {
  PageManager() : super('creta_page');
  @override
  AbsExModel newModel() => PageModel();
}
