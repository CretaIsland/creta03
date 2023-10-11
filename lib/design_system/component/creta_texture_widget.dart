import 'package:flutter/material.dart';
import 'dart:ui';

extension GlassWidget<T extends Widget> on T {
  /// .asGlass(): Converts the calling widget into a glass widget.
  ///
  /// Parameters:
  /// * [blurX]: Amount of blur in the direction of the X axis, defaults to 10.0.
  /// * [blurY]: Amount of blur in the direction of the Y axis, defaults to 10.0.
  /// * [tintColor]: Tint color for the glass (defaults to Colors.white).
  /// * [frosted]: Whether this glass should be frosted or not (defaults to true).
  /// * [clipBorderRadius]: The border radius of the rounded corners.
  ///   Values are clamped so that horizontal and vertical radii sums do not exceed width/height.
  ///   This value is ignored if clipper is non-null.
  /// * [clipBehaviour]: Defaults to [Clip.antiAlias].
  /// * [tileMode]: Defines what happens at the edge of a gradient or the sampling of a source image in an [ImageFilter].
  /// * [clipper]: If non-null, determines which clip to use.
  ClipRRect asGlass({
    double blurX = 10.0,
    double blurY = 10.0,
    Color tintColor = Colors.white,
    bool frosted = true,
    BorderRadius? clipBorderRadius = BorderRadius.zero,
    Clip clipBehaviour = Clip.antiAlias,
    TileMode tileMode = TileMode.clamp,
    CustomClipper<RRect>? clipper,
  }) {
    return ClipRRect(
      clipper: clipper,
      clipBehavior: clipBehaviour,
      borderRadius: clipBorderRadius!,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurX,
          sigmaY: blurY,
          tileMode: tileMode,
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: (tintColor != Colors.transparent)
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      tintColor.withOpacity(0.1),
                      tintColor.withOpacity(0.08),
                    ],
                  )
                : null,
            image: frosted
                ? const DecorationImage(
                    image: AssetImage('assets/noise.png'),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: this,
        ),
      ),
    );
  }

  Widget asCretaGlass({
    double blurX = 15.0,
    double blurY = 15.0,
    //Color tintColor = Colors.white,
    bool frosted = true,
    BorderRadius? clipBorderRadius = BorderRadius.zero,
    BorderRadius? radius = BorderRadius.zero,
    Clip clipBehaviour = Clip.antiAlias,
    TileMode tileMode = TileMode.clamp,
    CustomClipper<RRect>? clipper,
    BoxBorder? border,
    required Color bgColor1,
    required Color bgColor2,
    required double opacity,
    Gradient? gradient,
    int? borderStyle,
    double? borderWidth,
    BoxShadow? boxShadow,
    required double width,
    required double height,
    double? pageWidth,
    double? pageHeight,
  }) {
    return _asCretaGlass(
      blurX: blurX,
      blurY: blurY,
      frosted: frosted,
      clipBorderRadius: clipBorderRadius,
      radius: radius,
      clipBehaviour: clipBehaviour,
      tileMode: tileMode,
      clipper: clipper,
      border: border,
      bgColor1: bgColor1,
      bgColor2: bgColor2,
      opacity: opacity,
      gradient: gradient,
      boxShadow: boxShadow,
      width: width,
      height: height,
      pageWidth: pageWidth,
      pageHeight: pageHeight,
    );
  }

  Widget _asCretaGlass({
    double blurX = 15.0,
    double blurY = 15.0,
    //Color tintColor = Colors.white,
    bool frosted = true,
    BorderRadius? clipBorderRadius = BorderRadius.zero,
    BorderRadius? radius = BorderRadius.zero,
    Clip clipBehaviour = Clip.antiAlias,
    TileMode tileMode = TileMode.clamp,
    CustomClipper<RRect>? clipper,
    BoxBorder? border,
    required Color bgColor1,
    required Color bgColor2,
    required double opacity,
    Gradient? gradient,
    BoxShadow? boxShadow,
    required double width,
    required double height,
    double? pageWidth,
    double? pageHeight,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: border,
        borderRadius: radius,
        boxShadow: boxShadow != null ? [boxShadow] : null,
      ),
      child: ClipRRect(
        clipper: clipper,
        clipBehavior: clipBehaviour,
        borderRadius: clipBorderRadius!,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurX,
            sigmaY: blurY,
            tileMode: tileMode,
          ),
          child: pageWidth != null && pageHeight != null
              ? Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: pageWidth,
                        height: pageHeight,
                        decoration: BoxDecoration(
                          gradient: gradient ??
                              LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  bgColor1.withOpacity(opacity),
                                  bgColor2.withOpacity(opacity / 2),
                                ],
                              ),
                          image: frosted
                              ? const DecorationImage(
                                  image: AssetImage('assets/noise.png'),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        //child: this,
                      ),
                    ),
                    this,
                  ],
                )
              : Container(
                  decoration: BoxDecoration(
                    gradient: gradient ??
                        LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            bgColor1.withOpacity(opacity),
                            bgColor2.withOpacity(opacity / 2),
                          ],
                        ),
                    image: frosted
                        ? const DecorationImage(
                            image: AssetImage('assets/noise.png'),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: this,
                ),
        ),
      ),
    );
  }
}
