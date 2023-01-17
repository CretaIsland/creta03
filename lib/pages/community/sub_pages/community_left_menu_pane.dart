// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
//import 'dart:async';
import 'package:flutter/gestures.dart';
//import 'package:hycop/hycop.dart';
import 'package:hycop/common/util/logger.dart';
//import 'package:routemaster/routemaster.dart';
//import 'package:url_strategy/url_strategy.dart';
//import '../design_system/buttons/creta_button_wrapper.dart';
//import '../../design_system/component/snippet.dart';
//import '../../design_system/menu/creta_drop_down.dart';
//import '../../design_system/menu/creta_popup_menu.dart';
//import '../../design_system/text_field/creta_search_bar.dart';
//import '../design_system/creta_color.dart';
import 'package:image_network/image_network.dart';
import 'package:cached_network_image/cached_network_image.dart';
//import '../../common/cross_common_job.dart';
import '../../../routes.dart';
import '../../../design_system/component/creta_leftbar.dart';
import '../../../design_system/menu/creta_popup_menu.dart';

// const double _rightViewTopPane = 40;
// const double _rightViewLeftPane = 40;
// const double _rightViewRightPane = 40;
// const double _rightViewBottomPane = 40;
// const double _rightViewItemGapX = 20;
// const double _rightViewItemGapY = 20;
// const double _scrollbarWidth = 13;
// const double _rightViewBannerMaxHeight = 436;
// const double _rightViewBannerMinHeight = 188;
// const double _rightViewToolbarHeight = 76;
//
// const double _itemDefaultWidth = 290.0;
// const double _itemDefaultHeight = 256.0;
// const double _itemDescriptionHeight = 56;

//enum PopupMenuSampleItem { itemOne, itemTwo, itemThree }

//late bool isInUsingCanvaskit;

///////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////
class CommunityLeftMenuPane extends StatefulWidget {
  final String subPageUrl;
  final double width;
  final double height;
  const CommunityLeftMenuPane({super.key, required this.subPageUrl, required this.width, required this.height});

  @override
  State<CommunityLeftMenuPane> createState() => _CommunityLeftMenuPaneState();
}

class _CommunityLeftMenuPaneState extends State<CommunityLeftMenuPane> {
  late List<CretaMenuItem> _leftMenuItemList;

  @override
  void initState() {
    super.initState();

    _leftMenuItemList = [
      CretaMenuItem(caption: '커뮤니티 홈', iconData: Icons.home_outlined, onPressed: () {}, selected: false),
      CretaMenuItem(caption: '구독목록', iconData: Icons.local_library_outlined, onPressed: () {}, selected: false),
      CretaMenuItem(caption: '시청기록', iconData: Icons.article_outlined, onPressed: () {}, selected: false),
      CretaMenuItem(caption: '좋아요', iconData: Icons.favorite_outline, onPressed: () {}, selected: false),
      CretaMenuItem(caption: '재생목록', iconData: Icons.playlist_play, onPressed: () {}, selected: false),
    ];

    switch(widget.subPageUrl) {
    case AppRoutes.subscriptionList:
      _leftMenuItemList[1].selected = true;
    break;
    case AppRoutes.playList:
      _leftMenuItemList[4].selected = true;
    break;
    case AppRoutes.communityHome:
    default:
    _leftMenuItemList[0].selected = true;
    break;
    }
  }

  void _gotoButtonPressed() {
    //
    //
  }

  @override
  Widget build(BuildContext context) {
    return CretaLeftBar(
      width: widget.width,
      height: widget.height,
      menuItem: _leftMenuItemList,
      gotoButtonPressed: _gotoButtonPressed,
      gotoButtonTitle: '내 크레타북 관리',
    );
  }
}
