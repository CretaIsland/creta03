// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import '../../lang/creta_studio_lang.dart';
import '../../design_system/creta_color.dart';
import '../../design_system/creta_font.dart';
import 'studio_constant.dart';
import 'studio_snippet.dart';
import 'studio_variables.dart';

// ignore: must_be_immutable
class StickMenu extends StatefulWidget {
  final void Function(LeftMenuEnum idx) selectFunction;
  LeftMenuEnum initSelected;
  StickMenu({super.key, required this.selectFunction, required this.initSelected});

  @override
  State<StickMenu> createState() => _StickMenuState();
}

class _StickMenuState extends State<StickMenu> {
  List<bool> selected = [];
  List<IconData> icon = [
    Icons.dynamic_feed_outlined, //MaterialIcons.dynamic_feed,
    Icons.insert_drive_file_outlined, //MaterialIcons.insert_drive_file,
    Icons.space_dashboard_outlined,
    Icons.inventory_2_outlined,
    Icons.image_outlined,
    Icons.slideshow_outlined,
    Icons.title_outlined,
    Icons.pentagon_outlined,
    Icons.interests_outlined,
    Icons.photo_camera_outlined,
    Icons.chat_outlined,
  ];

  void select(int n) {
    for (int i = 0; i < icon.length; i++) {
      if (i == n && widget.initSelected != LeftMenuEnum.None) {
        selected[i] = true;
      } else {
        selected[i] = false;
      }
    }
  }

  @override
  void initState() {
    logger.finest('StickMenu::initState');
    super.initState();
    for (int i = 0; i < icon.length; i++) {
      selected.add(false);
    }
    //selected[0] = true;
  }

  @override
  Widget build(BuildContext context) {
    //double height = MediaQuery.of(context).size.height;
    if (StudioVariables.workHeight < 1) {
      return Container();
    }

    if (widget.initSelected == LeftMenuEnum.None) {
      for (int i = 0; i < selected.length; i++) {
        selected[i] = false;
      }
    }
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
          children: icon.map((e) {
            int idx = icon.indexOf(e);
            return NavBarItem(
              icon: e,
              title: CretaStudioLang.menuStick[idx],
              onTap: () {
                widget.initSelected = LeftMenuEnum.values[idx];
                widget.selectFunction(LeftMenuEnum.values[idx]);
                logger.fine('onTap ${widget.initSelected.toString()}, $idx');
                setState(() {
                  select(idx);
                });
              },
              selected: selected[idx],
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class NavBarItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final Function onTap;
  final bool selected;

  const NavBarItem(
      {super.key,
      required this.icon,
      required this.title,
      required this.onTap,
      required this.selected});

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
    _selected = widget.selected;
    logger.fine('build NavBarItem $_selected');
    return GestureDetector(
      onTap: () {
        widget.onTap();
        setState(() {
          //_selected = !_selected;
        });
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
                        widget.icon,
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
