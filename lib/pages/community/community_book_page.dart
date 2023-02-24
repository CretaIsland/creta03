// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
//import 'dart:async';
//import 'package:flutter/gestures.dart';
//import 'package:hycop/hycop.dart';
//import 'package:hycop/common/util/logger.dart';
//import 'package:routemaster/routemaster.dart';
//import 'package:url_strategy/url_strategy.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
//import '../../design_system/buttons/creta_button.dart';
import '../../design_system/component/snippet.dart';
//import '../../design_system/menu/creta_drop_down.dart';
//import '../../design_system/menu/creta_popup_menu.dart';
//import '../../design_system/text_field/creta_search_bar.dart';
//import '../design_system/creta_color.dart';
//import 'package:image_network/image_network.dart';
//import 'package:cached_network_image/cached_network_image.dart';
//import '../../common/cross_common_job.dart';
//import '../../routes.dart';
//import 'sub_pages/community_left_menu_pane.dart';
//import '../../design_system/component/creta_basic_layout_mixin.dart';
//import '../../design_system/component/custom_image.dart';
import '../../design_system/creta_font.dart';
//import '../../lang/creta_lang.dart';
//import 'package:creta03/design_system/creta_color.dart';


//bool _isInUsingCanvaskit = false;

class CommunityBookPage extends StatefulWidget {
  final String subPageUrl;
  const CommunityBookPage({super.key, this.subPageUrl = ''});

  @override
  State<CommunityBookPage> createState() => _CommunityBookPageState();
}

class _CommunityBookPageState extends State<CommunityBookPage> {

  @override
  void initState() {
    super.initState();

    // CrossCommonJob ccj = CrossCommonJob();
    // _isInUsingCanvaskit = ccj.isInUsingCanvaskit();
  }

  List<Widget> _getHashtagList() {
    return [
      BTN.opacity_gray_it_s(
        text: '#크레타북',
        textStyle: CretaFont.buttonMedium,
        //width: null,
        onPressed: () {},
      ),
      SizedBox(width: 12),
      BTN.opacity_gray_it_s(
        text: '#추천',
        textStyle: CretaFont.buttonMedium,
        //width: null,
        onPressed: () {},
      ),
      SizedBox(width: 12),
      BTN.opacity_gray_it_s(
        text: '#인기',
        textStyle: CretaFont.buttonMedium,
        //width: null,
        onPressed: () {},
      ),
      SizedBox(width: 12),
      BTN.opacity_gray_it_s(
        text: '#해시태그',
        textStyle: CretaFont.buttonMedium,
        //width: null,
        onPressed: () {},
      ),
    ];
  }

  Widget _getTitlePane(Size size) {
    return Container(
      width: size.width,
      height: size.height,
      padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
      child: Row(
        children: [
          Text(
            '_getTitlePane',
            style: CretaFont.titleELarge,
          ),
        ],
      ),
    );
  }

  Widget _getBookMainPane(Size size) {
    return Container(
      width: size.width,
      height: size.height,
      padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
      child: Row(
        children: [
          Text(
            '_getBookMainPane',
            style: CretaFont.titleELarge,
          ),
        ],
      ),
    );
  }

  Widget _getBookDescriptionPane(Size size) {
    return Container(
      width: size.width,
      height: size.height,
      padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
      child: Row(
        children: [
          Text(
            '_getBookDescriptionPane',
            style: CretaFont.titleELarge,
          ),
        ],
      ),
    );
  }

  Widget _getRelatedBookList(Size size) {
    return Container(
      width: size.width,
      height: size.height,
      padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
      child: Row(
        children: [
          Text(
            '_getBookSidePane',
            style: CretaFont.titleELarge,
          ),
        ],
      ),
    );
  }

  Size titleArea = Size.zero;
  Size bookArea = Size.zero;
  Size descriptionArea = Size.zero;
  Size sideArea = Size.zero;
  void _resize(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    //double height = MediaQuery.of(context).size.height;
    titleArea = Size(width, 116);
    sideArea = Size(525, double.infinity);
    bookArea = Size(width - sideArea.width, (width - 525 - 80) / 16 * 9);
    descriptionArea = Size(bookArea.width, double.infinity);
  }

  @override
  Widget build(BuildContext context) {
    _resize(context);
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            // title
            Container(
              color: Colors.yellow[200],
              width: titleArea.width,
              height: titleArea.height,
              child: Center(child: _getTitlePane(titleArea)),
            ),
            // body
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // main
                SizedBox(
                  width: bookArea.width,
                  child: Column(
                    children: [
                      // book
                      Container(
                        padding: EdgeInsets.fromLTRB(80, 0, 0, 0),
                        height: bookArea.height,
                        child: Container(
                          color: Colors.red[100],
                          child: Center(child: _getBookMainPane(Size(bookArea.width-80, bookArea.height))),
                        ),
                      ),
                      // description
                      Container(
                        padding: EdgeInsets.fromLTRB(100, 40, 20, 0),
                        child: Center(
                          child: Column(
                            children: [
                              // description
                              Container(
                                color: Colors.red[200],
                                height: 600,
                                child: Center(child: _getBookDescriptionPane(Size(bookArea.width-100,600))),
                              ),
                              // using contents list
                              Container(
                                color: Colors.red[300],
                                height: 600,
                                child: Center(child: Text('using contents list area')),
                              ),
                              // comments
                              Container(
                                color: Colors.red[400],
                                height: 600,
                                child: Center(child: Text('comments area')),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // side
                SizedBox(
                  width: sideArea.width,
                  child: Column(
                    children: [
                      // hashtag
                      Container(
                        height: 210,
                        padding: EdgeInsets.fromLTRB(60, 40, 100, 0),
                        child: Container(
                          color: Colors.grey,
                          child: Wrap(
                            direction: Axis.horizontal, // 나열 방향
                            alignment: WrapAlignment.start, // 정렬 방식
                            spacing: 5, // 좌우 간격
                            runSpacing: 5, // 상하 간격
                            children: _getHashtagList(),
                          ),
                        ),
                      ),
                      // related book
                      Container(
                        height: 1000,
                        padding: EdgeInsets.fromLTRB(60, 60, 100, 40),
                        child: Container(
                          color: Colors.green[200],
                          child: Center(child: _getRelatedBookList(Size(sideArea.width-60-100,1000))),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
