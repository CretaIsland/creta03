import 'package:flutter/material.dart';
import '../../../../data_io/depot_manager.dart';
import '../../../../design_system/component/creta_right_mouse_menu.dart';
import '../../../../design_system/menu/creta_popup_menu.dart';
import '../../../../lang/creta_studio_lang.dart';
//import '../../../../model/contents_model.dart';
import '../../../../model/depot_model.dart';
import '../../studio_variables.dart';
import 'depot_display.dart';

SelectionManager selectionManager = SelectionManager();

class SelectionManager {
  bool isSelected = false;
  List<String> selectedDepot = [];
  DepotModel? hoveredDepot; // Store the hovered content

  void handleHover(bool hover, DepotModel depotModel) {
    if (hover) {
      hoveredDepot = depotModel; // Update the hoveredDepot
    } else {
      hoveredDepot = null; // Reset hoveredDepot when not hovered
    }
    // DepotDisplay.depotManager.notify();
  }

  void handleTap(TapDownDetails details, DepotModel depotModel) {
    if (StudioVariables.isCtrlPressed) {
      if (DepotDisplay.ctrlSelectedSet.contains(depotModel)) {
        DepotDisplay.ctrlSelectedSet.remove(depotModel);
        isSelected = false;
        selectedDepot.remove(depotModel.mid);
      } else {
        isSelected = true;
        DepotDisplay.ctrlSelectedSet.add(depotModel);
        selectedDepot.add(depotModel.mid);
      }
    } else if (StudioVariables.isShiftPressed) {
      debugPrint('Shift key pressed');
    } else {
      // print("Ctrl key released");
      DepotDisplay.ctrlSelectedSet = {depotModel};
      selectedDepot.clear();
      selectedDepot.add(depotModel.mid);
      // isSelected = true;
      isSelected = !isSelected;
    }
    // DepotDisplay.depotManager.notify();
  }

  void clearMultiSelected() {
    DepotDisplay.ctrlSelectedSet.clear();
    selectedDepot.clear();
    // DepotDisplay.depotManager.notify();
  }

  void onRightMouseButton(TapDownDetails details, DepotManager depotManager, BuildContext context) {
    if (DepotDisplay.ctrlSelectedSet.isEmpty &&
        DepotDisplay.shiftSelectedSet.isEmpty &&
        selectedDepot.isEmpty) {
      return;
    }

    if (hoveredDepot != null &&
        DepotDisplay.ctrlSelectedSet.contains(hoveredDepot) == false &&
        DepotDisplay.shiftSelectedSet.contains(hoveredDepot) == false &&
        selectedDepot.contains(hoveredDepot!.mid) == false) {
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
              // DepotDisplay.depotManager.notify();
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
