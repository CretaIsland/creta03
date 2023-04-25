// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
//import 'dart:async';
//import 'package:flutter/gestures.dart';
//import 'package:hycop/hycop.dart';
//import 'package:hycop/common/util/logger.dart';
import 'package:routemaster/routemaster.dart';
//import 'package:url_strategy/url_strategy.dart';
import '../../design_system/creta_color.dart';
import '../../design_system/creta_font.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
//import '../../design_system/component/snippet.dart';
//import '../../design_system/menu/creta_drop_down.dart';
//import '../../design_system/menu/creta_popup_menu.dart';
//import '../../design_system/text_field/creta_search_bar.dart';
//import '../design_system/creta_color.dart';
//import 'package:image_network/image_network.dart';
//import 'package:cached_network_image/cached_network_image.dart';
//import '../../common/cross_common_job.dart';
import '../../routes.dart';
//import 'sub_pages/community_left_menu_pane.dart';
import 'community_sample_data.dart';
//import '../../design_system/component/custom_image.dart';
import '../../design_system/component/custom_image.dart';

// const double _rightViewTopPane = 40;
const double _rightViewLeftPane = 40;
const double _rightViewRightPane = 40;
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
//const double _itemDescriptionHeight = 56;

bool isInUsingCanvaskit = false;

class CretaPlaylistItem extends StatefulWidget {
  final CretaPlaylistData cretaPlayListData;
  final double width;
  //final double height;

  const CretaPlaylistItem({
    required super.key,
    required this.cretaPlayListData,
    required this.width,
    //required this.height,
  });

  @override
  CretaPlaylistItemState createState() => CretaPlaylistItemState();
}

class CretaPlaylistItemState extends State<CretaPlaylistItem> {
  bool mouseOver = false;
  bool popmenuOpen = false;

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  void setPopmenuOpen() {
    popmenuOpen = true;
  }

