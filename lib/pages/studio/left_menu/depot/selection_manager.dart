import 'package:flutter/material.dart';
import '../../../../data_io/depot_manager.dart';
import '../../../../design_system/component/creta_right_mouse_menu.dart';
import '../../../../design_system/menu/creta_popup_menu.dart';
import '../../../../lang/creta_studio_lang.dart';
//import '../../../../model/contents_model.dart';
import '../../../../model/contents_model.dart';
import '../../../../model/depot_model.dart';
import '../../studio_variables.dart';
import 'depot_display.dart';

SelectionStateManager selectionStateManager = SelectionStateManager();

class SelectionStateManager extends ChangeNotifier {
  bool isSelected = false;
  List<String> selectedContents = [];
  String hoveredContents = ''; // Store the hovered content
  //List<String> deletedContents = [];

  static List<ContentsModel> filteredContents = [];

  void handleHover(bool hover, String contentsModel) {
    if (hover) {
      hoveredContents = contentsModel; // Update the hoveredContents
    } else {
      hoveredContents = ''; // Reset hoveredContents when not hovered
    }
    //notifyListeners();
  }

  void handleTap(TapDownDetails details, DepotModel depotModel) {
    if (StudioVariables.isCtrlPressed) {
      // print("Ctrl key pressed");
      if (DepotDisplayClass.ctrlSelectedSet.contains(depotModel)) {
        // DepotDisplayClass.ctrlSelectedSet.remove(contentsModel.mid);
        DepotDisplayClass.ctrlSelectedSet.remove(depotModel);
        isSelected = false;
        selectedContents.remove(depotModel.mid);
      } else {
        isSelected = true;
        DepotDisplayClass.ctrlSelectedSet.add(depotModel);
        selectedContents.add(depotModel.mid);
      }
    } else if (StudioVariables.isShiftPressed) {
      debugPrint('Shift key pressed');
      if (selectedContents.isEmpty) {
        debugPrint('DepotDisplayClass.shiftSelectedSet is Empty');
        // Find the currentIndex
        int currentIndex = selectedContents.indexOf(depotModel.mid);
        // print('currentIndex $currentIndex');

        if (currentIndex != -1) {
          selectedContents.clear();
          // Add items in the range from index 0 to the current index
          // for (int i = 0; i <= currentIndex; i++) {
          //   isSelected = true;
          //   String itemMid = selectedContents[i];
          //   DepotDisplayClass.shiftSelectedSet.add(itemMid as DepotModel);
          //   selectedContents.add(itemMid);
          // }
        }
      } else {
        isSelected = true;
        // Select a range of items between the first selected item and the current selected item
        int startIndex = selectedContents.indexOf('0');
        int endIndex = selectedContents.indexOf(depotModel.mid);
        // print('startIndex $startIndex');
        // print('endIndex $endIndex');
        // Check if the elements are found in the list
        if (startIndex != -1 && endIndex != -1) {
          // Clear the current selection and add items in the range
          DepotDisplayClass.shiftSelectedSet.clear();
          selectedContents.clear();

          // for (int i = startIndex; i <= endIndex; i++) {
          //   DepotDisplayClass.shiftSelectedSet.add(selectedContents[i]);
          // }
          List<String> rangeSelection = selectedContents.sublist(startIndex, endIndex + 1);
          selectedContents.addAll(rangeSelection);
        }
      }
    } else {
      // print("Ctrl key released");
      DepotDisplayClass.ctrlSelectedSet = {depotModel};
      selectedContents.clear();
      selectedContents.add(depotModel.mid);
      // isSelected = true;
      isSelected = !isSelected;
    }
    notifyListeners();
  }

  void clearMultiSelected() {
    DepotDisplayClass.ctrlSelectedSet.clear();
    selectedContents.clear();
    notifyListeners();
  }

  void onRightMouseButton(TapDownDetails details, DepotManager depotManager, BuildContext context) {
    debugPrint('remove from depot DB');
    if (DepotDisplayClass.ctrlSelectedSet.isEmpty &&
        DepotDisplayClass.shiftSelectedSet.isEmpty &&
        selectedContents.isEmpty) {
      return;
    }

    CretaRightMouseMenu.showMenu(
      title: 'depotRightMouseMenu',
      context: context,
      popupMenu: [
        CretaMenuItem(
            caption: CretaStudioLang.tooltipDelete,
            onPressed: () async {
              Set<DepotModel> targetList = DepotDisplayClass.ctrlSelectedSet;
              if (DepotDisplayClass.shiftSelectedSet.isNotEmpty) {
                targetList.addAll(DepotDisplayClass.shiftSelectedSet);
                //eletedContents.remove(contents.mid);
              }
              for (var ele in targetList) {
                await depotManager.removeDepots(ele);
                //deletedContents.remove(contents.mid);
              }
              notifyListeners();
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

  static void removeContents(String contentsMid) {
    ContentsModel? target;
    for (var ele in filteredContents) {
      if (ele.mid == contentsMid) {
        target = ele;
        break;
      }
    }
    if (target != null) {
      filteredContents.remove(target);
    }
  }
}
