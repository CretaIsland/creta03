import 'package:creta03/model/contents_model.dart';
import 'package:creta03/pages/studio/left_menu/depot/depot_display.dart';
import 'package:creta03/pages/studio/studio_variables.dart';
import 'package:flutter/material.dart';

import '../../../../design_system/creta_color.dart';

class DepotSelectedClass extends StatefulWidget {
  final Widget child;
  final double width;
  final double height;
  final ContentsModel contents;
  final Function onTapDown;
  const DepotSelectedClass({
    required this.child,
    required this.width,
    required this.height,
    required this.contents,
    required this.onTapDown,
    super.key,
  });

  @override
  State<DepotSelectedClass> createState() => _DepotSelectedClassState();
}

class _DepotSelectedClassState extends State<DepotSelectedClass> {
  bool _isHover = false;

  void _handleHover(bool hover) {
    setState(() {
      _isHover = hover;
    });
  }

  void _handleTap(TapDownDetails details, ContentsModel contentsModel) {
    if (StudioVariables.isCtrlPressed) {
      print("Ctrl key pressed");
      if (DepotDisplayClass.ctrlSelectedSet.contains(contentsModel)) {
        setState(() {
          DepotDisplayClass.ctrlSelectedSet.remove(contentsModel.mid);
        });
        widget.onTapDown();
      } else {
        setState(() {
          DepotDisplayClass.ctrlSelectedSet.add(contentsModel);
        });
        widget.onTapDown();
      }
    } else {
      //setState(() {
      print("Ctrl key released");
      DepotDisplayClass.ctrlSelectedSet = {contentsModel};
      //});
      widget.onTapDown();
      //sflsfks.notify()
    }
  }

  void clearMultiSelected() {
    // setState(() {
    DepotDisplayClass.ctrlSelectedSet.clear();
    // });
    widget.onTapDown();
  }

  @override
  Widget build(BuildContext context) {
    final isSelectedbyCltr = DepotDisplayClass.ctrlSelectedSet.contains(widget.contents);

    return InkWell(
      onHover: _handleHover,
      onSecondaryTap: () {},
      onTapDown: (details) {
        _handleTap(details, widget.contents);
      },
      onDoubleTap: clearMultiSelected,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelectedbyCltr ? CretaColor.primary : CretaColor.text[200]!,
            width: isSelectedbyCltr
                ? 4
                : _isHover
                    ? 4
                    : 1,
          ),
        ),
        child: Center(
          child: widget.child,
        ),
      ),
    );
  }
}
