// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
//import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

import 'package:creta_common/model/app_enums.dart';
import 'package:creta_common/common/creta_color.dart';
import 'creta_arrow_clipper.dart';
import 'creta_digonal_clipper.dart';
import 'creta_dir_clipper.dart';
import 'creta_oval_clipper.dart';
import 'creta_poligon_clipper.dart';
import 'creta_slider_cut_clipper.dart';
import 'creta_star_clipper.dart';
import 'creta_wave_clippper_1.dart';
import 'diamond_container.dart';
import 'star_container.dart';
import 'triangle_container.dart';

class ShapeIndicator extends StatefulWidget {
  final ShapeType shapeType;
  final void Function(ShapeType value) onTapPressed;
  final double width;
  final double height;
  final bool isSelected;
  const ShapeIndicator({
    super.key,
    required this.shapeType,
    required this.onTapPressed,
    this.isSelected = false,
    this.width = 24,
    this.height = 24,
  });

  @override
  State<ShapeIndicator> createState() => _ShapeIndicatorState();
}

class _ShapeIndicatorState extends State<ShapeIndicator> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTapPressed(widget.shapeType);
      },
      child: Container(
        width: widget.width + 8,
        height: widget.height + 8,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: widget.isSelected ? CretaColor.primary : Colors.white,
            width: 2,
          ),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Center(
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: _drawShape(widget.shapeType, widget.width, widget.height),
          ),
        ),
      ),
    );
  }

  Widget _drawShape(ShapeType shapeType, double width, double height) {
    BoxBorder border = Border.all(
      color: CretaColor.text[300]!,
      width: 2,
      //style: BorderStyle.solid,
    );

    switch (shapeType) {
      case ShapeType.rectangle:
        return Container(
          decoration: BoxDecoration(
            border: border,
            color: CretaColor.text[300]!,
          ),
        );
      case ShapeType.circle:
        return Container(
          decoration: BoxDecoration(
            border: border,
            borderRadius: BorderRadius.all(Radius.circular(widget.width / 2)),
            color: CretaColor.text[300]!,
          ),
          child: ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.all(Radius.circular(widget.width / 2)),
            // child: Image.asset(
            //   'assets/creta_default.png',
            //   fit: BoxFit.cover,
            // ),
          ),
        );
      case ShapeType.oval:
        return Center(
          child: Container(
            width: width,
            height: width / 2,
            decoration: BoxDecoration(
              color: CretaColor.text[300]!,
              border: border,
              borderRadius: BorderRadius.all(Radius.elliptical(width / 2, width / 4)),
            ),
            child: ClipOval(
                // child: Image.asset(
                //   'assets/creta_default.png',
                //   fit: BoxFit.cover,
                // ),
                ),
          ),
        );
      case ShapeType.triangle:
        return Center(
          child: TriangleContainer(
            width: width,
            height: height,
            color: CretaColor.text[300]!,
            applyScale: 1.0,
            // child: Image.asset(
            //   'assets/creta_default.png',
            //   fit: BoxFit.cover,
            // ),
          ),
        );

      case ShapeType.star:
        return Center(
          child: StarContainer(
            width: width + 4,
            height: height + 4,
            color: CretaColor.text[300]!,
            // child: Image.asset(
            //   'assets/creta_default.png',
            //   fit: BoxFit.cover,
            // ),
            applyScale: 1.0,
          ),
        );

      case ShapeType.diamond:
        return Center(
          child: DiamondContainer(
            width: width,
            height: height,
            color: CretaColor.text[300]!,
            // child: Image.asset(
            //   'assets/noise.png',
            //   fit: BoxFit.cover,
            // ),
            applyScale: 1.0,
          ),
        );

      case ShapeType.sideCut:
        return Center(
          child: ClipPath(
            clipper: CretaSideCutClipper(delta: 0.15),
            child: Container(
              height: width,
              width: height,
              color: CretaColor.text[300]!,
            ),
          ),
        );
      case ShapeType.waveTopLeft:
        return Center(
          child: ClipPath(
            clipper: CretaWaveClipper1(flip: true, reverse: true, delta: height / 100),
            child: Container(
              height: width,
              width: height,
              color: CretaColor.text[300]!,
            ),
          ),
        );
      case ShapeType.waveTopRight:
        return Center(
          child: ClipPath(
            clipper: CretaWaveClipper1(flip: false, reverse: true, delta: height / 100),
            child: Container(
              height: width,
              width: height,
              color: CretaColor.text[300]!,
            ),
          ),
        );
      case ShapeType.waveBottomLeft:
        return Center(
          child: ClipPath(
            clipper: CretaWaveClipper1(flip: true, reverse: false, delta: height / 100),
            child: Container(
              height: width,
              width: height,
              color: CretaColor.text[300]!,
            ),
          ),
        );
      case ShapeType.waveBottomRight:
        return Center(
          child: ClipPath(
            clipper: CretaWaveClipper1(flip: false, reverse: false, delta: height / 100),
            child: Container(
              height: width,
              width: height,
              color: CretaColor.text[300]!,
            ),
          ),
        );
      case ShapeType.ovalTop:
        return Center(
          child: ClipPath(
            clipper: CreaOvalTopClipper(delta: height / 100),
            child: Container(
              height: width,
              width: height,
              color: CretaColor.text[300]!,
            ),
          ),
        );
      case ShapeType.ovalBottom:
        return Center(
          child: ClipPath(
            clipper: CretaOvalBottomClipper(delta: height / 100),
            child: Container(
              height: width,
              width: height,
              color: CretaColor.text[300]!,
            ),
          ),
        );
      case ShapeType.ovalLeft:
        return Center(
          child: ClipPath(
            clipper: CretaOvalLeftClipper(delta: height / 100),
            child: Container(
              height: width,
              width: height,
              color: CretaColor.text[300]!,
            ),
          ),
        );
      case ShapeType.ovalRight:
        return Center(
          child: ClipPath(
            clipper: CretaOvalRightClipper(delta: height / 100),
            child: Container(
              height: width,
              width: height,
              color: CretaColor.text[300]!,
            ),
          ),
        );
      case ShapeType.star4:
        return Center(
          child: ClipPath(
            clipper: CretaStarClipper(4),
            child: Container(
              height: width,
              width: height,
              color: CretaColor.text[300]!,
            ),
          ),
        );
      case ShapeType.star8:
        return Center(
          child: ClipPath(
            clipper: CretaStarClipper(8),
            child: Container(
              height: width,
              width: height,
              color: CretaColor.text[300]!,
            ),
          ),
        );
      case ShapeType.star16:
        return Center(
          child: ClipPath(
            clipper: CretaStarClipper(16),
            child: Container(
              height: width,
              width: height,
              color: CretaColor.text[300]!,
            ),
          ),
        );
      case ShapeType.arrowUp:
        return Center(
          child: ClipPath(
            clipper: CretaArrowClipper(height * 0.33, width * 0.6, CretaEdge.TOP),
            child: Container(
              height: width,
              width: height,
              color: CretaColor.text[300]!,
            ),
          ),
        );
      case ShapeType.arrowDown:
        return Center(
          child: ClipPath(
            clipper: CretaArrowClipper(height * 0.33, width * 0.6, CretaEdge.BOTTOM),
            child: Container(
              height: width,
              width: height,
              color: CretaColor.text[300]!,
            ),
          ),
        );
      case ShapeType.arrowLeft:
        return Center(
          child: ClipPath(
            clipper: CretaArrowClipper(width * 0.33, height * 0.6, CretaEdge.LEFT),
            child: Container(
              height: width,
              width: height,
              color: CretaColor.text[300]!,
            ),
          ),
        );
      case ShapeType.arrowRight:
        return Center(
          child: ClipPath(
            clipper: CretaArrowClipper(width * 0.33, height * 0.6, CretaEdge.RIGHT),
            child: Container(
              height: width,
              width: height,
              color: CretaColor.text[300]!,
            ),
          ),
        );
      case ShapeType.dirUp:
        return Center(
          child: ClipPath(
            clipper: CretaDirClipper(height * 0.33, CretaEdge.TOP),
            child: Container(
              height: width,
              width: height,
              color: CretaColor.text[300]!,
            ),
          ),
        );
      case ShapeType.dirDown:
        return Center(
          child: ClipPath(
            clipper: CretaDirClipper(height * 0.33, CretaEdge.BOTTOM),
            child: Container(
              height: width,
              width: height,
              color: CretaColor.text[300]!,
            ),
          ),
        );
      case ShapeType.dirLeft:
        return Center(
          child: ClipPath(
            clipper: CretaDirClipper(width * 0.33, CretaEdge.LEFT),
            child: Container(
              height: width,
              width: height,
              color: CretaColor.text[300]!,
            ),
          ),
        );
      case ShapeType.dirRight:
        return Center(
          child: ClipPath(
            clipper: CretaDirClipper(width * 0.33, CretaEdge.RIGHT),
            child: Container(
              height: width,
              width: height,
              color: CretaColor.text[300]!,
            ),
          ),
        );
      case ShapeType.octagon:
        return Center(
          child: ClipPath(
            clipper: CretaOctagonalClipper(),
            child: Container(
              height: width,
              width: height,
              color: CretaColor.text[300]!,
            ),
          ),
        );
      case ShapeType.hexagon:
        return Center(
          child: ClipPath(
            clipper: CretaHexagonalClipper(),
            child: Container(
              height: width,
              width: height,
              color: CretaColor.text[300]!,
            ),
          ),
        );
      case ShapeType.digonalBottomLeft:
        return Center(
          child: ClipPath(
            clipper: CretaDiagonalBottomLeft(delta: height / 100),
            child: Container(
              height: width,
              width: height,
              color: CretaColor.text[300]!,
            ),
          ),
        );
      case ShapeType.digonalBottomRight:
        return Center(
          child: ClipPath(
            clipper: CretaDiagonalBottomRight(delta: height / 100),
            child: Container(
              height: width,
              width: height,
              color: CretaColor.text[300]!,
            ),
          ),
        );
      case ShapeType.pepple1:
        return Center(
          child: ClipPath(
            clipper: CretaPeppleClipper1(delta: height / 10),
            child: Container(
              height: width,
              width: height,
              color: CretaColor.text[300]!,
            ),
          ),
        );
      case ShapeType.heart:
        return Center(
          child: ClipPath(
            clipper: CretaHeartClipper(),
            child: Container(
              height: width,
              width: height,
              color: CretaColor.text[300]!,
            ),
          ),
        );
      case ShapeType.leaf:
        return Center(
          child: ClipPath(
            clipper: CretaLeafClipper(),
            child: Container(
              height: width,
              width: height,
              color: CretaColor.text[300]!,
            ),
          ),
        );

      case ShapeType.snowman:
        return Center(
          child: ClipPath(
            clipper: CretaSnowManClipper(),
            child: Container(
              height: width,
              width: height,
              color: CretaColor.text[300]!,
            ),
          ),
        );
      default:
        return Container(
          width: width,
          height: height,
          color: Colors.amber,
        );
    }
  }
}
