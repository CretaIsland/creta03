//import 'package:creta03/model/contents_model.dart';
import 'package:flutter/material.dart';

import '../../../../data_io/depot_manager.dart';
import '../../../../design_system/creta_color.dart';
import '../../../../model/depot_model.dart';
import 'selection_manager.dart';
// ignore: depend_on_referenced_packages

class DepotSelectedClass extends StatelessWidget {
  final Widget childContents;
  final double width;
  final double height;
  final DepotModel? depot;
  final DepotManager depotManager;

  const DepotSelectedClass({
    required this.childContents,
    required this.width,
    required this.height,
    required this.depot,
    required this.depotManager,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (depot == null) {
      return const SizedBox.shrink();
    }
    return InkWell(
      onHover: (isHover) {
        selectionStateManager.handleHover(isHover, depot!.mid);
      },
      onTapDown: (details) {
        selectionStateManager.handleTap(details, depot!);
      },
      onDoubleTap: () {
        selectionStateManager.clearMultiSelected();
      },
      onSecondaryTapDown: (details) {
        selectionStateManager.onRightMouseButton.call(details, depotManager, context);
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(
            color: selectionStateManager.selectedContents.contains(depot!.mid)
                ? CretaColor.primary
                : CretaColor.text[200]!,
            width: selectionStateManager.selectedContents.contains(depot!.mid)
                ? 4
                : selectionStateManager.hoveredContents.contains(depot!.mid)
                    ? 4
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
