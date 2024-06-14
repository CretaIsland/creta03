//import 'package:flutter/src/widgets/container.dart';
//import 'package:flutter/src/widgets/framework.dart';

// ignore_for_file: prefer_const_constructors, prefer_final_fields, must_be_immutable, unnecessary_brace_in_string_interps

import 'package:creta03/design_system/text_field/creta_text_field.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import '../../pages/studio/studio_variables.dart';
import '../component/snippet.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';

class CretaScaleButton extends StatefulWidget {
  final double width;
  final double height;
  Color? shadowColor;
  final IconData icon1;
  final IconData icon2;
  final Function onManualScale;
  final Function onAutoScale;
  TextStyle? textStyle;
  final double iconSize;
  Color? clickColor;
  Color? hoverColor;
  Color? fgColor;
  Color? bgColor;
  final bool hasShadow;
  final String? tooltip;
  final Widget? extended;

  static List<double> scalePlot = [
    20,
    40,
    60,
    80,
    100,
    125,
    150,
    200,
    250,
    300,
    400,
    500,
    600,
    800,
    1000
  ];

  CretaScaleButton({
    super.key,
    this.width = 200,
    this.height = 36,
    this.shadowColor,
    this.icon1 = Icons.remove_outlined,
    this.icon2 = Icons.add_outlined,
    required this.onManualScale,
    required this.onAutoScale,
    this.textStyle,
    this.iconSize = 20,
    this.clickColor,
    this.hoverColor,
    this.bgColor = Colors.white,
    this.fgColor = CretaColor.text,
    this.hasShadow = true,
    this.tooltip,
    this.extended,
  }) {
    clickColor ??= CretaColor.text[200]!;
    hoverColor ??= CretaColor.text[100]!;
    shadowColor ??= CretaColor.text[200]!;
    textStyle ??= CretaFont.buttonMedium.copyWith(color: CretaColor.text[700]!);
  }

  @override
  State<CretaScaleButton> createState() => _CretaScaleButtonState();
}

class _CretaScaleButtonState extends State<CretaScaleButton> {
  bool _isClickedMinus = false;
  bool _isHoverMinus = false;
  bool _isClickedPlus = false;
  bool _isHoverPlus = false;
  bool _isClickedAuto = false;
  bool _isHoverAuto = false;

  String _scaleText = '';

  @override
  void initState() {
    super.initState();
    logger.finest('initState :: scale=${StudioVariables.scale}');
  }

