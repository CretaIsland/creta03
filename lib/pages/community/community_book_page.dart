// ignore_for_file: prefer_const_constructors

import 'package:creta03/design_system/buttons/creta_button.dart';
import 'package:flutter/material.dart';
//import 'dart:async';
//import 'package:flutter/gestures.dart';
//import 'package:hycop/hycop.dart';
//import 'package:hycop/common/util/logger.dart';
//import 'package:routemaster/routemaster.dart';
//import 'package:url_strategy/url_strategy.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/buttons/creta_elibated_button.dart';
//import '../../design_system/buttons/creta_button.dart';
import '../../design_system/component/snippet.dart';
//import '../../design_system/menu/creta_drop_down.dart';
//import '../../design_system/menu/creta_popup_menu.dart';
//import '../../design_system/text_field/creta_search_bar.dart';
import '../../design_system/creta_color.dart';
//import 'package:image_network/image_network.dart';
//import 'package:cached_network_image/cached_network_image.dart';
//import '../../common/cross_common_job.dart';
//import '../../routes.dart';
//import 'sub_pages/community_left_menu_pane.dart';
//import '../../design_system/component/creta_basic_layout_mixin.dart';
import '../../design_system/component/custom_image.dart';
import '../../design_system/creta_font.dart';
//import '../../lang/creta_lang.dart';
//import 'package:creta03/design_system/creta_color.dart';
import 'package:creta03/pages/community/community_sample_data.dart';
import 'creta_book_ui_item.dart';

//bool _isInUsingCanvaskit = false;

class CommunityBookPage extends StatefulWidget {
  final String subPageUrl;
  const CommunityBookPage({super.key, this.subPageUrl = ''});

  @override
  State<CommunityBookPage> createState() => _CommunityBookPageState();
}

class _CommunityBookPageState extends State<CommunityBookPage> {
  late List<CretaBookData> _cretaRelatedBookList;

  @override
  void initState() {
    super.initState();

    _cretaRelatedBookList = CommunitySampleData.getCretaBookList();
  }

  Widget _getHashtagWidget(String hashtag) {
    return CretaElevatedButton(
      height: 32,
      caption: hashtag,
      captionStyle: CretaFont.bodyMedium.copyWith(fontSize: 13),
      onPressed: () {},
      bgHoverColor: CretaColor.text[100]!,
      bgHoverSelectedColor: CretaColor.text[100]!,
      bgSelectedColor: Colors.white,
      borderColor: CretaColor.text[700]!,
      borderSelectedColor: CretaColor.text[700]!,
      fgColor: CretaColor.text[700]!,
      fgSelectedColor: CretaColor.text[700]!,
    );
  }

  List<Widget> _getHashtagList() {
    return [
      _getHashtagWidget('#크레타북'),
      _getHashtagWidget('#추천'),
      _getHashtagWidget('#인기'),
      _getHashtagWidget('#해시태그'),
      _getHashtagWidget('#목록입니다'),
      _getHashtagWidget('#스페이싱'),
      _getHashtagWidget('#스페이싱'),
      _getHashtagWidget('#스페이싱'),
      _getHashtagWidget('#스페이싱'),
      BTN.opacity_gray_it_s(
        text: '#크레타북',
        textStyle: CretaFont.buttonMedium,
        //width: null,
        onPressed: () {},
        width: null,
      ),
      BTN.opacity_gray_it_s(
        text: '#추천',
        textStyle: CretaFont.buttonMedium,
        //width: null,
        onPressed: () {},
        width: null,
      ),
      // SizedBox(width: 12),
      // BTN.opacity_gray_it_s(
      //   text: '#인기',
      //   textStyle: CretaFont.buttonMedium,
      //   //width: null,
      //   onPressed: () {},
      // ),
      // SizedBox(width: 12),
      // BTN.opacity_gray_it_s(
      //   text: '#해시태그',
      //   textStyle: CretaFont.buttonMedium,
      //   //width: null,
      //   onPressed: () {},
      // ),
    ];
  }

