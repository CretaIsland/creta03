//import 'package:creta03/model/contents_model.dart';
import 'package:flutter/material.dart';

import '../../../../design_system/creta_color.dart';
import '../../../../model/depot_model.dart';
import 'depot_display.dart';
import 'selection_manager.dart';
// ignore: depend_on_referenced_packages

class DepotSelected extends StatelessWidget {
  final Widget childContents;
  final double width;
  final double height;
  final DepotModel? depot;

  const DepotSelected({
    required this.childContents,
    required this.width,
    required this.height,
    required this.depot,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (depot == null) {
      return const SizedBox.shrink();
    }
    return InkWell(
      onHover: (isHover) {
        selectionManager.handleHover(isHover, depot!);
      },
      onTapDown: (details) {
        selectionManager.handleTap(details, depot!);
      },
      onDoubleTap: () {
        selectionManager.clearMultiSelected();
      },
      onSecondaryTapDown: (details) {
        selectionManager.onRightMouseButton.call(details, DepotDisplay.depotManager, context);
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(
            color: selectionManager.selectedDepot.contains(depot!.mid)
                ? CretaColor.primary
                // : CretaColor.text[200]!,
                : Colors.transparent,
            width: selectionManager.selectedDepot.contains(depot!.mid)
                ? 3
                : selectionManager.hoveredDepot != null &&
                        selectionManager.hoveredDepot!.mid == depot!.mid
                    ? 3
                    : 1,
          ),
        ),
        child: Center(
          child: childContents,
        ),
      ),
    );
  }
}
