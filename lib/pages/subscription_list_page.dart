// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
//import 'dart:async';
import 'dart:ui';
//import 'package:hycop/hycop.dart';
import 'package:hycop/common/util/logger.dart';
//import 'package:routemaster/routemaster.dart';
//import 'package:url_strategy/url_strategy.dart';
//import '../design_system/buttons/creta_button_wrapper.dart';
import '../design_system/component/snippet.dart';
//import '../design_system/menu/creta_drop_down.dart';
import '../design_system/menu/creta_popup_menu.dart';
//import '../design_system/text_field/creta_search_bar.dart';
//import '../design_system/creta_color.dart';
import 'community_home_page.dart';

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

// const double _itemDefaultWidth = 290.0;
// const double _itemDefaultHeight = 256.0;
const double _itemDescriptionHeight = 56;

class SubscriptionListPage extends StatefulWidget {
  const SubscriptionListPage({super.key});

  @override
  State<SubscriptionListPage> createState() => _SubscriptionListPageState();
}

class _SubscriptionListPageState extends State<SubscriptionListPage> {
  late ScrollController _controller;
  late List<CretaMenuItem> _leftMenuItemList;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);

    _leftMenuItemList = [
      CretaMenuItem(
          caption: '커뮤니티 홈', iconData: Icons.home_outlined, onPressed: () {}, selected: true),
      CretaMenuItem(
          caption: '구독목록',
          iconData: Icons.local_library_outlined,
          onPressed: () {},
          selected: false),
      CretaMenuItem(
          caption: '시청기록', iconData: Icons.article_outlined, onPressed: () {}, selected: false),
      CretaMenuItem(
          caption: '좋아요', iconData: Icons.favorite_outline, onPressed: () {}, selected: false),
      CretaMenuItem(
          caption: '재생목록', iconData: Icons.playlist_play, onPressed: () {}, selected: false),
    ];
  }

  //double headerSize = _rightViewBannerMaxHeight;
  double scrollOffset = 0;
  void _scrollListener() {
    //print('offet=${_controller.offset}, max=${_controller.position.maxScrollExtent}');
    // setState(() {
    //   scrollOffset = _controller.offset;
    //   headerSize = _rightViewBannerMaxHeight - _controller.offset;
    //   if (headerSize < _rightViewBannerMinHeight) headerSize = _rightViewBannerMinHeight;
    // });
  }

  Widget _getLeftPane(double height) {
    return Snippet.CretaTabBar(_leftMenuItemList, height);
  }

  // int _random(int min, int max) {
  //   return min + Random().nextInt(max - min);
  // }

  String _currentOpenedBookTitle = '';

  List<String> splitByCharacter(String text) {
    //RegEx from: https://github.com/i-Naji/emojis
    final regex = RegExp(
        '(\u{D83C}\u{DFF4}\u{DB40}\u{DC67}\u{DB40}\u{DC62}(?:\u{DB40}\u{DC77}\u{DB40}\u{DC6C}\u{DB40}\u{DC73}|\u{DB40}\u{DC73}\u{DB40}\u{DC63}\u{DB40}\u{DC74}|\u{DB40}\u{DC65}\u{DB40}\u{DC6E}\u{DB40}\u{DC67})\u{DB40}\u{DC7F}|\u{D83D}\u{DC69}\u{200D}\u{D83D}\u{DC69}\u{200D}(?:\u{D83D}\u{DC66}\u{200D}\u{D83D}\u{DC66}|\u{D83D}\u{DC67}\u{200D}(?:\u{D83D}[\u{DC66}\u{DC67}]))|\u{D83D}\u{DC68}(?:\u{D83C}\u{DFFF}\u{200D}(?:\u{D83E}\u{DD1D}\u{200D}\u{D83D}\u{DC68}(?:\u{D83C}[\u{DFFB}-\u{DFFE}])|\u{D83C}[\u{DF3E}\u{DF73}\u{DF7C}\u{DF93}\u{DFA4}\u{DFA8}\u{DFEB}\u{DFED}]|\u{D83D}[\u{DCBB}\u{DCBC}\u{DD27}\u{DD2C}\u{DE80}\u{DE92}]|\u{D83E}[\u{DDAF}-\u{DDB3}\u{DDBC}\u{DDBD}])|\u{D83C}\u{DFFE}\u{200D}(?:\u{D83E}\u{DD1D}\u{200D}\u{D83D}\u{DC68}(?:\u{D83C}[\u{DFFB}-\u{DFFD}\u{DFFF}])|\u{D83C}[\u{DF3E}\u{DF73}\u{DF7C}\u{DF93}\u{DFA4}\u{DFA8}\u{DFEB}\u{DFED}]|\u{D83D}[\u{DCBB}\u{DCBC}\u{DD27}\u{DD2C}\u{DE80}\u{DE92}]|\u{D83E}[\u{DDAF}-\u{DDB3}\u{DDBC}\u{DDBD}])|\u{D83C}\u{DFFD}\u{200D}(?:\u{D83E}\u{DD1D}\u{200D}\u{D83D}\u{DC68}(?:\u{D83C}[\u{DFFB}\u{DFFC}\u{DFFE}\u{DFFF}])|\u{D83C}[\u{DF3E}\u{DF73}\u{DF7C}\u{DF93}\u{DFA4}\u{DFA8}\u{DFEB}\u{DFED}]|\u{D83D}[\u{DCBB}\u{DCBC}\u{DD27}\u{DD2C}\u{DE80}\u{DE92}]|\u{D83E}[\u{DDAF}-\u{DDB3}\u{DDBC}\u{DDBD}])|\u{D83C}\u{DFFC}\u{200D}(?:\u{D83E}\u{DD1D}\u{200D}\u{D83D}\u{DC68}(?:\u{D83C}[\u{DFFB}\u{DFFD}-\u{DFFF}])|\u{D83C}[\u{DF3E}\u{DF73}\u{DF7C}\u{DF93}\u{DFA4}\u{DFA8}\u{DFEB}\u{DFED}]|\u{D83D}[\u{DCBB}\u{DCBC}\u{DD27}\u{DD2C}\u{DE80}\u{DE92}]|\u{D83E}[\u{DDAF}-\u{DDB3}\u{DDBC}\u{DDBD}])|\u{D83C}\u{DFFB}\u{200D}(?:\u{D83E}\u{DD1D}\u{200D}\u{D83D}\u{DC68}(?:\u{D83C}[\u{DFFC}-\u{DFFF}])|\u{D83C}[\u{DF3E}\u{DF73}\u{DF7C}\u{DF93}\u{DFA4}\u{DFA8}\u{DFEB}\u{DFED}]|\u{D83D}[\u{DCBB}\u{DCBC}\u{DD27}\u{DD2C}\u{DE80}\u{DE92}]|\u{D83E}[\u{DDAF}-\u{DDB3}\u{DDBC}\u{DDBD}])|\u{200D}(?:\u{2764}\u{FE0F}\u{200D}(?:\u{D83D}\u{DC8B}\u{200D})?\u{D83D}\u{DC68}|(?:\u{D83D}[\u{DC68}\u{DC69}])\u{200D}(?:\u{D83D}\u{DC66}\u{200D}\u{D83D}\u{DC66}|\u{D83D}\u{DC67}\u{200D}(?:\u{D83D}[\u{DC66}\u{DC67}]))|\u{D83D}\u{DC66}\u{200D}\u{D83D}\u{DC66}|\u{D83D}\u{DC67}\u{200D}(?:\u{D83D}[\u{DC66}\u{DC67}])|(?:\u{D83D}[\u{DC68}\u{DC69}])\u{200D}(?:\u{D83D}[\u{DC66}\u{DC67}])|[\u{2695}\u{2696}\u{2708}]\u{FE0F}|\u{D83D}[\u{DC66}\u{DC67}]|\u{D83C}[\u{DF3E}\u{DF73}\u{DF7C}\u{DF93}\u{DFA4}\u{DFA8}\u{DFEB}\u{DFED}]|\u{D83D}[\u{DCBB}\u{DCBC}\u{DD27}\u{DD2C}\u{DE80}\u{DE92}]|\u{D83E}[\u{DDAF}-\u{DDB3}\u{DDBC}\u{DDBD}])|(?:\u{D83C}\u{DFFF}\u{200D}[\u{2695}\u{2696}\u{2708}]|\u{D83C}\u{DFFE}\u{200D}[\u{2695}\u{2696}\u{2708}]|\u{D83C}\u{DFFD}\u{200D}[\u{2695}\u{2696}\u{2708}]|\u{D83C}\u{DFFC}\u{200D}[\u{2695}\u{2696}\u{2708}]|\u{D83C}\u{DFFB}\u{200D}[\u{2695}\u{2696}\u{2708}])\u{FE0F}|\u{D83C}[\u{DFFB}-\u{DFFF}])|\u{D83E}\u{DDD1}(?:(?:\u{D83C}[\u{DFFB}-\u{DFFF}])\u{200D}(?:\u{D83E}\u{DD1D}\u{200D}\u{D83E}\u{DDD1}(?:\u{D83C}[\u{DFFB}-\u{DFFF}])|\u{D83C}[\u{DF3E}\u{DF73}\u{DF7C}\u{DF84}\u{DF93}\u{DFA4}\u{DFA8}\u{DFEB}\u{DFED}]|\u{D83D}[\u{DCBB}\u{DCBC}\u{DD27}\u{DD2C}\u{DE80}\u{DE92}]|\u{D83E}[\u{DDAF}-\u{DDB3}\u{DDBC}\u{DDBD}])|\u{200D}(?:\u{D83E}\u{DD1D}\u{200D}\u{D83E}\u{DDD1}|\u{D83C}[\u{DF3E}\u{DF73}\u{DF7C}\u{DF84}\u{DF93}\u{DFA4}\u{DFA8}\u{DFEB}\u{DFED}]|\u{D83D}[\u{DCBB}\u{DCBC}\u{DD27}\u{DD2C}\u{DE80}\u{DE92}]|\u{D83E}[\u{DDAF}-\u{DDB3}\u{DDBC}\u{DDBD}]))|\u{D83D}\u{DC69}(?:\u{200D}(?:\u{2764}\u{FE0F}\u{200D}(?:\u{D83D}\u{DC8B}\u{200D}(?:\u{D83D}[\u{DC68}\u{DC69}])|\u{D83D}[\u{DC68}\u{DC69}])|\u{D83C}[\u{DF3E}\u{DF73}\u{DF7C}\u{DF93}\u{DFA4}\u{DFA8}\u{DFEB}\u{DFED}]|\u{D83D}[\u{DCBB}\u{DCBC}\u{DD27}\u{DD2C}\u{DE80}\u{DE92}]|\u{D83E}[\u{DDAF}-\u{DDB3}\u{DDBC}\u{DDBD}])|\u{D83C}\u{DFFF}\u{200D}(?:\u{D83C}[\u{DF3E}\u{DF73}\u{DF7C}\u{DF93}\u{DFA4}\u{DFA8}\u{DFEB}\u{DFED}]|\u{D83D}[\u{DCBB}\u{DCBC}\u{DD27}\u{DD2C}\u{DE80}\u{DE92}]|\u{D83E}[\u{DDAF}-\u{DDB3}\u{DDBC}\u{DDBD}])|\u{D83C}\u{DFFE}\u{200D}(?:\u{D83C}[\u{DF3E}\u{DF73}\u{DF7C}\u{DF93}\u{DFA4}\u{DFA8}\u{DFEB}\u{DFED}]|\u{D83D}[\u{DCBB}\u{DCBC}\u{DD27}\u{DD2C}\u{DE80}\u{DE92}]|\u{D83E}[\u{DDAF}-\u{DDB3}\u{DDBC}\u{DDBD}])|\u{D83C}\u{DFFD}\u{200D}(?:\u{D83C}[\u{DF3E}\u{DF73}\u{DF7C}\u{DF93}\u{DFA4}\u{DFA8}\u{DFEB}\u{DFED}]|\u{D83D}[\u{DCBB}\u{DCBC}\u{DD27}\u{DD2C}\u{DE80}\u{DE92}]|\u{D83E}[\u{DDAF}-\u{DDB3}\u{DDBC}\u{DDBD}])|\u{D83C}\u{DFFC}\u{200D}(?:\u{D83C}[\u{DF3E}\u{DF73}\u{DF7C}\u{DF93}\u{DFA4}\u{DFA8}\u{DFEB}\u{DFED}]|\u{D83D}[\u{DCBB}\u{DCBC}\u{DD27}\u{DD2C}\u{DE80}\u{DE92}]|\u{D83E}[\u{DDAF}-\u{DDB3}\u{DDBC}\u{DDBD}])|\u{D83C}\u{DFFB}\u{200D}(?:\u{D83C}[\u{DF3E}\u{DF73}\u{DF7C}\u{DF93}\u{DFA4}\u{DFA8}\u{DFEB}\u{DFED}]|\u{D83D}[\u{DCBB}\u{DCBC}\u{DD27}\u{DD2C}\u{DE80}\u{DE92}]|\u{D83E}[\u{DDAF}-\u{DDB3}\u{DDBC}\u{DDBD}]))|\u{D83D}\u{DC69}\u{D83C}\u{DFFF}\u{200D}\u{D83E}\u{DD1D}\u{200D}(?:\u{D83D}[\u{DC68}\u{DC69}])(?:\u{D83C}[\u{DFFB}-\u{DFFE}])|\u{D83D}\u{DC69}\u{D83C}\u{DFFE}\u{200D}\u{D83E}\u{DD1D}\u{200D}(?:\u{D83D}[\u{DC68}\u{DC69}])(?:\u{D83C}[\u{DFFB}-\u{DFFD}\u{DFFF}])|\u{D83D}\u{DC69}\u{D83C}\u{DFFD}\u{200D}\u{D83E}\u{DD1D}\u{200D}(?:\u{D83D}[\u{DC68}\u{DC69}])(?:\u{D83C}[\u{DFFB}\u{DFFC}\u{DFFE}\u{DFFF}])|\u{D83D}\u{DC69}\u{D83C}\u{DFFC}\u{200D}\u{D83E}\u{DD1D}\u{200D}(?:\u{D83D}[\u{DC68}\u{DC69}])(?:\u{D83C}[\u{DFFB}\u{DFFD}-\u{DFFF}])|\u{D83D}\u{DC69}\u{D83C}\u{DFFB}\u{200D}\u{D83E}\u{DD1D}\u{200D}(?:\u{D83D}[\u{DC68}\u{DC69}])(?:\u{D83C}[\u{DFFC}-\u{DFFF}])|\u{D83D}\u{DC69}\u{200D}\u{D83D}\u{DC66}\u{200D}\u{D83D}\u{DC66}|\u{D83D}\u{DC69}\u{200D}\u{D83D}\u{DC69}\u{200D}(?:\u{D83D}[\u{DC66}\u{DC67}])|(?:\u{D83D}\u{DC41}\u{FE0F}\u{200D}\u{D83D}\u{DDE8}|\u{D83D}\u{DC69}(?:\u{D83C}\u{DFFF}\u{200D}[\u{2695}\u{2696}\u{2708}]|\u{D83C}\u{DFFE}\u{200D}[\u{2695}\u{2696}\u{2708}]|\u{D83C}\u{DFFD}\u{200D}[\u{2695}\u{2696}\u{2708}]|\u{D83C}\u{DFFC}\u{200D}[\u{2695}\u{2696}\u{2708}]|\u{D83C}\u{DFFB}\u{200D}[\u{2695}\u{2696}\u{2708}]|\u{200D}[\u{2695}\u{2696}\u{2708}])|\u{D83C}\u{DFF3}\u{FE0F}\u{200D}\u{26A7}|\u{D83E}\u{DDD1}(?:(?:\u{D83C}[\u{DFFB}-\u{DFFF}])\u{200D}[\u{2695}\u{2696}\u{2708}]|\u{200D}[\u{2695}\u{2696}\u{2708}])|\u{D83D}\u{DC3B}\u{200D}\u{2744}|(?:\u{D83C}[\u{DFC3}\u{DFC4}\u{DFCA}]|\u{D83D}[\u{DC6E}\u{DC70}\u{DC71}\u{DC73}\u{DC77}\u{DC81}\u{DC82}\u{DC86}\u{DC87}\u{DE45}-\u{DE47}\u{DE4B}\u{DE4D}\u{DE4E}\u{DEA3}\u{DEB4}-\u{DEB6}]|\u{D83E}[\u{DD26}\u{DD35}\u{DD37}-\u{DD39}\u{DD3D}\u{DD3E}\u{DDB8}\u{DDB9}\u{DDCD}-\u{DDCF}\u{DDD6}-\u{DDDD}])(?:\u{D83C}[\u{DFFB}-\u{DFFF}])\u{200D}[\u{2640}\u{2642}]|(?:\u{26F9}|\u{D83C}[\u{DFCB}\u{DFCC}]|\u{D83D}\u{DD75})(?:\u{FE0F}\u{200D}[\u{2640}\u{2642}]|(?:\u{D83C}[\u{DFFB}-\u{DFFF}])\u{200D}[\u{2640}\u{2642}])|\u{D83C}\u{DFF4}\u{200D}\u{2620}|(?:\u{D83C}[\u{DFC3}\u{DFC4}\u{DFCA}]|\u{D83D}[\u{DC6E}-\u{DC71}\u{DC73}\u{DC77}\u{DC81}\u{DC82}\u{DC86}\u{DC87}\u{DE45}-\u{DE47}\u{DE4B}\u{DE4D}\u{DE4E}\u{DEA3}\u{DEB4}-\u{DEB6}]|\u{D83E}[\u{DD26}\u{DD35}\u{DD37}-\u{DD39}\u{DD3C}-\u{DD3E}\u{DDB8}\u{DDB9}\u{DDCD}-\u{DDCF}\u{DDD6}-\u{DDDF}])\u{200D}[\u{2640}\u{2642}])\u{FE0F}|\u{D83D}\u{DC69}\u{200D}\u{D83D}\u{DC67}\u{200D}(?:\u{D83D}[\u{DC66}\u{DC67}])|\u{D83C}\u{DFF3}\u{FE0F}\u{200D}\u{D83C}\u{DF08}|\u{D83D}\u{DC69}\u{200D}\u{D83D}\u{DC67}|\u{D83D}\u{DC69}\u{200D}\u{D83D}\u{DC66}|\u{D83D}\u{DC15}\u{200D}\u{D83E}\u{DDBA}|\u{D83C}\u{DDFD}\u{D83C}\u{DDF0}|\u{D83C}\u{DDF6}\u{D83C}\u{DDE6}|\u{D83C}\u{DDF4}\u{D83C}\u{DDF2}|\u{D83D}\u{DC08}\u{200D}\u{2B1B}|\u{D83E}\u{DDD1}(?:\u{D83C}[\u{DFFB}-\u{DFFF}])|\u{D83D}\u{DC69}(?:\u{D83C}[\u{DFFB}-\u{DFFF}])|\u{D83C}\u{DDFF}(?:\u{D83C}[\u{DDE6}\u{DDF2}\u{DDFC}])|\u{D83C}\u{DDFE}(?:\u{D83C}[\u{DDEA}\u{DDF9}])|\u{D83C}\u{DDFC}(?:\u{D83C}[\u{DDEB}\u{DDF8}])|\u{D83C}\u{DDFB}(?:\u{D83C}[\u{DDE6}\u{DDE8}\u{DDEA}\u{DDEC}\u{DDEE}\u{DDF3}\u{DDFA}])|\u{D83C}\u{DDFA}(?:\u{D83C}[\u{DDE6}\u{DDEC}\u{DDF2}\u{DDF3}\u{DDF8}\u{DDFE}\u{DDFF}])|\u{D83C}\u{DDF9}(?:\u{D83C}[\u{DDE6}\u{DDE8}\u{DDE9}\u{DDEB}-\u{DDED}\u{DDEF}-\u{DDF4}\u{DDF7}\u{DDF9}\u{DDFB}\u{DDFC}\u{DDFF}])|\u{D83C}\u{DDF8}(?:\u{D83C}[\u{DDE6}-\u{DDEA}\u{DDEC}-\u{DDF4}\u{DDF7}-\u{DDF9}\u{DDFB}\u{DDFD}-\u{DDFF}])|\u{D83C}\u{DDF7}(?:\u{D83C}[\u{DDEA}\u{DDF4}\u{DDF8}\u{DDFA}\u{DDFC}])|\u{D83C}\u{DDF5}(?:\u{D83C}[\u{DDE6}\u{DDEA}-\u{DDED}\u{DDF0}-\u{DDF3}\u{DDF7}-\u{DDF9}\u{DDFC}\u{DDFE}])|\u{D83C}\u{DDF3}(?:\u{D83C}[\u{DDE6}\u{DDE8}\u{DDEA}-\u{DDEC}\u{DDEE}\u{DDF1}\u{DDF4}\u{DDF5}\u{DDF7}\u{DDFA}\u{DDFF}])|\u{D83C}\u{DDF2}(?:\u{D83C}[\u{DDE6}\u{DDE8}-\u{DDED}\u{DDF0}-\u{DDFF}])|\u{D83C}\u{DDF1}(?:\u{D83C}[\u{DDE6}-\u{DDE8}\u{DDEE}\u{DDF0}\u{DDF7}-\u{DDFB}\u{DDFE}])|\u{D83C}\u{DDF0}(?:\u{D83C}[\u{DDEA}\u{DDEC}-\u{DDEE}\u{DDF2}\u{DDF3}\u{DDF5}\u{DDF7}\u{DDFC}\u{DDFE}\u{DDFF}])|\u{D83C}\u{DDEF}(?:\u{D83C}[\u{DDEA}\u{DDF2}\u{DDF4}\u{DDF5}])|\u{D83C}\u{DDEE}(?:\u{D83C}[\u{DDE8}-\u{DDEA}\u{DDF1}-\u{DDF4}\u{DDF6}-\u{DDF9}])|\u{D83C}\u{DDED}(?:\u{D83C}[\u{DDF0}\u{DDF2}\u{DDF3}\u{DDF7}\u{DDF9}\u{DDFA}])|\u{D83C}\u{DDEC}(?:\u{D83C}[\u{DDE6}\u{DDE7}\u{DDE9}-\u{DDEE}\u{DDF1}-\u{DDF3}\u{DDF5}-\u{DDFA}\u{DDFC}\u{DDFE}])|\u{D83C}\u{DDEB}(?:\u{D83C}[\u{DDEE}-\u{DDF0}\u{DDF2}\u{DDF4}\u{DDF7}])|\u{D83C}\u{DDEA}(?:\u{D83C}[\u{DDE6}\u{DDE8}\u{DDEA}\u{DDEC}\u{DDED}\u{DDF7}-\u{DDFA}])|\u{D83C}\u{DDE9}(?:\u{D83C}[\u{DDEA}\u{DDEC}\u{DDEF}\u{DDF0}\u{DDF2}\u{DDF4}\u{DDFF}])|\u{D83C}\u{DDE8}(?:\u{D83C}[\u{DDE6}\u{DDE8}\u{DDE9}\u{DDEB}-\u{DDEE}\u{DDF0}-\u{DDF5}\u{DDF7}\u{DDFA}-\u{DDFF}])|\u{D83C}\u{DDE7}(?:\u{D83C}[\u{DDE6}\u{DDE7}\u{DDE9}-\u{DDEF}\u{DDF1}-\u{DDF4}\u{DDF6}-\u{DDF9}\u{DDFB}\u{DDFC}\u{DDFE}\u{DDFF}])|\u{D83C}\u{DDE6}(?:\u{D83C}[\u{DDE8}-\u{DDEC}\u{DDEE}\u{DDF1}\u{DDF2}\u{DDF4}\u{DDF6}-\u{DDFA}\u{DDFC}\u{DDFD}\u{DDFF}])|[#\\*0-9]\u{FE0F}\u{20E3}|(?:\u{D83C}[\u{DFC3}\u{DFC4}\u{DFCA}]|\u{D83D}[\u{DC6E}\u{DC70}\u{DC71}\u{DC73}\u{DC77}\u{DC81}\u{DC82}\u{DC86}\u{DC87}\u{DE45}-\u{DE47}\u{DE4B}\u{DE4D}\u{DE4E}\u{DEA3}\u{DEB4}-\u{DEB6}]|\u{D83E}[\u{DD26}\u{DD35}\u{DD37}-\u{DD39}\u{DD3D}\u{DD3E}\u{DDB8}\u{DDB9}\u{DDCD}-\u{DDCF}\u{DDD6}-\u{DDDD}])(?:\u{D83C}[\u{DFFB}-\u{DFFF}])|(?:\u{26F9}|\u{D83C}[\u{DFCB}\u{DFCC}]|\u{D83D}\u{DD75})(?:\u{D83C}[\u{DFFB}-\u{DFFF}])|(?:[\u{261D}\u{270A}-\u{270D}]|\u{D83C}[\u{DF85}\u{DFC2}\u{DFC7}]|\u{D83D}[\u{DC42}\u{DC43}\u{DC46}-\u{DC50}\u{DC66}\u{DC67}\u{DC6B}-\u{DC6D}\u{DC72}\u{DC74}-\u{DC76}\u{DC78}\u{DC7C}\u{DC83}\u{DC85}\u{DCAA}\u{DD74}\u{DD7A}\u{DD90}\u{DD95}\u{DD96}\u{DE4C}\u{DE4F}\u{DEC0}\u{DECC}]|\u{D83E}[\u{DD0C}\u{DD0F}\u{DD18}-\u{DD1C}\u{DD1E}\u{DD1F}\u{DD30}-\u{DD34}\u{DD36}\u{DD77}\u{DDB5}\u{DDB6}\u{DDBB}\u{DDD2}-\u{DDD5}])(?:\u{D83C}[\u{DFFB}-\u{DFFF}])|(?:[\u{231A}\u{231B}\u{23E9}-\u{23EC}\u{23F0}\u{23F3}\u{25FD}\u{25FE}\u{2614}\u{2615}\u{2648}-\u{2653}\u{267F}\u{2693}\u{26A1}\u{26AA}\u{26AB}\u{26BD}\u{26BE}\u{26C4}\u{26C5}\u{26CE}\u{26D4}\u{26EA}\u{26F2}\u{26F3}\u{26F5}\u{26FA}\u{26FD}\u{2705}\u{270A}\u{270B}\u{2728}\u{274C}\u{274E}\u{2753}-\u{2755}\u{2757}\u{2795}-\u{2797}\u{27B0}\u{27BF}\u{2B1B}\u{2B1C}\u{2B50}\u{2B55}]|\u{D83C}[\u{DC04}\u{DCCF}\u{DD8E}\u{DD91}-\u{DD9A}\u{DDE6}-\u{DDFF}\u{DE01}\u{DE1A}\u{DE2F}\u{DE32}-\u{DE36}\u{DE38}-\u{DE3A}\u{DE50}\u{DE51}\u{DF00}-\u{DF20}\u{DF2D}-\u{DF35}\u{DF37}-\u{DF7C}\u{DF7E}-\u{DF93}\u{DFA0}-\u{DFCA}\u{DFCF}-\u{DFD3}\u{DFE0}-\u{DFF0}\u{DFF4}\u{DFF8}-\u{DFFF}]|\u{D83D}[\u{DC00}-\u{DC3E}\u{DC40}\u{DC42}-\u{DCFC}\u{DCFF}-\u{DD3D}\u{DD4B}-\u{DD4E}\u{DD50}-\u{DD67}\u{DD7A}\u{DD95}\u{DD96}\u{DDA4}\u{DDFB}-\u{DE4F}\u{DE80}-\u{DEC5}\u{DECC}\u{DED0}-\u{DED2}\u{DED5}-\u{DED7}\u{DEEB}\u{DEEC}\u{DEF4}-\u{DEFC}\u{DFE0}-\u{DFEB}]|\u{D83E}[\u{DD0C}-\u{DD3A}\u{DD3C}-\u{DD45}\u{DD47}-\u{DD78}\u{DD7A}-\u{DDCB}\u{DDCD}-\u{DDFF}\u{DE70}-\u{DE74}\u{DE78}-\u{DE7A}\u{DE80}-\u{DE86}\u{DE90}-\u{DEA8}\u{DEB0}-\u{DEB6}\u{DEC0}-\u{DEC2}\u{DED0}-\u{DED6}])|(?:[#\\*0-9\\xA9\\xAE\u{203C}\u{2049}\u{2122}\u{2139}\u{2194}-\u{2199}\u{21A9}\u{21AA}\u{231A}\u{231B}\u{2328}\u{23CF}\u{23E9}-\u{23F3}\u{23F8}-\u{23FA}\u{24C2}\u{25AA}\u{25AB}\u{25B6}\u{25C0}\u{25FB}-\u{25FE}\u{2600}-\u{2604}\u{260E}\u{2611}\u{2614}\u{2615}\u{2618}\u{261D}\u{2620}\u{2622}\u{2623}\u{2626}\u{262A}\u{262E}\u{262F}\u{2638}-\u{263A}\u{2640}\u{2642}\u{2648}-\u{2653}\u{265F}\u{2660}\u{2663}\u{2665}\u{2666}\u{2668}\u{267B}\u{267E}\u{267F}\u{2692}-\u{2697}\u{2699}\u{269B}\u{269C}\u{26A0}\u{26A1}\u{26A7}\u{26AA}\u{26AB}\u{26B0}\u{26B1}\u{26BD}\u{26BE}\u{26C4}\u{26C5}\u{26C8}\u{26CE}\u{26CF}\u{26D1}\u{26D3}\u{26D4}\u{26E9}\u{26EA}\u{26F0}-\u{26F5}\u{26F7}-\u{26FA}\u{26FD}\u{2702}\u{2705}\u{2708}-\u{270D}\u{270F}\u{2712}\u{2714}\u{2716}\u{271D}\u{2721}\u{2728}\u{2733}\u{2734}\u{2744}\u{2747}\u{274C}\u{274E}\u{2753}-\u{2755}\u{2757}\u{2763}\u{2764}\u{2795}-\u{2797}\u{27A1}\u{27B0}\u{27BF}\u{2934}\u{2935}\u{2B05}-\u{2B07}\u{2B1B}\u{2B1C}\u{2B50}\u{2B55}\u{3030}\u{303D}\u{3297}\u{3299}]|\u{D83C}[\u{DC04}\u{DCCF}\u{DD70}\u{DD71}\u{DD7E}\u{DD7F}\u{DD8E}\u{DD91}-\u{DD9A}\u{DDE6}-\u{DDFF}\u{DE01}\u{DE02}\u{DE1A}\u{DE2F}\u{DE32}-\u{DE3A}\u{DE50}\u{DE51}\u{DF00}-\u{DF21}\u{DF24}-\u{DF93}\u{DF96}\u{DF97}\u{DF99}-\u{DF9B}\u{DF9E}-\u{DFF0}\u{DFF3}-\u{DFF5}\u{DFF7}-\u{DFFF}]|\u{D83D}[\u{DC00}-\u{DCFD}\u{DCFF}-\u{DD3D}\u{DD49}-\u{DD4E}\u{DD50}-\u{DD67}\u{DD6F}\u{DD70}\u{DD73}-\u{DD7A}\u{DD87}\u{DD8A}-\u{DD8D}\u{DD90}\u{DD95}\u{DD96}\u{DDA4}\u{DDA5}\u{DDA8}\u{DDB1}\u{DDB2}\u{DDBC}\u{DDC2}-\u{DDC4}\u{DDD1}-\u{DDD3}\u{DDDC}-\u{DDDE}\u{DDE1}\u{DDE3}\u{DDE8}\u{DDEF}\u{DDF3}\u{DDFA}-\u{DE4F}\u{DE80}-\u{DEC5}\u{DECB}-\u{DED2}\u{DED5}-\u{DED7}\u{DEE0}-\u{DEE5}\u{DEE9}\u{DEEB}\u{DEEC}\u{DEF0}\u{DEF3}-\u{DEFC}\u{DFE0}-\u{DFEB}]|\u{D83E}[\u{DD0C}-\u{DD3A}\u{DD3C}-\u{DD45}\u{DD47}-\u{DD78}\u{DD7A}-\u{DDCB}\u{DDCD}-\u{DDFF}\u{DE70}-\u{DE74}\u{DE78}-\u{DE7A}\u{DE80}-\u{DE86}\u{DE90}-\u{DEA8}\u{DEB0}-\u{DEB6}\u{DEC0}-\u{DEC2}\u{DED0}-\u{DED6}])\u{FE0F}|(?:[\u{261D}\u{26F9}\u{270A}-\u{270D}]|\u{D83C}[\u{DF85}\u{DFC2}-\u{DFC4}\u{DFC7}\u{DFCA}-\u{DFCC}]|\u{D83D}[\u{DC42}\u{DC43}\u{DC46}-\u{DC50}\u{DC66}-\u{DC78}\u{DC7C}\u{DC81}-\u{DC83}\u{DC85}-\u{DC87}\u{DC8F}\u{DC91}\u{DCAA}\u{DD74}\u{DD75}\u{DD7A}\u{DD90}\u{DD95}\u{DD96}\u{DE45}-\u{DE47}\u{DE4B}-\u{DE4F}\u{DEA3}\u{DEB4}-\u{DEB6}\u{DEC0}\u{DECC}]|\u{D83E}[\u{DD0C}\u{DD0F}\u{DD18}-\u{DD1F}\u{DD26}\u{DD30}-\u{DD39}\u{DD3C}-\u{DD3E}\u{DD77}\u{DDB5}\u{DDB6}\u{DDB8}\u{DDB9}\u{DDBB}\u{DDCD}-\u{DDCF}\u{DDD1}-\u{DDDD}]))');
    List<String> list = [];
    var matches = regex.allMatches(text);
    int pos = 0;
    for (var match in matches) {
      list.addAll([
        ...text.substring(pos, match.start).split('').map((value) => value).toList(),
        match[0]!,
      ]);
      pos = match.end;
    }
    if (pos != text.length) list.addAll([...text.substring(pos, text.length).split('').map((value) => value).toList()]);
    return list;
  }

  Widget _getRightItemPane(double width, double height) {
    return Scrollbar(
      thumbVisibility: true,
      controller: _controller,
      child: ListView(
        controller: _controller,
        // 스크롤 방향 설정. 수평적으로 스크롤되도록 설정
        scrollDirection: Axis.horizontal,
        // 컨테이너들을 ListView의 자식들로 추가
        children: <Widget>[
          Wrap(
            direction: Axis.horizontal,
            spacing: 4, // <-- Spacing between children
            children: <Widget>[
              ...cretaBookList.map((item) {
                List<String> titleCharList = splitByCharacter(item.title);
                if (titleCharList.length > 28) {
                  List<String> tmpList = [];
                  for(int i=0; i<28; i++) {
                    tmpList.add(titleCharList[i]);
                  }
                  titleCharList = tmpList;
                }
                double wid = (_currentOpenedBookTitle == item.title) ? 400 : (item.totalPages / 10) * 30 + 64;
                double hei = height - 70;
                return Container(
                  margin: EdgeInsets.fromLTRB(0, 50, 0, 20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.4),),
                  clipBehavior: Clip.antiAlias,
                  width: wid,
                  height: hei,
                  child:
                  Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(item.imageUrl, fit: BoxFit.cover),
                      ClipRRect( // Clip it cleanly.
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            color: Colors.grey.withOpacity(0.1),
                            alignment: Alignment.center,
                            child: Text('CHOCOLATE'),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () => setState(() {
                          _currentOpenedBookTitle = (_currentOpenedBookTitle != item.title) ? item.title : '';
                        }),
                        child: Container(
                          //width: wid,
                          //height: hei,
                          color: (_currentOpenedBookTitle == item.title) ? Colors.orange[100] : Colors.blue[100],
                          child: Column(children: [
                            Container(width: 20, height: 20, color:Colors.white, margin: EdgeInsets.fromLTRB(0, 10, 0, 10),),
                            ...titleCharList.map((value) => Center(child: Text(value, style: TextStyle(fontSize: 22, height: 1,),),)).toList(),
                            // GridView.builder(
                            //   //controller: _controller,
                            //   scrollDirection: Axis.horizontal,
                            //   itemCount: titleCharList.length > 20 ? 20 : titleCharList.length, //item 개수
                            //   gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            //     maxCrossAxisExtent: 30,
                            //     childAspectRatio: 1,
                            //     //crossAxisSpacing: 20,
                            //     //mainAxisSpacing: 20,
                            //   ),
                            //   itemBuilder: (BuildContext context, int index) {
                            //     return Center(child: Text(titleCharList[index], style: TextStyle(fontSize: 22),),);
                            //   },
                            // ),
                          ],),
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ],),
    );
  }

  // Widget _getRightMenuPane(double width, double height) {
  //   return Container(
  //     width: width,
  //     height: height,
  //     color: Colors.grey,
  //   );
  // }

  Widget _mainPage() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - CretaComponentLocation.BarTop.height;
    return SizedBox(
        child: Row(
      children: [
        // 왼쪽 메뉴
        _getLeftPane(height),
        // 오른쪽 컨텐츠
        Container(
          width: width - CretaComponentLocation.TabBar.width,
          height: height,
          color: Colors.white,
          child: Row(
            children: [
              SizedBox(
                width: width - CretaComponentLocation.TabBar.width,// - 346,
                height: height,
                child: _getRightItemPane(width - CretaComponentLocation.TabBar.width - 346, height),
              ),
              // SizedBox(
              //   width: 346,
              //   height: height,
              //   child: _getRightMenuPane(346, height),
              // ),
            ],
          ),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    //double width = MediaQuery.of(context).size.width;
    //double height = MediaQuery.of(context).size.height;
    //print('screen_width=$width, screen_height=$height');
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
            isAntiAlias: true,
          ),
        ],
      ),
      context: context,
      child: _mainPage(),
    );
  }
}

//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////

class CretaBookItemV extends StatefulWidget {
  final CretaBookData cretaBookData;
  final double width;
  final double height;

  const CretaBookItemV({
    required super.key,
    required this.cretaBookData,
    required this.width,
    required this.height,
  });

  @override
  CretaBookItemState createState() => CretaBookItemState();
}

class CretaBookItemVState extends State<CretaBookItemV> {
  bool mouseOver = false;
  bool popmenuOpen = false;

  late List<CretaMenuItem> _popupMenuList;

  void _openPopupMenu() {
    CretaPopupMenu.showMenu(
            context: context,
            globalKey: widget.cretaBookData.globalKey,
            popupMenu: _popupMenuList,
            initFunc: setPopmenuOpen)
        .then((value) {
      logger.finest('팝업메뉴 닫기');
      setState(() {
        popmenuOpen = false;
      });
    });
  }

  void _editItem() {
    logger.finest('편집하기(${widget.cretaBookData.title})');
  }

  void _doPopupMenuPlay() {
    logger.finest('재생하기(${widget.cretaBookData.title})');
  }

  void _doPopupMenuEdit() {
    logger.finest('편집하기(${widget.cretaBookData.title})');
  }

  void _doPopupMenuAddToPlayList() {
    logger.finest('재생목록에 추가(${widget.cretaBookData.title})');
  }

  void _doPopupMenuShare() {
    logger.finest('공유하기(${widget.cretaBookData.title})');
  }

  void _doPopupMenuDownload() {
    logger.finest('다운로드(${widget.cretaBookData.title})');
  }

  void _doPopupMenuCopy() {
    logger.finest('복사하기(${widget.cretaBookData.title})');
  }

  @override
  void initState() {
    super.initState();

    _popupMenuList = [
      CretaMenuItem(
        caption: '재생하기',
        onPressed: _doPopupMenuPlay,
      ),
      CretaMenuItem(
        caption: '편집하기',
        onPressed: _doPopupMenuEdit,
      ),
      CretaMenuItem(
        caption: '재생목록에 추가',
        onPressed: _doPopupMenuAddToPlayList,
      ),
      CretaMenuItem(
        caption: '공유하기',
        onPressed: _doPopupMenuShare,
      ),
      CretaMenuItem(
        caption: '다운로드',
        onPressed: _doPopupMenuDownload,
      ),
      CretaMenuItem(
        caption: '복사하기',
        onPressed: _doPopupMenuCopy,
      ),
    ];
  }

  void setPopmenuOpen() {
    popmenuOpen = true;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> overlayMenu = !(mouseOver || popmenuOpen)
        ? [
            Container(),
          ]
        : [
            Positioned(
              left: 8,
              top: 8,
              // BTN.opacity_gray_it_s
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => _editItem(),
                  child: SizedBox(
                    width: 91,
                    height: 29,
                    child: Stack(
                      children: [
                        Opacity(
                          opacity: 0.25,
                          child: SizedBox(
                            width: 91,
                            height: 29,
                            child: FloatingActionButton.extended(
                              onPressed: () => _editItem(),
                              label: Container(),
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 91,
                          height: 29,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.edit_outlined,
                                size: 12.0,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                '편집하기',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: widget.width - 68,
              top: 8,
              //BTN.opacity_gray_i_s
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => _openPopupMenu(),
                  child: SizedBox(
                    width: 29,
                    height: 29,
                    child: Stack(
                      children: [
                        Opacity(
                          opacity: 0.25,
                          child: SizedBox(
                            width: 28,
                            height: 28,
                            child: FloatingActionButton.extended(
                              onPressed: () => _openPopupMenu(),
                              label: Container(),
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 29,
                          height: 29,
                          child: Center(
                            child: Icon(
                              Icons.add,
                              size: 12.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: widget.width - 36,
              top: 8,
              child: Stack(
                children: [
                  Opacity(
                    opacity: 0.25,
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: FloatingActionButton.extended(
                        onPressed: () {},
                        label: Text(
                          '',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                        // icon: Icon(
                        //   Icons.menu,
                        //   size: 12.0,
                        // ),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                      ),
                    ),
                  ),
                  PopupMenuButton<PopupMenuSampleItem>(
                    tooltip: '',
                    offset: Offset(100, 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: Icon(
                        Icons.menu,
                        size: 12.0,
                        color: Colors.white,
                      ),
                    ),
                    //initialValue: selectedMenu,
                    // Callback that sets the selected popup menu item.
                    onSelected: (PopupMenuSampleItem item) {
                      setState(() {
                        //selectedMenu = item;
                        popmenuOpen = false;
                      });
                    },
                    onCanceled: () {
                      setState(() {
                        popmenuOpen = false;
                      });
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<PopupMenuSampleItem>>[
                      const PopupMenuItem<PopupMenuSampleItem>(
                        value: PopupMenuSampleItem.itemOne,
                        child: Text('Item 1'),
                      ),
                      const PopupMenuItem<PopupMenuSampleItem>(
                        value: PopupMenuSampleItem.itemTwo,
                        child: Text('Item 2'),
                      ),
                      const PopupMenuItem<PopupMenuSampleItem>(
                        value: PopupMenuSampleItem.itemThree,
                        child: Text('Item 3'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ];

    return MouseRegion(
      onEnter: (value) {
        setState(() {
          mouseOver = true;
        });
      },
      onExit: (value) {
        setState(() {
          mouseOver = false;
        });
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          // crop
          borderRadius: BorderRadius.circular(20.0),
        ),
        clipBehavior: Clip.antiAlias, // crop method
        child: Column(
          children: [
            Container(
              width: widget.width,
              height: widget.height - _itemDescriptionHeight,
              color: Colors.white,
              child: Stack(
                children: [
                  // 콘텐츠 프리뷰 이미지
                  Image.network(
                    //width: 200,
                    //  height: 100,
                    width: double.maxFinite,
                    widget.cretaBookData.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  // 편집하기, 추가, 메뉴 버튼 (반투명 배경)
                  ...overlayMenu,
                ],
              ),
            ),
            Container(
              height: _itemDescriptionHeight,
              color: (mouseOver || popmenuOpen) ? Colors.grey[100] : Colors.white,
              child: Stack(
                children: [
                  Positioned(
                      left: widget.width - 37,
                      top: 17,
                      child: Container(
                        width: 20,
                        height: 20,
                        color: (mouseOver || popmenuOpen) ? Colors.grey[100] : Colors.white,
                        child: Icon(
                          Icons.favorite_outline,
                          size: 20.0,
                          color: Colors.grey[700],
                        ),
                      )),
                  Positioned(
                    left: 15,
                    top: 7,
                    child: Container(
                        width: widget.width - 45 - 15,
                        color: (mouseOver || popmenuOpen) ? Colors.grey[100] : Colors.white,
                        child: Text(
                          widget.cretaBookData.title,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                            fontFamily: 'Pretendard',
                          ),
                        )),
                  ),
                  Positioned(
                    left: 16,
                    top: 29,
                    child: Container(
                      width: widget.width - 45 - 15,
                      color: (mouseOver || popmenuOpen) ? Colors.grey[100] : Colors.white,
                      child: Text(
                        widget.cretaBookData.userNickname,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[500],
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
