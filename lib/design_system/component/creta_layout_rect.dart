import 'package:flutter/material.dart';

class CretaLayoutRect {
  CretaLayoutRect({
    required this.size,
    required this.childMargin,
    required this.childRect,
    required this.childPadding,
  });
  CretaLayoutRect.fromLTWH(
    double width,
    double height,
    double childLeft,
    double childTop,
    double childWidth,
    double childHeight, {
    double leftMargin = 0,
    double topMargin = 0,
    double rightMargin = 0,
    double bottomMargin = 0,
  }) : this(
          size: Size(width, height),
          childMargin: EdgeInsets.fromLTRB(leftMargin, topMargin, rightMargin, bottomMargin),
          childRect: Rect.fromLTWH(childLeft, childTop, childWidth, childHeight),
          childPadding: EdgeInsets.fromLTRB(
            childLeft,
            childTop,
            width - (childLeft + childWidth),
            height - (childTop + childHeight),
          ),
        );
  CretaLayoutRect.fromLTRB(
    double width,
    double height,
    double childLeft,
    double childTop,
    double childRight,
    double childBottom, {
    double leftMargin = 0,
    double topMargin = 0,
    double rightMargin = 0,
    double bottomMargin = 0,
  }) : this(
          size: Size(width, height),
          childMargin: EdgeInsets.fromLTRB(leftMargin, topMargin, rightMargin, bottomMargin),
          childRect: Rect.fromLTRB(childLeft, childTop, childRight, childBottom),
          childPadding: EdgeInsets.fromLTRB(
            childLeft,
            childTop,
            width - childRight,
            height - childBottom,
          ),
        );
  CretaLayoutRect.fromPadding(
    double width,
    double height,
    double leftPadding,
    double topPadding,
    double rightPadding,
    double bottomPadding, {
    double leftMargin = 0,
    double topMargin = 0,
    double rightMargin = 0,
    double bottomMargin = 0,
  }) : this(
          size: Size(width, height),
          childMargin: EdgeInsets.fromLTRB(leftMargin, topMargin, rightMargin, bottomMargin),
          childRect: Rect.fromLTRB(
            leftMargin + leftPadding,
            topMargin + topPadding,
            width - (rightMargin + rightPadding),
            height - (bottomMargin + bottomPadding),
          ),
          childPadding: EdgeInsets.fromLTRB(
            leftPadding,
            topPadding,
            rightPadding,
            bottomPadding,
          ),
        );
  static CretaLayoutRect zero = CretaLayoutRect(
    size: Size.zero,
    childMargin: EdgeInsets.zero,
    childRect: Rect.zero,
    childPadding: EdgeInsets.zero,
  );

  CretaLayoutRect copyWith({
    Size? size,
    EdgeInsets? childMargin,
    Rect? childRect,
    EdgeInsets? childPadding,
  }) {
    return CretaLayoutRect(
      size: size ?? this.size,
      childMargin: childMargin ?? this.childMargin,
      childRect: childRect ?? this.childRect,
      childPadding: childPadding ?? this.childPadding,
    );
  }

  Widget childContainer({
    Key? key,
    AlignmentGeometry? alignment,
    //EdgeInsetsGeometry? padding,
    Color? color,
    Decoration? decoration,
    Decoration? foregroundDecoration,
    //double? width,
    //double? height,
    BoxConstraints? constraints,
    //EdgeInsetsGeometry? margin,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Widget? child,
    Clip clipBehavior = Clip.none,
  }) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Container(
        key: key,
        alignment: alignment,
        padding: childPadding,
        color: color,
        decoration: decoration,
        foregroundDecoration: foregroundDecoration,
        width: childRect.width,
        height: childRect.height,
        constraints: constraints,
        margin: childMargin,
        transform: transform,
        transformAlignment: transformAlignment,
        clipBehavior: clipBehavior,
        child: child,
      ),
    );
  }

  final Size size;
  final EdgeInsets childMargin;

  double get width => size.width;
  double get height => size.height;

  final Rect childRect;
  final EdgeInsets childPadding;

  double get childLeft => childRect.left;
  double get childRight => childRect.right;
  double get childTop => childRect.top;
  double get childBottom => childRect.bottom;

  double get childWidth => childRect.width;
  double get childHeight => childRect.height;

  double get childLeftPadding => childPadding.left;
  double get childRightPadding => childPadding.right;
  double get childTopPadding => childPadding.top;
  double get childBottomPadding => childPadding.bottom;
}
