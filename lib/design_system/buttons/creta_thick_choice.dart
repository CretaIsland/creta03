// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
//import 'package:flutter_awesome_select/flutter_awesome_select.dart';
//import 'package:roundcheckbox/roundcheckbox.dart';

import 'package:creta_common/common/creta_color.dart';

class CretaThickChoice extends StatefulWidget {
  final List<int> valueList; // value and title map
  final void Function(int value) onSelected;
  final double density;
  final int defaultValue;

  const CretaThickChoice({
    super.key,
    required this.onSelected,
    required this.valueList,
    required this.defaultValue,
    this.density = 10,
  });

  @override
  State<CretaThickChoice> createState() => _CretaThickChoiceState();
}

class _CretaThickChoiceState extends State<CretaThickChoice> {
  TextEditingController controller = TextEditingController();
  late List<bool> hover;
  int? selectedValue;
  @override
  void initState() {
    super.initState();
    hover = widget.valueList.map((value) {
      return false;
    }).toList();
    selectedValue = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    int counter = 0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.valueList.map((value) {
        int idx = counter % widget.valueList.length;
        counter++;
        return GestureDetector(
          onLongPressDown: (details) {
            setState(() {
              logger.finest('onLongPressDown = $value');
              selectedValue = value;
              widget.onSelected(selectedValue!);
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
              child: SizedBox(
                width: 36,
                height: 26,
                child: Container(
                  decoration: BoxDecoration(
                    color: selectedValue == value
                        ? CretaColor.primary[200]!
                        : hover[idx]
                            ? CretaColor.primary[100]!
                            : Colors.white,
                    borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
                  ),
                  child: Center(
                    child: Container(
                      color: CretaColor.text[900]!,
                      width: 12,
                      height: value.toDouble(),
                    ),
                  ),
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




// // ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, avoid_print

// import 'package:flutter/material.dart';

// import 'package:creta_common/common/creta_color.dart';

// class CretaThickChoice extends StatefulWidget {
//   final double thickness;
//   final Function onPressed;

//   CretaThickChoice({
//     required this.onPressed,
//     required this.thickness,
//     Key? key,
//   }) : super(key: key);
//   @override
//   State<CretaThickChoice> createState() => _CretaThickChoiceState();
// }

// class _CretaThickChoiceState extends State<CretaThickChoice> {
//   bool hover = false;
//   bool clicked = false;
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTapDown: (details) {
//         setState(() {
//           clicked = true;
//         });
//       },
//       onTapUp: (details) {
//         setState(() {
//           clicked = false;
//         });
//         widget.onPressed.call();
//       },
//       child: MouseRegion(
//         onExit: (val) {
//           setState(() {
//             print('hover is false');
//             hover = false;
//             clicked = false;
//           });
//         },
//         onEnter: (val) {
//           setState(() {
//             print('hover is true');
//             hover = true;
//           });
//         },
//         child: SizedBox(
//           width: 36,
//           height: 26,
//           child: Container(
//             decoration: BoxDecoration(
//               color:
//                   hover ? (clicked ? CretaColor.primary : CretaColor.primary[200]!) : Colors.white,
//               borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
//             ),
//             child: Center(
//               child: Container(
//                 color: CretaColor.text[900]!,
//                 width: 12,
//                 height: widget.thickness,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
