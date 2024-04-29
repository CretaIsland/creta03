import 'package:creta03/data_io/depot_manager.dart';
import 'package:creta_user_io/data_io/team_manager.dart';
import 'package:creta03/pages/studio/left_menu/depot/depot_display.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
import '../../../design_system/buttons/creta_tab_button.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
import '../../../design_system/menu/creta_drop_down_button.dart';
import '../../../design_system/menu/creta_popup_menu.dart';
import '../../../design_system/text_field/creta_search_bar.dart';
import 'package:creta_common/lang/creta_lang.dart';
import '../../../lang/creta_studio_lang.dart';
import '../studio_constant.dart';

class LeftMenuStorage extends StatefulWidget {
  const LeftMenuStorage({super.key});

  @override
  State<LeftMenuStorage> createState() => _LeftMenuStorageState();
  //static String selectedType = CretaStudioLang['storageTypes']!.values.first;
}

class _LeftMenuStorageState extends State<LeftMenuStorage> {
  final double verticalPadding = 16;
  final double horizontalPadding = 19;

  late String _selectedTab;
  late double bodyWidth;

  String searchText = '';
  static String _selectedType = '';

  Map<String, String> depotMenuTabBar = {};
  String? _myTeamId;
  late DepotManager _depotManager;

  late List<CretaMenuItem> _dropDownOptions;

  String _getCurrentTypes() {
    int index = 0;
    String currentSelectedType = _selectedType;
    List<String> types = [...CretaStudioLang['storageTypes']!.values.toList()];
    for (String ele in types) {
      if (currentSelectedType == ele) {
        return types[index];
      }
      index++;
    }
    return CretaStudioLang['storageTypes']!.values.toString()[0];
  }

  void _initMenuTabName() {
    for (var ele in TeamManager.getTeamList) {
      depotMenuTabBar[ele.name] = ele.mid;
    }
  }

  @override
  void initState() {
    logger.fine('_LeftMenuStorageState.initState');
    super.initState();

    _selectedType = CretaStudioLang['storageTypes']!.values.first;

    depotMenuTabBar[CretaStudioLang['myStorage']] = 'myDepot';

    // _selectedTab = CretaStudioLang['storageMenuTabBar']!.values.first;
    bodyWidth = LayoutConst.leftMenuWidth - horizontalPadding * 2;
    _selectedType = _getCurrentTypes();
    _initMenuTabName();
    _selectedTab = depotMenuTabBar.values.first;
    _depotManager = DepotDisplay.getMyTeamManager(_myTeamId)!;

    _dropDownOptions = [
      CretaMenuItem(
        caption: CretaLang['basicBookSortFilter']![0], // 최신순
        onPressed: () {
          _depotManager.depotOrder = DepotOrderEnum.latest;
          _depotManager.notify();
        },
        selected: true,
      ),
      CretaMenuItem(
        caption: CretaLang['basicBookSortFilter']![1], // 이름순
        onPressed: () {
          _depotManager.depotOrder = DepotOrderEnum.name;
          _depotManager.notify();
        },
        selected: false,
      ),
    ];
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
        child: CustomRadioButton(
          radioButtonValue: (value) {
            setState(() {
              _selectedTab = value;
              List<String> menu = depotMenuTabBar.values.toList();
              for (int i = 0; i < menu.length; i++) {
                if (_selectedTab == menu[i]) {
                  if (i == 0) {
                    _myTeamId = null;
                  } else if (i - 1 < TeamManager.getTeamList.length) {
                    _myTeamId = TeamManager.getTeamList[i - 1].mid;
                  }
                }
              }
            });
            _depotManager = DepotDisplay.getMyTeamManager(_myTeamId)!;
            _depotManager.notify();
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
          buttonLables: depotMenuTabBar.keys.toList(),
          buttonValues: depotMenuTabBar.values.toList(),
          selectedBorderColor: Colors.transparent,
          unSelectedBorderColor: Colors.transparent,
          elevation: 0,
          enableButtonWrap: true,
          enableShape: true,
          shapeRadius: 60,
        ));
  }

  Widget _storageView() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: horizontalPadding),
      //child: _storageMenu(),
      child: _myStorageView(),
    );
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
      hintText: CretaStudioLang['queryHintText']!,
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
              CretaDropDownButton(
                dropDownMenuItemList: _dropDownOptions,
                height: 30.0,
              ),
            ],
          ),
          _selectedStorage(),
        ],
      ),
    );
  }

  Widget _storageType() {
    return CretaTabButton(
      defaultString: _getCurrentTypes(),
      onEditComplete: (value) {
        int idx = 0;
        for (String val in CretaStudioLang['storageTypes']!.values) {
          if (value == val) {
            setState(() {
              _selectedType = CretaStudioLang['storageTypes']!.values.toList()[idx];
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
      buttonLables: CretaStudioLang['storageTypes']!.keys.toList(),
      buttonValues: [...CretaStudioLang['storageTypes']!.values.toList()],
    );
  }

  Widget _selectedStorage() {
    List<String> type = [...CretaStudioLang['storageTypes']!.values.toList()];
    if (_selectedType == type[0]) {
      return DepotDisplay(
        key: const GlobalObjectKey('DepotDisplayClass_0'),
        contentsType: ContentsType.none,
        myTeamId: _myTeamId,
      );
    }
    if (_selectedType == type[1]) {
      return DepotDisplay(
        key: const GlobalObjectKey('DepotDisplayClass_1'),
        contentsType: ContentsType.image,
        myTeamId: _myTeamId,
      );
    }
    if (_selectedType == type[2]) {
      return DepotDisplay(
        key: const GlobalObjectKey('DepotDisplayClass_2'),
        contentsType: ContentsType.video,
        myTeamId: _myTeamId,
      );
    }
    return const SizedBox.shrink();
  }
}
