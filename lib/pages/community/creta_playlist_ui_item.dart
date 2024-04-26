// ignore_for_file: prefer_const_constructors

//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'dart:async';
import 'package:url_launcher/link.dart';
//import 'package:flutter/gestures.dart';
//import 'package:hycop/hycop.dart';
//import 'package:hycop/common/util/logger.dart';
import 'package:routemaster/routemaster.dart';
import 'package:creta_common/common/creta_common_utils.dart';

//import 'package:url_strategy/url_strategy.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
//import '../../design_system/component/snippet.dart';
//import '../../design_system/menu/creta_drop_down.dart';
import '../../design_system/menu/creta_popup_menu.dart';
//import '../../design_system/text_field/creta_search_bar.dart';
//import 'package:creta_common/common/creta_color.dart';
//import 'package:image_network/image_network.dart';
//import 'package:cached_network_image/cached_network_image.dart';
//import '../../common/cross_common_job.dart';
import '../../lang/creta_commu_lang.dart';
import '../../routes.dart';
//import 'sub_pages/community_left_menu_pane.dart';
//import 'community_sample_data.dart';
//import '../../design_system/component/custom_image.dart';
//import '../../pages/login_page.dart';
import '../../pages/login/creta_account_manager.dart';
import '../../design_system/component/custom_image.dart';
import 'package:creta_studio_model/model/book_model.dart';
import '../../model/playlist_model.dart';
import 'sub_pages/community_right_playlist_detail_pane.dart';

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
  const CretaPlaylistItem({
    required super.key,
    required this.playlistModel,
    required this.width,
    //required this.height,
    required this.bookMap,
    required this.editPopupMenu,
    required this.deletePopupMenu,
  });
  final PlaylistModel playlistModel;
  final double width;
  final Map<String, BookModel> bookMap;
  //final double height;
  final Function(PlaylistModel) editPopupMenu;
  final Function(PlaylistModel) deletePopupMenu;

  @override
  CretaPlaylistItemState createState() => CretaPlaylistItemState();
}

class CretaPlaylistItemState extends State<CretaPlaylistItem> {
  //bool _mouseOver = false;
  //bool _popmenuOpen = false;

  final ScrollController _controller = ScrollController();
  late final GlobalKey _popupMenuKey;
  late List<CretaMenuItem> _popupMenuList;

  @override
  void initState() {
    super.initState();

    _popupMenuKey =
        GlobalObjectKey('CretaPlaylistItemState.${widget.playlistModel.getMid}.popmenu');
    _popupMenuList = [
      CretaMenuItem(
        caption: CretaCommuLang['playListModify'],
        onPressed: _editPlaylistProperty,
      ),
      CretaMenuItem(
        caption: CretaCommuLang['playListDelete'],
        onPressed: _deletePlaylist,
      ),
    ];
  }

  void _editPlaylistProperty() {
    widget.editPopupMenu.call(widget.playlistModel);
  }

  void _deletePlaylist() {
    widget.deletePopupMenu.call(widget.playlistModel);
  }

  void setPopmenuOpen() {
    //_popmenuOpen = true;
  }

  void _openPopupMenu() {
    CretaPopupMenu.showMenu(
      xOffset: 35,
      context: context,
      globalKey: _popupMenuKey,
      popupMenu: _popupMenuList,
      initFunc: setPopmenuOpen,
    ).then((value) {
      // logger.finest('팝업메뉴 닫기');
      // setState(() {
      //   _popmenuOpen = false;
      // });
    });
  }

  Widget _leftInfoPane() {
    final String showDetailLinkUrl = '${AppRoutes.playlistDetail}?${widget.playlistModel.mid}';
    final String playDetailLinkUrl = (widget.playlistModel.bookIdList.isEmpty)
        ? ''
        : '${AppRoutes.communityBook}?${widget.playlistModel.bookIdList[0]}&${widget.playlistModel.getMid}';
    return Container(
      //color: Colors.amberAccent,
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
                        widget.playlistModel.name,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: CretaFont.titleELarge.copyWith(color: CretaColor.text[700]),
                      ),
                    ),
                    SizedBox(width: 8),
                    (widget.playlistModel.isPublic)
                        ? SizedBox.shrink()
                        : Icon(Icons.lock_outline, size: 16),
                    Expanded(child: Container()),
                  ],
                ),
              ),
              SizedBox(height: 48),
              Text(
                CretaAccountManager.getUserProperty?.nickname ?? '', //widget.playlistModel.userId,
                style: CretaFont.buttonMedium.copyWith(color: CretaColor.text[500]),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    '${CretaCommuLang['videoCount']} ${widget.playlistModel.bookIdList.length}',
                    style: CretaFont.buttonMedium.copyWith(color: CretaColor.text[400]),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '${CretaCommuLang['recentUpdates']} ${CretaCommonUtils.dateToDurationString(widget.playlistModel.updateTime)}',
                    style: CretaFont.buttonMedium.copyWith(color: CretaColor.text[400]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
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
              BTN.fill_gray_i_m(
                key: _popupMenuKey,
                icon: Icons.menu,
                onPressed: () {
                  //widget.popupMenu.call(widget.playlistModel);
                  _openPopupMenu();
                },
              ),
              SizedBox(height: 23),
              Link(
                uri: Uri.parse(showDetailLinkUrl),
                builder: (context, function) {
                  return BTN.fill_gray_t_m(
                    text: CretaCommuLang['viewAll'],
                    width: 77,
                    height: 32,
                    onPressed: () {
                      CommunityRightPlaylistDetailPane.playlistId = widget.playlistModel.mid;
                      Routemaster.of(context).push(showDetailLinkUrl);
                    },
                  );
                },
              ),
              SizedBox(height: 8),
              Link(
                uri: Uri.parse(playDetailLinkUrl),
                builder: (context, function) {
                  return BTN.fill_blue_t_m(
                    width: 77,
                    height: 32,
                    text: CretaCommuLang['play'],
                    onPressed: () {
                      if (playDetailLinkUrl.isNotEmpty) {
                        Routemaster.of(context).push(playDetailLinkUrl);
                      }
                    },
                  );
                },
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
              children: List<Widget>.generate(widget.playlistModel.bookIdList.length, (idx) {
                BookModel bModel =
                    widget.bookMap[widget.playlistModel.bookIdList[idx]] ?? BookModel('dummy');
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
                      image: bModel.thumbnailUrl.value,
                      hasAni: false,
                      hasMouseOverEffect: false,
                      useDefaultErrorImage: true,
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
          //_mouseOver = true;
        });
      },
      onExit: (value) {
        setState(() {
          //_mouseOver = false;
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
      ),
    );
  }
}
