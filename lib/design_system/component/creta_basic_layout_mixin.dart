import 'package:creta03/design_system/menu/creta_popup_menu.dart';
import 'package:flutter/foundation.dart';
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
  void setScrollOffset(double offset) {
    _scrollOffset = 0;
    _bannerScrollController.jumpTo(_scrollOffset);
  }

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
    if (kDebugMode) print('_scrollOffset=$_scrollOffset');
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

  double paddingLeft = 0;

  void resize(
    BuildContext context, {
    double leftPaddingOnRightPane = 0,
    double topPaddingOnRightPane = 0,
    double rightPaddingOnRightPane = 0,
    double bottomPaddingOnRightPane = 0,
  }) {
    CretaUtils.getDisplaySize(context);
    availArea =
        Size(StudioVariables.displayWidth, StudioVariables.displayHeight - CretaComponentLocation.BarTop.height);
    leftBarArea = Size(CretaComponentLocation.TabBar.width, availArea.height);
    rightPaneArea = Size(
        StudioVariables.displayWidth - leftBarArea.width - leftPaddingOnRightPane - rightPaddingOnRightPane,
        availArea.height - topPaddingOnRightPane - bottomPaddingOnRightPane);
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
    double? leftPaddingOnFilter,
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
      leftPaddingOnFilter: leftPaddingOnFilter,
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
    double? leftPaddingOnFilter,
    double leftPaddingOnRightPane = 0,
    double topPaddingOnRightPane = 0,
    double rightPaddingOnRightPane = 0,
    double bottomPaddingOnRightPane = 0,
  }) {
    // cacluate pane-size
    resize(
      context,
      leftPaddingOnRightPane: leftPaddingOnRightPane,
      topPaddingOnRightPane: topPaddingOnRightPane,
      rightPaddingOnRightPane: rightPaddingOnRightPane,
      bottomPaddingOnRightPane: bottomPaddingOnRightPane,
    );
    //
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
              ? Stack(
                  children: [
                    Container(
                      color: Colors.white,
                      width: rightPaneArea.width,
                      height: rightPaneArea.height,
                      padding: EdgeInsets.fromLTRB(
                        leftPaddingOnRightPane,
                        topPaddingOnRightPane,
                        rightPaddingOnRightPane,
                        bottomPaddingOnRightPane,
                      ),
                      child: mainWidget,
                    ),
                    Listener(
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
                      child: getBannerPane(
                        width: topBannerArea.width,
                        height: topBannerArea.height,
                        title: bannerTitle,
                        description: bannerDescription,
                        listOfListFilter: listOfListFilter,
                        titlePane: titlePane,
                        isSearchbarInBanner: isSearchbarInBanner,
                        scrollbarOnRight: true,
                        listOfListFilterOnRight: listOfListFilterOnRight,
                        onSearch: onSearch,
                        leftPaddingOnFilter: leftPaddingOnFilter,
                      ),
                    ),
                  ],
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
                            leftPaddingOnFilter: leftPaddingOnFilter,
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
