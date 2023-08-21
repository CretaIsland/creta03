import 'package:creta03/data_io/depot_manager.dart';
import 'package:creta03/pages/studio/left_menu/depot/depot_selected.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
import '../../../design_system/buttons/creta_tab_button.dart';
import '../../../design_system/creta_color.dart';
import '../../../design_system/creta_font.dart';
import '../../../design_system/text_field/creta_search_bar.dart';
import '../../../lang/creta_studio_lang.dart';
import '../studio_constant.dart';
import '../studio_variables.dart';

enum SelectedContentsType {
  none,
  image,
  video,
}

class LeftMenuStorage extends StatefulWidget {
  const LeftMenuStorage({super.key});

  @override
  State<LeftMenuStorage> createState() => _LeftMenuStorageState();
}

class _LeftMenuStorageState extends State<LeftMenuStorage> {
  final double verticalPadding = 16;
  final double horizontalPadding = 24;

  late String _selectedTab;
  late double bodyWidth;

  String searchText = '';
  // late String _selectedType;
  String _selectedType = '';

  // late String contentsMid;

  late DepotManager depotManager;

  // final List<CretaMenuItem> _dropDownOptions = [
  //   CretaMenuItem(
  //     caption: CretaLang.basicBookSortFilter[0], // 최신순
  //     onPressed: () {},
  //     selected: true,
  //   ),
  //   CretaMenuItem(
  //     caption: CretaLang.basicBookSortFilter[1], // 이름순
  //     onPressed: () {},
  //     selected: false,
  //   ),
  // ];

  @override
  void initState() {
    logger.info('_LeftMenuStorageState.initState');
    super.initState();

    _selectedTab = CretaStudioLang.storageMenuTabBar.values.first;
    bodyWidth = LayoutConst.leftMenuWidth - horizontalPadding * 2;
    depotManager = DepotManager(userEmail: AccountManager.currentLoginUser.email);
    _selectedType = CretaStudioLang.storageTypes.values.first;
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
      child: _storageMenu(),
    );
  }

  Widget _storageMenu() {
    List<String> menu = CretaStudioLang.storageMenuTabBar.values.toList();
    if (_selectedTab == menu[0]) {
      return _myStorageView();
    }
    if (_selectedTab == menu[1]) {
      return Container(
        height: StudioVariables.workHeight - 250.0,
        padding: const EdgeInsets.only(top: 10),
      );
    }
    if (_selectedTab == menu[2]) {
      return Container(
        height: StudioVariables.workHeight - 250.0,
        padding: const EdgeInsets.only(top: 10),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _myStorageView() {
    return Column(
      children: [
        _textQuery(),
        _storageOptions(),
      ],
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
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _storageType(),
              // CretaDropDownButton(
              //   dropDownMenuItemList: _dropDownOptions,
              //   height: 30.0,
              // ),
            ],
          ),
          _selectedStorage(),
        ],
      ),
    );
  }

  Widget _storageType() {
    return CretaTabButton(
      onEditComplete: (value) {
        int idx = 0;
        for (String val in CretaStudioLang.storageTypes.values) {
          if (value == val) {
            setState(() {
              _selectedType = CretaStudioLang.storageTypes.values.toList()[idx];
            });
          }
          idx++;
        }
      },
      width: 55,
      height: 32,
      selectedTextColor: Colors.white,
      unSelectedTextColor: CretaColor.primary,
      selectedColor: CretaColor.primary,
      unSelectedColor: Colors.white,
      unSelectedBorderColor: CretaColor.primary,
      buttonLables: CretaStudioLang.storageTypes.keys.toList(),
      buttonValues: CretaStudioLang.storageTypes.values.toList(),
    );
  }

  Widget _selectedStorage() {
    List<String> type = CretaStudioLang.storageTypes.values.toList();

    if (_selectedType == type[0]) {
      return const DepotSelectedClass(contentsType: ContentsType.none);
    }

    if (_selectedType == type[1]) {
      return const DepotSelectedClass(contentsType: ContentsType.image);
    }

    if (_selectedType == type[2]) {
      return const DepotSelectedClass(contentsType: ContentsType.video);
    }

    if (_selectedType == type[3]) {
      debugPrint('Depot------Added to DB-----');
      depotManager.createNextDepot(
          'contents=63a90f61-2f2b-4a47-aa5f-6144b7c72c37', ContentsType.image);
      depotManager.createNextDepot(
          'contents=1db8ece7-2a0b-442b-be9e-5a68d309f346', ContentsType.image);
      depotManager.createNextDepot(
          'contents=14d4d89a-2ba5-40e7-b78b-976ebed789b3', ContentsType.image);
      depotManager.createNextDepot(
          'contents=12f6eaf1-99da-4de3-b357-1b3a31f08085', ContentsType.image);
      depotManager.createNextDepot(
          'contents=64087921-9cf3-4040-be15-f82469ee15b7', ContentsType.video);
      depotManager.createNextDepot(
          'contents=a12a82cc-a4ad-4873-bc89-e729cd59d156', ContentsType.video);
      depotManager.createNextDepot(
          'contents=f6ec7825-7beb-4671-a732-9691f2d7cd76', ContentsType.video);
    }
    return const SizedBox.shrink();
  }
}