  Widget _leftInfoPane() {
    return Container(
      width: 395,
      padding: EdgeInsets.fromLTRB(_rightViewLeftPane, 0, _rightViewRightPane, 0),
      child: Row(
        children: [
          // left (title, nickname, info)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 36),
              SizedBox(
                width: 230,
                child: Row(
                  children: [
                    Container(
                      //width: 206,
                      constraints: BoxConstraints(maxWidth: 230 - 8 - 16),
                      child: Text(
                        widget.cretaPlayListData.title,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: CretaFont.titleELarge.copyWith(color: CretaColor.text[700]),
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.lock_outline, size: 16),
                    Expanded(child: Container()),
                  ],
                ),
              ),
              SizedBox(height: 48),
              Text(
                widget.cretaPlayListData.userNickname,
                style: CretaFont.buttonMedium.copyWith(color: CretaColor.text[500]),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    '영상 154개',
                    style: CretaFont.buttonMedium.copyWith(color: CretaColor.text[400]),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '최근 업데이트 1일전',
                    style: CretaFont.buttonMedium.copyWith(color: CretaColor.text[400]),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(width: 8),
          // right (menu, all-list, play buttons)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: 24),
              BTN.fill_gray_i_m(icon: Icons.menu, onPressed: () {}),
              SizedBox(height: 23),
              BTN.fill_gray_t_m(
                text: '전체보기',
                width: 77,
                height: 32,
                onPressed: () {
                  Routemaster.of(context).push(AppRoutes.playlistDetail);
                },
              ),
              SizedBox(height: 8),
              BTN.fill_blue_t_m(
                text: '재생하기',
                width: 77,
                height: 32,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _rightBookListPane() {
    return Container(
      width: widget.width - 395 - 2,
      padding: EdgeInsets.fromLTRB(0, 33, 20, 33),
      child: Scrollbar(
        thumbVisibility: false,
        controller: _controller,
        child: ListView(
          controller: _controller,
          // 스크롤 방향 설정. 수평적으로 스크롤되도록 설정
          scrollDirection: Axis.horizontal,
          // 컨테이너들을 ListView의 자식들로 추가
          children: [
            Wrap(
              direction: Axis.horizontal,
              spacing: 20, // <-- Spacing between children
              children: List<Widget>.generate(widget.cretaPlayListData.cretaBookDataList.length, (idx) {
                return Container(
                  width: 207,
                  height: 118,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.4),
                    color: Colors.grey, //Color.fromARGB(255, 242, 242, 242),
                  ),
                  //padding: EdgeInsets.all(10),
                  //color: Colors.red[100],
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.4),
                    child: CustomImage(
                      width: 207,
                      height: 118,
                      image: widget.cretaPlayListData.cretaBookDataList[idx].thumbnailUrl,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
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
        height: 184,
        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: CretaColor.text[100],
        ),
        child: Row(
          children: [
            // left (info) pane
            _leftInfoPane(),
            // right (book list) pane
            _rightBookListPane(),
          ],
        ),
        // child: Column(
        //   children: [
        //     Expanded(
        //       child: Container(
        //         decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(7.2),
        //           color: Color.fromARGB(255, 242, 242, 242),
        //         ),
        //         width: widget.width,
        //         //height: 184,
        //         child: Stack(
        //           children: [
        //             Positioned(
        //               left: 40,
        //               top: 40,
        //               child: Container(
        //                 width: 270,
        //                 color: Color.fromARGB(255, 242, 242, 242),
        //                 child: Row(
        //                   children: [
        //                     Container(
        //                       constraints: BoxConstraints(maxWidth: 270-16-16, ),
        //                       child:Text(
        //                         widget.cretaPlayListData.title,
        //                         overflow: TextOverflow.ellipsis,
        //                         textAlign: TextAlign.left,
        //                         style: TextStyle(
        //                           color: Colors.grey[700],
        //                           fontSize: 22,
        //                           fontFamily: 'Pretendard',
        //                           fontWeight: FontWeight.w600,
        //                         ),
        //                       ),),
        //                     SizedBox(width:16,),
        //                     widget.cretaPlayListData.locked ?
        //                     Icon(Icons.lock_outline, size:16, color: Colors.grey[700],)
        //                         : Icon(Icons.lock_open_outlined, size:16, color: Colors.grey[700],),
        //                     Expanded(child: Container()),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //             // Positioned(
        //             //   left: 154,
        //             //   top: 45,
        //             //   child: widget.cretaPlayListData.locked ?
        //             //     Icon(Icons.lock_outline, size:16, color: Colors.grey[700],)
        //             //     : Icon(Icons.lock_open_outlined, size:16, color: Colors.grey[700],
        //             //   ),
        //             // ),
        //             Positioned(
        //               left: 40,
        //               top: 107,
        //               child: Text(
        //                 widget.cretaPlayListData.userNickname,
        //                 style: TextStyle(
        //                   color: Colors.grey[500],
        //                   fontSize: 13,
        //                   fontFamily: 'Pretendard',
        //                   //fontWeight: FontWeight.w600,
        //                 ),
        //               ),
        //             ),
        //             Positioned(
        //               left: 40,
        //               top: 129,
        //               child: Text(
        //                 '영상 ${widget.cretaPlayListData.cretaBookDataList.length}개  최근 업데이트 1일전',
        //                 style: TextStyle(
        //                   color: Colors.grey[400],
        //                   fontSize: 13,
        //                   fontFamily: 'Pretendard',
        //                   //fontWeight: FontWeight.w600,
        //                 ),
        //               ),
        //             ),
        //             Positioned(
        //               left: 331,
        //               top: 48,
        //               child: Icon(Icons.menu, size:16, color: Colors.grey[700],),
        //             ),
        //             Positioned(
        //               left: 277+1,
        //               top: 77-1,
        //               width: 77,
        //               height: 32,
        //               //BTN.fill_gray_t_m
        //               child: BTN.fill_gray_t_m(
        //                 text: '전체보기',
        //                 onPressed: () {
        //                   Routemaster.of(context).push(AppRoutes.playlistDetail);
        //                 },
        //               ),
        //             ),
        //             Positioned(
        //               left: 278,
        //               top: 114,
        //               width: 77,
        //               height: 32,
        //               //BTN.fill_blue_t_m
        //               child: BTN.fill_blue_t_m(
        //                 text: '재생하기',
        //                 onPressed: () {},
        //               ),
        //             ),
        //             Positioned(
        //               left: 495,
        //               top: 20,
        //               width: widget.width - 495 - 20 - _rightViewLeftPane - _rightViewRightPane,
        //               height: 144,
        //               child: Scrollbar(
        //                 thumbVisibility: false,
        //                 controller: _controller,
        //                 child: ListView(
        //                   controller: _controller,
        //                   // 스크롤 방향 설정. 수평적으로 스크롤되도록 설정
        //                   scrollDirection: Axis.horizontal,
        //                   // 컨테이너들을 ListView의 자식들로 추가
        //                   children: <Widget>[
        //                     Wrap(
        //                       direction: Axis.horizontal,
        //                       spacing: 20, // <-- Spacing between children
        //                       children: <Widget>[
        //                         ...List<Widget>.generate(widget.cretaPlayListData.cretaBookDataList.length, (idx) {
        //                           return Container(
        //                             width: 187,
        //                             height: 144,
        //                             decoration: BoxDecoration(
        //                               borderRadius: BorderRadius.circular(5.4),
        //                               color: Colors.grey,//Color.fromARGB(255, 242, 242, 242),
        //                             ),
        //                             //padding: EdgeInsets.all(10),
        //                             //color: Colors.red[100],
        //                             child: ClipRRect(
        //                               borderRadius: BorderRadius.circular(5.4),
        //                               child: CustomImage(
        //                                 width: 187,
        //                                 height: 144,
        //                                 image: widget.cretaPlayListData.cretaBookDataList[idx].thumbnailUrl,
        //                               ),
        //                             ),
        //                           );
        //                         }).toList(),
        //                       ],
        //                     )
        //                   ],
        //                 ),
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //     SizedBox(
        //       height: 20,
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
