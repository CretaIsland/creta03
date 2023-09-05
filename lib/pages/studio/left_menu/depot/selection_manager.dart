import 'package:flutter/material.dart';
import 'package:hycop/hycop/account/account_manager.dart';
import '../../../../data_io/depot_manager.dart';
import '../../../../design_system/component/creta_right_mouse_menu.dart';
import '../../../../design_system/menu/creta_popup_menu.dart';
import '../../../../lang/creta_studio_lang.dart';
import '../../../../model/contents_model.dart';
import '../../studio_variables.dart';
import 'depot_display.dart';

SelectionStateManager selectionStateManager = SelectionStateManager();

class SelectionStateManager extends ChangeNotifier {
  bool isSelected = false;
  List<String> selectedContents = [];
  String hoveredContents = ''; // Store the hovered content

  void handleHover(bool hover, String contentsModel) {
    if (hover) {
      hoveredContents = contentsModel; // Update the hoveredContents
    } else {
      hoveredContents = ''; // Reset hoveredContents when not hovered
    }
    notifyListeners();
  }

  void handleTap(TapDownDetails details, ContentsModel contentsModel) {
    if (StudioVariables.isCtrlPressed) {
      // print("Ctrl key pressed");
      if (DepotDisplayClass.ctrlSelectedSet.contains(contentsModel)) {
        DepotDisplayClass.ctrlSelectedSet.remove(contentsModel.mid);
        isSelected = false;
        selectedContents.remove(contentsModel.mid);
        notifyListeners();
      } else {
        DepotDisplayClass.ctrlSelectedSet.add(contentsModel);
        isSelected = true;
        selectedContents.add(contentsModel.mid);
        notifyListeners();
      }
    } else {
      // print("Ctrl key released");
      DepotDisplayClass.ctrlSelectedSet = {contentsModel};
      selectedContents.clear();
      selectedContents.add(contentsModel.mid);
      // isSelected = true;
      isSelected = !isSelected;
      notifyListeners();
    }
  }

  void clearMultiSelected() {
    DepotDisplayClass.ctrlSelectedSet.clear();
    selectedContents.clear();
    notifyListeners();
  }

  void onRightMouseButton(TapDownDetails details, ContentsModel contents, BuildContext context) {
    CretaRightMouseMenu.showMenu(
      title: 'frameRightMouseMenu',
      context: context,
      popupMenu: [
        CretaMenuItem(
            caption: CretaStudioLang.tooltipDelete,
            onPressed: () {
              DepotManager depotManager =
                  DepotManager(userEmail: AccountManager.currentLoginUser.email);
              Set<ContentsModel> targetList = DepotDisplayClass.ctrlSelectedSet;
              if (DepotDisplayClass.shiftSelectedSet.isNotEmpty) {
                targetList.addAll(DepotDisplayClass.shiftSelectedSet);
              }
              if (targetList.isEmpty) {
                _removeFromDepot(depotManager, contents);
              }
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
    notifyListeners();
  }

  void _removeFromDepot(DepotManager depotManager, ContentsModel contents) async {}
}
