// ignore_for_file: prefer_const_constructors

import 'package:creta03/design_system/buttons/creta_button.dart';
import 'package:flutter/material.dart';
//import 'dart:async';
//import 'package:flutter/gestures.dart';
//import 'package:hycop/hycop.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:routemaster/routemaster.dart';
//import 'package:url_strategy/url_strategy.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/component/snippet.dart';
//import '../../design_system/menu/creta_drop_down.dart';
import '../../design_system/menu/creta_popup_menu.dart';
//import '../../design_system/text_field/creta_search_bar.dart';
//import '../design_system/creta_color.dart';
//import 'package:image_network/image_network.dart';
//import 'package:cached_network_image/cached_network_image.dart';
//import '../../common/cross_common_job.dart';
import '../../routes.dart';
//import 'sub_pages/community_left_menu_pane.dart';
import 'community_sample_data.dart';
import '../../design_system/component/custom_image.dart';
import '../../design_system/creta_font.dart';
import '../../design_system/creta_color.dart';

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
const double _itemDescriptionHeight = 56;

bool isInUsingCanvaskit = false;

class CretaBookItem extends StatefulWidget {
  final CretaBookData cretaBookData;
  final double width;
  final double height;

  const CretaBookItem({
    required super.key,
    required this.cretaBookData,
    required this.width,
    required this.height,
  });

  @override
  CretaBookItemState createState() => CretaBookItemState();
}

class CretaBookItemState extends State<CretaBookItem> {
  bool mouseOver = false;
  bool popmenuOpen = false;

  late List<CretaMenuItem> _popupMenuList;

  void _openPopupMenu() {
    CretaPopupMenu.showMenu(
        context: context, globalKey: widget.cretaBookData.uiKey, popupMenu: _popupMenuList, initFunc: setPopmenuOpen)
        .then((value) {
      logger.finest('팝업메뉴 닫기');
      setState(() {
        popmenuOpen = false;
      });
    });
  }

  void _editItem() {
    logger.finest('편집하기(${widget.cretaBookData.name})');
    Routemaster.of(context).push(AppRoutes.communityBook);
  }

  void _doPopupMenuPlay() {
    logger.finest('재생하기(${widget.cretaBookData.name})');
  }

  void _doPopupMenuEdit() {
    logger.finest('편집하기(${widget.cretaBookData.name})');
  }

  void _doPopupMenuAddToPlayList() {
    logger.finest('재생목록에 추가(${widget.cretaBookData.name})');
  }

  void _doPopupMenuShare() {
    logger.finest('공유하기(${widget.cretaBookData.name})');
  }

  void _doPopupMenuDownload() {
    logger.finest('다운로드(${widget.cretaBookData.name})');
  }

  void _doPopupMenuCopy() {
    logger.finest('복사하기(${widget.cretaBookData.name})');
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

  List<Widget> _getOverlayMenu() {
    if (!(mouseOver || popmenuOpen)) {
      return [];
    }

    return [
      Container(
        width: widget.width,
        height: 37,
        padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Row(
          children: [
            BTN.opacity_gray_it_s(
              width: 91,
              icon: Icons.edit_outlined,
              text: '편집하기',
              onPressed: () => _editItem(),
              alwaysShowIcon: true,
            ),
            Expanded(child: Container()),
            BTN.opacity_gray_i_s(
              icon: Icons.favorite_outline,
              onPressed: () {},
            ),
            SizedBox(width: 4),
            BTN.opacity_gray_i_s(
              icon: Icons.content_copy_rounded,
              onPressed: () {},
            ),
            SizedBox(width: 4),
            BTN.opacity_gray_i_s(
              icon: Icons.menu_outlined,
              onPressed: () => _openPopupMenu(),
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
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
                  // 썸네일 이미지
                  ClipRect(
                    child: CustomImage(
                        key: widget.cretaBookData.imgKey,
                        duration: 500,
                        hasMouseOverEffect: true,
                        width: widget.width,
                        height: widget.height - _itemDescriptionHeight,
                        image: widget.cretaBookData.thumbnailUrl),
                  ),
                  // 그라데이션
                  Container(
                    width: widget.width,
                    height: widget.height - _itemDescriptionHeight,
                    decoration: (mouseOver || popmenuOpen) ? Snippet.gradationShadowDeco() : null,
                  ),
                  // 편집하기, 추가, 메뉴 버튼 (반투명 배경)
                  ..._getOverlayMenu(),
                ],
              ),
            ),
            Container(
              width: widget.width,
              height: _itemDescriptionHeight,
              color: (mouseOver || popmenuOpen) ? Colors.grey[100] : Colors.white,
              child: Row(
                children: [
                  SizedBox(width: 15),
                  Expanded(
                    //width: widget.width - 15 - 8 - 36 - 8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text(
                          widget.cretaBookData.name,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: CretaFont.bodyMedium.copyWith(color: CretaColor.text[700]),
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.cretaBookData.creator,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: CretaFont.buttonMedium.copyWith(color: CretaColor.text[400]),
                        ),
                      ],
                    ),
                  ),
                  //Expanded(child: Container()),
                  SizedBox(width: 8),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 9),
                        BTN.fill_gray_i_l(
                          icon: Icons.content_copy_rounded,
                          buttonColor: CretaButtonColor.transparent,
                          onPressed: () {},
                        ),
                      ],
                  ),
                  SizedBox(width: 8),
                ],
              ),
              // child: Stack(
              //   children: [
              //     Positioned(
              //         left: widget.width - 37,
              //         top: 17,
              //         child: Container(
              //           width: 20,
              //           height: 20,
              //           color: (mouseOver || popmenuOpen) ? Colors.grey[100] : Colors.white,
              //           child: Icon(
              //             Icons.favorite_outline,
              //             size: 20.0,
              //             color: Colors.grey[700],
              //           ),
              //         )),
              //     Positioned(
              //       left: 15,
              //       top: 7,
              //       child: Container(
              //           width: widget.width - 45 - 15,
              //           color: (mouseOver || popmenuOpen) ? Colors.grey[100] : Colors.white,
              //           child: Text(
              //             widget.cretaBookData.name,
              //             overflow: TextOverflow.ellipsis,
              //             textAlign: TextAlign.left,
              //             style: TextStyle(
              //               fontSize: 16,
              //               color: Colors.grey[700],
              //               fontFamily: 'Pretendard',
              //             ),
              //           )),
              //     ),
              //     Positioned(
              //       left: 16,
              //       top: 29,
              //       child: Container(
              //         width: widget.width - 45 - 15,
              //         color: (mouseOver || popmenuOpen) ? Colors.grey[100] : Colors.white,
              //         child: Text(
              //           widget.cretaBookData.creator,
              //           overflow: TextOverflow.ellipsis,
              //           textAlign: TextAlign.left,
              //           style: TextStyle(
              //             fontSize: 13,
              //             color: Colors.grey[500],
              //             fontFamily: 'Pretendard',
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
