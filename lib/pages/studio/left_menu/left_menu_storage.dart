import 'package:creta03/design_system/menu/creta_drop_down_button.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../design_system/creta_color.dart';
import '../../../design_system/creta_font.dart';
import '../../../design_system/menu/creta_popup_menu.dart';
import '../../../design_system/text_field/creta_search_bar.dart';
import '../../../lang/creta_lang.dart';
import '../../../lang/creta_studio_lang.dart';
import '../studio_constant.dart';
import '../studio_variables.dart';

class LeftMenuStorage extends StatefulWidget {
  const LeftMenuStorage({super.key});

  @override
  State<LeftMenuStorage> createState() => _LeftMenuStorageState();
}

class _LeftMenuStorageState extends State<LeftMenuStorage> {
  final double verticalPadding = 18;
  final double horizontalPadding = 24;

  late String _selectedTab;
  late double bodyWidth;

  String searchText = '';

  final List<CretaMenuItem> _dropDownOptions = [
    CretaMenuItem(
      caption: CretaLang.basicBookSortFilter[0], // 최신순
      onPressed: () {},
      selected: true,
    ),
    CretaMenuItem(
      caption: CretaLang.basicBookSortFilter[1], // 이름순
      onPressed: () {},
      selected: false,
    ),
  ];

  @override
  void initState() {
    logger.info('_LeftMenuStorageState.initState');
    _selectedTab = CretaStudioLang.storageMenuTabBar.values.first;
    bodyWidth = LayoutConst.leftMenuWidth - horizontalPadding * 2;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _menuBar(),
        _storageView(),
      ],
    );
  }

  Widget _menuBar() {
    return Container(
        height: LayoutConst.innerMenuBarHeight, // heihgt: 36
        width: LayoutConst.rightMenuWidth, // width: 380
        color: CretaColor.text[100],
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(right: 100.0),
          child: CustomRadioButton(
            radioButtonValue: (value) {
              setState(() {
                _selectedTab = value;
              });
            },
            width: 95,
            autoWidth: true,
            height: 24,
            buttonTextStyle: ButtonTextStyle(
              selectedColor: CretaColor.primary,
              unSelectedColor: CretaColor.text[700]!,
              textStyle: CretaFont.buttonMedium,
            ),
            selectedColor: Colors.white,
            unSelectedColor: CretaColor.text[100]!,
            defaultSelected: _selectedTab,
            buttonLables: CretaStudioLang.storageMenuTabBar.keys.toList(),
            buttonValues: CretaStudioLang.storageMenuTabBar.values.toList(),
            selectedBorderColor: Colors.transparent,
            unSelectedBorderColor: Colors.transparent,
            elevation: 0,
            enableButtonWrap: true,
            enableShape: true,
            shapeRadius: 60,
          ),
        ));
  }

  Widget _storageView() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: horizontalPadding),
      child: Column(
        children: [
          _textQuery(),
          _storageOptions(),
          _storageMenu(),
        ],
      ),
    );
  }

  Widget _textQuery() {
    return CretaSearchBar(
      width: bodyWidth,
      hintText: CretaStudioLang.queryHintText,
      onSearch: (value) {
        searchText = value;
      },
    );
  }

  Widget _storageOptions() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding - 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _storageType(),
          CretaDropDownButton(
            dropDownMenuItemList: _dropDownOptions,
            height: 30.0,
          )
        ],
      ),
    );
  }

  Widget _storageType() {
    return Row(
      children: [
        BTN.line_blue_t_m(
          text: CretaStudioLang.storageTypes[0],
          onPressed: () {},
        ),
        const SizedBox(width: 8.0),
        BTN.line_blue_t_m(
          text: CretaStudioLang.storageTypes[1],
          onPressed: () {},
        ),
        const SizedBox(width: 8.0),
        BTN.line_blue_t_m(
          text: CretaStudioLang.storageTypes[2],
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _storageMenu() {
    List<String> menu = CretaStudioLang.storageMenuTabBar.values.toList();
    if (_selectedTab == menu[0]) {
      return Column(
        children: [
          Container(
            height: StudioVariables.workHeight - 250.0,
            padding: const EdgeInsets.only(top: 10),
          ),
        ],
      );
    }
    if (_selectedTab == menu[1]) {
      return Column(
        children: [
          Container(
            height: StudioVariables.workHeight - 250.0,
            padding: const EdgeInsets.only(top: 10),
          ),
        ],
      );
    }
    if (_selectedTab == menu[2]) {
      return Column(
        children: [
          Container(
            height: StudioVariables.workHeight - 250.0,
            padding: const EdgeInsets.only(top: 10),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}
