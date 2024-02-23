import 'package:hycop/hycop.dart';

import 'package:creta_user_io/data_io/creta_manager.dart';
import 'package:creta_common/model/creta_model.dart';

import 'package:creta_studio_model/model/book_model.dart';
import '../model/filter_model.dart';

class FilterManager extends CretaManager {
  final String userEmail;
  BookModel? bookModel;
  void setBook(BookModel b) {
    bookModel = b;
    parentMid = b.mid;
  }

  FilterManager(this.userEmail) : super('creta_filter', null) {
    // parentMid 는 userEmail 이다.
    saveManagerHolder?.registerManager('filter', this, postfix: userEmail);
  }

  @override
  CretaModel cloneModel(CretaModel src) {
    FilterModel retval = newModel(src.mid) as FilterModel;
    src.copyTo(retval);
    return retval;
  }

  @override
  AbsExModel newModel(String mid) => FilterModel(mid);

  Future<int> getFilter() async {
    // parentMid 는 userEmail 이다.
    startTransaction();
    try {
      Map<String, QueryValue> query = {};
      query['parentMid'] = QueryValue(value: userEmail);
      query['isRemoved'] = QueryValue(value: false);
      await queryFromDB(query);
      reOrdering();
    } catch (error) {
      logger.fine('something wrong in FilterManager >> $error');
      return 0;
    }
    endTransaction();
    return modelList.length;
  }

  Future<FilterModel> createNext({
    required FilterModel filter,
    bool doNotify = true,
    void Function(bool, String)? onComplete,
  }) async {
    logger.fine('createNext()');
    // FilterModel filter = FilterModel('');
    // filter.parentMid.set(userEmail, save: false, noUndo: true);
    // filter.name = name;
    // filter.excludes = excludes != null ? [...excludes] : [];
    // filter.includes = includes != null ? [...includes] : [];
    // filter.order.set(getMaxOrder() + 1, save: false, noUndo: true);

    await createToDB(filter);
    insert(filter, postion: getLength(), doNotify: doNotify);
    selectedMid = filter.mid;
    if (doNotify) notify();
    onComplete?.call(false, userEmail);

    MyChange<FilterModel> c = MyChange<FilterModel>(
      filter,
      execute: () {},
      redo: () async {
        filter.isRemoved.set(false, noUndo: true);
        insert(filter, postion: getLength(), doNotify: doNotify);
        selectedMid = filter.mid;
        onComplete?.call(false, userEmail);
      },
      undo: (FilterModel old) async {
        filter.isRemoved.set(true, noUndo: true);
        remove(filter);
        selectedMid = '';
        onComplete?.call(true, userEmail);
      },
    );
    mychangeStack.add(c);

    return filter;
  }

  Future<FilterModel> update({
    required FilterModel filter,
    bool doNotify = true,
  }) async {
    logger.fine('update()');
    await setToDB(filter);
    updateModel(filter);
    selectedMid = filter.mid;
    if (doNotify) notify();

    return filter;
  }

  Future<FilterModel> delete({
    required FilterModel filter,
    bool doNotify = true,
  }) async {
    logger.fine('delete()');
    filter.isRemoved.set(true, save: false);
    await setToDB(filter);
    updateModel(filter);
    selectedMid = filter.mid;

    if (doNotify) notify();

    return filter;
  }

  List<String> getFilterList() {
    List<String> retval = [];
    for (var ele in modelList) {
      if (ele.isRemoved.value == true) {
        continue;
      }
      FilterModel model = ele as FilterModel;
      retval.add(model.name);
    }
    return retval;
  }

  FilterModel? findFilter(String name) {
    for (var ele in modelList) {
      if (ele.isRemoved.value == true) {
        continue;
      }
      FilterModel model = ele as FilterModel;
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
      FilterModel model = ele as FilterModel;
      if (name == model.name) {
        return true;
      }
    }
    return false;
  }

  bool isVisible(AbsExModel model) {
    if (bookModel == null) {
      return true;
    }
    if (model.hashTag.value.isEmpty) {
      return true;
    }
    if (bookModel!.filter.value.isEmpty) {
      return true;
    }
    FilterModel? filter = findFilter(bookModel!.filter.value);
    if (filter == null) {
      return true;
    }
    if (filter.excludes.isEmpty) {
      return true;
    }
    for (String ele in filter.excludes) {
      if (model.hashTag.value.contains(ele) == true) {
        return false;
      }
    }
    return true;
  }
}
