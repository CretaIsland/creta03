// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/account/account_manager.dart';
import 'package:material_tag_editor/tag_editor.dart';

import '../../../../common/creta_utils.dart';
import '../../../../data_io/book_manager.dart';
import '../../../../design_system/creta_color.dart';
import '../../../../design_system/creta_font.dart';
import '../../../../design_system/menu/creta_drop_down_button.dart';
import '../../../../design_system/menu/creta_popup_menu.dart';
import '../../../../design_system/text_field/creta_text_field.dart';
import '../../../../lang/creta_studio_lang.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/book_model.dart';
import '../../studio_constant.dart';

class BookInfoProperty extends StatefulWidget {
  final BookModel model;
  final Function() parentNotify;
  const BookInfoProperty({super.key, required this.model, required this.parentNotify});

  @override
  State<BookInfoProperty> createState() => _BookInfoPropertyState();
}

class _BookInfoPropertyState extends State<BookInfoProperty> {
  // ignore: unused_field
  BookManager? _bookManager;
  // ignore: unused_field
  //late ScrollController _scrollController;

  final double horizontalPadding = 24;

  List<String> hashTagList = [];

  late TextStyle _titleStyle;
  late TextStyle _dataStyle;

  @override
  void initState() {
    //_scrollController.addListener(_scrollListener);
    logger.finer('_BookInfoPropertyState.initState');
    //_scrollController = ScrollController(initialScrollOffset: 0.0);

    hashTagList = CretaUtils.jsonStringToList(widget.model.hashTag.value);
    logger.finest('hashTagList=$hashTagList');

    _titleStyle = CretaFont.bodySmall.copyWith(color: CretaColor.text[400]!);
    _dataStyle = CretaFont.bodySmall;
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
        _copyWright(),
        ..._info(),
      ],
    );
  }

  List<Widget> _description() {
    return [
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(CretaStudioLang.description, style: CretaFont.titleSmall),
      ),
      CretaTextField.long(
        hintText: '',
        textFieldKey: GlobalKey(),
        onEditComplete: (String value) {
          widget.model.description.set(value);
        },
        value: widget.model.description.value,
      ),
    ];
  }

  List<Widget> _tag() {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 12),
        child: Text(CretaStudioLang.hashTab, style: CretaFont.titleSmall),
      ),
      TagEditor(
        textFieldHeight: 36,
        minTextFieldWidth: LayoutConst.rightMenuWidth - horizontalPadding * 2,
        tagSpacing: 0,
        textStyle: CretaFont.buttonMedium,
        length: hashTagList.length,
        delimiters: const [',', ' '],
        hasAddButton: true,
        resetTextOnSubmitted: true,
        inputDecoration: InputDecoration(
          iconColor: CretaColor.text[200]!,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              width: 1,
              color: CretaColor.text[200]!,
            ),
          ),
          //hintText: '당신의 크레타북에 적절한 검섹어 태그를 붙이세요',
        ),
        inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[/\\]'))],
        onTagChanged: (newValue) {
          setState(() {
            hashTagList.add(newValue);
            String val = CretaUtils.listToString(hashTagList);
            logger.fine('hashTag=$val');
            widget.model.hashTag.set(val);
          });
          logger.fine('onTagChanged $newValue input');
        },
        onSubmitted: (outstandingValue) {
          setState(() {
            hashTagList.add(outstandingValue);
            String val = CretaUtils.listToString(hashTagList);
            logger.fine('hashTag=$val');
            widget.model.hashTag.set(val);
            logger.fine('onSubmitted $outstandingValue input');
          });
        },
        tagBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(
              right: 4,
              bottom: 4,
            ),
            child: _Chip(
              index: index,
              label: hashTagList[index],
              onDeleted: (idx) {
                setState(() {
                  hashTagList.removeAt(index);
                  String val = CretaUtils.listToString(hashTagList);
                  widget.model.hashTag.set(val);
                  logger.fine('onDelete $index');
                });
              },
            ),
          );
        },
      )
    ];
  }

  Widget _copyWright() {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(CretaStudioLang.copyWright, style: CretaFont.titleSmall),
          widget.model.creator == AccountManager.currentLoginUser.email
              ? CretaDropDownButton(height: 36, dropDownMenuItemList: getCopyWrightListItem(null))
              : Text(CretaStudioLang.copyWrightList[widget.model.copyWright.value.index],
                  style: _dataStyle),
        ],
      ),
    );
  }

  List<Widget> _info() {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 18),
        child: Text(CretaStudioLang.infomation, style: CretaFont.titleSmall),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              CretaStudioLang.updateDate,
              style: _titleStyle,
            ),
            Text(widget.model.updateTime.toString(), style: _dataStyle),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              CretaStudioLang.creator,
              style: _titleStyle,
            ),
            Text(widget.model.creator, style: _dataStyle),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(CretaStudioLang.bookType, style: _titleStyle),
            Text(CretaStudioLang.bookTypeList[widget.model.bookType.value.index],
                style: _dataStyle),
          ],
        ),
      )
    ];
  }

  List<CretaMenuItem> getCopyWrightListItem(Function? onChnaged) {
    return [
      CretaMenuItem(
          caption: CretaStudioLang.copyWrightList[1],
          onPressed: () {
            widget.model.copyWright.set(CopyWrightType.free);
          },
          selected: true),
      CretaMenuItem(
          caption: CretaStudioLang.copyWrightList[2],
          onPressed: () {
            widget.model.copyWright.set(CopyWrightType.nonComertialsUseOnly);
          },
          selected: false),
      CretaMenuItem(
          caption: CretaStudioLang.copyWrightList[3],
          onPressed: () {
            widget.model.copyWright.set(CopyWrightType.openSource);
          },
          selected: false),
      CretaMenuItem(
          caption: CretaStudioLang.copyWrightList[4],
          onPressed: () {
            widget.model.copyWright.set(CopyWrightType.needPermition);
          },
          selected: false),
    ];
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.onDeleted,
    required this.index,
  });

  final String label;
  final ValueChanged<int> onDeleted;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Chip(
      clipBehavior: Clip.antiAlias,
      //backgroundColor: Colors.white,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(32),
      //   side: BorderSide(
      //     width: 2,
      //     color: CretaColor.text[700]!,
      //   ),
      // ),
      labelPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      label: Text(
        '#$label',
        style: CretaFont.buttonMedium.copyWith(color: CretaColor.text[700]!),
      ),
      deleteIcon: Icon(
        Icons.close,
        size: 18,
      ),
      onDeleted: () {
        onDeleted(index);
      },
    );
  }
}
