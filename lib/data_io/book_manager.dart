import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import '../model/book_model.dart';
import 'creta_manager.dart';

class BookManager extends CretaManager {
  BookManager() : super('creta_book');

  @override
  AbsExModel newModel() => BookModel();
}
