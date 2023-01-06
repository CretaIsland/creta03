//import 'package:flutter/src/widgets/container.dart';
//import 'package:flutter/src/widgets/framework.dart';

// ignore_for_file: prefer_const_constructors, prefer_final_fields, must_be_immutable, unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import '../../pages/studio/studio_variables.dart';
import '../../lang/creta_studio_lang.dart';
import '../component/snippet.dart';
import '../creta_color.dart';
import '../creta_font.dart';

class CretaScaleButton extends StatefulWidget {
  final double width;
  final double height;
  Color? shadowColor;
  final IconData icon1;
  final IconData icon2;
  final void Function() onPressedMinus;
  final void Function() onPressedPlus;
  final void Function() onPressedAutoScale;
  TextStyle? textStyle;
  final double iconSize;
  Color? clickColor;
  Color? hoverColor;
  Color? fgColor;
  Color? bgColor;
  final bool hasShadow;
  final String? tooltip;

  CretaScaleButton({
    super.key,
    this.width = 200,
    this.height = 36,
    this.shadowColor,
    this.icon1 = Icons.remove_outlined,
    this.icon2 = Icons.add_outlined,
    required this.onPressedMinus,
    required this.onPressedPlus,
    required this.onPressedAutoScale,
    this.textStyle,
    this.iconSize = 20,
    this.clickColor,
    this.hoverColor,
    this.bgColor = Colors.white,
    this.fgColor = CretaColor.text,
    this.hasShadow = true,
    this.tooltip,
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
  List<bool> _isClickedMinus = [false, false];
  List<bool> _isHoverMinus = [false, false];
  List<bool> _isClickedPlus = [false, false];
  List<bool> _isHoverPlus = [false, false];

  String _scaleText = '';

  @override
  void initState() {
    super.initState();
    logger.fine('initState :: scale=${StudioVariables.scale}');
  }

  @override
  Widget build(BuildContext context) {
    _scaleText = "${(StudioVariables.scale * 100).round()}%";
    logger.fine('scaleText=$_scaleText');

    if (widget.tooltip != null) {
      return Snippet.TooltipWrapper(
        tooltip: widget.tooltip!,
        bgColor: widget.bgColor!,
        fgColor: widget.fgColor!,
        child: _fiveButtons(),
      );
    }
    return _fiveButtons();
  }

  Widget _fiveButtons() {
    return Container(
        padding: EdgeInsets.only(left: 4, right: 4),
        decoration: _getDeco(),
        width: widget.width,
        height: widget.height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //_button5xMinus('-50', widget.onPressedMinus),
            _buttonMinus(50, widget.onPressedMinus),
            _buttonMinus(10, widget.onPressedMinus),
            _buttonAuto(),
            _buttonPlus(10, widget.onPressedPlus),
            _buttonPlus(50, widget.onPressedPlus),
          ],
        ));
  }

  Widget _buttonAuto() {
    return TextButton(
      onPressed: () {
        setState(() {
          logger.finest('middle button pressed ${StudioVariables.autoScale}');
          StudioVariables.autoScale = true;
          StudioVariables.scale = StudioVariables.fitScale;
          StudioVariables.showScale = !StudioVariables.showScale;
        });
        widget.onPressedAutoScale.call();
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: ((StudioVariables.showScale == false) ? 4 : 2)),
        child: Text(
          StudioVariables.showScale == false ? CretaStudioLang.autoScale : _scaleText,
          style: widget.textStyle,
        ),
      ),
    );
  }

  Widget _buttonMinus(int scaleVariant, void Function() onPressed) {
    int idx = scaleVariant == 10 ? 0 : 1;
    return Container(
      width: _isClickedMinus[idx] ? widget.iconSize : widget.iconSize * 1.2,
      height: _isClickedMinus[idx] ? widget.iconSize : widget.iconSize * 1.2,
      decoration: BoxDecoration(
          color: _isClickedMinus[idx]
              ? widget.clickColor
              : _isHoverMinus[idx]
                  ? widget.hoverColor
                  : widget.bgColor,
          shape: BoxShape.circle),
      child: GestureDetector(
        onLongPressDown: (details) {
          setState(() {
            _isClickedMinus[idx] = true;
          });
        },
        onTapUp: (details) {
          setState(() {
            _isClickedMinus[idx] = false;
            _minusScale(scaleVariant);
          });
          onPressed.call();
        },
        child: MouseRegion(
          onExit: (val) {
            setState(() {
              _isHoverMinus[idx] = false;
              _isClickedMinus[idx] = false;
            });
          },
          onEnter: (val) {
            setState(() {
              _isHoverMinus[idx] = true;
            });
          },
          child: Center(
              child: Text('-${scaleVariant}',
                  style: CretaFont.bodyESmall.copyWith(color: widget.fgColor))),
        ),
      ),
    );
  }

  Widget _buttonPlus(int scaleVariant, void Function() onPressed) {
    int idx = scaleVariant == 10 ? 0 : 1;
    return Container(
      width: _isClickedPlus[idx] ? widget.iconSize : widget.iconSize * 1.2,
      height: _isClickedPlus[idx] ? widget.iconSize : widget.iconSize * 1.2,
      decoration: BoxDecoration(
          color: _isClickedPlus[idx]
              ? widget.clickColor
              : _isHoverPlus[idx]
                  ? widget.hoverColor
                  : widget.bgColor,
          shape: BoxShape.circle),
      child: GestureDetector(
        onLongPressDown: (details) {
          setState(() {
            _isClickedPlus[idx] = true;
          });
        },
        onTapUp: (details) {
          setState(() {
            _isClickedPlus[idx] = false;
            _plusScale(scaleVariant);
          });
          onPressed.call();
        },
        child: MouseRegion(
          onExit: (val) {
            setState(() {
              _isHoverPlus[idx] = false;
              _isClickedPlus[idx] = false;
            });
          },
          onEnter: (val) {
            setState(() {
              _isHoverPlus[idx] = true;
            });
          },
          child: Center(
              child: Text('+${scaleVariant}',
                  style: CretaFont.bodyESmall.copyWith(color: widget.fgColor))),
        ),
      ),
    );
  }

  void _plusScale(int variant) {
    if (StudioVariables.scale < 20.0) {
      int percent = (StudioVariables.scale * 100).round();
      percent += (variant - (percent % variant));
      StudioVariables.scale = percent / 100.0;
      StudioVariables.autoScale = false;
      StudioVariables.showScale = true;
    }
  }

  void _minusScale(int variant) {
    if (StudioVariables.scale > (variant / 100)) {
      int percent = (StudioVariables.scale * 100).round();
      int remain = (percent % variant);
      if (remain == 0) remain = variant;
      percent -= remain;
      StudioVariables.scale = percent / 100.0;
      StudioVariables.autoScale = false;
      StudioVariables.showScale = true;
    }
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
