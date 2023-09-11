//import 'package:creta03/model/contents_model.dart';
import 'package:flutter/material.dart';

import '../../../../data_io/depot_manager.dart';
import '../../../../design_system/component/creta_right_mouse_menu.dart';
import '../../../../design_system/creta_color.dart';
import '../../../../design_system/menu/creta_popup_menu.dart';
import '../../../../lang/creta_studio_lang.dart';
import '../../../../model/depot_model.dart';
import '../../studio_variables.dart';
import 'depot_display.dart';
//import 'selection_manager.daxt';
// ignore: depend_on_referenced_packages

// ignore: must_be_immutable
class DepotSelected extends StatefulWidget {
  final DepotManager depotManager;
  final Widget childContents;
  final double width;
  final double height;
  final DepotModel? depot;

  const DepotSelected({
    required this.depotManager,
    required this.childContents,
    required this.width,
    required this.height,
    required this.depot,
    super.key,
  });

  @override
  State<DepotSelected> createState() => _DepotSelectedState();
}

class _DepotSelectedState extends State<DepotSelected> {
  bool _isHover = false;
  bool isSelected = false;
  bool _isMultiSelectedChanged = false;

  // List<String> selectedDepot = [];
  @override
  Widget build(BuildContext context) {
    if (widget.depot == null) {
      return const SizedBox.shrink();
    }
    return InkWell(
      onHover: (isHover) {
        _isHover = isHover;
//        selectionManager.handleHover(isHover, depot!);
      },
      onTapDown: (details) {
        handleTap(details, widget.depot);
      },
      onDoubleTap: () {
        clearMultiSelected();
      },
      onSecondaryTapDown: (details) {
        onRightMouseButton.call(details, widget.depot, widget.depotManager, context);
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? CretaColor.primary
                // : CretaColor.text[200]!,
                : Colors.transparent,
            width: DepotDisplay.ctrlSelectedSet.contains(widget.depot) ? 4 : 1,
          ),
        ),
        child: Center(
          child: widget.childContents,
        ),
      ),
    );
  }

  void handleTap(TapDownDetails details, DepotModel? depotModel) {
    if (StudioVariables.isCtrlPressed) {
      if (DepotDisplay.ctrlSelectedSet.contains(depotModel)) {
        DepotDisplay.ctrlSelectedSet.remove(depotModel);
        setState(() {
          _isMultiSelectedChanged = !_isMultiSelectedChanged;
        });
        // selectedDepot.remove(depotModel!.mid);
      } else {
        setState(() {
          _isMultiSelectedChanged = !_isMultiSelectedChanged;
        });
        DepotDisplay.ctrlSelectedSet.add(depotModel!);
        // selectedDepot.add(depotModel.mid);
      }
    } else if (StudioVariables.isShiftPressed) {
      debugPrint('Shift key pressed');
    } else {
      // print("Ctrl key released");
      DepotDisplay.ctrlSelectedSet = {depotModel!};
      DepotDisplay.ctrlSelectedSet.clear();
      // selectedDepot.clear();
      // selectedDepot.add(depotModel.mid);
      setState(() {
        isSelected = !isSelected;
      });
    }
    widget.depotManager.notify();
  }

  void clearMultiSelected() {
    DepotDisplay.ctrlSelectedSet.clear();
    // selectedDepot.clear();
    widget.depotManager.notify();
  }

  void onRightMouseButton(TapDownDetails details, DepotModel? depotModel, DepotManager depotManager,
      BuildContext context) {
    if (DepotDisplay.ctrlSelectedSet.isEmpty && DepotDisplay.shiftSelectedSet.isEmpty
        // &&
        // selectedDepot.isEmpty
        ) {
      return;
    }

    if (_isHover &&
            DepotDisplay.ctrlSelectedSet.contains(depotModel) == false &&
            DepotDisplay.shiftSelectedSet.contains(depotModel) == false
        // &&
        // selectedDepot.contains(depotModel!.mid) == false
        ) {
      return;
    }

    CretaRightMouseMenu.showMenu(
      title: 'depotRightMouseMenu',
      context: context,
      popupMenu: [
        CretaMenuItem(
            caption: CretaStudioLang.tooltipDelete,
            onPressed: () async {
              Set<DepotModel> targetList = DepotDisplay.ctrlSelectedSet;
              if (DepotDisplay.shiftSelectedSet.isNotEmpty) {
                targetList.addAll(DepotDisplay.shiftSelectedSet);
              }
              for (var ele in targetList) {
                await depotManager.removeDepots(ele);
              }
              debugPrint('remove from depot DB');
              depotManager.notify();
            }),
      ],
      itemHeight: 24,
      x: details.globalPosition.dx,
      y: details.globalPosition.dy,
      width: 150,
      height: 36,
      iconSize: 12,
      alwaysShowBorder: true,
      borderRadius: 8,
    );
  }
}
