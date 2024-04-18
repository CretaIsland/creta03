// ignore_for_file: library_private_types_in_public_api

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import 'package:creta_common/common/creta_color.dart';

// ignore_for_file: prefer_const_constructors

import 'package:hycop/common/util/logger.dart';

class CretaWidgetDropDown extends StatefulWidget {
  final List<Widget> items;
  final int defaultValue;
  final void Function(int value) onSelected;
  final double width;
  final double height;

  const CretaWidgetDropDown({
    super.key,
    required this.items,
    required this.defaultValue,
    required this.onSelected,
    this.width = 93,
    this.height = 30,
  });

  @override
  State<CretaWidgetDropDown> createState() => _CretaWidgetDropDownState();
}

class _CretaWidgetDropDownState extends State<CretaWidgetDropDown> {
  bool hover = false;
  bool clicked = false;
  int? selectedItem;

  @override
  void initState() {
    selectedItem = widget.defaultValue;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CretaWidgetDropDown oldWidget) {
    if (widget.defaultValue != oldWidget.defaultValue) {
      //print('selected item changed');
      selectedItem = widget.defaultValue;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onExit: (val) {
        setState(() {
          logger.finest('hover is false');
          hover = false;
          //clicked = false;
        });
      },
      onEnter: (val) {
        setState(() {
          logger.finest('hover is true');
          hover = true;
        });
      },
      child: GestureDetector(
        onLongPressDown: (details) {
          setState(() {
            clicked = true;
          });
        },
        //width: widget.width,
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButton2(
              onMenuStateChange: (val) {
                setState(() {
                  if (val == false) {
                    clicked = false;
                  }
                });
              },
              alignment: AlignmentDirectional.center,
              value: selectedItem,
              isExpanded: true,
              items: List.generate(widget.items.length, (int index) {
                return DropdownMenuItem(
                  value: index,
                  child: widget.items[index],
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  clicked = false;
                  selectedItem = value;
                  widget.onSelected(selectedItem!);
                });
              },
              icon: Icon(
                Icons.arrow_drop_down_outlined,
              ),
              iconSize: 24,
              iconEnabledColor: CretaColor.text[700]!,
              buttonHeight: widget.height,
              buttonWidth: widget.width,
              buttonPadding: const EdgeInsets.only(left: 10, right: 10),
              buttonDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: clicked
                    ? Border.all(width: 1, color: CretaColor.primary)
                    : hover
                        ? Border.all(width: 1, color: CretaColor.text[200]!)
                        : null,
                color: Colors.white,
              ),
              buttonElevation: 0,
              itemHeight: widget.height,
              itemPadding: const EdgeInsets.only(left: 10, right: 10),
              dropdownWidth: widget.width,
              dropdownMaxHeight: widget.height * (widget.items.length + 2),
              dropdownPadding: null,
              dropdownElevation: 0,
              dropdownDecoration: BoxDecoration(
                border: Border.all(width: 1, color: CretaColor.text[300]!),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              offset: Offset(0, -8),
            ),
          ),
        ),
      ),
    );
  }
}


// class CretaWidgetDropDown extends StatefulWidget {
//   final List<Widget> widgetList;
//   final void Function(int?) onChanged;
//   final double width;
//   final double height;
//   final int defaultValue;
//   const CretaWidgetDropDown(
//       {super.key,
//       required this.defaultValue,
//       required this.width,
//       required this.height,
//       required this.widgetList,
//       required this.onChanged});

//   @override
//   _CretaWidgetDropDownState createState() => _CretaWidgetDropDownState();
// }

// class _CretaWidgetDropDownState extends State<CretaWidgetDropDown> {
//  bool hover = false;
//   bool clicked = false;
//   String? selectedItem;
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonHideUnderline(
//       child: DropdownButton2(
//          icon: const Icon(
//                 Icons.arrow_drop_down_outlined,
//               ),
//               iconSize: 12,
//               iconEnabledColor: CretaColor.text[700]!,
//               buttonHeight: widget.height,
//               buttonWidth: widget.width,
//               buttonPadding: const EdgeInsets.only(left: 10, right: 10),
//               buttonDecoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15),
//                 border: clicked
//                     ? Border.all(width: 1, color: CretaColor.primary)
//                     : hover
//                         ? Border.all(width: 1, color: CretaColor.text[200]!)
//                         : null,
//                 color: Colors.white,
//               ),
//               buttonElevation: 0,
//               itemHeight: widget.height,
//               itemPadding: const EdgeInsets.only(left: 10, right: 10),
//               dropdownWidth: widget.width,
//               dropdownMaxHeight: widget.height * (widget.items.length + 2),
//               dropdownPadding: null,
//               dropdownElevation: 0,
//               dropdownDecoration: BoxDecoration(
//                 border: Border.all(width: 1, color: CretaColor.text[300]!),
//                 borderRadius: BorderRadius.circular(8),
//                 color: Colors.white,
//               ),
//               offset: Offset(0, -8),
//         itemHeight: 32,
//         buttonElevation: 0,
//         dropdownElevation: 0,
//         buttonWidth: widget.width,
//         buttonHeight: widget.height,
//         dropdownWidth: widget.width - 24,
//         value: widget.defaultValue,
//         items: List.generate(widget.widgetList.length, (int index) {
//           return DropdownMenuItem(
//             value: index,
//             child: widget.widgetList[index],
//           );
//         }),
//         onChanged: widget.onChanged,
//         //),
//       ),
//     );
//   }
// }
