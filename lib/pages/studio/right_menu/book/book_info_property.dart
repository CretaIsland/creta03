// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'package:creta_common/lang/creta_lang.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../../design_system/component/hash_tag_wrapper.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
import '../../../../lang/creta_studio_lang.dart';
import 'package:creta_studio_model/model/book_model.dart';
import '../../book_info_mixin.dart';
import '../../studio_constant.dart';

class BookInfoProperty extends StatefulWidget {
  final BookModel model;
  final Function() parentNotify;
  const BookInfoProperty({super.key, required this.model, required this.parentNotify});

  @override
  State<BookInfoProperty> createState() => _BookInfoPropertyState();
}

class _BookInfoPropertyState extends State<BookInfoProperty> with BookInfoMixin {
  HashTagWrapper hashTagWrapper = HashTagWrapper();
  bool _tagEnabled = true;

  // ignore: unused_field
  //late ScrollController _scrollController;

  @override
  void initState() {
    //_scrollController.addListener(_scrollListener);
    logger.finer('_BookInfoPropertyState.initState');
    //_scrollController = ScrollController(initialScrollOffset: 0.0);

    //hashTagWrapper.hashTagList = CretaCommonUtils.jsonStringToList(widget.model.hashTag.value);
    logger.finest('hashTagList=${hashTagWrapper.hashTagList}');

    titleStyle = CretaFont.bodySmall.copyWith(color: CretaColor.text[400]!);
    dataStyle = CretaFont.bodySmall;

    //BookMainPage.onceBookInfoOpened = true; // 처음한번만 열리도록 한다.

    super.initState();
  }

  @override
  void dispose() {
    //_scrollController.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._description(),
        ..._tag(),
        copyRight(widget.model),
        ..._info(),
      ],
    );
  }

  List<Widget> _description() {
    return description(
        model: widget.model,
        onEditComplete: (value) {
          setState(() {});
        });
  }

  List<Widget> _tag() {
    String val = widget.model.hashTag.value;
    int rest = StudioConst.maxTextLimit - 2 - val.length;
    if (rest <= 0) {
      logger.warning('len1 overflow $rest');
      _tagEnabled = false;
    }

    return hashTagWrapper.hashTag(
      top: 24,
      model: widget.model,
      minTextFieldWidth: LayoutConst.rightMenuWidth - horizontalPadding * 2,
      onTagChanged: (value) {
        setState(() {
          _tagEnabled = (value == null) ? false : true;
        });
      },
      onSubmitted: (value) {
        setState(() {
          _tagEnabled = (value == null) ? false : true;
        });
      },
      onDeleted: (value) {
        setState(() {});
      },
      limit: StudioConst.maxTextLimit - 2,
      enabled: _tagEnabled,
      rest: rest > 0 ? rest - 1 : 0,
    );

    // return [
    //   Padding(
    //     padding: const EdgeInsets.only(top: 24, bottom: 12),
    //     child: Text(CretaStudioLang['hashTab']!, style: CretaFont.titleSmall),
    //   ),
    //   TagEditor(
    //     textFieldHeight: 36,
    //     minTextFieldWidth: LayoutConst.rightMenuWidth - horizontalPadding * 2,
    //     tagSpacing: 0,
    //     textStyle: CretaFont.buttonMedium,
    //     length: hashTagList.length,
    //     delimiters: const [',', ' '],
    //     hasAddButton: true,
    //     resetTextOnSubmitted: true,
    //     inputDecoration: InputDecoration(
    //       iconColor: CretaColor.text[200]!,
    //       border: OutlineInputBorder(
    //         borderRadius: BorderRadius.circular(30),
    //         borderSide: BorderSide(
    //           width: 1,
    //           color: CretaColor.text[200]!,
    //         ),
    //       ),
    //       //hintText: '당신의 크레타북에 적절한 검섹어 태그를 붙이세요',
    //     ),
    //     inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[/\\]'))],
    //     onTagChanged: (newValue) {
    //       setState(() {
    //         hashTagList.add(newValue);
    //         String val = CretaCommonUtils.listToString(hashTagList);
    //         logger.finest('hashTag=$val');
    //         widget.model.hashTag.set(val);
    //       });
    //       logger.finest('onTagChanged $newValue input');
    //     },
    //     onSubmitted: (outstandingValue) {
    //       setState(() {
    //         hashTagList.add(outstandingValue);
    //         String val = CretaCommonUtils.listToString(hashTagList);
    //         logger.finest('hashTag=$val');
    //         widget.model.hashTag.set(val);
    //         logger.finest('onSubmitted $outstandingValue input');
    //       });
    //     },
    //     tagBuilder: (context, index) {
    //       return Padding(
    //         padding: const EdgeInsets.only(
    //           right: 4,
    //           bottom: 4,
    //         ),
    //         child: CretaChip(
    //           index: index,
    //           label: hashTagList[index],
    //           onDeleted: (idx) {
    //             setState(() {
    //               hashTagList.removeAt(index);
    //               String val = CretaCommonUtils.listToString(hashTagList);
    //               widget.model.hashTag.set(val);
    //               logger.finest('onDelete $index');
    //             });
    //           },
    //         ),
    //       );
    //     },
    //   )
    // ];
  }

  // Widget _copyRight() {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 24, bottom: 12),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(CretaStudioLang['copyRight']!, style: CretaFont.titleSmall),
  //         widget.model.creator == AccountManager.currentLoginUser.email
  //             ? CretaDropDownButton(
  //                 selectedColor: CretaColor.text[700]!,
  //                 textStyle: CretaFont.bodyESmall,
  //                 width: 87,
  //                 height: 28,
  //                 itemHeight: 12,
  //                 dropDownMenuItemList: StudioSnippet.getCopyRightListItem(
  //                     defaultValue: widget.model.copyRight.value,
  //                     onChanged: (val) {
  //                       widget.model.copyRight.set(val);
  //                     }))
  //             : Text(CretaStudioLang['copyWrightList']![widget.model.copyRight.value.index],
  //                 style: dataStyle),
  //       ],
  //     ),
  //   );
  // }

  List<Widget> _info() {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 18),
        child: Text(CretaStudioLang['infomation']!, style: CretaFont.titleSmall),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              CretaStudioLang['createDate']!,
              style: titleStyle,
            ),
            Text(widget.model.createTime.toString().substring(0, 19), style: dataStyle),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              CretaStudioLang['updateDate']!,
              style: titleStyle,
            ),
            Text(widget.model.updateTime.toString().substring(0, 19), style: dataStyle),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              CretaStudioLang['creator']!,
              style: titleStyle,
            ),
            Text(widget.model.creator, style: dataStyle),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(CretaStudioLang['bookType']!, style: titleStyle),
            Text(CretaLang['basicBookFilter']![widget.model.bookType.value.index],
                style: dataStyle),
          ],
        ),
      )
    ];
  }
}
