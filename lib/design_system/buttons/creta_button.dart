// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, avoid_print

import 'package:creta_common/common/creta_color.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import '../component/snippet.dart';

enum CretaButtonType {
  iconOnly,
  textOnly,
  iconText,
  textIcon,
  imageText,
  child,
  iconTextFix,
}

enum CretaButtonDeco {
  fill,
  line,
  opacity,
  shadow,
}

enum CretaButtonColor {
  blue,
  blueGray,
  blueAndWhite,
  blueAndWhiteTitle,
  sky,
  skyTitle,
  gray,
  gray2,
  gray100,
  gray100light,
  gray100blue,
  gray200,
  white,
  white300,
  whiteShadow,
  purple,
  skypurple,
  black,
  red,
  redAndWhiteTitle,
  transparent,
  secondary,
  primary,
  forTree,
  channelTabSelected,
  channelTabUnselected,
}

class CretaButton extends StatefulWidget {
  final CretaButtonType buttonType;
  final CretaButtonColor buttonColor;
  final CretaButtonDeco decoType;
  final Widget? text;
  final Icon? icon;
  final Function onPressed;
  final double? width;
  final double? height;
  final Widget? child;
  final bool isSelectedWidget;

  final String? textString;
  final TextStyle? textStyle;

  final IconData? iconData;
  final double? iconSize;

  final Widget? image;

  Color? bgColor;
  Color? hoverColor;
  Color? clickColor;
  Color? selectColor;

  Color? tooltipFg;
  Color? tooltipBg;

  Color? fgColor;
  Color? fgHoverColor;
  Color? fgClickColor;

  final String? tooltip;
  final bool hasShadow;
  final bool showClickableCursor;
  final bool alwaysShowIcon;
  //final double sidePaddingSize;
  final CretaButtonSidePadding? sidePadding;

  final void Function(bool)? onHover;
  final bool noHoverEffect; // 호버 진입 이벤트를 없앤다.

  final bool useTapUp;

  CretaButton({
    required this.buttonType,
    required this.onPressed,
    this.buttonColor = CretaButtonColor.blue,
    this.decoType = CretaButtonDeco.fill,
    this.text,
    this.textString,
    this.textStyle,
    this.icon,
    this.iconData,
    this.iconSize,
    this.image,
    this.child,
    this.width,
    this.height,
    this.tooltip,
    this.isSelectedWidget = false,
    this.hasShadow = true,
    this.tooltipFg,
    this.tooltipBg,
    this.showClickableCursor = true,
    this.alwaysShowIcon = false,
    //this.sidePaddingSize = 0,
    this.sidePadding,
    this.onHover,
    this.useTapUp = false,
    this.noHoverEffect = false,
    Key? key,
  }) : super(key: key) {
    _setColor();
  }

  @override
  State<CretaButton> createState() => _CretaButtonState();

