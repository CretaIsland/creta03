// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
//import 'dart:async';
//import 'package:flutter/gestures.dart';
//import 'package:hycop/hycop.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:routemaster/routemaster.dart';
//import 'package:url_strategy/url_strategy.dart';
//import '../design_system/buttons/creta_button_wrapper.dart';
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
      Positioned(
        left: 8,
        top: 8,
        // BTN.opacity_gray_it_s
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child:
          GestureDetector(
            onTap: () => _editItem(),
            child:
            SizedBox(
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
            SizedBox(
              width: 28,
              height: 28,
              child: Icon(
                Icons.menu,
                size: 12.0,
                color: Colors.white,
              ),
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
                    decoration: mouseOver ? Snippet.gradationShadowDeco() : null,
                  ),
                  // 편집하기, 추가, 메뉴 버튼 (반투명 배경)
                  ..._getOverlayMenu(),
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
                          widget.cretaBookData.name,
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
                        widget.cretaBookData.creator,
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
