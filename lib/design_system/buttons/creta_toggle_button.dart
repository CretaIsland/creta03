// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import '../creta_color.dart';

//import 'package:elegant_radio_button_group/elegant_radio_button_group.dart';
//import 'package:radio_grouped_buttons/radio_grouped_buttons.dart';

//import '../creta_color.dart';
//import '../creta_font.dart';

class CretaToggleButton extends StatefulWidget {
  final void Function(bool value) onSelected;
  final bool defaultValue;
  final double width;
  final double height;
  final bool isActive;

  const CretaToggleButton({
    super.key,
    required this.onSelected,
    required this.defaultValue,
    this.width = 54,
    this.height = 28,
    this.isActive = true
  });

  @override
  State<CretaToggleButton> createState() => _CretaRadioButton2State();
}

class _CretaRadioButton2State extends State<CretaToggleButton> {
  bool hover = false;
  bool toggleValue = false;
  int aniTime = 200;
  @override
  void initState() {
    super.initState();
    toggleValue = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    double circleSize = widget.height - 2;
    return Center(
      child: AnimatedContainer(
        alignment: AlignmentDirectional.centerStart,
        duration: Duration(milliseconds: aniTime),
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          //border: Border.all(color: CretaColor.primary, width: 1.0),
          borderRadius: BorderRadius.circular(18.0),
          color: widget.isActive ? toggleValue
              ? hover
                  ? CretaColor.primary[500]!
                  : CretaColor.primary
              : hover
                  ? CretaColor.primary[300]!
                  : CretaColor.primary[200]!
            : CretaColor.text[200]!
        ),
        child: InkWell(
          onHover: (value) {
            setState(() {
              hover = value;
            });
          },
          onTap: () {
            if(widget.isActive) {
              setState(() {
                toggleValue = !toggleValue;
              });
              widget.onSelected.call(toggleValue);
            }
          },
          child: Stack(
            alignment: AlignmentDirectional.centerStart,
            children: [
              AnimatedPositioned(
                  duration: Duration(milliseconds: aniTime),
                  curve: Curves.easeIn,
                  //top: 3.0,
                  left: toggleValue ? widget.width - circleSize : 0.0,
                  right: toggleValue ? 0.0 : widget.width - circleSize,
                  child: AnimatedSwitcher(
                      duration: Duration(milliseconds: aniTime),
                      transitionBuilder: (child, animation) {
                        return RotationTransition(turns: animation, child: child);
                      },
                      child: Icon(Icons.circle,
                          color: Colors.white, size: circleSize, key: UniqueKey()))),
            ],
          ),
        ),
      ),
    );
  }
}