  @override
  Widget build(BuildContext context) {
    _scaleText = "${(StudioVariables.scale * 100).round()}";
    logger.finest('scaleText=$_scaleText');
    return Container(
        padding: EdgeInsets.only(left: 4, right: 4),
        decoration: _getDeco(),
        width: widget.width,
        height: widget.height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buttonMinus(),
            _scaleTextField(),
            _buttonPlus(),
            widget.tooltip != null
                ? Snippet.TooltipWrapper(
                    tooltip: widget.tooltip!,
                    bgColor: widget.bgColor!,
                    fgColor: widget.fgColor!,
                    child: _buttonAuto())
                : _buttonAuto(),
            if (widget.extended != null) widget.extended!,
          ],
        ));
  }

  Widget _buttonAuto() {
    return Container(
        width: _isClickedAuto ? widget.iconSize : widget.iconSize * 1.2,
        height: _isClickedAuto ? widget.iconSize : widget.iconSize * 1.2,
        decoration: BoxDecoration(
            color: _isClickedAuto
                ? widget.clickColor
                : _isHoverAuto
                    ? widget.hoverColor
                    : widget.bgColor,
            shape: BoxShape.circle),
        child: GestureDetector(
          onLongPressDown: (details) {
            setState(() {
              _isClickedAuto = true;
            });
          },
          onTapUp: (details) {
            setState(() {
              _isClickedAuto = false;
              StudioVariables.autoScale = true;
              StudioVariables.scale = StudioVariables.fitScale * StudioVariables.pageDisplayRate;
            });
            widget.onAutoScale.call();
          },
          child: MouseRegion(
            onExit: (val) {
              setState(() {
                _isHoverAuto = false;
                _isClickedMinus = false;
              });
            },
            onEnter: (val) {
              setState(() {
                _isHoverAuto = true;
              });
            },
            child: Center(
              child: Icon(Icons.fullscreen_outlined),
            ),
          ),
        ));
  }

  Widget _scaleTextField() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CretaTextField.xshortNumber(
              align: TextAlign.center,
              limit: 3,
              width: 34,
              textFieldKey: GlobalKey(),
              value: _scaleText,
              hintText: _scaleText,
              onEditComplete: (valStr) {
                double max = StudioVariables.scale * 100 > CretaScaleButton.scalePlot.last
                    ? StudioVariables.scale * 100
                    : CretaScaleButton.scalePlot.last;
                double min = CretaScaleButton.scalePlot.first;
                logger.fine('scale = $valStr');
                double val = 100;
                try {
                  val = int.parse(valStr).toDouble();
                } catch (e) {
                  logger.severe('sacele = $valStr');
                }
                if (val < min) {
                  val = min;
                } else if (val > max) {
                  val = max;
                }
                setState(() {
                  logger.finest('onEditComplete button pressed ${StudioVariables.scale}');
                  StudioVariables.autoScale = false;
                  StudioVariables.scale = val / 100.0;
                });
                widget.onManualScale.call();
              }),
          Text('%', style: CretaFont.buttonLarge),
        ]);
  }

  Widget _buttonMinus() {
    return Container(
        width: _isClickedMinus ? widget.iconSize : widget.iconSize * 1.2,
        height: _isClickedMinus ? widget.iconSize : widget.iconSize * 1.2,
        decoration: BoxDecoration(
            color: _isClickedMinus
                ? widget.clickColor
                : _isHoverMinus
                    ? widget.hoverColor
                    : widget.bgColor,
            shape: BoxShape.circle),
        child: GestureDetector(
          onLongPressDown: (details) {
            setState(() {
              _isClickedMinus = true;
            });
          },
          onTapUp: (details) {
            setState(() {
              _isClickedMinus = false;
              _minusScale();
            });
            widget.onManualScale.call();
          },
          child: MouseRegion(
            onExit: (val) {
              setState(() {
                _isHoverMinus = false;
                _isClickedMinus = false;
              });
            },
            onEnter: (val) {
              setState(() {
                _isHoverMinus = true;
              });
            },
            child: Center(
              child: Icon(widget.icon1),
            ),
          ),
        ));
  }

  Widget _buttonPlus() {
    return Container(
        //padding: EdgeInsets.only(left: 6),
        width: _isClickedPlus ? widget.iconSize : widget.iconSize * 1.2,
        height: _isClickedPlus ? widget.iconSize : widget.iconSize * 1.2,
        decoration: BoxDecoration(
            color: _isClickedPlus
                ? widget.clickColor
                : _isHoverPlus
                    ? widget.hoverColor
                    : widget.bgColor,
            shape: BoxShape.circle),
        child: GestureDetector(
          onLongPressDown: (details) {
            setState(() {
              _isClickedPlus = true;
            });
          },
          onTapUp: (details) {
            setState(() {
              _isClickedPlus = false;
              _plusScale();
            });
            widget.onManualScale.call();
          },
          child: MouseRegion(
            onExit: (val) {
              setState(() {
                _isHoverPlus = false;
                _isClickedPlus = false;
              });
            },
            onEnter: (val) {
              setState(() {
                _isHoverPlus = true;
              });
            },
            child: Center(child: Icon(widget.icon2)),
          ),
        ));
  }

  void _plusScale() {
    int index = 0;
    for (double ele in CretaScaleButton.scalePlot) {
      if (ele > StudioVariables.scale * 100) {
        break;
      }
      index++;
    }
    if (index < 0 || index >= CretaScaleButton.scalePlot.length) return;

    if (CretaScaleButton.scalePlot[index] > StudioVariables.scale * 100) {
      StudioVariables.scale = CretaScaleButton.scalePlot[index] / 100;
    }
    StudioVariables.autoScale = false;
  }

  void _minusScale() {
    int index = CretaScaleButton.scalePlot.length - 1;
    for (double ele in CretaScaleButton.scalePlot.reversed) {
      if (ele < StudioVariables.scale * 100) {
        break;
      }
      index--;
    }
    if (index < 0 || index >= CretaScaleButton.scalePlot.length) return;
    if (CretaScaleButton.scalePlot[index] < StudioVariables.scale * 100) {
      StudioVariables.scale = CretaScaleButton.scalePlot[index] / 100;
    }
    StudioVariables.autoScale = false;
  }

  Decoration? _getDeco() {
    return BoxDecoration(
      border: widget.hasShadow ? null : _getBorder(),
      boxShadow: widget.hasShadow ? _getShadow() : null,
      color: widget.bgColor!,
      borderRadius: BorderRadius.all(Radius.circular(36)),
    );
  }

  Border? _getBorder() {
    return Border.all(
      width: 2,
      color: widget.shadowColor!,
    );
  }

  List<BoxShadow>? _getShadow() {
    double spreadRadius = 1;
    return [
      //LTRB
      BoxShadow(
        //color: Colors.grey.shade500,
        color: widget.shadowColor!,
        offset: Offset(-2, -2),
        blurRadius: 8,
        spreadRadius: spreadRadius,
      ),
      BoxShadow(
        //color: Colors.grey.shade500,
        color: widget.shadowColor!,
        offset: Offset(2, -2),
        blurRadius: 8,
        spreadRadius: spreadRadius,
      ),
      BoxShadow(
        //color: Colors.grey.shade500,
        color: widget.shadowColor!,
        offset: Offset(-2, 2),
        blurRadius: 8,
        spreadRadius: spreadRadius,
      ),
      BoxShadow(
        //color: Colors.grey.shade500,
        color: widget.shadowColor!,
        offset: Offset(2, 2),
        blurRadius: 8,
        spreadRadius: spreadRadius,
      ),
    ];
  }
}