  void _setColor() {
    switch (buttonColor) {
      case CretaButtonColor.white:
        bgColor = Colors.white;
        hoverColor = CretaColor.text[100]!;
        clickColor = CretaColor.text[200]!;
        selectColor = CretaColor.text[700]!;
        break;
      case CretaButtonColor.white300:
        bgColor = Colors.white;
        hoverColor = CretaColor.text[300]!;
        clickColor = CretaColor.text[400]!;
        break;
      case CretaButtonColor.whiteShadow:
        bgColor = Colors.white;
        hoverColor = CretaColor.text[200]!;
        clickColor = Colors.white;
        fgColor = CretaColor.text[700];
        fgHoverColor = CretaColor.text[700];
        fgClickColor = CretaColor.text[200];
        break;
      case CretaButtonColor.gray100:
        bgColor = CretaColor.text[100]!;
        hoverColor = CretaColor.text[200]!;
        clickColor = CretaColor.text[300]!;
        break;
      case CretaButtonColor.gray100light:
        bgColor = CretaColor.text[100]!;
        hoverColor = CretaColor.text[100]!;
        clickColor = CretaColor.text[200]!;
        fgColor = CretaColor.text[400];
        break;
      case CretaButtonColor.gray100blue:
        bgColor = CretaColor.text[100]!;
        hoverColor = CretaColor.text[100]!;
        clickColor = CretaColor.text[200]!;
        fgColor = CretaColor.primary[400];
        break;
      case CretaButtonColor.gray200:
        bgColor = CretaColor.text[200]!;
        hoverColor = CretaColor.text[300]!;
        clickColor = CretaColor.text[400]!;
        break;
      case CretaButtonColor.gray:
        bgColor = CretaColor.text[900]!.withOpacity(0.25);
        hoverColor = CretaColor.text[900]!.withOpacity(0.40);
        clickColor = CretaColor.text[900]!.withOpacity(0.60);
        break;
      case CretaButtonColor.gray2:
        bgColor = CretaColor.text[200]!.withOpacity(0.25);
        hoverColor = CretaColor.text[500]!.withOpacity(0.25);
        clickColor = CretaColor.text[900]!.withOpacity(0.25);
        break;
      case CretaButtonColor.sky:
        bgColor = Colors.white;
        hoverColor = CretaColor.primary[200]!;
        clickColor = CretaColor.primary[300]!;
        selectColor = CretaColor.primary[400]!;
        break;
      case CretaButtonColor.skyTitle:
        bgColor = CretaColor.primary;
        hoverColor = CretaColor.primary[500]!;
        clickColor = CretaColor.primary[600]!;
        selectColor = CretaColor.primary;
        break;
      case CretaButtonColor.purple:
        bgColor = CretaColor.secondary;
        hoverColor = CretaColor.secondary[500]!;
        clickColor = CretaColor.secondary[600]!;
        break;
      case CretaButtonColor.skypurple:
        bgColor = Colors.white;
        hoverColor = CretaColor.secondary[200]!;
        clickColor = CretaColor.secondary[300]!;
        selectColor = CretaColor.secondary[400]!;
        // bgColor = Colors.transparent;
        // hoverColor = Colors.transparent;
        // clickColor = Colors.transparent;
        // fgColor = Colors.white;
        // fgHoverColor = CretaColor.secondary[200]!;
        // fgClickColor = CretaColor.secondary[300]!;
        break;
      case CretaButtonColor.black:
        bgColor = CretaColor.text[700]!;
        hoverColor = CretaColor.text[600]!;
        clickColor = CretaColor.text[500]!;
        break;
      case CretaButtonColor.red:
        // bgColor = CretaColor.red;
        // hoverColor = CretaColor.red[600]!;
        // clickColor = CretaColor.red[700]!;
        bgColor = Colors.transparent;
        hoverColor = Colors.transparent;
        clickColor = Colors.transparent;
        fgColor = CretaColor.red;
        fgHoverColor = CretaColor.red[600];
        fgClickColor = CretaColor.red[700];
        break;
      case CretaButtonColor.redAndWhiteTitle:
        bgColor = CretaColor.red[400]!;
        hoverColor = CretaColor.red[500]!;
        clickColor = CretaColor.red[600]!;
        break;
      case CretaButtonColor.transparent:
        bgColor = Colors.transparent;
        hoverColor = Colors.transparent;
        clickColor = Colors.transparent;
        fgColor = CretaColor.primary;
        fgHoverColor = CretaColor.primary[500];
        fgClickColor = CretaColor.primary[600];
        break;
      case CretaButtonColor.blueGray:
        bgColor = CretaColor.text[900]!.withOpacity(0.25);
        hoverColor = CretaColor.primary[500];
        clickColor = CretaColor.primary[600];
        fgColor = CretaColor.text[900]!.withOpacity(0.25);
        fgHoverColor = CretaColor.primary[500];
        fgClickColor = CretaColor.primary[600];
        break;
      case CretaButtonColor.blueAndWhite:
        bgColor = CretaColor.primary[400]!;
        hoverColor = CretaColor.primary[200]!;
        clickColor = CretaColor.primary[600]!;
        break;
      case CretaButtonColor.blueAndWhiteTitle:
        bgColor = CretaColor.primary[400]!;
        hoverColor = CretaColor.primary[500]!;
        clickColor = CretaColor.primary[600]!;
        break;
      case CretaButtonColor.secondary:
        bgColor = CretaColor.secondary[100]!;
        hoverColor = CretaColor.secondary[100]!;
        clickColor = CretaColor.secondary[300]!;
        fgColor = CretaColor.secondary;
        break;
      case CretaButtonColor.primary:
        bgColor = CretaColor.primary[100]!;
        hoverColor = CretaColor.primary[100]!;
        clickColor = CretaColor.primary[300]!;
        fgColor = CretaColor.primary;
        break;
      case CretaButtonColor.forTree:
        fgColor = CretaColor.text[700]!;
        bgColor = Colors.transparent;
        hoverColor = CretaColor.primary[300]!;
        clickColor = CretaColor.primary[400]!;
        selectColor = CretaColor.primary[500]!;
        break;
      case CretaButtonColor.channelTabSelected:
        fgColor = CretaColor.text[700]!;
        bgColor = Colors.white;
        hoverColor = CretaColor.text[100]!;
        clickColor = CretaColor.text[100]!;
        selectColor = CretaColor.text[100]!;
        break;
      case CretaButtonColor.channelTabUnselected:
        fgColor = CretaColor.text[700]!;
        bgColor = CretaColor.text[100]!;
        hoverColor = CretaColor.text[100]!;
        clickColor = CretaColor.text[100]!;
        selectColor = CretaColor.text[100]!;
        // fgHoverColor = CretaColor.primary[400]!;
        break;
      default:
        bgColor = CretaColor.primary[400]!;
        hoverColor = CretaColor.primary[500]!;
        clickColor = CretaColor.primary[600]!;
        break;
    }
  }
}

