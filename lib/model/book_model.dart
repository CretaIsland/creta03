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
import 'book_mixin.dart';

// ignore: camel_case_types
class BookModel extends CretaModel with BookMixin {
  String creator = '';
  String creatorName = '';
  late UndoAble<String> name;
  late UndoAble<bool> isSilent;
  late UndoAble<bool> isAutoPlay;
  late UndoAble<bool> isAutoThumbnail;
  late UndoAble<bool> isAllowReply;
  late UndoAble<BookType> bookType;
  late UndoAble<int> pageSizeType;
  late UndoAble<CopyRightType> copyRight;
  late UndoAble<String> description;
  late UndoAble<String> filter;
  late UndoAble<bool> isReadOnly;
  late UndoAble<String> thumbnailUrl;
  late UndoAble<String> backgroundMusicFrame;
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
  List<String> channels = [];

  Size realSize = Size(LayoutConst.minPageSize, LayoutConst.minPageSize);

  @override
  List<Object?> get props => [
        ...super.props,
        creator,
        creatorName,
        name,
        isSilent,
        isAutoPlay,
        isAutoThumbnail,
        isAllowReply,
        bookType,
        pageSizeType,
        copyRight,
        description,
        filter,
        isReadOnly,
        thumbnailUrl,
        backgroundMusicFrame,
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
        channels,
        ...super.propsMixin,
      ];
  BookModel(String pmid) : super(pmid: pmid, type: ExModelType.book, parent: '') {
    name = UndoAble<String>('', mid, 'name');
    thumbnailUrl = UndoAble<String>('', mid, 'thumbnailUrl');
    backgroundMusicFrame = UndoAble<String>('', mid, 'backgroundMusicFrame');
    thumbnailType = UndoAble<ContentsType>(ContentsType.none, mid, 'thumbnailType');
    thumbnailAspectRatio = UndoAble<double>(1, mid, 'thumbnailAspectRatio');
    isSilent = UndoAble<bool>(false, mid, 'isSilent');
    isAutoPlay = UndoAble<bool>(true, mid, 'isAutoPlay');
    isAutoThumbnail = UndoAble<bool>(true, mid, 'isAutoThumbnail');
    isAllowReply = UndoAble<bool>(true, mid, 'isAllowReply');
    bookType = UndoAble<BookType>(BookType.presentaion, mid, 'bookType');
    pageSizeType = UndoAble<int>(0, mid, 'pageSizeType');
    copyRight = UndoAble<CopyRightType>(CopyRightType.free, mid, 'copyRight');
    isReadOnly = UndoAble<bool>(false, mid, 'isReadOnly');
    viewCount = 0;
    likeCount = 0;
    owners = [];
    readers = [];
    writers = [];
    shares = [];
    //publishMid = '';
    //sourceMid = '';
    //hashtags = [];
    description = UndoAble<String>("You could do it simple and plain", mid, 'description');
    filter = UndoAble<String>('', mid, 'filter');
    super.initMixin(mid);
    parentMid.set(mid, noUndo: true, save: false);
    setRealTimeKey(mid);
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
    List<String>? channels,
  }) : super(pmid: '', type: ExModelType.book, parent: '') {
    //print('new mid = $mid');
    name = UndoAble<String>(nameStr, mid, 'name');
    thumbnailUrl = UndoAble<String>(imageUrl, mid, 'thumbnailType');
    backgroundMusicFrame = UndoAble<String>('', mid, 'backgroundMusicFrame');
    thumbnailType = UndoAble<ContentsType>(ContentsType.image, mid, 'thumbnailType');
    thumbnailAspectRatio = UndoAble<double>(imageRatio, mid, 'thumbnailAspectRatio');
    isSilent = UndoAble<bool>(false, mid, 'isSilent');
    isAutoPlay = UndoAble<bool>(true, mid, 'isAutoPlay');
    isAutoThumbnail = UndoAble<bool>(true, mid, 'isAutoThumbnail');
    isAllowReply = UndoAble<bool>(true, mid, 'isAllowReply');
    bookType = UndoAble<BookType>(bookTypeVal, mid, 'bookType');
    pageSizeType = UndoAble<int>(0, mid, 'pageSizeType');
    copyRight = UndoAble<CopyRightType>(copyRightVal, mid, 'copyRight');
    isReadOnly = UndoAble<bool>(false, mid, 'isReadOnly');
    viewCount = likeNo;
    likeCount = viewNo;
    description = UndoAble<String>("You could do it simple and plain", mid, 'description');
    filter = UndoAble<String>('', mid, 'filter');
    owners = [...ownerList];
    readers = [...readerList];
    writers = [...writerList];
    //shares = [...ownerList, ...writerList, ...readerList];
    shares = _getShares(ownerList, writerList, readerList);
    if (publishMid != null) this.publishMid = publishMid;
    if (sourceMid != null) this.sourceMid = sourceMid;
    if (hashtags != null) this.hashtags = [...hashtags];
    if (channels != null) this.channels = [...channels];
    if (desc != null) {
      description = UndoAble<String>(desc, mid, 'description');
    }
    super.makeSampleMixin(mid);
    parentMid.set(mid, noUndo: true, save: false);
    setRealTimeKey(mid);
    logger.finest('owners=${owners.toString()}');
  }
  @override
  void copyFrom(AbsExModel src, {String? newMid, String? pMid}) {
    super.copyFrom(src, newMid: newMid, pMid: pMid);
    BookModel srcBook = src as BookModel;
    creator = src.creator;
    creatorName = src.creatorName;
    name = UndoAble<String>(srcBook.name.value, mid, 'name');
    thumbnailUrl = UndoAble<String>(srcBook.thumbnailUrl.value, mid, 'thumbnailUrl');
    backgroundMusicFrame =
        UndoAble<String>(srcBook.backgroundMusicFrame.value, mid, 'backgroundMusicFrame');
    thumbnailType = UndoAble<ContentsType>(srcBook.thumbnailType.value, mid, 'thumbnailType');
    thumbnailAspectRatio =
        UndoAble<double>(srcBook.thumbnailAspectRatio.value, mid, 'thumbnailAspectRatio');
    isSilent = UndoAble<bool>(srcBook.isSilent.value, mid, 'isSilent');
    isAutoPlay = UndoAble<bool>(srcBook.isAutoPlay.value, mid, 'isAutoPlay');
    isAutoThumbnail = UndoAble<bool>(srcBook.isAutoThumbnail.value, mid, 'isAutoThumbnail');
    isAllowReply = UndoAble<bool>(srcBook.isAllowReply.value, mid, 'isAllowReply');
    bookType = UndoAble<BookType>(srcBook.bookType.value, mid, 'bookType');
    pageSizeType = UndoAble<int>(srcBook.pageSizeType.value, mid, 'pageSizeType');
    copyRight = UndoAble<CopyRightType>(srcBook.copyRight.value, mid, 'copyRight');
    isReadOnly = UndoAble<bool>(srcBook.isReadOnly.value, mid, 'isReadOnly');
    description = UndoAble<String>(srcBook.description.value, mid, 'description');
    filter = UndoAble<String>(srcBook.filter.value, mid, 'filter');
    viewCount = srcBook.viewCount;
    likeCount = srcBook.likeCount;
    owners = [...srcBook.owners];
    readers = [...srcBook.readers];
    writers = [...srcBook.writers];
    //shares = [...srcBook.owners, ...srcBook.writers, ...srcBook.readers];
    shares = _getShares(srcBook.owners, srcBook.writers, srcBook.readers);
    publishMid = srcBook.publishMid;
    sourceMid = srcBook.sourceMid;
    hashtags = [...srcBook.hashtags];
    channels = [...srcBook.channels];

    super.copyFromMixin(mid, srcBook);
    logger.finest('BookCopied($mid)');
  }

  @override
  void updateFrom(AbsExModel src) {
    super.updateFrom(src);
    BookModel srcBook = src as BookModel;
    creator = src.creator;
    creatorName = src.creatorName;
    name.init(srcBook.name.value);
    thumbnailUrl.init(srcBook.thumbnailUrl.value);
    backgroundMusicFrame.init(srcBook.backgroundMusicFrame.value);
    thumbnailType.init(srcBook.thumbnailType.value);
    thumbnailAspectRatio.init(srcBook.thumbnailAspectRatio.value);
    isSilent.init(srcBook.isSilent.value);
    isAutoPlay.init(srcBook.isAutoPlay.value);
    isAutoThumbnail.init(srcBook.isAutoThumbnail.value);
    isAllowReply.init(srcBook.isAllowReply.value);
    bookType.init(srcBook.bookType.value);
    pageSizeType.init(srcBook.pageSizeType.value);
    copyRight.init(srcBook.copyRight.value);
    isReadOnly.init(srcBook.isReadOnly.value);
    description.init(srcBook.description.value);
    filter.init(srcBook.filter.value);
    viewCount = srcBook.viewCount;
    likeCount = srcBook.likeCount;
    owners = [...srcBook.owners];
    readers = [...srcBook.readers];
    writers = [...srcBook.writers];
    //shares = [...srcBook.owners, ...srcBook.writers, ...srcBook.readers];
    shares = _getShares(srcBook.owners, srcBook.writers, srcBook.readers);
    publishMid = srcBook.publishMid;
    sourceMid = srcBook.sourceMid;
    hashtags = [...srcBook.hashtags];
    channels = [...srcBook.channels];

    super.updateFromMixin(srcBook);
    logger.finest('BookCopied($mid)');
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);
    name.setDD(map["name"] ?? '', save: false, noUndo: true);
    creator = map["creator"] ?? '';
    creatorName = map["creatorName"] ?? '';
    isSilent.setDD(map["isSilent"] ?? false, save: false, noUndo: true);
    isAutoPlay.setDD(map["isAutoPlay"] ?? true, save: false, noUndo: true);
    isAutoThumbnail.setDD(map["isAutoThumbnail"] ?? true, save: false, noUndo: true);
    isAllowReply.setDD(map["isAllowReply"] ?? true, save: false, noUndo: true);
    isReadOnly.setDD(map["isReadOnly"] ?? (map["readOnly"] ?? false), save: false, noUndo: true);
    bookType.setDD(BookType.fromInt(map["bookType"] ?? 0), save: false, noUndo: true);
    pageSizeType.setDD(map["pageSizeType"] ?? 0, save: false, noUndo: true);
    copyRight.setDD(CopyRightType.fromInt(map["copyRight"] ?? 1), save: false, noUndo: true);
    description.setDD(map["description"] ?? '', save: false, noUndo: true);
    filter.setDD(map["filter"] ?? '', save: false, noUndo: true);
    thumbnailUrl.setDD(map["thumbnailUrl"] ?? '', save: false, noUndo: true);
    backgroundMusicFrame.setDD(map["backgroundMusicFrame"] ?? '', save: false, noUndo: true);
    thumbnailType.setDD(ContentsType.fromInt(map["thumbnailType"] ?? 1), save: false, noUndo: true);
    thumbnailAspectRatio.setDD((map["thumbnailAspectRatio"] ?? 1), save: false, noUndo: true);
    owners = CretaUtils.jsonStringToList(map["owners"] ?? '');
    if (owners.isEmpty) {
      owners.add(creator);
    }
    readers = CretaUtils.jsonStringToList((map["readers"] ?? ''));
    writers = CretaUtils.jsonStringToList((map["writers"] ?? ''));
    shares = _getShares(owners, writers, readers);
    publishMid = map["publishMid"] ?? '';
    sourceMid = map["sourceMid"] ?? '';
    //hashtags = map["hashtags"] ?? [];
    hashtags = CretaUtils.dynamicListToStringList(map["hashtags"]);
    channels = CretaUtils.dynamicListToStringList(map["channels"]);
    // if (channels.isEmpty) {
    //   channels.add(creator);
    // }
    viewCount = (map["viewCount"] ?? 0);
    likeCount = (map["likeCount"] ?? 0);

    super.fromMapMixin(map);
    setRealTimeKey(mid);
  }

  @override
  Map<String, dynamic> toMap() {
    //shares = [...owners, ...writers, ...readers];
    shares = _getShares(owners, writers, readers);
    if (owners.isEmpty) {
      owners.add(creator);
    }
    // if (channels.isEmpty) {
    //   channels.add(creator);
    // }
    return super.toMap()
      ..addEntries({
        "name": name.value,
        "creator": creator,
        "creatorName": creatorName,
        "isSilent": isSilent.value,
        "isAutoPlay": isAutoPlay.value,
        "isAutoThumbnail": isAutoThumbnail.value,
        "isAllowReply": isAllowReply.value,
        "isReadOnly": isReadOnly.value,
        "bookType": bookType.value.index,
        "pageSizeType": pageSizeType.value,
        "copyRight": copyRight.value.index,
        "description": description.value,
        "filter": filter.value,
        "thumbnailUrl": thumbnailUrl.value,
        "backgroundMusicFrame": backgroundMusicFrame.value,
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
        "channels": channels,
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

  List<String> _getShares(
      List<String> ownerList, List<String> writerList, List<String> readerList) {
    List<String> valueList = [];
    for (var val in ownerList) {
      String name = '<${PermissionType.owner.name}>$val';
      if (valueList.contains(name) == true) continue;
      valueList.add(name);
    }
    for (var val in writerList) {
      String name = '<${PermissionType.writer.name}>$val';
      if (valueList.contains(name) == true) continue;
      valueList.add(name);
    }
    for (var val in readerList) {
      String name = '<${PermissionType.reader.name}>$val';
      if (valueList.contains(name) == true) continue;
      valueList.add(name);
    }
    return valueList;
  }

  Map<String, PermissionType> getSharesAsMap() {
    Map<String, PermissionType> retval = {};
    for (var val in owners) {
      retval[val] = PermissionType.owner;
    }
    for (var val in writers) {
      retval[val] = PermissionType.writer;
    }
    for (var val in readers) {
      retval[val] = PermissionType.reader;
    }
    return retval;
  }
}
