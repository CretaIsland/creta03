//import 'package:creta_studio_model/model/contents_model.dart';

import 'package:flutter/material.dart';
import '../../../../data_io/depot_manager.dart';
import '../../../../design_system/component/creta_right_mouse_menu.dart';
import 'package:creta_common/common/creta_color.dart';
import '../../../../design_system/menu/creta_popup_menu.dart';
import '../../../../lang/creta_studio_lang.dart';
import 'package:creta_studio_model/model/depot_model.dart';
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
  bool isSelected;

  DepotSelected({
    required this.depotManager,
    required this.childContents,
    required this.width,
    required this.height,
    required this.depot,
    required this.isSelected,
    super.key,
  });

  @override
  State<DepotSelected> createState() => _DepotSelectedState();
}

class _DepotSelectedState extends State<DepotSelected> {
  bool _isHover = false;

  @override
  Widget build(BuildContext context) {
    if (widget.depot == null) {
      return const SizedBox.shrink();
    }
    return InkWell(
      onHover: (isHover) {
        _isHover = isHover;
      },
      onTapDown: (details) {
        handleTap(details, widget.depot, widget.depotManager);
      },
      onDoubleTap: () {
        clearMultiSelected();
      },
      onSecondaryTapDown: (details) {
        onRightMouseButton.call(details, widget.depot, widget.depotManager, context);
      },
      child: Draggable(
        // Draggable 과 DragTarget 은 한쌍이다.  DragTarget 은 FrameEach Widget 에 있다.
        data: widget.depot,
        feedback: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.isSelected ? CretaColor.primary : Colors.transparent,
              width: widget.isSelected ? 3 : 1,
            ),
          ),
        ),
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.isSelected ? CretaColor.primary : Colors.transparent,
              width: widget.isSelected ? 3 : 1,
            ),
          ),
          child: Center(
            child: widget.childContents,
          ),
        ),
      ),
    );
  }

  void handleTap(TapDownDetails details, DepotModel? depotModel, DepotManager manager) {
    if (depotModel == null) {
      return;
    }
    if (StudioVariables.isCtrlPressed) {
      if (DepotDisplay.ctrlSelectedSet.contains(depotModel)) {
        DepotDisplay.ctrlSelectedSet.remove(depotModel);
        widget.isSelected = false;
      } else {
        DepotDisplay.ctrlSelectedSet.add(depotModel);
        widget.isSelected = !widget.isSelected;
      }
    } else if (StudioVariables.isShiftPressed) {
      // print('Shift key pressed');
      Map<String, int> gridIndexOfDepot = {};
      int currentSelectedIndex = -1;
      int firstSelectedIndex = -1;

      for (int i = 0; i < manager.filteredContents.length; i++) {
        if (manager.filteredContents[i].mid == depotModel.contentsMid) {
          gridIndexOfDepot[depotModel.contentsMid] = i;
          currentSelectedIndex = i;
          break;
        }
      }

      if (DepotDisplay.shiftSelectedSet.isEmpty) {
        for (int i = 0; i <= currentSelectedIndex; i++) {
          DepotModel? depot = manager.getModelByContentsMid(manager.filteredContents[i].mid);
          if (depot != null) {
            DepotDisplay.shiftSelectedSet.add(depot);
          }
        }
      } else {
        for (int i = 0; i < manager.filteredContents.length; i++) {
          if (manager.filteredContents[i].mid == DepotDisplay.shiftSelectedSet.first.contentsMid) {
            gridIndexOfDepot[depotModel.contentsMid] = i;
            firstSelectedIndex = i;
            break;
          }
        }
        int start =
            firstSelectedIndex < currentSelectedIndex ? firstSelectedIndex : currentSelectedIndex;

        int end =
            firstSelectedIndex < currentSelectedIndex ? currentSelectedIndex : firstSelectedIndex;
        for (int i = start; i <= end; i++) {
          DepotModel? depot = manager.getModelByContentsMid(manager.filteredContents[i].mid);
          if (depot != null) {
            DepotDisplay.shiftSelectedSet.add(depot);
          }
        }
      }
    } else {
      DepotDisplay.ctrlSelectedSet = {depotModel};
      DepotDisplay.shiftSelectedSet = {depotModel};
      // widget.isSelected = true;
      widget.isSelected = !widget.isSelected;
    }
    widget.depotManager.notify();
  }

  void clearMultiSelected() {
    DepotDisplay.ctrlSelectedSet.clear();
    DepotDisplay.shiftSelectedSet.clear();
    widget.depotManager.notify();
  }

  void onRightMouseButton(TapDownDetails details, DepotModel? depotModel, DepotManager depotManager,
      BuildContext context) {
    if (DepotDisplay.ctrlSelectedSet.isEmpty && DepotDisplay.shiftSelectedSet.isEmpty) {
      return;
    }

    if (_isHover &&
        DepotDisplay.ctrlSelectedSet.contains(depotModel) == false &&
        DepotDisplay.shiftSelectedSet.contains(depotModel) == false) {
      return;
    }

    CretaRightMouseMenu.showMenu(
      title: 'depotRightMouseMenu',
      context: context,
      popupMenu: [
        CretaMenuItem(
            caption: CretaStudioLang['tooltipDelete']!,
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

  int indexFor(DepotModel? selectedModel, Set<DepotModel> selectedSet) {
    if (selectedModel == null) {
      return -1;
    }

    final selectedList = selectedSet.toList();
    final selectedModelId = selectedModel.mid; // Replace with the actual identifier property

    for (int i = 0; i < selectedList.length; i++) {
      if (selectedList[i].mid == selectedModelId) {
        return i;
      }
    }

    return -1;
  }
}
