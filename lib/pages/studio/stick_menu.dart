// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import '../../design_system/creta_color.dart';
import '../../design_system/creta_font.dart';
import 'studio_constant.dart';
import '../../creta_strings.dart';
import 'studio_snippet.dart';

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
    double height = MediaQuery.of(context).size.height;
    if (widget.initSelected == LeftMenuEnum.None) {
      for (int i = 0; i < selected.length; i++) {
        selected[i] = false;
      }
    }
    return Container(
        margin: EdgeInsets.only(top: LayoutConst.layoutMargin, right: LayoutConst.layoutMargin),
        height: height,
        width: LayoutConst.menuStickWidth,
        decoration: BoxDecoration(
          color: LayoutConst.menuStickBGColor,
          boxShadow: StudioSnippet.basicShadow(),
        ),
        child: Stack(
          children: [
            Positioned(
                top: 24,
                child: Column(
                  children: icon.map((e) {
                    int idx = icon.indexOf(e);
                    return NavBarItem(
                      icon: e,
                      title: CretaStrings.menuStick[idx],
                      onTap: () {
                        widget.initSelected = LeftMenuEnum.values[idx];
                        widget.selectFunction(LeftMenuEnum.values[idx]);
                        setState(() {
                          select(idx);
                        });
                      },
                      selected: selected[idx],
                    );
                  }).toList(),
                ))
          ],
        ));
  }
}

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
  bool hovered = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: MouseRegion(
        onEnter: (value) {
          setState(() {
            hovered = true;
          });
        },
        onExit: (value) {
          setState(() {
            hovered = false;
          });
        },
        child: Container(
          width: LayoutConst.menuStickWidth,
          color: widget.selected ? LayoutConst.studioBGColor : Colors.transparent,
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
                            hovered ? CretaColor.text[900] : CretaColor.text[700], //_color.value,
                        size: hovered
                            ? LayoutConst.menuStickIconSize + 4
                            : LayoutConst.menuStickIconSize,
                      ),
                      Text(
                        widget.title,
                        style: CretaFont.titleSmall,
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
