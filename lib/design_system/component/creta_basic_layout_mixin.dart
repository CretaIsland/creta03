import 'package:creta03/design_system/menu/creta_popup_menu.dart';
import 'package:flutter/material.dart';

import '../../pages/studio/studio_variables.dart';
import 'creta_banner_pane.dart';
import 'creta_leftbar.dart';
import 'snippet.dart';

mixin CretaBasicLayoutMixin {
  Size availArea = Size.zero;
  Size leftBarArea = Size.zero;
  Size rightPaneArea = Size.zero;
  Size topBannerArea = Size.zero;
  Size gridArea = Size.zero;

  void resize(BuildContext context) {
    StudioVariables.displayWidth = MediaQuery.of(context).size.width;
    StudioVariables.displayHeight = MediaQuery.of(context).size.height;
    availArea = Size(StudioVariables.displayWidth,
        StudioVariables.displayHeight - CretaComponentLocation.BarTop.height);
    leftBarArea = Size(CretaComponentLocation.TabBar.width, availArea.height);
    rightPaneArea = Size(StudioVariables.displayWidth - leftBarArea.width, availArea.height);
    topBannerArea = Size(rightPaneArea.width, cretaBannerMinHeight);
    gridArea = Size(rightPaneArea.width, rightPaneArea.height - cretaBannerMinHeight);
    // logger.finest(
    //     'displayWidth=${StudioVariables.displayWidth}, displayHeight=${StudioVariables.displayHeight}');
    // logger.finest('topBannerArea=${topBannerArea.width}, ${topBannerArea.height}');
  }

  Widget mainPage(
    BuildContext context, {
    required List<CretaMenuItem> leftMenuItemList,
    required Function gotoButtonPressed,
    required String gotoButtonTitle,
    required String bannerTitle,
    required String bannerDescription,
    required List<List<CretaMenuItem>> listOfListFilter,
    required Widget mainWidget,
    void Function(String)? onSearch,
    Size gridMinArea = const Size(300, 300),
  }) {
    resize(context);
    return Row(
      children: [
        CretaLeftBar(
          width: leftBarArea.width,
          height: leftBarArea.height,
          menuItem: leftMenuItemList,
          gotoButtonPressed: gotoButtonPressed,
          gotoButtonTitle: gotoButtonTitle,
        ),
        Container(
          width: rightPaneArea.width,
          height: rightPaneArea.height,
          color: Colors.white,
          child: Column(
            children: [
              StudioVariables.displayHeight >
                      topBannerArea.height + CretaComponentLocation.BarTop.height
                  ? CretaBannerPane(
                      width: topBannerArea.width,
                      height: topBannerArea.height,
                      color: Colors.white,
                      title: bannerTitle,
                      description: bannerDescription,
                      listOfListFilter: listOfListFilter,
                      onSearch: onSearch,
                    )
                  : Container(),
              gridArea.height > gridMinArea.height && gridArea.width > gridMinArea.width
                  ? Container(
                      color: Colors.white,
                      width: gridArea.width,
                      height: gridArea.height,
                      child: mainWidget,
                    )
                  : Container()
            ],
          ),
        ),
      ],
    );
  }
}
