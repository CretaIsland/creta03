import 'package:flutter/material.dart';


class CretaLayoutRect {
  CretaLayoutRect({
    required this.size,
    required this.margin,
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
          margin: EdgeInsets.fromLTRB(leftMargin, topMargin, rightMargin, bottomMargin),
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
          margin: EdgeInsets.fromLTRB(leftMargin, topMargin, rightMargin, bottomMargin),
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
          margin: EdgeInsets.fromLTRB(leftMargin, topMargin, rightMargin, bottomMargin),
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
    margin: EdgeInsets.zero,
    childRect: Rect.zero,
    childPadding: EdgeInsets.zero,
  );

  final Size size;
  final EdgeInsets margin;

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
  double get childtopPadding => childPadding.top;
  double get childbottomPadding => childPadding.bottom;
}