class _CretaButtonState extends State<CretaButton> {
  bool hover = false;
  bool clicked = false;
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    //print('build $hover $clicked $selected');
    if (widget.tooltip != null) {
      return Snippet.TooltipWrapper(
        fgColor: widget.tooltipFg ?? (widget.fgColor ?? Colors.white),
        bgColor: widget.tooltipBg ?? (widget.bgColor ?? Colors.grey[700]!),
        tooltip: widget.tooltip!,
        child: _myButton(),
        onShow: () {
          widget.onHover?.call(true);
        },
        // onDismiss: () {
        //   widget.onHover?.call(false);
        // },
      );
    }
    return _myButton();
  }

  Widget _myButton() {
    Widget childWidget = SizedBox(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transformAlignment: AlignmentDirectional.center,
        transform: Matrix4.identity()..scale(_getScale()),
        decoration: _getDeco(),
        width: widget.width ?? _getWidth(),
        height: widget.height ?? _getHeight(),
        clipBehavior: Clip.antiAlias,
        //child: Center(
        child: Container(
          margin: EdgeInsets.fromLTRB(
              widget.sidePadding?.left ?? 0, 0, widget.sidePadding?.right ?? 0, 0),
          child: _getChild(),
        ),
        //),
      ),
    );

    return GestureDetector(
      onLongPressDown: (details) {
        if (widget.useTapUp == false) {
          logger.fine("Gest : CretaButton onLongPressDown");
          setState(() {
            clicked = true;
            if (widget.isSelectedWidget) {
              selected = !selected;
            }
          });
          widget.onPressed.call();
        }
      },
      onLongPressUp: () {
        logger.fine("onLongPressUp");
        setState(() {
          clicked = false;
        });
        //widget.onPressed.call();
      },
      onTapUp: (details) {
        if (widget.useTapUp == false) {
          logger.fine("onTapUp...");
          setState(() {
            clicked = false;
          });
          //widget.onPressed.call();
        } else {
          logger.fine("Gest : CretaButton onTapUp");
          setState(() {
            clicked = false;
            if (widget.isSelectedWidget) {
              selected = !selected;
            }
          });
          widget.onPressed.call();
        }
      },
      child: MouseRegion(
        cursor: widget.showClickableCursor ? SystemMouseCursors.click : MouseCursor.defer,
        onExit: (val) {
          setState(() {
            //print('hover is false');
            hover = false;
            clicked = false;
            widget.onHover?.call(hover);
          });
        },
        onEnter: (val) {
          setState(() {
            //print('hover is true');
            hover = true;
            if (widget.noHoverEffect == false) {
              // noHoverEffect 의 경우, hover 진입이벤트만 사용하지 않게된다.
              widget.onHover?.call(hover);
            }
          });
        },
        // child: Transform.scale(
        //   scale: getScale(),
        //   child: Container(
        //     decoration: getDeco(),
        //     width: widget.width ?? getWidth(),
        //     height: widget.height ?? getHeight(),
        //     child: Center(
        //       child: getChild(),
        //     ),
        //   ),
        // )
        child: childWidget,
      ),
    );
  }

  double _getScale() {
    return clicked ? ((widget.height != null && widget.height! > 40.0) ? 0.8 : 0.6) : 1.0;
  }

  List<BoxShadow>? _getShadow() {
    if (widget.decoType != CretaButtonDeco.shadow) {
      return null;
    }
    double spreadRadius = 1;
    if (clicked) {
      spreadRadius = -1;
    }
    return [
      //LTRB
      BoxShadow(
        //color: Colors.grey.shade500,
        color: widget.fgClickColor!,
        offset: Offset(-2, -2),
        blurRadius: 8,
        spreadRadius: spreadRadius,
      ),
      BoxShadow(
        //color: Colors.grey.shade500,
        color: widget.fgClickColor!,
        offset: Offset(2, -2),
        blurRadius: 8,
        spreadRadius: spreadRadius,
      ),
      BoxShadow(
        //color: Colors.grey.shade500,
        color: widget.fgClickColor!,
        offset: Offset(-2, 2),
        blurRadius: 8,
        spreadRadius: spreadRadius,
      ),
      BoxShadow(
        //color: Colors.grey.shade500,
        color: widget.fgClickColor!,
        offset: Offset(2, 2),
        blurRadius: 8,
        spreadRadius: spreadRadius,
      ),
    ];
  }

  Border? _getBorder() {
    if (selected) {
      if (widget.decoType == CretaButtonDeco.fill) {
        return Border.all(width: 1, color: CretaColor.primary[300]!);
      }
    }
    if (widget.decoType == CretaButtonDeco.line) {
      if (widget.buttonColor == CretaButtonColor.sky) {
        return Border.all(width: 1, color: CretaColor.primary[500]!);
      }
      if (widget.buttonColor == CretaButtonColor.white) {
        return Border.all(width: 1, color: CretaColor.text[700]!);
      }
      if (widget.buttonColor == CretaButtonColor.whiteShadow) {
        return null;
      }
      if (widget.buttonColor == CretaButtonColor.purple) {
        return Border.all(width: 1, color: CretaColor.secondary);
      }
      if (widget.buttonColor == CretaButtonColor.skypurple) {
        return Border.all(width: 1, color: CretaColor.secondary);
      }
      if (widget.buttonColor == CretaButtonColor.red) {
        return Border.all(width: 1, color: CretaColor.red);
      }
      if (widget.buttonColor == CretaButtonColor.transparent) {
        return Border.all(width: 1, color: CretaColor.primary[500]!);
      }
      return Border.all(width: 2, color: widget.fgClickColor!);
    }
    return null;
  }

  Decoration? _getDeco() {
    return BoxDecoration(
      border: _getBorder(),
      boxShadow: widget.hasShadow ? _getShadow() : null,
      color: _getColor(),
      borderRadius: BorderRadius.all(Radius.circular(36)),
    );
  }

  Color _getColor() {
    if (selected) {
      if (widget.selectColor != null && widget.decoType == CretaButtonDeco.line) {
        return widget.selectColor!;
      }
    }
    return hover ? (clicked ? widget.clickColor! : widget.hoverColor!) : widget.bgColor!;
  }

  Widget _getText() {
    if (widget.textString != null && widget.textStyle != null) {
      //if (selected && widget.isSelectedWidget && widget.buttonColor == CretaButtonColor.white) {
      if (selected && widget.isSelectedWidget) {
        if (widget.buttonType == CretaButtonType.textOnly) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.textString!, style: widget.textStyle!.copyWith(color: Colors.white)),
            ],
          );
        }
        return Padding(
          padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
          child: Text(widget.textString!, style: widget.textStyle!.copyWith(color: Colors.white)),
        );
      }
      if (widget.buttonType == CretaButtonType.textOnly) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.textString!, style: widget.textStyle!),
          ],
        );
      }
      return Padding(
        padding: const EdgeInsets.fromLTRB(3, 0, 0, 0),
        child: Text(widget.textString!,
            style: _isTransparent()
                ? widget.textStyle!.copyWith(
                    color: _getFgColor(),
                  )
                : widget.textStyle!),
      );
    }
    return widget.text!;
  }

  bool _isTransparent() {
    if (widget.buttonColor == CretaButtonColor.transparent) return true;
    if (widget.decoType == CretaButtonDeco.line) {
      if (widget.buttonColor == CretaButtonColor.red) {
        return true;
      }
      if (widget.buttonColor == CretaButtonColor.skypurple) {
        return true;
      }
    }
    return false;
  }

  Icon _getIcon() {
    if (widget.iconData != null && widget.iconSize != null) {
      if (_isTransparent()) {
        return Icon(
          widget.iconData!,
          color: _getFgColor(),
          size: widget.iconSize,
        );
      }
    }
    return widget.icon!;
  }

  Color _getFgColor() {
    return hover ? (clicked ? widget.fgClickColor! : widget.fgHoverColor!) : widget.fgColor!;
  }

  Widget _getChild() {
    if (widget.buttonType == CretaButtonType.iconOnly) {
      return _getIcon();
    }
    if (widget.buttonType == CretaButtonType.textOnly) {
      return _getText();
    }
    if (widget.buttonType == CretaButtonType.iconText) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (hover || widget.alwaysShowIcon) ? _getIcon() : Container(),
          AnimatedPadding(
            curve: Curves.easeOutQuad,
            padding: EdgeInsetsDirectional.only(start: hover ? (widget.width ?? 0) / 14 : 0),
            duration: Duration(milliseconds: 800),
            child: _getText(),
          ),
        ],
      );
    }
    if (widget.buttonType == CretaButtonType.iconTextFix) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: _getIcon(),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: _getText(),
          ),
        ],
      );
    }
    if (widget.buttonType == CretaButtonType.textIcon) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedPadding(
            curve: Curves.easeOutQuad,
            padding: EdgeInsetsDirectional.only(end: hover ? widget.width! / 14 : 0),
            duration: Duration(milliseconds: 800),
            child: _getText(),
          ),
          (hover || widget.alwaysShowIcon) ? _getIcon() : Container(),
        ],
      );
    }
    if (widget.buttonType == CretaButtonType.imageText && widget.image != null) {
      return Row(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.image!,
          _getText(),
        ],
      );
    }
    if (widget.buttonType == CretaButtonType.child) {
      return widget.child!;
    }

    return Container();
  }

  double? _getWidth() {
    if (widget.buttonType == CretaButtonType.iconOnly) {
      return 36;
    }
    return null;
  }

  double? _getHeight() {
    if (widget.buttonType == CretaButtonType.iconOnly) {
      return 36;
    }
    return null;
  }
}

class CretaButtonSidePadding {
  CretaButtonSidePadding({
    required this.left,
    required this.right,
  });

  CretaButtonSidePadding.fromLR(double left, double right)
      : this(
          left: left,
          right: right,
        );

  final double left;
  final double right;
}
