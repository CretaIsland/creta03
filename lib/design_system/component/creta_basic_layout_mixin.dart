import 'package:creta03/design_system/menu/creta_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import '../../common/creta_utils.dart';
import '../../pages/studio/studio_constant.dart';
import '../../pages/studio/studio_variables.dart';
import 'creta_banner_pane.dart';
import 'creta_leftbar.dart';
import 'snippet.dart';
//import 'creta_filter_pane.dart';

mixin CretaBasicLayoutMixin {
  final ScrollController _bannerScrollController = ScrollController();
  double _bannerHeight = LayoutConst.cretaBannerMinHeight;
  double _topPaneMaxHeight = LayoutConst.cretaBannerMinHeight;
  double _topPaneMinHeight = LayoutConst.cretaBannerMinHeight;
  double _scrollOffset = 0;
  bool _usingBannerScrollbar = false;
  void Function(bool)? _scrollChangedCallback;

  double get getBannerHeight => _bannerHeight;
  ScrollController get getBannerScrollController => _bannerScrollController;

  void setUsingBannerScrollBar({
    required void Function(bool bannerSizeChanged) scrollChangedCallback,
    double bannerMaxHeight = LayoutConst.cretaBannerMinHeight,
    double bannerMinHeight = LayoutConst.cretaBannerMinHeight,
  }) {
    _bannerHeight = bannerMaxHeight;
    _topPaneMaxHeight = bannerMaxHeight;
    _topPaneMinHeight = bannerMinHeight;
    _usingBannerScrollbar = true;
    _bannerScrollController.addListener(_scrollListener);
    _scrollChangedCallback = scrollChangedCallback;
  }

  void _scrollListener() {
    // 스크롤 위치 저장
    _scrollOffset = _bannerScrollController.offset;
    // 스크롤에 따른 배너 높이 재설정
    double bannerHeight = _topPaneMaxHeight - _bannerScrollController.offset;
    if (bannerHeight < _topPaneMinHeight) bannerHeight = _topPaneMinHeight;
    // 스크롤 변경 콜백
    if (_scrollChangedCallback != null) _scrollChangedCallback!.call(bannerHeight != _bannerHeight);
    _bannerHeight = bannerHeight;
  }

  Size availArea = Size.zero;
  Size leftBarArea = Size.zero;
  Size rightPaneArea = Size.zero;
  Size topBannerArea = Size.zero;
  Size gridArea = Size.zero;

  void resize(BuildContext context) {
    CretaUtils.getDisplaySize(context);
    availArea =
        Size(StudioVariables.displayWidth, StudioVariables.displayHeight - CretaComponentLocation.BarTop.height);
    leftBarArea = Size(CretaComponentLocation.TabBar.width, availArea.height);
    rightPaneArea = Size(StudioVariables.displayWidth - leftBarArea.width, availArea.height);
    topBannerArea = Size(rightPaneArea.width, _bannerHeight);
    gridArea = Size(rightPaneArea.width, rightPaneArea.height - LayoutConst.cretaBannerMinHeight);
    // logger.finest(
    //     'displayWidth=${StudioVariables.displayWidth}, displayHeight=${StudioVariables.displayHeight}');
    // logger.finest('topBannerArea=${topBannerArea.width}, ${topBannerArea.height}');
  }

  Widget getBannerPane({
    required double width,
    required double height,
    String? title,
    String? description,
    List<List<CretaMenuItem>>? listOfListFilter,
    Widget Function(Size)? titlePane,
    bool? isSearchbarInBanner,
    bool? scrollbarOnRight,
    List<List<CretaMenuItem>>? listOfListFilterOnRight,
    void Function(String)? onSearch,
    double? leftPaddingOfFilter,
  }) {
    return CretaBannerPane(
      width: width,
      height: height,
      color: Colors.white,
      title: title ?? '',
      description: description ?? '',
      listOfListFilter: listOfListFilter ?? [],
      titlePane: titlePane,
      isSearchbarInBanner: isSearchbarInBanner,
      scrollbarOnRight: scrollbarOnRight,
      listOfListFilterOnRight: listOfListFilterOnRight,
      onSearch: onSearch,
      leftPaddingOfFilter: leftPaddingOfFilter,
    );
  }

  Widget mainPage(
    BuildContext context, {
    Key? key,
    required List<CretaMenuItem> leftMenuItemList,
    required Function gotoButtonPressed,
    required String gotoButtonTitle,
    required String bannerTitle,
    required String bannerDescription,
    required List<List<CretaMenuItem>> listOfListFilter,
    required Widget mainWidget,
    Widget Function(Size)? titlePane,
    void Function(String)? onSearch,
    bool isSearchbarInBanner = false,
    List<List<CretaMenuItem>>? listOfListFilterOnRight,
    Size gridMinArea = const Size(300, 300),
    double? leftPaddingOfFilter,
  }) {
    resize(context);
    //topBannerArea = Size(topBannerArea.width, topBannerArea.height - (leftPaddingOfFilter == null ? 0 : 76));
    return Row(
      key: key,
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
          child: _usingBannerScrollbar
              ? Listener(
                  onPointerSignal: (PointerSignalEvent event) {
                    if (event is PointerScrollEvent) {
                      _scrollOffset += event.scrollDelta.dy;
                      if (_scrollOffset < 0) _scrollOffset = 0;
                      if (_scrollOffset > _bannerScrollController.position.maxScrollExtent) {
                        _scrollOffset = _bannerScrollController.position.maxScrollExtent;
                      }
                      _bannerScrollController.jumpTo(_scrollOffset);
                    }
                  },
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.white,
                        width: rightPaneArea.width,
                        height: rightPaneArea.height,
                        child: mainWidget,
                      ),
                      getBannerPane(
                        width: topBannerArea.width,
                        height: topBannerArea.height,
                        title: bannerTitle,
                        description: bannerDescription,
                        listOfListFilter: listOfListFilter,//(leftPaddingOfFilter != null) ? [] : listOfListFilter,
                        titlePane: titlePane,
                        isSearchbarInBanner: isSearchbarInBanner,
                        scrollbarOnRight: true,
                        listOfListFilterOnRight: listOfListFilterOnRight,//(leftPaddingOfFilter != null) ? null : listOfListFilterOnRight,
                        onSearch: onSearch,//(leftPaddingOfFilter != null) ? null : onSearch,
                        leftPaddingOfFilter: leftPaddingOfFilter,
                      ),
                      // (leftPaddingOfFilter == null)
                      //     ? const SizedBox.shrink()
                      //     : Positioned(
                      //         left: leftPaddingOfFilter,
                      //         top: topBannerArea.height - 20,
                      //         child: SizedBox(
                      //           width: topBannerArea.width - leftPaddingOfFilter - LayoutConst.cretaScrollbarWidth,
                      //           height: LayoutConst.cretaTopFilterHeight - 20,
                      //           child: CretaFilterPane(
                      //             width: topBannerArea.width - leftPaddingOfFilter - LayoutConst.cretaScrollbarWidth,
                      //             height: LayoutConst.cretaTopFilterHeight,
                      //             listOfListFilter: listOfListFilter,
                      //             onSearch: onSearch,
                      //             listOfListFilterOnRight: listOfListFilterOnRight,
                      //             rowCrossAxisAlignment: CrossAxisAlignment.start,
                      //           ),
                      //         ),
                      //       ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    StudioVariables.displayHeight > topBannerArea.height + CretaComponentLocation.BarTop.height
                        ? getBannerPane(
                            width: topBannerArea.width,
                            height: topBannerArea.height,
                            title: bannerTitle,
                            description: bannerDescription,
                            listOfListFilter: listOfListFilter,
                            isSearchbarInBanner: isSearchbarInBanner,
                            listOfListFilterOnRight: listOfListFilterOnRight,
                            onSearch: onSearch,
                            leftPaddingOfFilter: leftPaddingOfFilter,
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
