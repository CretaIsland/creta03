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
      if (selectedDepot.isEmpty) {
        debugPrint('DepotDisplay.shiftSelectedSet is Empty');
        // Find the currentIndex
        int currentIndex = selectedDepot.indexOf(depotModel.mid);
        // print('currentIndex $currentIndex');

        if (currentIndex != -1) {
          selectedDepot.clear();
          // Add items in the range from index 0 to the current index
          // for (int i = 0; i <= currentIndex; i++) {
          //   isSelected = true;
          //   String itemMid = selectedDepot[i];
          //   DepotDisplay.shiftSelectedSet.add(itemMid as DepotModel);
          //   selectedDepot.add(itemMid);
          // }
        }
      } else {
        isSelected = true;
        // Select a range of items between the first selected item and the current selected item
        int startIndex = selectedDepot.indexOf('0');
        int endIndex = selectedDepot.indexOf(depotModel.mid);
        // print('startIndex $startIndex');
        // print('endIndex $endIndex');
        // Check if the elements are found in the list
        if (startIndex != -1 && endIndex != -1) {
          // Clear the current selection and add items in the range
          DepotDisplay.shiftSelectedSet.clear();
          selectedDepot.clear();

          // for (int i = startIndex; i <= endIndex; i++) {
          //   DepotDisplay.shiftSelectedSet.add(selectedDepot[i]);
          // }
          List<String> rangeSelection = selectedDepot.sublist(startIndex, endIndex + 1);
          selectedDepot.addAll(rangeSelection);
        }
      }
    } else {
      // print("Ctrl key released");
      DepotDisplay.ctrlSelectedSet = {depotModel};
      selectedDepot.clear();
      selectedDepot.add(depotModel.mid);
      // isSelected = true;
      isSelected = !isSelected;
    }
    DepotDisplay.depotManager.notify();
  }

  void clearMultiSelected() {
    DepotDisplay.ctrlSelectedSet.clear();
    selectedDepot.clear();
    DepotDisplay.depotManager.notify();
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
              DepotDisplay.depotManager.notify();
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