  Widget _getTitlePane(Size size) {
    return Container(
      width: size.width,
      height: size.height,
      padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(7.6),
        ),
        padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
        child: Row(
          children: [
            Text(
              '크레타북 01', //'[아이유의 팔레트🎨] 내 마음속 영원히 맑은 하늘 (With god) Ep.17',
              overflow: TextOverflow.ellipsis,
              style: CretaFont.titleELarge.copyWith(color: Colors.white),
            ),
            SizedBox(width: 20),
            // CretaElevatedButton(
            //   caption: '이지금 [IU Official]',
            //   captionStyle: CretaFont.bodyMedium.copyWith(color: Colors.white),
            //   icon: Icon(Icons.person_pin, color: Colors.white, size: 16),
            //   bgColor: CretaColor.primary,
            //   bgSelectedColor: CretaColor.primary[600]!,
            //   bgHoverColor: CretaColor.primary[500]!,
            //   bgHoverSelectedColor: CretaColor.primary,
            //   fgColor: CretaColor.primary,
            //   fgSelectedColor: CretaColor.primary,
            //   borderColor: CretaColor.primary,
            //   borderSelectedColor: CretaColor.primary,
            //   onPressed: () {},
            // ),
            BTN.fill_gray_it_m(
              text: '이지금 [IU Official]',
              icon: Icons.account_circle,
              onPressed: () {},
              width: null,
              buttonColor: CretaButtonColor.transparent,
              textColor: Colors.white,
              alwaysShowIcon: true,
            ),
            // InkWell(
            //   onTap: () {},
            //   child: Row(
            //     children: [
            //       Icon(Icons.person_pin, color: Colors.white, size: 16),
            //       SizedBox(width:8),
            //       Text(
            //         '이지금 [IU Official]',
            //         overflow: TextOverflow.ellipsis,
            //         style: CretaFont.bodyMedium.copyWith(color: Colors.white),
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(width: 20),
            Text(
              '2023.03.01',
              style: CretaFont.bodyMedium.copyWith(color: Colors.white),
            ),
            SizedBox(width: 20),
            Text(
              '조회수 123,456회',
              style: CretaFont.bodyMedium.copyWith(color: Colors.white),
            ),
            Expanded(child: Container()),
            BTN.fill_gray_i_l(
              icon: Icons.edit_outlined,
              onPressed: () {},
              buttonColor: CretaButtonColor.blueAndWhiteTitle,
              iconColor: Colors.white,
            ),
            SizedBox(width: 12),
            BTN.fill_gray_it_l(
              icon: Icons.favorite_border_outlined,
              text: '123',
              onPressed: () {},
              buttonColor: CretaButtonColor.transparent,
              textColor: Colors.white,
              width: null,
              sidePaddingSize: 8,
            ),
            SizedBox(width: 13),
            BTN.fill_gray_itt_l(
              icon: Icons.copy_rounded,
              text: '복제하기',
              subText: '123',
              onPressed: () {},
              buttonColor: CretaButtonColor.skyTitle,
              textColor: Colors.white,
              subTextColor: CretaColor.primary[200],
              width: null,
              sidePaddingSize: 8,
            ),
            SizedBox(width: 12),
            BTN.fill_gray_i_l(
              icon: Icons.menu_outlined,
              onPressed: () {},
              buttonColor: CretaButtonColor.transparent,
              iconColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  final GlobalKey bookKey = GlobalKey();

  Widget _getBook(Size size) {
    if (_cretaRelatedBookList.isNotEmpty) {
      return Container(
        decoration: BoxDecoration(
          // crop
          borderRadius: BorderRadius.circular(20.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            ClipRect(
              child: CustomImage(
                  key: bookKey,
                  duration: 500,
                  hasMouseOverEffect: false,
                  width: size.width,
                  height: size.height,
                  image: _cretaRelatedBookList[0].thumbnailUrl),
            ),
            Container(
              width: size.width,
              height: size.height,
              decoration: bookMouseOver ? Snippet.gradationShadowDeco() : null,
            ),
          ],
        ),
      );
    }
    return Container();
  }

  double _value = 0;
  bool bookMouseOver = false;
  bool sliderMouseOver = false;

  Widget _getBookMainPane(Size size) {
    return MouseRegion(
      onEnter: (val) {
        setState(() {
          bookMouseOver = true;
        });
      },
      onExit: (val) {
        setState(() {
          bookMouseOver = false;
        });
      },
      child: Container(
        width: size.width,
        height: size.height,
        margin: EdgeInsets.fromLTRB(80, 0, 0, 0),
        child: Stack(
          children: [
            _getBook(size),
            !bookMouseOver
                ? Container()
                : Container(
              padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Container()),
                  BTN.fill_blue_i_l(
                    icon: Icons.share_outlined,
                    buttonColor: CretaButtonColor.blueGray,
                    onPressed: () {},
                  ),
                  SizedBox(width: 12),
                  BTN.fill_blue_i_l(
                    icon: Icons.file_download_outlined,
                    buttonColor: CretaButtonColor.blueGray,
                    onPressed: () {},
                  ),
                  SizedBox(width: 12),
                  BTN.fill_blue_i_l(
                    icon: Icons.playlist_add_outlined,
                    buttonColor: CretaButtonColor.blueGray,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            !bookMouseOver
                ? Container()
                : SizedBox(
              width: size.width,
              height: size.height,
              child: Center(
                child: BTN.opacity_gray_i_el(
                  icon: Icons.play_arrow,
                  onPressed: () {},
                ),
              ),
            ),
            !bookMouseOver
                ? Container()
                : Container(
              height: size.height,
              padding: EdgeInsets.fromLTRB(20-4, 24, 20-4, 16),
              child: Column(
                children: [
                  Expanded(child: Container()),
                  MouseRegion(
                    onEnter: (val) {
                      setState(() {
                        sliderMouseOver = true;
                      });
                    },
                    onExit: (val) {
                      setState(() {
                        sliderMouseOver = false;
                      });
                    },
                    child: Container(
                      height: 8,
                      //color: Colors.red,
                      margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
                      decoration: BoxDecoration(
                        // crop
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: SliderTheme(
                        data: SliderThemeData(
                          //overlayShape: SliderComponentShape.noOverlay,
                          trackHeight: 8.0,
                          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4, elevation: 0, pressedElevation: 0),
                          thumbColor: sliderMouseOver ? null : Colors.transparent,
                          inactiveTrackColor: Colors.white,
                          overlayColor: Colors.transparent,
                          //disabledThumbColor: Colors.transparent,
                          // overlappingShapeStrokeColor: Colors.transparent,
                          // valueIndicatorColor: Colors.transparent,
                          trackShape: CustomTrackShape(),
                        ),
                        child: Slider(
                          //thumbColor: sliderMouseOver ? null : Colors.transparent,
                          min: 0,
                          max: 100,
                          value: _value,
                          onChanged: (double value) {
                            setState(() {
                              _value = value;
                              //print('value=$value');
                            });
                          },
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
    double height = _cretaRelatedBookList.length * 256;
    if (_cretaRelatedBookList.isNotEmpty) {
      height += ((_cretaRelatedBookList.length - 1) * 20);
    }
    return SizedBox(
      width: size.width,
      height: height,
      //height: size.height,
      //padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
      child: Wrap(
        //direction: Axis.vertical, // 나열 방향
        //alignment: WrapAlignment.start, // 정렬 방식
        //spacing: 16, // 좌우 간격
        runSpacing: 20, // 상하 간격
        children: _cretaRelatedBookList.map((item) {
          return CretaBookItem(
            key: item.uiKey,
            cretaBookData: item,
            width: 365,
            height: 256,
          );
        }).toList(),
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

  Widget _getMainPane() {
    return SizedBox(
      width: bookArea.width,
      child: Column(
        children: [
          // book
          _getBookMainPane(Size(bookArea.width - 80, bookArea.height)),
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
                    child: Center(child: _getBookDescriptionPane(Size(bookArea.width - 100, 600))),
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
    );
  }

  Widget _getSidePane() {
    return SizedBox(
      width: sideArea.width,
      child: Column(
        children: [
          // hashtag
          Container(
            //height: 210,
            padding: EdgeInsets.fromLTRB(60, 20, 0, 0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '해시태그',
                      style: CretaFont.titleELarge.copyWith(color: CretaColor.text[700]),
                    ),
                    Expanded(child: Container()),
                    BTN.fill_gray_200_i_s(icon: Icons.edit_outlined, onPressed: () {}),
                    SizedBox(width: 46),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    SizedBox(
                      width: 365 + 16 + 16,
                      child: Wrap(
                        direction: Axis.horizontal, // 나열 방향
                        alignment: WrapAlignment.start, // 정렬 방식
                        spacing: 16, // 좌우 간격
                        runSpacing: 20, // 상하 간격
                        children: _getHashtagList(),
                      ),
                    ),
                    Expanded(child: Container()),
                  ],
                ),
              ],
            ),
          ),
          // related book
          Container(
            //height: 1000,
            padding: EdgeInsets.fromLTRB(60, 60, 100, 40),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '연관 크레타북',
                      style: CretaFont.titleELarge.copyWith(color: CretaColor.text[700]),
                    ),
                    Expanded(child: Container()),
                  ],
                ),
                SizedBox(height: 20),
                _getRelatedBookList(Size(sideArea.width - 60 - 100, 1000)),
              ],
            ),
          ),
        ],
      ),
    );
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
            _getTitlePane(titleArea),
            // body
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // main
                _getMainPane(),
                // side
                _getSidePane(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}