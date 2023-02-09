// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/account/account_manager.dart';
import 'package:provider/provider.dart';
import 'package:material_tag_editor/tag_editor.dart';

import '../../../common/creta_utils.dart';
import '../../../data_io/book_manager.dart';
import '../../../design_system/buttons/creta_tab_button.dart';
import '../../../design_system/creta_color.dart';
import '../../../design_system/creta_font.dart';
import '../../../design_system/menu/creta_drop_down_button.dart';
import '../../../design_system/menu/creta_popup_menu.dart';
import '../../../design_system/text_field/creta_text_field.dart';
import '../../../lang/creta_studio_lang.dart';
import '../../../model/app_enums.dart';
import '../../../model/book_model.dart';
import '../studio_constant.dart';
import '../studio_variables.dart';

class RightMenuBook extends StatefulWidget {
  const RightMenuBook({super.key});

  @override
  State<RightMenuBook> createState() => _RightMenuBookState();
}

class _RightMenuBookState extends State<RightMenuBook> {
  // ignore: unused_field
  BookManager? _bookManager;
  // ignore: unused_field
  late ScrollController _scrollController;

  final double verticalPadding = 10;
  final double horizontalPadding = 24;
  final double headerHeight = 36;
  final double menuBarHeight = 36;

  late String _selectedTab;
  BookModel? _model;
  List<String> hashTagList = [];

  late TextStyle _titleStyle;
  late TextStyle _dataStyle;

  @override
  void initState() {
    //_scrollController.addListener(_scrollListener);
    logger.finer('_RightMenuBookState.initState');
    _scrollController = ScrollController(initialScrollOffset: 0.0);
    _selectedTab = CretaStudioLang.bookInfoTabBar.values.first;
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
    return Consumer<BookManager>(builder: (context, bookManager, child) {
      _bookManager = bookManager;
      _model = _bookManager?.onlyOne() as BookModel?;
      if (_model == null) {
        return Center(
          child: Text("No CretaBook Selected", style: CretaFont.titleLarge),
        );
      }
      hashTagList = CretaUtils.jsonStringToList(_model!.hashTag.value);
      return Column(
        children: [
          _menuBar(),
          _pageView(),
        ],
      );
    });
  }

  Widget _menuBar() {
    return Container(
      height: menuBarHeight,
      width: LayoutConst.rightMenuWidth,
      color: CretaColor.text[100]!,
      child: CretaTabButton(
          onEditComplete: (value) {
            setState(() {
              _selectedTab = value;
            });
          },
          defaultString: CretaStudioLang.bookInfoTabBar.values.first,
          buttonLables: CretaStudioLang.bookInfoTabBar.keys.toList(),
          buttonValues: CretaStudioLang.bookInfoTabBar.values.toList()),
    );
  }

  Widget _pageView() {
    return Container(
      padding: EdgeInsets.all(horizontalPadding),
      height: StudioVariables.workHeight,
      width: LayoutConst.rightMenuWidth,
      child: _selectTab(),
    );
  }

  Widget _selectTab() {
    List<String> menu = CretaStudioLang.bookInfoTabBar.values.toList();
    if (_selectedTab == menu[0]) {
      return _bookInfo();
    }
    if (_selectedTab == menu[1]) {
      return _pageSettings();
    }
    if (_selectedTab == menu[2]) {
      return _authority();
    }
    return Container();
  }

  Widget _bookInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(CretaStudioLang.description, style: CretaFont.titleSmall),
        ),
        CretaTextField.long(
          hintText: '',
          textFieldKey: GlobalKey(),
          onEditComplete: (String value) {
            _model!.description.set(value);
          },
          value: _model!.description.value,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 12),
          child: Text(CretaStudioLang.hashTab, style: CretaFont.titleSmall),
        ),
        _tag(),
        Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(CretaStudioLang.copyWright, style: CretaFont.titleSmall),
              _model!.creator == AccountManager.currentLoginUser.email
                  ? CretaDropDownButton(
                      height: 36, dropDownMenuItemList: getCopyWrightListItem(null))
                  : Text(CretaStudioLang.copyWrightList[_model!.copyWright.value.index],
                      style: _dataStyle),
            ],
          ),
        ),
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
              Text(_model!.updateTime.toString(), style: _dataStyle),
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
              Text(_model!.creator, style: _dataStyle),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(CretaStudioLang.bookType, style: _titleStyle),
              Text(CretaStudioLang.bookTypeList[_model!.bookType.value.index], style: _dataStyle),
            ],
          ),
        ),
      ],
    );
  }

  List<CretaMenuItem> getCopyWrightListItem(Function? onChnaged) {
    return [
      CretaMenuItem(
          caption: CretaStudioLang.copyWrightList[1],
          onPressed: () {
            _model!.copyWright.set(CopyWrightType.free);
          },
          selected: true),
      CretaMenuItem(
          caption: CretaStudioLang.copyWrightList[2],
          onPressed: () {
            _model!.copyWright.set(CopyWrightType.nonComertialsUseOnly);
          },
          selected: false),
      CretaMenuItem(
          caption: CretaStudioLang.copyWrightList[3],
          onPressed: () {
            _model!.copyWright.set(CopyWrightType.openSource);
          },
          selected: false),
      CretaMenuItem(
          caption: CretaStudioLang.copyWrightList[4],
          onPressed: () {
            _model!.copyWright.set(CopyWrightType.needPermition);
          },
          selected: false),
    ];
  }

  Widget _tag() {
    return TagEditor(
      textFieldHeight: 32,
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
          borderRadius: BorderRadius.circular(32),
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
          _model!.hashTag.set(val);
        });
        logger.fine('onTagChanged $newValue input');
      },
      onSubmitted: (outstandingValue) {
        setState(() {
          hashTagList.add(outstandingValue);
          String val = CretaUtils.listToString(hashTagList);
          _model!.hashTag.set(val);
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
                _model!.hashTag.set(val);
                logger.fine('onDelete $index');
              });
            },
          ),
        );
      },
    );
  }

  Widget _pageSettings() {
    return Column(
      children: [
        Text(CretaStudioLang.pageSize, style: CretaFont.titleSmall),
      ],
    );
  }

  Widget _authority() {
    return Column(
      children: [
        Text(CretaStudioLang.onLine, style: CretaFont.titleSmall),
      ],
    );
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
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          width: 1,
          color: CretaColor.text[700]!,
        ),
      ),
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
