// ignore_for_file: must_be_immutable, prefer_const_constructors

//import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/enum/model_enums.dart';
import '../common/creta_utils.dart';
import '../pages/studio/studio_constant.dart';
import 'app_enums.dart';
import 'creta_model.dart';
import 'creta_style_mixin.dart';

// ignore: camel_case_types
class BookModel extends CretaModel with CretaStyleMixin {
  String creator = '';
  String creatorName = '';
  late UndoAble<String> name;
  late UndoAble<bool> isSilent;
  late UndoAble<bool> isAutoPlay;
  late UndoAble<BookType> bookType;
  late UndoAble<int> pageSizeType;
  late UndoAble<CopyRightType> copyRight;
  late UndoAble<String> description;
  late UndoAble<bool> isReadOnly;
  late UndoAble<String> thumbnailUrl;
  late UndoAble<ContentsType> thumbnailType;
  late UndoAble<double> thumbnailAspectRatio;
  int viewCount = 0;
  int likeCount = 0;
  List<String> owners = [];
  List<String> readers = [];
  List<String> writers = [];
  List<String> shares = [];
  String publishMid = ''; // 원본Book의 발행된 BookMid
  String sourceMid = ''; // 발행된 Book의 원본BookMid
  List<String> hashtags = [];

  Size realSize = Size(LayoutConst.minPageSize, LayoutConst.minPageSize);

  @override
  List<Object?> get props => [
        ...super.props,
        creator,
        creatorName,
        name,
        isSilent,
        isAutoPlay,
        bookType,
        pageSizeType,
        copyRight,
        description,
        isReadOnly,
        thumbnailUrl,
        thumbnailType,
        thumbnailAspectRatio,
        viewCount,
        likeCount,
        owners,
        readers,
        writers,
        shares,
        publishMid,
        sourceMid,
        hashtags,
        ...super.propsMixin,
      ];
  BookModel(String pmid) : super(pmid: pmid, type: ExModelType.book, parent: '') {
    name = UndoAble<String>('', mid);
    thumbnailUrl = UndoAble<String>('', mid);
    thumbnailType = UndoAble<ContentsType>(ContentsType.none, mid);
    thumbnailAspectRatio = UndoAble<double>(1, mid);
    isSilent = UndoAble<bool>(false, mid);
    isAutoPlay = UndoAble<bool>(true, mid);
    bookType = UndoAble<BookType>(BookType.presentaion, mid);
    pageSizeType = UndoAble<int>(0, mid);
    copyRight = UndoAble<CopyRightType>(CopyRightType.free, mid);
    isReadOnly = UndoAble<bool>(false, mid);
    viewCount = 0;
    likeCount = 0;
    owners = [];
    readers = [];
    writers = [];
    shares = [];
    //publishMid = '';
    //sourceMid = '';
    //hashtags = [];
    description = UndoAble<String>("You could do it simple and plain", mid);
    super.initMixin(mid);
  }

