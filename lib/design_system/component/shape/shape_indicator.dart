// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../../model/app_enums.dart';
import '../../creta_color.dart';
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
        ));
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
