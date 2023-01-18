// ignore_for_file: prefer_const_constructors

import 'package:creta03/pages/community/sub_pages/community_right_home_pane.dart';
import 'package:flutter/material.dart';
//import 'dart:async';
//import 'package:flutter/gestures.dart';
//import 'package:hycop/hycop.dart';
//import 'package:hycop/common/util/logger.dart';
//import 'package:routemaster/routemaster.dart';
//import 'package:url_strategy/url_strategy.dart';
//import '../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/component/snippet.dart';
//import '../../design_system/menu/creta_drop_down.dart';
//import '../../design_system/menu/creta_popup_menu.dart';
//import '../../design_system/text_field/creta_search_bar.dart';
//import '../design_system/creta_color.dart';
//import 'package:image_network/image_network.dart';
//import 'package:cached_network_image/cached_network_image.dart';
//import '../../common/cross_common_job.dart';
import '../../routes.dart';
import 'sub_pages/community_left_menu_pane.dart';

class CommunityPage extends StatefulWidget {
  final String subPageUrl;
  const CommunityPage({super.key, this.subPageUrl = ''});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  void initState() {
    super.initState();
  }

  Widget _getLeftPane(Size size) {
    return CommunityLeftMenuPane(
      subPageUrl: widget.subPageUrl,
      pageWidth: size.width,
      pageHeight: size.height,
    );
  }

  Widget _getRightPane(Size size) {
    switch (widget.subPageUrl) {
      case AppRoutes.subscriptionList:
        return CommunityRightHomePane(
          subPageUrl: widget.subPageUrl,
          pageWidth: size.width,
          pageHeight: size.height,
        );
      case AppRoutes.playList:
        return CommunityRightHomePane(
          subPageUrl: widget.subPageUrl,
          pageWidth: size.width,
          pageHeight: size.height,
        );
      case AppRoutes.communityHome:
      default:
        return CommunityRightHomePane(
          subPageUrl: widget.subPageUrl,
          pageWidth: size.width,
          pageHeight: size.height,
        );
    }
  }

  Size _leftPaneSize = Size.zero;
  Size _rightPaneSize = Size.zero;

  void _resizePane(BuildContext context) {
    double pageWidth = MediaQuery.of(context).size.width;
    double pageHeight = MediaQuery.of(context).size.height - CretaComponentLocation.BarTop.height;
    _leftPaneSize = Size(CretaComponentLocation.TabBar.width, pageHeight);
    _rightPaneSize = Size(pageWidth - CretaComponentLocation.TabBar.width, pageHeight);
  }

  Widget _mainPage(BuildContext context) {
    _resizePane(context);
    return SizedBox(
      child: Row(
        children: [
          _getLeftPane(_leftPaneSize),
          _getRightPane(_rightPaneSize),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Snippet.CretaScaffoldOfCommunity(
      //title: Text('Community page'),
      title: Row(
        children: const [
          SizedBox(
            width: 24,
          ),
          Image(
            image: AssetImage('assets/creta_logo_blue.png'),
            //width: 120,
            height: 20,
          ),
        ],
      ),
      context: context,
      child: _mainPage(context),
    );
  }
}
