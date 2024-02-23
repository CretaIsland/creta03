//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hycop/hycop.dart';
//import '../common/creta_utils.dart';
//import '../design_system/menu/creta_popup_menu.dart';
//import 'package:creta_common/lang/creta_lang.dart';
//import '../lang/creta_studio_lang.dart';
//import 'package:creta_common/model/app_enums.dart';
//import 'package:creta_studio_model/model/book_model.dart';
import '../model/comment_model.dart';
import 'package:creta_common/model/creta_model.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';

class CommentManager extends CretaManager {
  CommentManager() : super('creta_comment', null) {
    saveManagerHolder?.registerManager('comment', this);
  }

  @override
  AbsExModel newModel(String mid) => CommentModel(mid);

  @override
  CretaModel cloneModel(CretaModel src) {
    CommentModel retval = newModel(src.mid) as CommentModel;
    src.copyTo(retval);
    return retval;
  }

  String prefix() => CretaManager.modelPrefix(ExModelType.comment);

  List<CommentModel> commentList = [];

  Future<List<CommentModel>> getCommentList(String bookId) async {
    // 추후 페이징 기능 추가 필요!!!
    addWhereClause('isRemoved', QueryValue(value: false));
    addWhereClause('bookId', QueryValue(value: bookId));
    addWhereClause('parentId', QueryValue(value: ''));
    addOrderBy('createTime', OrderDirection.descending);
    List<AbsExModel> modelList = await queryByAddedContitions();
    commentList = [];
    List<List<String>> commentIdListList = [];
    List<String> commentIdList = [];
    for (var model in modelList) {
      CommentModel commentModel = model as CommentModel;
      commentList.add(commentModel);
      commentIdList.add(commentModel.mid);
      if (commentIdList.length == 10) {
        commentIdListList.add(commentIdList);
        commentIdList = [];
      }
    }
    if (commentIdList.isNotEmpty) {
      commentIdListList.add(commentIdList);
    }
    for (var commentIdList in commentIdListList) {
      addWhereClause('isRemoved', QueryValue(value: false));
      addWhereClause('bookId', QueryValue(value: bookId));
      addWhereClause('parentId', QueryValue(value: commentIdList, operType: OperType.whereIn));
      addOrderBy('createTime', OrderDirection.ascending);
      List<AbsExModel> modelList = await queryByAddedContitions();
      for (var model in modelList) {
        commentList.add(model as CommentModel);
      }
    }
    return commentList;
  }

  Future<void> removeCommentFromDB(CommentModel model) async {
    // remove child-comments
    for (var replayComment in model.replyList) {
      await removeToDB(replayComment.mid);
    }
    // remove comment
    await removeToDB(model.mid);
  }
}
