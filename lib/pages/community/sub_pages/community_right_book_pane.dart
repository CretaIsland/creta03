// ignore_for_file: prefer_const_constructors

import 'package:creta03/design_system/buttons/creta_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
//import 'dart:async';
//import 'package:flutter/gestures.dart';
//import 'package:hycop/hycop.dart';
//import 'package:hycop/common/util/logger.dart';
//import 'package:routemaster/routemaster.dart';
//import 'package:url_strategy/url_strategy.dart';
import '../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../design_system/buttons/creta_elibated_button.dart';
//import '../../design_system/buttons/creta_button.dart';
import '../../../design_system/component/snippet.dart';
//import '../../design_system/menu/creta_drop_down.dart';
//import '../../design_system/menu/creta_popup_menu.dart';
//import '../../design_system/text_field/creta_search_bar.dart';
import '../../../design_system/creta_color.dart';
//import 'package:image_network/image_network.dart';
//import 'package:cached_network_image/cached_network_image.dart';
//import '../../common/cross_common_job.dart';
//import '../../routes.dart';
//import 'sub_pages/community_left_menu_pane.dart';
//import '../../design_system/component/creta_basic_layout_mixin.dart';
import '../../../design_system/component/custom_image.dart';
import '../../../design_system/creta_font.dart';
//import '../../lang/creta_lang.dart';
//import 'package:creta03/design_system/creta_color.dart';
import 'package:creta03/pages/community/community_sample_data.dart';
import '../creta_book_ui_item.dart';
import '../../../design_system/buttons/creta_progress_slider.dart';
//import '../../design_system/text_field/creta_comment_bar.dart';
import 'community_comment_pane.dart';

//bool _isInUsingCanvaskit = false;

class CommunityRightBookPane extends StatefulWidget {
  final double pageWidth;
  final double pageHeight;
  final ScrollController scrollController;
  const CommunityRightBookPane({
    super.key,
    required this.pageWidth,
    required this.pageHeight,
    required this.scrollController,
  });

  @override
  State<CommunityRightBookPane> createState() => _CommunityRightBookPaneState();
}

class _CommunityRightBookPaneState extends State<CommunityRightBookPane> {
  late List<CretaBookData> _cretaRelatedBookList;

