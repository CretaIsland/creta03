// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import '../../lang/creta_studio_lang.dart';
import '../../design_system/creta_color.dart';
import '../../design_system/creta_font.dart';
import 'book_main_page.dart';
import 'studio_constant.dart';
import 'studio_snippet.dart';
import 'studio_variables.dart';

// ignore: must_be_immutable
class StickMenu extends StatefulWidget {
  final void Function(LeftMenuEnum idx) selectFunction;
  //LeftMenuEnum initSelected;
  // StickMenu({super.key, required this.selectFunction}) {
  //   StickMenu.initSelect();
  // }
  const StickMenu({super.key, required this.selectFunction});

  @override
  State<StickMenu> createState() => _StickMenuState();

  // static List<bool> selected = [];

  // static void select(int n) {
  //   int len = CretaStudioLang.menuIconList.length;
  //   for (int i = 0; i < len; i++) {
  //     if (i == n && BookMainPage.selectedStick != LeftMenuEnum.None) {
  //       selected[i] = true;
  //     } else {
  //       selected[i] = false;
  //     }
  //   }
  // }

  // static void initSelect() {
  //   selected.clear();
  //   int len = CretaStudioLang.menuIconList.length;
  //   for (int i = 0; i < len; i++) {
  //     selected.add(false);
  //   }
  // }
}

class _StickMenuState extends State<StickMenu> {
  @override
  void initState() {
    logger.finest('StickMenu::initState');
    super.initState();

    //selected[0] = true;
  }

  @override
  Widget build(BuildContext context) {
    //double height = MediaQuery.of(context).size.height;
    if (StudioVariables.workHeight < 1) {
      return Container();
    }
    logger.fine('StickMenu.build: ${BookMainPage.selectedStick}');
    // if (BookMainPage.selectedStick == LeftMenuEnum.None) {
    //   StickMenu.initSelect();
    // }
    return Container(
      margin: EdgeInsets.only(right: LayoutConst.layoutMargin),
      height: StudioVariables.workHeight,
      width: LayoutConst.menuStickWidth,
      decoration: BoxDecoration(
        color: LayoutConst.menuStickBGColor,
        boxShadow: StudioSnippet.basicShadow(direction: ShadowDirection.rightBottum),
      ),
      padding: EdgeInsets.only(top: 12),
      child: //SingleChildScrollView(
          ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false), // 스크롤바 감추기,
        child: ListView(
          children: CretaStudioLang.menuIconList.map((iconData) {
            int idx = CretaStudioLang.menuIconList.indexOf(iconData);
            return NavBarItem(
              menuType: LeftMenuEnum.values[idx],
              iconData: iconData,
              title: CretaStudioLang.menuStick[idx],
              onTap: () {
                LeftMenuEnum selectedButton = LeftMenuEnum.values[idx];
                if (BookMainPage.selectedStick == selectedButton) {
                  BookMainPage.selectedStick = LeftMenuEnum.None;
                } else {
                  BookMainPage.selectedStick = selectedButton;
                }
                widget.selectFunction(selectedButton);
                logger.fine('onTap ${BookMainPage.selectedStick.toString()}, $idx');
                setState(() {
                  //StickMenu.select(idx);
                });
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class NavBarItem extends StatefulWidget {
  final IconData iconData;
  final String title;
  final Function onTap;
  final LeftMenuEnum menuType;

  const NavBarItem({
    super.key,
    required this.iconData,
    required this.title,
    required this.onTap,
    required this.menuType,
  });

  @override
  State<NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem> with TickerProviderStateMixin {
  bool _hovered = false;
  bool _selected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _selected = (BookMainPage.selectedStick == widget.menuType);
    //logger.fine('build NavBarItem $_selected');
    return GestureDetector(
      onTap: () {
        widget.onTap();
        // setState(() {
        //   logger.fine('setState NavBarItem $_selected');
        //   //_selected = !_selected;
        // });
      },
      child: MouseRegion(
        onEnter: (value) {
          setState(() {
            _hovered = true;
          });
        },
        onExit: (value) {
          setState(() {
            _hovered = false;
          });
        },
        child: Container(
          width: LayoutConst.menuStickWidth,
          decoration: BoxDecoration(
            color: _selected ? CretaColor.primary[100] : Colors.transparent,
            border: _selected ? Border.all(width: 1, color: CretaColor.primary) : null,
          ),
          child: Stack(
            children: [
              SizedBox(
                height: LayoutConst.menuStickIconAreaHeight,
                width: LayoutConst.menuStickWidth,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        widget.iconData,
                        color:
                            _selected ? CretaColor.primary : CretaColor.text[700], //_color.value,
                        size: _hovered
                            ? LayoutConst.menuStickIconSize + 4
                            : LayoutConst.menuStickIconSize,
                      ),
                      Text(
                        widget.title,
                        style: CretaFont.titleSmall.copyWith(
                          color: _selected ? CretaColor.primary : CretaColor.text[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
