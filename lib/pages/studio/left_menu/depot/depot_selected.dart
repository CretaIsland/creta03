import 'package:creta03/model/contents_model.dart';
import 'package:flutter/material.dart';

import '../../../../design_system/creta_color.dart';
import 'selection_manager.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

class DepotSelectedClass extends StatelessWidget {
  final Widget childContents;
  final double width;
  final double height;
  final ContentsModel contents;

  const DepotSelectedClass({
    required this.childContents,
    required this.width,
    required this.height,
    required this.contents,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: selectionStateManager),
      ],
      child: Consumer<SelectionStateManager>(
        builder: (context, selectionStateManager, child) {
          return InkWell(
            onHover: (isHover) {
              selectionStateManager.handleHover(isHover, contents.mid);
            },
            onTapDown: (details) {
              selectionStateManager.handleTap(details, contents);
            },
            onDoubleTap: () {
              selectionStateManager.clearMultiSelected();
            },
            onSecondaryTapDown: (details) {
              selectionStateManager.onRightMouseButton.call(details, contents, context);
            },
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                border: Border.all(
                  color: selectionStateManager.selectedContents.contains(contents.mid)
                      ? CretaColor.primary
                      : CretaColor.text[200]!,
                  width: selectionStateManager.selectedContents.contains(contents.mid)
                      ? 4
                      : selectionStateManager.hoveredContents.contains(contents.mid)
                          ? 4
                          : 1,
                ),
              ),
              child: Center(
                child: childContents,
              ),
            ),
          );
        },
      ),
    );
  }
}
