// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import '../creta_color.dart';
import '../creta_font.dart';
import 'creta_popup_menu.dart';

class CretaDropDownButton extends StatefulWidget {
  //final double width;
  final double height;
  final List<CretaMenuItem> dropDownMenuItemList;

  const CretaDropDownButton({
    super.key,
    //required this.width,
    required this.height,
    required this.dropDownMenuItemList,
  });

  @override
  State<CretaDropDownButton> createState() => _CretaDropDownButtonState();
}

class _CretaDropDownButtonState extends State<CretaDropDownButton> {
  final GlobalKey dropDownButtonKey = GlobalKey();
  bool dropDownButtonOpened = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: dropDownButtonKey,
      style: _buttonStyle(),
      onPressed: () {
        setState(() {
          CretaDropDownMenu.showMenu(
              context: context,
              globalKey: dropDownButtonKey,
              popupMenu: widget.dropDownMenuItemList,
              initFunc: () {
                dropDownButtonOpened = true;
              }).then((value) {
            logger.finest('팝업메뉴 닫기');
            setState(() {
              dropDownButtonOpened = false;
            });
          });
          dropDownButtonOpened = !dropDownButtonOpened;
        });
      },
      child: SizedBox(
        //     width: widget.width,
        height: widget.height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _getInitString(),
              style: CretaFont.buttonLarge,
            ),
            //Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(Icons.keyboard_arrow_down),
            ),
          ],
        ),
      ),
    );
  }

  String _getInitString() {
    for (var ele in widget.dropDownMenuItemList) {
      if (ele.selected == true) {
        return ele.caption;
      }
    }
    return "All";
  }

  ButtonStyle _buttonStyle() {
    return ButtonStyle(
      overlayColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) {
            return CretaColor.text[100]!;
          }
          return Colors.white;
        },
      ),
      elevation: MaterialStateProperty.all<double>(0.0),
      shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
      foregroundColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          return CretaColor.text;
          // if (states.contains(MaterialState.hovered) || dropDownButtonOpened) {
          //   return Color.fromARGB(255, 89, 89, 89);
          // }
          // return Color.fromARGB(255, 140, 140, 140);
        },
      ),
      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      shape: MaterialStateProperty.resolveWith<OutlinedBorder?>(
        (Set<MaterialState> states) {
          return RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.height / 2));
          // return RoundedRectangleBorder(
          //     borderRadius: dropDownButtonOpened
          //         ? BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0))
          //         : BorderRadius.circular(8.0),
          //     side: BorderSide(
          //         color: (states.contains(MaterialState.hovered) || dropDownButtonOpened)
          //             ? Color.fromARGB(255, 89, 89, 89)
          //             : Colors.white));
        },
      ),
    );
  }
}

class CretaDropDownMenu {
  static Widget _createDropDownMenu(
    BuildContext context,
    double x,
    double y,
    double width,
    List<CretaMenuItem> menuItem,
  ) {
    return Stack(
      children: [
        Positioned(
          left: x,
          top: y,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: CretaColor.text[300]!),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Wrap(
              direction: Axis.vertical,
              spacing: 5, // <-- Spacing between children
              children: <Widget>[
                ...menuItem
                    .map((item) => SizedBox(
                          width: width - 2,
                          height: 39,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.hovered)) {
                                    return Color.fromARGB(255, 242, 242, 242);
                                  }
                                  return Colors.white;
                                },
                              ),
                              elevation: MaterialStateProperty.all<double>(0.0),
                              shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                              foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                  if (item.selected) {
                                    return Color.fromARGB(255, 0, 122, 255);
                                  } else if (states.contains(MaterialState.hovered)) {
                                    return Color.fromARGB(255, 89, 89, 89);
                                  }
                                  return Color.fromARGB(255, 140, 140, 140);
                                },
                              ),
                              backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.hovered)) {
                                    return Color.fromARGB(255, 242, 242, 242);
                                  }
                                  return Colors.white;
                                },
                              ),
                              shape: null,
                              // MaterialStateProperty.all<RoundedRectangleBorder>(
                              //   RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(18.0),
                              //     side: BorderSide(color: Colors.white),
                              //   ),
                              // ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              item.onPressed();
                            },
                            child: Row(
                              children: [
                                //SizedBox(width:16,),
                                Text(
                                  item.caption,
                                  style: CretaFont.buttonLarge,
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                item.selected
                                    ? Icon(
                                        Icons.check,
                                        size: 24,
                                      )
                                    : Container(),
                                //SizedBox(width:16,),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static Future<void> showMenu(
      {required BuildContext context,
      required GlobalKey globalKey,
      required List<CretaMenuItem> popupMenu,
      Function? initFunc}) async {
    await showDialog(
      context: context,
      barrierDismissible: true, // Dialog를 제외한 다른 화면 터치 x
      barrierColor: null,
      builder: (BuildContext context) {
        if (initFunc != null) initFunc();

        final RenderBox renderBox = globalKey.currentContext!.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);
        final size = renderBox.size;

        double x = position.dx;
        double y = position.dy + size.height - 1;

        return _createDropDownMenu(
          context,
          x,
          y,
          size.width,
          popupMenu,
        );
      },
    );

    return Future.value();
  }
}
