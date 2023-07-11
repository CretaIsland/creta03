// ignore_for_file: must_be_immutable, prefer_const_constructors

//import 'dart:convert';

//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
//import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/enum/model_enums.dart';
//import '../common/creta_utils.dart';
//import '../pages/studio/studio_constant.dart';
//import 'app_enums.dart';
import 'creta_model.dart';
//import 'creta_style_mixin.dart';

// ignore: camel_case_types
class CommentModel extends CretaModel {
  String userId = '';
  String bookId = '';
  String parentId = '';
  String comment = '';

  @override
  List<Object?> get props => [
        ...super.props,
        userId,
        bookId,
        parentId,
        comment,
      ];
  CommentModel(String pmid) : super(pmid: pmid, type: ExModelType.comment, parent: '');

  CommentModel.withName({
    required this.userId,
    required this.bookId,
    required this.parentId,
    required this.comment,
  }) : super(pmid: '', type: ExModelType.watchHistory, parent: '');

  @override
  void copyFrom(AbsExModel src, {String? newMid, String? pMid}) {
    super.copyFrom(src, newMid: newMid, pMid: pMid);
    CommentModel srcComment = src as CommentModel;
    userId = srcComment.userId;
    bookId = srcComment.bookId;
    parentId = srcComment.parentId;
    comment = srcComment.comment;
    logger.finest('CommentCopied($mid)');
  }

  @override
  void updateFrom(AbsExModel src) {
    super.updateFrom(src);
    CommentModel srcComment = src as CommentModel;
    userId = srcComment.userId;
    bookId = srcComment.bookId;
    parentId = srcComment.parentId;
    comment = srcComment.comment;
    logger.finest('WatchHistoryCopied($mid)');
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);
    userId = map["userId"] ?? '';
    bookId = map["bookId"] ?? '';
    parentId = map["parentId"] ?? '';
    comment = map["comment"] ?? '';
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addEntries({
        "userId": userId,
        "bookId": bookId,
        "parentId": parentId,
        "comment": comment,
      }.entries);
  }
}
