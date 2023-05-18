// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
// import 'package:hycop/common/util/logger.dart';

class CretaMenuItem {
  final String caption;
  final IconData? iconData;
  final double? iconSize;
  Function? onPressed;
  String? referencedAttr;
  bool? isDescending;
  bool selected;
  String? linkUrl;
  final bool isIconText;
  final String fontFamily;
  final FontWeight? fontWeight;

  CretaMenuItem({
    required this.caption,
    required this.onPressed,
    this.selected = false,
    this.iconData,
    this.iconSize,
    this.linkUrl,
    this.referencedAttr,
    this.isDescending,
    this.isIconText = false,
    this.fontFamily = 'Pretendard',
    this.fontWeight,
  });

  CretaMenuItem.clone(CretaMenuItem src)
      : this(
  caption: src.caption,
  iconData: src.iconData,
  iconSize: src.iconSize,
  onPressed: src.onPressed,
  referencedAttr: src.referencedAttr,
  isDescending: src.isDescending,
  selected: src.selected,
  linkUrl: src.linkUrl,
  isIconText: src.isIconText,
  fontFamily: src.fontFamily,
  fontWeight: src.fontWeight,
  );
}

class CretaPopupMenu {
  static Widget _createPopupMenu(
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
              // shadow
              borderRadius: BorderRadius.circular(16.4),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  //offset: Offset(0.0, 20.0),
                  spreadRadius: -10.0,
                  blurRadius: 20.0,
                )
              ],
            ),
            padding: EdgeInsets.all(8),
            child: Wrap(
              direction: Axis.vertical,
              spacing: 4, // <-- Spacing between children
              children: <Widget>[
                ...menuItem
                    .map((item) => SizedBox(
                          width: width,
                          height: 32,
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
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.grey[700]!),
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.white))),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              item.onPressed?.call();
                            },
                            child: Text(
                              item.caption,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: item.fontWeight,
                                fontFamily: item.fontFamily,
                              ),
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

        double x = position.dx + size.width - 70;
        double y = position.dy + 40;

        return _createPopupMenu(
          context,
          x,
          y,
          114,
          popupMenu,
        );
      },
    );

    return Future.value();
  }
}
