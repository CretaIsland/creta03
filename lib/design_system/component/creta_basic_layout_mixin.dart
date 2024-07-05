import 'package:creta03/design_system/menu/creta_popup_menu.dart';
import 'package:creta_common/common/creta_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import '../../common/creta_utils.dart';

import '../../pages/studio/studio_variables.dart';
import 'creta_banner_pane.dart';
import 'creta_leftbar.dart';
//import 'creta_filter_pane.dart';
import 'creta_layout_rect.dart';

mixin CretaBasicLayoutMixin {
  ScrollController _bannerScrollController = ScrollController();
  double _bannerHeight = CretaConst.cretaBannerMinHeight;
  double _bannerPaneMaxHeight = CretaConst.cretaBannerMinHeight;
  double _bannerPaneMinHeight = CretaConst.cretaBannerMinHeight;
  double _scrollOffset = 0;
  bool _usingBannerScrollbar = false;
  void Function(bool)? _scrollChangedCallback;

  double get getBannerHeight => _bannerHeight;
  set setBannerHeight(val) => _bannerHeight = val;
  ScrollController get getBannerScrollController => _bannerScrollController;
  void setBannerScrollController(ScrollController sc) {
    _bannerScrollController = sc;
    _bannerScrollController.addListener(_scrollListener);
  }

  void setScrollOffset(double offset) {
    _scrollOffset = offset;
    if (_bannerScrollController.hasClients) {
      _bannerScrollController.jumpTo(_scrollOffset);
    }
  }

  void setUsingBannerScrollBar({
    required void Function(bool bannerSizeChanged) scrollChangedCallback,
    double bannerMaxHeight = CretaConst.cretaBannerMinHeight,
    double bannerMinHeight = CretaConst.cretaBannerMinHeight,
  }) {
    _bannerHeight = bannerMaxHeight;
    _bannerPaneMaxHeight = bannerMaxHeight;
    _bannerPaneMinHeight = bannerMinHeight;
    _usingBannerScrollbar = true;
    _bannerScrollController.addListener(_scrollListener);
    _scrollChangedCallback = scrollChangedCallback;
  }

  void _scrollListener() {
    // 스크롤 위치 저장
    _scrollOffset = _bannerScrollController.offset;
    // 스크롤에 따른 배너 높이 재설정
    //if (kDebugMode) print('_scrollOffset=$_scrollOffset');
    double bannerHeight = _bannerPaneMaxHeight - _bannerScrollController.offset;
    if (bannerHeight < _bannerPaneMinHeight) bannerHeight = _bannerPaneMinHeight;
    // 스크롤 변경 콜백
    _scrollChangedCallback?.call(bannerHeight != _bannerHeight);
    _bannerHeight = bannerHeight;
  }

  Size displaySize = Size.zero; // 전체 화면크기 (최상단 앱바 제외)
  CretaLayoutRect leftPaneRect = CretaLayoutRect.zero;
  CretaLayoutRect rightPaneRect = CretaLayoutRect.zero;
  CretaLayoutRect bannerPaneRect = CretaLayoutRect.zero;
  //CretaLayoutRect gridArea = CretaLayoutRect.zero;

  double paddingLeft = 0;

  void resize(
    BuildContext context, {
    bool isExistFilterOnBanner = true,
    double leftMarginOnRightPane = 0,
    double topMarginOnRightPane = 0,
    double rightMarginOnRightPane = 0,
    double bottomMarginOnRightPane = 0,
  }) {
    Size size = CretaUtils.getDisplaySize(context);
    // 전체 화면크기 (최상단 앱바 제외)
    //displaySize = Size(size.width, size.height - CretaComponentLocation.BarTop.height);
    displaySize =
        Size(size.width, size.height); // no Appbar anymore - CretaComponentLocation.BarTop.height);
    leftPaneRect = CretaLayoutRect.fromPadding(
      CretaComponentLocation.TabBar.width,
      displaySize.height,
      CretaComponentLocation.TabBar.padding.left,
      CretaComponentLocation.TabBar.padding.top,
      CretaComponentLocation.TabBar.padding.right,
      CretaComponentLocation.TabBar.padding.bottom,
    );
    rightPaneRect = CretaLayoutRect.fromPadding(
      displaySize.width - leftPaneRect.width - CretaConst.verticalAppbarWidth,
      displaySize.height,
      40, //CretaComponentLocation.TabBar.padding.left,
      _usingBannerScrollbar ? _bannerPaneMaxHeight : 0,
      40, //CretaComponentLocation.TabBar.padding.right,
      40, //CretaComponentLocation.TabBar.padding.bottom,
      leftMargin: leftMarginOnRightPane,
      topMargin: topMarginOnRightPane,
      rightMargin: rightMarginOnRightPane,
      bottomMargin: bottomMarginOnRightPane,
    );
    bannerPaneRect = CretaLayoutRect.fromPadding(
      rightPaneRect.width,
      _bannerHeight - 1,
      40,
      40,
      40,
      isExistFilterOnBanner ? CretaComponentLocation.TabBar.padding.bottom : 20,
    );
    // gridArea = CretaLayoutRect.fromPadding(
    //   rightPaneRect.width,
    //   rightPaneRect.height, // - CretaConst.cretaBannerMinHeight,
    //   40,
    //   40,
    //   40,
    //   40,
    // );
    //gridArea = Size(rightPaneArea.width, rightPaneArea.height - CretaConst.cretaBannerMinHeight);
    // logger.finest(
    //     'displayWidth=${StudioVariables.displayWidth}, displayHeight=${StudioVariables.displayHeight}');
    // logger.finest('topBannerArea=${topBannerArea.width}, ${topBannerArea.height}');
  }

  Widget getBannerPane({
    required double width,
    required double height,
    Key? key,
    String? title,
    String? description,
    List<List<CretaMenuItem>>? listOfListFilter,
    Widget Function(Size)? titlePane,
    bool? isSearchbarInBanner,
    bool? scrollbarOnRight,
    List<List<CretaMenuItem>>? listOfListFilterOnRight,
    void Function(String)? onSearch,
    double? leftPaddingOnFilter,
    List<CretaMenuItem>? tabMenuList,
  }) {
    return CretaBannerPane(
      key: key,
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
      tabMenuList: tabMenuList,
    );
  }

  Widget mainPage(
    BuildContext context, {
    Key? key,
    Key? bannerKey,
    required List<CretaMenuItem> leftMenuItemList,
    required Function gotoButtonPressed,
    required String gotoButtonTitle,
    required String bannerTitle,
    Function? gotoButtonPressed2,
    String? gotoButtonTitle2,
    required String bannerDescription,
    required List<List<CretaMenuItem>> listOfListFilter,
    required Widget Function(BuildContext) mainWidget,
    Widget Function(Size)? titlePane,
    Widget Function(Size)? bannerPane,
    void Function(String)? onSearch,
    bool isSearchbarInBanner = false,
    List<List<CretaMenuItem>>? listOfListFilterOnRight,
    Size gridMinArea = const Size(300, 300),
    double? leftPaddingOnFilter,
    double leftMarginOnRightPane = 0,
    double topMarginOnRightPane = 0,
    double rightMarginOnRightPane = 0,
    double bottomMarginOnRightPane = 0,
    List<CretaMenuItem>? tabMenuList,
    Function? onFoldButtonPressed,
    bool scrollbarOnRight = true,
  }) {
    //print('mainPage() called++++++++++++++++++++++++++++++++++');

    // cacluate pane-size
    resize(
      context,
      isExistFilterOnBanner: listOfListFilter.isNotEmpty ||
          (listOfListFilterOnRight?.isNotEmpty ?? false) ||
          (onSearch != null && isSearchbarInBanner == false),
      leftMarginOnRightPane: leftMarginOnRightPane,
      topMarginOnRightPane: topMarginOnRightPane,
      rightMarginOnRightPane: rightMarginOnRightPane,
      bottomMarginOnRightPane: bottomMarginOnRightPane,
    );
    //

    return Row(
      key: key,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CretaLeftBar(
          width: leftPaneRect.width,
          height: leftPaneRect.height,
          menuItem: leftMenuItemList,
          onFoldButtonPressed: onFoldButtonPressed,
          // gotoButtonPressed: gotoButtonPressed,
          // gotoButtonTitle: gotoButtonTitle,
          // gotoButtonPressed2: gotoButtonPressed2,
          // gotoButtonTitle2: gotoButtonTitle2,
        ),
        Container(
          width: rightPaneRect.width,
          height: rightPaneRect.height,
          color: Colors.white,
          child: _usingBannerScrollbar
              ? Stack(
                  children: [
                    // item pane
                    // rightPaneRect.childContainer(
                    //   color: Colors.white,
                    //   child: mainWidget(context),
                    // ),
                    Container(
                      color: Colors.white,
                      width: rightPaneRect.width,
                      height: rightPaneRect.height,
                      margin: EdgeInsets.fromLTRB(
                        leftMarginOnRightPane,
                        topMarginOnRightPane,
                        rightMarginOnRightPane,
                        bottomMarginOnRightPane,
                      ),
                      child: mainWidget(context),
                    ),
                    // banner pane (over on item pane)
                    Listener(
                      onPointerSignal: (PointerSignalEvent event) {
                        if (event is PointerScrollEvent && _bannerScrollController.hasClients) {
                          _scrollOffset += event.scrollDelta.dy;
                          if (_scrollOffset < 0) _scrollOffset = 0;
                          if (_scrollOffset > _bannerScrollController.position.maxScrollExtent) {
                            _scrollOffset = _bannerScrollController.position.maxScrollExtent;
                          }
                          _bannerScrollController.jumpTo(_scrollOffset);
                        }
                      },
                      child: (bannerPane != null)
                          ? bannerPane.call(bannerPaneRect.size)
                          : getBannerPane(
                              key: bannerKey,
                              width: bannerPaneRect.width,
                              height: bannerPaneRect.height,
                              title: bannerTitle,
                              description: bannerDescription,
                              listOfListFilter: listOfListFilter,
                              titlePane: titlePane,
                              isSearchbarInBanner: isSearchbarInBanner,
                              scrollbarOnRight: scrollbarOnRight,
                              listOfListFilterOnRight: listOfListFilterOnRight,
                              onSearch: onSearch,
                              leftPaddingOnFilter: leftPaddingOnFilter,
                              tabMenuList: tabMenuList,
                            ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // banner pane
                    StudioVariables.displayHeight >
                            bannerPaneRect.height + CretaComponentLocation.BarTop.height
                        ? getBannerPane(
                            key: bannerKey,
                            width: bannerPaneRect.width,
                            height: bannerPaneRect.height,
                            title: bannerTitle,
                            description: bannerDescription,
                            listOfListFilter: listOfListFilter,
                            isSearchbarInBanner: isSearchbarInBanner,
                            listOfListFilterOnRight: listOfListFilterOnRight,
                            onSearch: onSearch,
                            leftPaddingOnFilter: leftPaddingOnFilter,
                            tabMenuList: tabMenuList,
                          )
                        : const SizedBox.shrink(),
                    // child pane
                    rightPaneRect.childHeight > gridMinArea.height &&
                            rightPaneRect.childWidth > gridMinArea.width
                        ? rightPaneRect.childContainer(
                            color: Colors.white,
                            child: mainWidget(context),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
        ),
      ],
    );
  }
}
