// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
//import 'package:flutter_awesome_select/flutter_awesome_select.dart';
//import 'package:roundcheckbox/roundcheckbox.dart';

import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';

class CretaCheckbox extends StatefulWidget {
  final Map<String, bool> valueMap; // value and title map
  final void Function(String name, bool value, Map<String, bool> nvMap) onSelected;
  final double density;
  final bool enable;

  const CretaCheckbox({
    super.key,
    required this.onSelected,
    required this.valueMap,
    this.density = 10,
    this.enable = true,
  });

  @override
  State<CretaCheckbox> createState() => _CretaCheckboxState();
}

class _CretaCheckboxState extends State<CretaCheckbox> {
  TextEditingController controller = TextEditingController();
  late List<bool> hover;
  String? selectedTitle;
  @override
  void initState() {
    super.initState();
    hover = widget.valueMap.keys.map((value) {
      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    int counter = 0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.valueMap.keys.map((title) {
        int idx = counter % widget.valueMap.length;
        counter++;
        return Container(
          color: hover[idx] ? CretaColor.text[200]! : null,
          child: GestureDetector(
            onLongPressDown: (details) {
              if (widget.enable == false) {
                return;
              }
              setState(() {
                if (widget.valueMap[title] != true) {
                  logger.finest('onLongPressDown = $title');
                  selectedTitle = title;
                  widget.valueMap[title] = true;
                } else {
                  widget.valueMap[title] = false;
                  logger.finest('onLongPressDown = null');
                  selectedTitle = null;
                }
                widget.onSelected(title, widget.valueMap[title]!, widget.valueMap);
              });
            },
            child: MouseRegion(
              onExit: (val) {
                setState(() {
                  hover[idx] = false;
                });
              },
              onEnter: (val) {
                setState(() {
                  hover[idx] = true;
                });
              },
              child: Padding(
                padding: EdgeInsets.only(
                    top: widget.density / 2, bottom: widget.density / 2, left: widget.density / 2),
                child: Row(
                  children: [
                    widget.valueMap[title] == true
                        ? Icon(
                            Icons.check_circle_outline_outlined,
                            size: 20,
                            color: CretaColor.primary,
                          )
                        : Icon(
                            Icons.circle_outlined,
                            size: 20,
                          ),
                    SizedBox(width: widget.density),
                    title.isNotEmpty
                        ? Text(
                            title,
                            style: CretaFont.bodySmall.copyWith(
                              color: CretaColor.text[700]!,
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class CretaIconCheckbox extends StatefulWidget {
  final Map<IconData, bool> valueMap; // value and title map
  final void Function(IconData icon, bool value, Map<IconData, bool> nvMap) onSelected;
  final double density;
  final int iconTurns;

  const CretaIconCheckbox({
    super.key,
    required this.onSelected,
    required this.valueMap,
    this.density = 10,
    this.iconTurns = 0,
  });

  @override
  State<CretaIconCheckbox> createState() => _CretaIconCheckboxState();
}

class _CretaIconCheckboxState extends State<CretaIconCheckbox> {
  TextEditingController controller = TextEditingController();
  late List<bool> hover;
  IconData? selectedTitle;
  @override
  void initState() {
    super.initState();
    hover = widget.valueMap.keys.map((value) {
      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    int counter = 0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.valueMap.keys.map((iconData) {
        int idx = counter % widget.valueMap.length;
        counter++;
        return Container(
          color: hover[idx] ? CretaColor.text[200]! : null,
          child: GestureDetector(
            onLongPressDown: (details) {
              setState(() {
                if (widget.valueMap[iconData] != true) {
                  logger.finest('onLongPressDown = $iconData');
                  selectedTitle = iconData;
                  widget.valueMap[iconData] = true;
                } else {
                  widget.valueMap[iconData] = false;
                  logger.finest('onLongPressDown = null');
                  selectedTitle = null;
                }
                widget.onSelected(iconData, widget.valueMap[iconData]!, widget.valueMap);
              });
            },
            child: MouseRegion(
              onExit: (val) {
                setState(() {
                  hover[idx] = false;
                });
              },
              onEnter: (val) {
                setState(() {
                  hover[idx] = true;
                });
              },
              child: Padding(
                padding:
                    EdgeInsets.only(top: widget.density / 2, bottom: widget.density / 2, left: 5),
                child: Row(
                  children: [
                    widget.valueMap[iconData] == true
                        ? Icon(
                            Icons.check_circle_outline_outlined,
                            size: 20,
                            color: CretaColor.primary,
                          )
                        : Icon(
                            Icons.circle_outlined,
                            size: 20,
                          ),
                    SizedBox(width: widget.density),
                    RotatedBox(
                      quarterTurns: widget.iconTurns,
                      child: Icon(
                        iconData,
                        size: 16,
                        color: CretaColor.text[700]!,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}



// // 
// MouseRegion(
//             onExit = (val) {
//               setState(() {
//                 hover = false;
//               });
//             },
//             onEnter = (val) {
//               setState(() {
//                 hover = true;
//               });
//             },
//             child = 

//   return ListTile(
          //     dense: true,
          //     minVerticalPadding: widget.density,
          //     visualDensity: VisualDensity(vertical: widget.density, horizontal: widget.density),
          //     horizontalTitleGap: 0,
          //     contentPadding: EdgeInsets.symmetric(vertical: 0),
          //     leading: Container(
          //       color: CretaColor.text[200],
          //       child: RoundCheckBox(
          //         animationDuration: Duration(milliseconds: 200),
          //         size: 20,
          //         isChecked: value == selectedTitle,
          //         checkedWidget: Icon(
          //           Icons.check_circle_outline_outlined,
          //           size: 20,
          //           color: CretaColor.primary,
          //         ),
          //         uncheckedWidget: Icon(
          //           Icons.circle_outlined,
          //           size: 20,
          //         ),
          //         border: null,
          //         borderColor: Colors.transparent,
          //         checkedColor: Colors.transparent,
          //         onTap: (v) {
          //           setState(() {
          //             if (v!) {
          //               logger.finest('onTapped = $v');
          //               selectedTitle = value;
          //             } else {
          //               logger.finest('onTapped = null');
          //               selectedTitle = null;
          //             }
          //             widget.onSelected(selectedTitle);
          //           });
          //         },
          //       ),
          //     ),
          //     title: Text(
          //       widget.valueMap[value]!,
          //       style: CretaFont.bodySmall.copyWith(
          //         color: CretaColor.text[700]!,
          //       ),
          //     ),
          //   );