  BookModel.withName(
    String nameStr, {
    required this.creator,
    required this.creatorName,
    required String imageUrl,
    double imageRatio = 1080 / 1920,
    int likeNo = 0,
    int viewNo = 0,
    BookType bookTypeVal = BookType.presentaion,
    CopyRightType copyRightVal = CopyRightType.free,
    List<String> ownerList = const [],
    List<String> readerList = const [],
    List<String> writerList = const [],
    String? desc,
    String? publishMid,
    String? sourceMid,
    List<String>? hashtags,
      }) : super(pmid: '', type: ExModelType.book, parent: '') {
    name = UndoAble<String>(nameStr, mid);
    thumbnailUrl = UndoAble<String>(imageUrl, mid);
    thumbnailType = UndoAble<ContentsType>(ContentsType.image, mid);
    thumbnailAspectRatio = UndoAble<double>(imageRatio, mid);
    isSilent = UndoAble<bool>(false, mid);
    isAutoPlay = UndoAble<bool>(true, mid);
    bookType = UndoAble<BookType>(bookTypeVal, mid);
    pageSizeType = UndoAble<int>(0, mid);
    copyRight = UndoAble<CopyRightType>(copyRightVal, mid);
    isReadOnly = UndoAble<bool>(false, mid);
    viewCount = likeNo;
    likeCount = viewNo;
    description = UndoAble<String>("You could do it simple and plain", mid);
    owners = [...ownerList];
    readers = [...readerList];
    writers = [...writerList];
    //shares = [...ownerList, ...writerList, ...readerList];
    shares = _getShares(ownerList, writerList, readerList);
    if (publishMid != null) this.publishMid = publishMid;
    if (sourceMid != null) this.sourceMid = sourceMid;
    if (hashtags != null) this.hashtags = [...hashtags];
    if (desc != null) {
      description = UndoAble<String>(desc, mid);
    }
    super.makeSampleMixin(mid);

    logger.finest('owners=${owners.toString()}');
  }
  @override
  void copyFrom(AbsExModel src, {String? newMid, String? pMid}) {
    super.copyFrom(src, newMid: newMid, pMid: pMid);
    BookModel srcBook = src as BookModel;
    creator = src.creator;
    creatorName = src.creatorName;
    name = UndoAble<String>(srcBook.name.value, mid);
    thumbnailUrl = UndoAble<String>(srcBook.thumbnailUrl.value, mid);
    thumbnailType = UndoAble<ContentsType>(srcBook.thumbnailType.value, mid);
    thumbnailAspectRatio = UndoAble<double>(srcBook.thumbnailAspectRatio.value, mid);
    isSilent = UndoAble<bool>(srcBook.isSilent.value, mid);
    isAutoPlay = UndoAble<bool>(srcBook.isAutoPlay.value, mid);
    bookType = UndoAble<BookType>(srcBook.bookType.value, mid);
    pageSizeType = UndoAble<int>(srcBook.pageSizeType.value, mid);
    copyRight = UndoAble<CopyRightType>(srcBook.copyRight.value, mid);
    isReadOnly = UndoAble<bool>(srcBook.isReadOnly.value, mid);
    viewCount = srcBook.viewCount;
    likeCount = srcBook.likeCount;
    description = UndoAble<String>(srcBook.description.value, mid);
    owners = [...srcBook.owners];
    readers = [...srcBook.readers];
    writers = [...srcBook.writers];
    //shares = [...srcBook.owners, ...srcBook.writers, ...srcBook.readers];
    shares = _getShares(srcBook.owners, srcBook.writers, srcBook.readers);
    publishMid = srcBook.publishMid;
    sourceMid = srcBook.sourceMid;
    hashtags = [...srcBook.hashtags];

    super.copyFromMixin(mid, srcBook);
    logger.finest('BookCopied($mid)');
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);
    name.set(map["name"] ?? '', save: false, noUndo: true);
    creator = map["creator"] ?? '';
    creatorName = map["creatorName"] ?? '';
    isSilent.set(map["isSilent"] ?? false, save: false, noUndo: true);
    isAutoPlay.set(map["isAutoPlay"] ?? true, save: false, noUndo: true);
    isReadOnly.set(map["isReadOnly"] ?? (map["readOnly"] ?? false), save: false, noUndo: true);
    bookType.set(BookType.fromInt(map["bookType"] ?? 0), save: false, noUndo: true);
    pageSizeType.set(map["pageSizeType"] ?? 0, save: false, noUndo: true);
    copyRight.set(CopyRightType.fromInt(map["copyRight"] ?? 1), save: false, noUndo: true);
    description.set(map["description"] ?? '', save: false, noUndo: true);
    thumbnailUrl.set(map["thumbnailUrl"] ?? '', save: false, noUndo: true);
    thumbnailType.set(ContentsType.fromInt(map["thumbnailType"] ?? 1), save: false, noUndo: true);
    thumbnailAspectRatio.set((map["thumbnailAspectRatio"] ?? 1), save: false, noUndo: true);
    owners = CretaUtils.jsonStringToList(map["owners"] ?? '');
    readers = CretaUtils.jsonStringToList((map["readers"] ?? ''));
    writers = CretaUtils.jsonStringToList((map["writers"] ?? ''));
    //shares = CretaUtils.jsonStringToList((map["shares"] ?? ''));  //DB 에서 읽어오지 않는다.
    publishMid = map["publishMid"] ?? '';
    sourceMid = map["sourceMid"] ?? '';
    hashtags = map["hashtags"] ?? [];

    viewCount = (map["viewCount"] ?? 0);
    likeCount = (map["likeCount"] ?? 0);

    super.fromMapMixin(map);
  }

  @override
  Map<String, dynamic> toMap() {
    //shares = [...owners, ...writers, ...readers];
    shares = _getShares(owners, writers, readers);
    return super.toMap()
      ..addEntries({
        "name": name.value,
        "creator": creator,
        "creatorName": creatorName,
        "isSilent": isSilent.value,
        "isAutoPlay": isAutoPlay.value,
        "isReadOnly": isReadOnly.value,
        "bookType": bookType.value.index,
        "pageSizeType": pageSizeType.value,
        "copyRight": copyRight.value.index,
        "description": description.value,
        "thumbnailUrl": thumbnailUrl.value,
        "thumbnailType": thumbnailType.value.index,
        "thumbnailAspectRatio": thumbnailAspectRatio.value,
        "viewCount": viewCount,
        "likeCount": likeCount,
        "owners": CretaUtils.listToString(owners),
        "readers": CretaUtils.listToString(readers),
        "writers": CretaUtils.listToString(writers),
        "shares": shares, //DB 에 쓰기는 쓴다, 검색용이다.
        "publishMid": publishMid,
        "sourceMid": sourceMid,
        "hashtags": hashtags,
      ...super.toMapMixin(),
      }.entries);
  }

  double getRatio() {
    return height.value / width.value;
  }

  Size getSize() {
    return Size(width.value, height.value);
  }

  Size getRealSize() {
    if (key.currentContext != null) {
      RenderBox box = key.currentContext?.findRenderObject() as RenderBox;
      realSize = box.size; //this is global position
    }
    //logger.finest("kye.currentContext is null $realSize", level: 6);
    return realSize; //보관된 realSize 값을 리턴한다.
  }

  Size getRealRatio() {
    Size size = getRealSize();
    return Size(size.width / width.value, size.height / height.value);
  }

  List<String> _getShares(List<String> ownerList, List<String> writerList, List<String> readerList) {
    List<String> valueList = [];
    for(var val in ownerList) {
      valueList.add('<${PermissionType.owner.name}>$val');
    }
    for(var val in writerList) {
      valueList.add('<${PermissionType.writer.name}>$val');
    }
    for(var val in readerList) {
      valueList.add('<${PermissionType.reader.name}>$val');
    }
    return valueList;
  }
}