  @override
  void initState() {
    super.initState();

    _cretaRelatedBookList = CommunitySampleData.getCretaBookList();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.selection = TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
      }
    });
    _controller.text = _description;
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
  //bool sliderMouseOver = false;

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
                    padding: EdgeInsets.fromLTRB(20, 24, 20, 16 - 4),
                    child: Column(
                      children: [
                        Expanded(child: Container()),
                        CretaProgressSlider(
                          height: 24,
                          barThickness: 8,
                          min: 0,
                          max: 100,
                          value: _value,
                          inactiveTrackColor: Colors.white,
                          onChanged: (value) {
                            setState(() {
                              _value = value;
                              //print('value=$value');
                            });
                          },
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  bool _clickedDescriptionEditButton = false;
  String _description =
      '한강의 사계절을 한강 철교를 중심으로 표현해 보았습니다. 즐겁게 감상하세요.\n보다 자세한 사항은 아래 블로그를 방문해 주세요.\n\n이 콘텐츠의 사용 조건(저작권) : MIT\n이 콘텐츠가 포함하고 있는 원본 저작권 표시 : YG Entertainment, SME, Hive...';
  String _descriptionOld = '';
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  Widget _getBookDescriptionPane(Size size) {
    _descriptionOld = _description;
    return SizedBox(
      width: size.width,
      //height: size.height,
      //padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '내용',
                style: CretaFont.titleELarge.copyWith(color: CretaColor.text[700]),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 19),
              RawKeyboardListener(
                focusNode: FocusNode(),
                onKey: (RawKeyEvent event) {
                  if (event.logicalKey == LogicalKeyboardKey.escape) {
                    // Do something when ESC key is pressed
                    setState(() {
                      //print('_description(1)=$_description');
                      _controller.text = _description;
                      _clickedDescriptionEditButton = false;
                    });
                  }
                },
                child: CupertinoTextField(
                  minLines: 1,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  focusNode: _focusNode,
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 6),
                  enabled: _clickedDescriptionEditButton,
                  autofocus: false,
                  decoration: BoxDecoration(
                    color: _clickedDescriptionEditButton ? Colors.white : Color.fromARGB(255, 250, 250, 250),
                    border: _clickedDescriptionEditButton
                        ? Border.all(color: CretaColor.text[200]!)
                        : Border.all(color: Color.fromARGB(255, 250, 250, 250)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  controller: _controller,
                  //placeholder: _clicked ? null : widget.hintText,
                  placeholderStyle: CretaFont.bodySmall.copyWith(color: CretaColor.text[400]!),
                  // prefixInsets: EdgeInsetsDirectional.only(start: 18),
                  // prefixIcon: Container(),
                  style: CretaFont.bodyMedium.copyWith(
                    color: CretaColor.text[700],
                    height: 2.0,
                  ),
                  // suffixInsets: EdgeInsetsDirectional.only(end: 18),
                  // suffixIcon: Icon(CupertinoIcons.search),
                  suffixMode: OverlayVisibilityMode.always,
                  onChanged: (value) {
                    _descriptionOld = value;
                  },
                  onSubmitted: ((value) {
                    _descriptionOld = value;
                  }),
                  onTapOutside: (event) {
                    //logger.fine('onTapOutside($_searchValue)');
                    if (_clickedDescriptionEditButton) {
                      setState(() {
                        _description = _descriptionOld;
                        //print('_description(2)=$_description');
                        _clickedDescriptionEditButton = false;
                      });
                    }
                  },
                  // onSuffixTap: () {
                  //   _searchValue = _controller.text;
                  //   logger.finest('search $_searchValue');
                  //   widget.onSearch(_searchValue);
                  // },
                  onTap: () {
                    // setState(() {
                    //   _clicked = true;
                    // });
                  },
                ),
              )
              // Wrap(
              //   direction: Axis.vertical,
              //   spacing: 13, // 상하 간격
              //   children: descList
              //       .map((item) => SizedBox(
              //             width: size.width,
              //             child: Text(
              //               item,
              //               style: CretaFont.bodyMedium.copyWith(color: CretaColor.text[700]),
              //               overflow: TextOverflow.ellipsis,
              //             ),
              //           ))
              //       .toList(),
              // ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Container()),
              _clickedDescriptionEditButton
                  ? Container()
                  : BTN.fill_gray_200_i_s(
                      icon: Icons.edit_outlined,
                      onPressed: () {
                        setState(() {
                          _clickedDescriptionEditButton = true;
                        });
                      },
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getCommentsPane(Size size) {
    return SizedBox(
      width: size.width,
      //height: size.height,
      //padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '댓글',
            style: CretaFont.titleELarge.copyWith(color: CretaColor.text[700]),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 20),
          // CretaCommentBar(
          //   hintText: '욕설, 비방 등은 경고 없이 삭제될 수 있습니다.',
          //   onSearch: (text) {},
          //   width: size.width,
          //   thumb: Icon(Icons.account_circle),
          // ),
          CommunityCommentPane(
            paneWidth: size.width,
            paneHeight: null,
            showAddCommentBar: true,
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

  //Size titleArea = Size.zero;
  Size bookArea = Size.zero;
  //Size descriptionArea = Size.zero;
  Size sideArea = Size.zero;
  void _resize(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    //double height = MediaQuery.of(context).size.height;
    //titleArea = Size(width, 116);
    sideArea = Size(525, double.infinity);
    bookArea = Size(width - sideArea.width, (width - 525 - 80) / 16 * 9);
    //descriptionArea = Size(bookArea.width, double.infinity);
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
                  _getBookDescriptionPane(Size(bookArea.width - 100, 600)),
                  // using contents list
                  // Container(
                  //   color: Colors.red[300],
                  //   height: 600,
                  //   child: Center(child: Text('using contents list area')),
                  // ),
                  SizedBox(height: 12),
                  // comments
                  _getCommentsPane(Size(bookArea.width - 100 - 20, 600)),
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
    return SingleChildScrollView(
      child:
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // main
          _getMainPane(),
          // side
          _getSidePane(),
        ],
      ),
    );
  }
}
