// ignore_for_file: prefer_const_constructors

//import 'package:creta03/design_system/buttons/creta_button.dart';
import 'package:creta03/design_system/text_field/creta_text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'dart:async';
//import 'package:flutter/gestures.dart';
//import 'package:hycop/hycop.dart';
//import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop.dart';
import 'package:routemaster/routemaster.dart';
import 'package:creta_common/common/creta_common_utils.dart';

//import 'package:url_strategy/url_strategy.dart';
import '../../data_io/host_manager.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/component/snippet.dart';
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
import '../../design_system/component/custom_image.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:creta_common/common/creta_color.dart';
//import '../../../routes.dart';
//import 'package:routemaster/routemaster.dart';
import 'package:url_launcher/link.dart';
//import '../../../design_system/buttons/creta_button_wrapper.dart';
// import '../../../design_system/menu/creta_popup_menu.dart';
// import '../../../design_system/component/custom_image.dart';
// import 'package:creta_common/common/creta_font.dart';
// import 'package:creta_common/common/creta_color.dart';
//import '../../../design_system/buttons/creta_button.dart';
//import '../../../design_system/component/snippet.dart';
import 'package:creta_studio_model/model/book_model.dart';
//import 'package:creta_studio_model/model/page_model.dart';
//import 'package:creta_studio_model/model/frame_model.dart';
import '../../../model/watch_history_model.dart';
import 'package:creta_user_model/model/user_property_model.dart';
import '../../../model/channel_model.dart';
//import '../login/creta_account_manager.dart';
//import 'package:creta_common/model/app_enums.dart';
import '../../../design_system/dialog/creta_dialog.dart';
//import '../../design_system/component/snippet.dart';
//import '../../data_io/page_manager.dart';
import '../../data_io/book_manager.dart';
import '../studio/host_select_page.dart';

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

// class CretaBookItem extends StatefulWidget {
//   final CretaBookData cretaBookData;
//   final double width;
//   final double height;
//
//   const CretaBookItem({
//     required super.key,
//     required this.cretaBookData,
//     required this.width,
//     required this.height,
//   });
//
//   @override
//   CretaBookItemState createState() => CretaBookItemState();
// }
//
// class CretaBookItemState extends State<CretaBookItem> {
//   bool mouseOver = false;
//   bool popmenuOpen = false;
//
//   late List<CretaMenuItem> _popupMenuList;
//
//   void _openPopupMenu() {
//     CretaPopupMenu.showMenu(
//       context: context,
//       globalKey: widget.cretaBookData.uiKey,
//       popupMenu: _popupMenuList,
//       initFunc: setPopmenuOpen,
//     ).then((value) {
//       logger.finest('팝업메뉴 닫기');
//       setState(() {
//         popmenuOpen = false;
//       });
//     });
//   }
//
//   void _editItem() {
//     logger.finest('편집하기(${widget.cretaBookData.name})');
//     Routemaster.of(context).push(AppRoutes.communityBook);
//   }
//
//   void _doPopupMenuPlay() {
//     logger.finest('재생하기(${widget.cretaBookData.name})');
//   }
//
//   void _doPopupMenuEdit() {
//     logger.finest('편집하기(${widget.cretaBookData.name})');
//   }
//
//   void _doPopupMenuAddToPlayList() {
//     logger.finest('재생목록에 추가(${widget.cretaBookData.name})');
//   }
//
//   void _doPopupMenuShare() {
//     logger.finest('공유하기(${widget.cretaBookData.name})');
//   }
//
//   void _doPopupMenuDownload() {
//     logger.finest('다운로드(${widget.cretaBookData.name})');
//   }
//
//   void _doPopupMenuCopy() {
//     logger.finest('사본만들기(${widget.cretaBookData.name})');
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     _popupMenuList = [
//       CretaMenuItem(
//         caption: '재생하기',
//         onPressed: _doPopupMenuPlay,
//       ),
//       CretaMenuItem(
//         caption: CretaCommuLang['edit'],
//         onPressed: _doPopupMenuEdit,
//       ),
//       CretaMenuItem(
//         caption: CretaCommuLang['addToPlaylist'],
//         onPressed: _doPopupMenuAddToPlayList,
//       ),
//       CretaMenuItem(
//         caption: CretaCommuLang['share'],
//         onPressed: _doPopupMenuShare,
//       ),
//       CretaMenuItem(
//         caption: CretaCommuLang['download'],
//         onPressed: _doPopupMenuDownload,
//       ),
//       CretaMenuItem(
//         caption: CretaCommuLang['createCopy'],
//         onPressed: _doPopupMenuCopy,
//       ),
//     ];
//   }
//
//   void setPopmenuOpen() {
//     popmenuOpen = true;
//   }
//
//   List<Widget> _getOverlayMenu() {
//     if (!(mouseOver || popmenuOpen)) {
//       return [];
//     }
//
//     return [
//       Container(
//         width: widget.width,
//         height: 37,
//         padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
//         child: Row(
//           children: [
//             BTN.opacity_gray_it_s(
//               width: 91,
//               icon: Icons.edit_outlined,
//               text: CretaCommuLang['edit'],
//               onPressed: () => _editItem(),
//               alwaysShowIcon: true,
//             ),
//             Expanded(child: Container()),
//             BTN.opacity_gray_i_s(
//               icon: Icons.favorite_outline,
//               onPressed: () {},
//             ),
//             SizedBox(width: 4),
//             BTN.opacity_gray_i_s(
//               icon: Icons.content_copy_rounded,
//               onPressed: () {},
//             ),
//             SizedBox(width: 4),
//             BTN.opacity_gray_i_s(
//               icon: Icons.menu_outlined,
//               onPressed: () => _openPopupMenu(),
//             ),
//           ],
//         ),
//       ),
//     ];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MouseRegion(
//       onEnter: (value) {
//         setState(() {
//           mouseOver = true;
//         });
//       },
//       onExit: (value) {
//         setState(() {
//           mouseOver = false;
//         });
//       },
//       child: Container(
//         width: widget.width,
//         height: widget.height,
//         decoration: BoxDecoration(
//           // crop
//           borderRadius: BorderRadius.circular(20.0),
//         ),
//         clipBehavior: Clip.antiAlias, // crop method
//         child: Column(
//           children: [
//             Container(
//               width: widget.width,
//               height: widget.height - _itemDescriptionHeight,
//               color: Colors.white,
//               child: Stack(
//                 children: [
//                   // 썸네일 이미지
//                   ClipRect(
//                     child: CustomImage(
//                         key: widget.cretaBookData.imgKey,
//                         duration: 500,
//                         hasMouseOverEffect: true,
//                         width: widget.width,
//                         height: widget.height - _itemDescriptionHeight,
//                         image: widget.cretaBookData.thumbnailUrl),
//                   ),
//                   // 그라데이션
//                   Container(
//                     width: widget.width,
//                     height: widget.height - _itemDescriptionHeight,
//                     decoration: (mouseOver || popmenuOpen) ? Snippet.gradationShadowDeco() : null,
//                   ),
//                   // 편집하기, 추가, 메뉴 버튼 (반투명 배경)
//                   ..._getOverlayMenu(),
//                 ],
//               ),
//             ),
//             Container(
//               width: widget.width,
//               height: _itemDescriptionHeight,
//               color: (mouseOver || popmenuOpen) ? Colors.grey[100] : Colors.white,
//               child: Row(
//                 children: [
//                   SizedBox(width: 15),
//                   Expanded(
//                     //width: widget.width - 15 - 8 - 36 - 8,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(height: 8),
//                         Text(
//                           widget.cretaBookData.name,
//                           overflow: TextOverflow.ellipsis,
//                           textAlign: TextAlign.left,
//                           style: CretaFont.bodyMedium.copyWith(color: CretaColor.text[700]),
//                         ),
//                         SizedBox(height: 4),
//                         Text(
//                           widget.cretaBookData.creator,
//                           overflow: TextOverflow.ellipsis,
//                           textAlign: TextAlign.left,
//                           style: CretaFont.buttonMedium.copyWith(color: CretaColor.text[400]),
//                         ),
//                       ],
//                     ),
//                   ),
//                   //Expanded(child: Container()),
//                   SizedBox(width: 8),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       SizedBox(height: 9),
//                       BTN.fill_gray_i_l(
//                         icon: Icons.content_copy_rounded,
//                         buttonColor: CretaButtonColor.transparent,
//                         onPressed: () {},
//                       ),
//                     ],
//                   ),
//                   SizedBox(width: 8),
//                 ],
//               ),
//               // child: Stack(
//               //   children: [
//               //     Positioned(
//               //         left: widget.width - 37,
//               //         top: 17,
//               //         child: Container(
//               //           width: 20,
//               //           height: 20,
//               //           color: (mouseOver || popmenuOpen) ? Colors.grey[100] : Colors.white,
//               //           child: Icon(
//               //             Icons.favorite_outline,
//               //             size: 20.0,
//               //             color: Colors.grey[700],
//               //           ),
//               //         )),
//               //     Positioned(
//               //       left: 15,
//               //       top: 7,
//               //       child: Container(
//               //           width: widget.width - 45 - 15,
//               //           color: (mouseOver || popmenuOpen) ? Colors.grey[100] : Colors.white,
//               //           child: Text(
//               //             widget.cretaBookData.name,
//               //             overflow: TextOverflow.ellipsis,
//               //             textAlign: TextAlign.left,
//               //             style: TextStyle(
//               //               fontSize: 16,
//               //               color: Colors.grey[700],
//               //               fontFamily: 'Pretendard',
//               //             ),
//               //           )),
//               //     ),
//               //     Positioned(
//               //       left: 16,
//               //       top: 29,
//               //       child: Container(
//               //         width: widget.width - 45 - 15,
//               //         color: (mouseOver || popmenuOpen) ? Colors.grey[100] : Colors.white,
//               //         child: Text(
//               //           widget.cretaBookData.creator,
//               //           overflow: TextOverflow.ellipsis,
//               //           textAlign: TextAlign.left,
//               //           style: TextStyle(
//               //             fontSize: 13,
//               //             color: Colors.grey[500],
//               //             fontFamily: 'Pretendard',
//               //           ),
//               //         ),
//               //       ),
//               //     ),
//               //   ],
//               // ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class HoverImage extends StatefulWidget {
  final String image;

  const HoverImage({super.key, required this.image});

  @override
  State<HoverImage> createState() => _HoverImageState();
}

class _HoverImageState extends State<HoverImage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  late Animation padding;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 275),
      vsync: this,
    );
    _animation = Tween(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(parent: _controller, curve: Curves.ease, reverseCurve: Curves.easeIn));
    padding = Tween(begin: 0.0, end: -25.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.ease, reverseCurve: Curves.easeIn));
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (value) {
        setState(() {
          _controller.forward();
        });
      },
      onExit: (value) {
        setState(() {
          _controller.reverse();
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0.0, 20.0),
              spreadRadius: -10.0,
              blurRadius: 20.0,
            )
          ],
        ),
        child: Container(
          height: 220.0,
          width: 170.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
          ),
          clipBehavior: Clip.hardEdge,
          transform: Matrix4(_animation.value, 0, 0, 0, 0, _animation.value, 0, 0, 0, 0, 1, 0,
              padding.value, padding.value, 0, 1),
          child: Image.network(
            widget.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////
class SNSShareItem {
  const SNSShareItem({
    required this.title,
    required this.onPressed,
    required this.image,
    this.width = 32,
    this.height = 32,
  });
  final String title;
  final Function() onPressed;
  final ImageProvider? image;
  final double width;
  final double height;
}

class CretaBookUIItem extends StatefulWidget {
  const CretaBookUIItem({
    required super.key,
    required this.bookModel,
    required this.userPropertyModel,
    required this.channelModel,
    required this.width,
    required this.height,
    required this.isFavorites,
    this.addToFavorites,
    this.addToPlaylist,
    this.watchHistoryModel,
    this.onRemoveBook,
  });
  final BookModel bookModel;
  final UserPropertyModel? userPropertyModel;
  final ChannelModel? channelModel;
  final double width;
  final double height;
  final Function(String, bool)? addToFavorites;
  final Function(BookModel)? addToPlaylist;
  final bool isFavorites;
  final WatchHistoryModel? watchHistoryModel;
  final Function(String)? onRemoveBook;

  @override
  State<CretaBookUIItem> createState() => _CretaBookUIItemState();
}

class _CretaBookUIItemState extends State<CretaBookUIItem> {
  bool _mouseOver = false;
  bool _popmenuOpen = false;

  late List<CretaMenuItem> _popupMenuList;
  late List<SNSShareItem> _shareItemList;

  late String bookLinkUrl;
  late String encodeTitle;
  late String encodeLinkUrl;

  late HostManager hostManagerHolder;

  final ScrollController scrollController = ScrollController();

  void _openPopupMenu() {
    CretaPopupMenu.showMenu(
      context: context,
      globalKey: widget.key as GlobalKey,
      popupMenu: _popupMenuList,
      initFunc: setPopmenuOpen,
    ).then((value) {
      logger.finest('팝업메뉴 닫기');
      setState(() {
        _popmenuOpen = false;
      });
    });
  }

  // void _editItem() {
  //   logger.finest('편집하기(${widget.bookModel.name})');
  // }

  // void _doPopupMenuPlay() {
  //   logger.finest('재생하기(${widget.bookModel.name})');
  // }

  void _doPopupMenuEdit() {
    logger.finest('편집하기(${widget.bookModel.name})');
    String url = '${AppRoutes.studioBookMainPage}?${widget.bookModel.sourceMid}';
    AppRoutes.launchTab(url);
  }

  void _doPopupMenuAddToPlayList() {
    logger.finest('재생목록에 추가(${widget.bookModel.name})');
    widget.addToPlaylist?.call(widget.bookModel);
  }

  void _doPopupMenuShare() {
    logger.finest('공유하기(${widget.bookModel.name})');
    String bookLinkUrl = '${Uri.base.origin}${AppRoutes.communityBook}?${widget.bookModel.mid}';
    showDialog(
      context: context,
      builder: (context) => CretaDialog(
        width: 364.0 + 28,
        height: 304.0,
        title: CretaCommuLang['share'],
        crossAxisAlign: CrossAxisAlignment.center,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16 - 1, 0, 0),
              child: Text(
                CretaCommuLang['shareLink'],
                style: CretaFont.titleSmall.copyWith(color: CretaColor.text[700]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 13, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CretaTextField(
                    textFieldKey: GlobalObjectKey(
                        '${widget.bookModel.mid}.CretaBookUIItem._doPopupMenuShare.CretaTextField'),
                    width: 364 - 120 + 28,
                    height: 30,
                    value: bookLinkUrl,
                    hintText: '',
                    readOnly: true,
                    onEditComplete: (value) {},
                  ),
                  SizedBox(width: 11),
                  BTN.line_blue_t_m(
                    text: CretaCommuLang['copy'],
                    width: 45,
                    height: 32,
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: bookLinkUrl));
                      showSnackBar(
                        context,
                        CretaCommuLang['linkCopiedToClipboard'],
                        duration: const Duration(seconds: 2),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 19, 0, 0),
              child: Text(
                CretaCommuLang['shareOnSns'],
                style: CretaFont.titleSmall.copyWith(color: CretaColor.text[700]),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 17, 0, 31),
              width: 364 + 28,
              height: 40,
              child: Row(
                children: [
                  // InkWell(
                  //   customBorder: const CircleBorder(),
                  //   onTap: () {
                  //     scrollController.animateTo(
                  //       0,
                  //       duration: const Duration(milliseconds: 200),
                  //       curve: Curves.easeInOut,
                  //     );
                  //   },
                  //   child: Icon(Icons.arrow_left_sharp, size: 24),
                  // ),
                  SizedBox(width: 24),
                  SizedBox(
                    width: 364 - 24 - 24 + 28,
                    height: 32,
                    child: Scrollbar(
                      thickness: 0,
                      thumbVisibility: false,
                      controller: scrollController,
                      child: ListView.builder(
                        itemCount: 1,
                        controller: scrollController,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Wrap(
                            spacing: 20,
                            direction: Axis.horizontal,
                            children: _shareItemList
                                .map(
                                  (item) => SizedBox(
                                    width: item.width,
                                    height: item.height,
                                    child: Snippet.TooltipWrapper(
                                      fgColor: Colors.white,
                                      bgColor: Colors.grey[700]!,
                                      tooltip: item.title,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          shape: CircleBorder(),
                                          padding: EdgeInsets.all(0),
                                          backgroundColor: Colors.transparent, // <-- Button color
                                          //foregroundColor: Colors.red, // <-- Splash color
                                        ),
                                        onPressed: item.onPressed,
                                        child: item.image == null
                                            ? Text(
                                                item.title.substring(0, 2),
                                                style: CretaFont.titleSmall,
                                              )
                                            : Image(
                                                width: item.width,
                                                height: item.height,
                                                image: item.image!,
                                              ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          );
                        },
                      ),
                    ),
                  ),
                  // InkWell(
                  //   customBorder: const CircleBorder(),
                  //   onTap: () {
                  //     scrollController.animateTo(
                  //       scrollController.position.maxScrollExtent,
                  //       duration: const Duration(milliseconds: 200),
                  //       curve: Curves.easeInOut,
                  //     );
                  //   },
                  //   child: Icon(Icons.arrow_right_sharp, size: 24),
                  // ),
                  SizedBox(width: 24),
                ],
              ),
            ),
            Container(
              width: 364 + 28,
              height: 2.0,
              color: CretaColor.text[100], //Colors.grey.shade200,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(364 - 67 + 28, 12 - 1, 0, 0),
              child: BTN.fill_blue_t_m(
                text: CretaCommuLang['complete'],
                width: 55,
                height: 32,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _doPopupMenuDownload() {
    logger.finest('다운로드(${widget.bookModel.name})');
  }

  void _doPopupMenuRemove() {
    logger.finest('삭제하기(${widget.bookModel.name})');
    widget.onRemoveBook?.call(widget.bookModel.mid);
  }

  void _doPopupMenuCopy() async {
    logger.finest('복사하기(${widget.bookModel.name})');
    final BookManager copyBookManagerHolder = BookManager();
    copyBookManagerHolder
        .makeClone(
      widget.bookModel,
      srcIsPublishedBook: true,
      cloneToPublishedBook: false,
    )
        .then((newBook) {
      if (newBook == null) {
        showSnackBar(context, CretaCommuLang['copyCreationFailed']);
      } else {
        showSnackBar(context, '${newBook.name.value}${CretaCommuLang['createdSuccessfully']}');
      }
    }).catchError((error, stackTrace) {
      showSnackBar(context, CretaCommuLang['copyCreationFailed']);
    });
  }

  @override
  void initState() {
    super.initState();

    hostManagerHolder = HostManager();
    hostManagerHolder.configEvent(notifyModify: false);
    hostManagerHolder.clearAll();

    _popupMenuList = [
      // CretaMenuItem(
      //   caption: '재생하기',
      //   onPressed: _doPopupMenuPlay,
      // ),
      // if (widget.bookModel.shares.contains(owner) || widget.bookModel.shares.contains(writer))
      //   CretaMenuItem(
      //     caption: CretaCommuLang['edit'],
      //     onPressed: () {},//_doPopupMenuEdit,
      //     linkUrl: '${AppRoutes.studioBookMainPage}?${widget.bookModel.sourceMid}',
      //   ),
      if (AccountManager.currentLoginUser.isLoginedUser)
        CretaMenuItem(
          caption: CretaCommuLang['broadcast'] ?? 'Broadcast',
          onPressed: () {
            HostUtil.broadCast(
                context, hostManagerHolder, widget.bookModel.mid, widget.bookModel.name.value);
          },
        ),
      if (AccountManager.currentLoginUser.isLoginedUser)
        CretaMenuItem(
          caption: CretaCommuLang['addToPlaylist'],
          onPressed: _doPopupMenuAddToPlayList,
        ),
      CretaMenuItem(
        caption: CretaCommuLang['share'],
        onPressed: _doPopupMenuShare,
      ),
      if (AccountManager.currentLoginUser.isLoginedUser)
        CretaMenuItem(
          caption: CretaCommuLang['download'],
          onPressed: _doPopupMenuDownload,
        ),
      if (widget.bookModel.isEditable && widget.onRemoveBook != null)
        CretaMenuItem(
          caption: CretaCommuLang['delete'],
          onPressed: _doPopupMenuRemove,
        ),
      if (widget.bookModel.isCopyable)
        CretaMenuItem(
          caption: CretaCommuLang['createCopy'],
          onPressed: _doPopupMenuCopy,
        ),
    ];

    bookLinkUrl = '${Uri.base.origin}${AppRoutes.communityBook}?${widget.bookModel.mid}';
    encodeTitle = Uri.encodeComponent(widget.bookModel.name.value);
    encodeLinkUrl = Uri.encodeComponent(bookLinkUrl);

    _shareItemList = [
      SNSShareItem(
        title: CretaCommuLang['facebook'],
        onPressed: () {
          String tabUrl = 'https://www.facebook.com/sharer/sharer.php?u=$encodeLinkUrl';
          AppRoutes.launchTab(tabUrl, isFullUrl: true);
        },
        image: AssetImage('assets/social/facebook.png'),
      ),
      // SNSShareItem( // 2023-11-15일자로 공유서비스 종료됨 https://devtalk.kakao.com/t/api-notice-end-of-support-for-the-kakaostory-api/129857
      //   title: '카카오스토리',
      //   onPressed: () {
      //     String tabUrl = 'https://story.kakao.com/share?text=$encodeTitle&url=$encodeLinkUrl';
      //     AppRoutes.launchTab(tabUrl, isFullUrl: true);
      //   },
      //   image: AssetImage('assets/social/kakaostory.png'),
      // ),
      SNSShareItem(
        title: CretaCommuLang['twitter'],
        onPressed: () {
          String tabUrl = 'https://twitter.com/share?url=$encodeLinkUrl&text=$encodeTitle';
          AppRoutes.launchTab(tabUrl, isFullUrl: true);
        },
        image: AssetImage('assets/social/twitter.png'),
      ),
      SNSShareItem(
        title: CretaCommuLang['reddit'],
        onPressed: () {
          String tabUrl = 'https://reddit.com/submit?url=$encodeLinkUrl&title=$encodeTitle';
          AppRoutes.launchTab(tabUrl, isFullUrl: true);
        },
        image: AssetImage('assets/social/reddit.png'),
      ),
      SNSShareItem(
        title: CretaCommuLang['pinterest'],
        onPressed: () {
          String encodeThumbUrl = Uri.encodeComponent(widget.bookModel.thumbnailUrl.value);
          String tabUrl =
              'https://pinterest.com/pin/create/button/?url=$encodeLinkUrl&description=$encodeTitle&is_video=false&media=$encodeThumbUrl';
          AppRoutes.launchTab(tabUrl, isFullUrl: true);
        },
        image: AssetImage('assets/social/pinterest.png'),
      ),
      SNSShareItem(
        title: CretaCommuLang['linkedin'],
        onPressed: () {
          String tabUrl = 'https://www.linkedin.com/sharing/share-offsite/?url=$encodeLinkUrl';
          AppRoutes.launchTab(tabUrl, isFullUrl: true);
        },
        image: AssetImage('assets/social/linkedin.png'),
      ),
      SNSShareItem(
        title: CretaCommuLang['line'],
        onPressed: () {
          String tabUrl = 'https://social-plugins.line.me/lineit/share?url=$encodeLinkUrl';
          AppRoutes.launchTab(tabUrl, isFullUrl: true);
        },
        image: AssetImage('assets/social/line.png'),
      ),
      SNSShareItem(
        title: CretaCommuLang['kakaoTalk'],
        onPressed: () {
          //String tabUrl = 'https://sharer.kakao.com/talk/friends/picker/easylink?app_key=(APP_KEY))&......';
          //AppRoutes.launchTab(tabUrl, isFullUrl: true);
          showSnackBar(context, CretaCommuLang['notSupportedYet']);
        },
        image: AssetImage('assets/social/kakaotalk.png'),
      ),

/*
reddit
https://reddit.com/submit?url=(URL)&title=(TITLE)

pinterest
https://pinterest.com/pin/create/button/?url=(URL)&description=(TITLE)&is_video=true&media=(THUMBNAIL_URL)

linkedin
https://www.linkedin.com/sharing/share-offsite/?url=(URL)

line
https://social-plugins.line.me/lineit/share?url=(URL)

카카오톡 (기업계정 가입필요)
https://sharer.kakao.com/talk/friends/picker/easylink?app_key=437a6516bd110eb436d443c705bc1a84&ka=sdk%2F1.22.0%20os%2Fjavascript%20lang%2Fko-KR%20device%2FWin32%20origin%2Fhttps%253A%252F%252Fwww.compuzone.co.kr&validation_action=default&validation_params=%7B%22link_ver%22%3A%224.0%22%2C%22template_object%22%3A%7B%22object_type%22%3A%22commerce%22%2C%22button_title%22%3A%22%22%2C%22content%22%3A%7B%22title%22%3A%22%5B%EB%89%B4%EC%97%90%EC%9D%B4%EC%BB%A4%5D%20%EC%B6%A9%EC%A0%84%EC%8B%9D%20%EC%86%90%EB%82%9C%EB%A1%9C%20%EB%AF%B8%EB%8B%88%20%ED%9C%B4%EB%8C%80%EC%9A%A9%20%EB%B3%B4%EC%A1%B0%EB%B0%B0%ED%84%B0%EB%A6%AC%2010000mAh%20HW-100%22%2C%22image_url%22%3A%22%22%2C%22link%22%3A%7B%22web_url%22%3A%22http%3A%2F%2Fwww.compuzone.co.kr%2Fproduct%2Fproduct_detail.htm%3FProductNo%3D1082443%22%2C%22mobile_web_url%22%3A%22http%3A%2F%2Fm.compuzone.co.kr%2Fproduct%2Fproduct_detail.htm%3FProductNo%3D1082443%22%7D%7D%2C%22commerce%22%3A%7B%22regular_price%22%3A34900%7D%7D%7D

      messenger(facebook) (개발자계정 가입필요)
      ttps://www.facebook.com/dialog/send?app_id=102628213125203&display=popup&link=(URL)&redirect_uri=(URL)

      vk
      http://vkontakte.ru/share.php?url=(URL)

      ok
      https://connect.ok.ru/offer?url=(URL)&title=(TITLE)

      blogger
      http://www.blogger.com/blog-this.g?n=(TITLE)&source=youtube&b=%3Ciframe%20width%3D%22480%22%20height%3D%22270%22%20src%3D%22https%3A//youtube.com/embed/FJfwehhzIhw%3Fsi%3DQB_JsxX9sEI_lMbX%22%20frameborder%3D%220%22%20allow%3D%22accelerometer%3B%20autoplay%3B%20clipboard-write%3B%20encrypted-media%3B%20gyroscope%3B%20picture-in-picture%3B%20web-share%22%20allowfullscreen%3E%3C/iframe%3E&eurl=(THUMBNAIL_URL)

      tumblr
      https://www.tumblr.com/share/video?embed=(URL)&caption=(TITLE)

      skyrock
      http://skyrock.com/m/blog/share-widget.php?idp=10&idm=(YOUTUBE_CONTENTS_ID)&title=(TITLE)

      mix
      https://mix.com/add?url=(URL)

      goo
      http://blog.goo.ne.jp/portal_login/blogparts/?key=(YOUTUBE_CONTENTS_ID)&title=(TITLE)&type=youtube

      band
      https://band.us/plugin/share?body=%EC%9D%B4%EA%B1%B0%20%EC%A2%80%20%EA%B4%9C%EC%B0%AE%EC%9D%80%20%EB%93%AF.%20%5B%EB%89%B4%EC%97%90%EC%9D%B4%EC%BB%A4%5D%20%EC%B6%A9%EC%A0%84%EC%8B%9D%20%EC%86%90%EB%82%9C%EB%A1%9C%20%EB%AF%B8%EB%8B%88%20%ED%9C%B4%EB%8C%80%EC%9A%A9%20%EB%B3%B4%EC%A1%B0%EB%B0%B0%ED%84%B0%EB%A6%AC%2010000mAh%20HW-100%0Ahttp%3A%2F%2Fwww.compuzone.co.kr%2Fproduct%2Fproduct_detail.htm%3FProductNo%3D1082443
      https://band.us/plugin/share?body=(Text of Title&Url)

*/
    ];
  }

  void setPopmenuOpen() {
    _popmenuOpen = true;
  }

  List<Widget> _getOverlayMenu() {
    if (!(_mouseOver || _popmenuOpen)) {
      return [];
    }

    return [
      Container(
        width: widget.width,
        height: 37,
        padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Row(
          children: [
            if (widget.bookModel.isEditable)
              BTN.opacity_gray_it_s(
                width: 91,
                icon: Icons.edit_outlined,
                text: CretaCommuLang['edit'],
                onPressed: () => _doPopupMenuEdit(),
                alwaysShowIcon: true,
                textStyle: CretaFont.buttonSmall.copyWith(color: CretaColor.text[100]),
              ),
            Expanded(child: Container()),
            if (AccountManager.currentLoginUser.isLoginedUser)
              BTN.opacity_gray_i_s(
                icon: widget.isFavorites ? Icons.favorite : Icons.favorite_border,
                iconColor: CretaColor.text[100],
                onPressed: () {
                  widget.addToFavorites?.call(widget.bookModel.mid, widget.isFavorites);
                },
              ),
            // SizedBox(width: 4),
            // BTN.opacity_gray_i_s(
            //   icon: Icons.content_copy_rounded,
            //   iconColor: CretaColor.text[100],
            //   onPressed: () {},
            // ),
            SizedBox(width: 4),
            BTN.opacity_gray_i_s(
              icon: Icons.menu,
              iconColor: CretaColor.text[100],
              onPressed: () => _openPopupMenu(),
            ),
          ],
        ),
      ),
      SizedBox(
        width: widget.width,
        height: widget.height - _itemDescriptionHeight,
        child: Center(
          child: Icon(Icons.play_arrow, size: 40, color: CretaColor.text[100]),
        ),
      ),
    ];
  }

  Widget _getDebugInfo() {
    return Container(
      width: widget.width,
      height: widget.height,
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(CretaCommonUtils.getDateTimeString(widget.bookModel.updateTime),
              style: CretaFont.buttonSmall),
          Text('likeCount=${widget.bookModel.likeCount}', style: CretaFont.buttonSmall),
          Text('viewCount=${widget.bookModel.viewCount}', style: CretaFont.buttonSmall),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String bookLinkUrl = '${AppRoutes.communityBook}?${widget.bookModel.mid}';
    String channelLinkUrl =
        (widget.channelModel == null) ? '' : '${AppRoutes.channel}?${widget.channelModel!.mid}';
    return MouseRegion(
      onEnter: (value) {
        setState(() {
          _mouseOver = true;
        });
      },
      onExit: (value) {
        setState(() {
          _mouseOver = false;
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
            // 이미지 부분
            Link(
              uri: Uri.parse(bookLinkUrl),
              builder: (context, function) {
                return InkWell(
                  onTap: () {
                    Routemaster.of(context).push(bookLinkUrl);
                  },
                  child: Container(
                    width: widget.width,
                    height: widget.height - _itemDescriptionHeight,
                    color: Colors.white,
                    child: Stack(
                      children: [
                        // 썸네일 이미지
                        ClipRect(
                          child: CustomImage(
                            key: ValueKey(widget.bookModel.thumbnailUrl.value),
                            duration: 500,
                            //hasMouseOverEffect: true,
                            width: widget.width,
                            height: widget.height - _itemDescriptionHeight,
                            image: widget.bookModel.thumbnailUrl.value,
                            hasAni: false,
                            useDefaultErrorImage: true,
                          ),
                        ),
                        // 그라데이션
                        Container(
                          width: widget.width,
                          height: widget.height - _itemDescriptionHeight,
                          decoration: (_mouseOver || _popmenuOpen) ? Snippet.shadowDeco() : null,
                        ),
                        // 편집하기, 추가, 메뉴 버튼 (반투명 배경)
                        if (widget.bookModel.isRemoved.value == false) ..._getOverlayMenu(),
                        // 디버그 정보
                        (kDebugMode) ? _getDebugInfo() : SizedBox.shrink(),
                      ],
                    ),
                  ),
                );
              },
            ),
            // 텍스트 부분
            Container(
              width: widget.width,
              height: _itemDescriptionHeight,
              color: (_mouseOver || _popmenuOpen) ? CretaColor.text[100] : Colors.white,
              padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                children: [
                  SizedBox(
                    width: widget.width - 16 - 16,
                    child: Link(
                        uri: Uri.parse(bookLinkUrl),
                        builder: (context, function) {
                          return InkWell(
                            onTap: () {
                              Routemaster.of(context).push(bookLinkUrl);
                            },
                            child: Text(
                              widget.bookModel.name.value,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: CretaFont.titleMedium.copyWith(color: CretaColor.text[700]),
                            ),
                          );
                        }),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // channel
                      Link(
                        uri: Uri.parse(channelLinkUrl), // 직접 채널로 이동은 막아둠 (23-07-26)
                        //uri: Uri.parse(bookLinkUrl),
                        builder: (context, function) {
                          return InkWell(
                            onTap: () {
                              // 직접 채널로 이동은 막아둠 (23-07-26)
                              if (channelLinkUrl.isNotEmpty) {
                                Routemaster.of(context).push(channelLinkUrl);
                              }
                              // if (bookLinkUrl.isNotEmpty) {
                              //   Routemaster.of(context).push(bookLinkUrl);
                              // }
                            },
                            child: Text(
                              //widget.userPropertyModel?.nickname ?? '', // 저작자로 표시 (23-07-26)
                              widget.channelModel?.name ?? '',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: CretaFont.buttonMedium.copyWith(color: CretaColor.text[400]),
                            ),
                          );
                        },
                      ),
                      // time
                      Text(
                        CretaCommonUtils.dateToDurationString(
                            widget.watchHistoryModel?.updateTime ?? widget.bookModel.updateTime),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: CretaFont.buttonMedium.copyWith(color: CretaColor.text[300]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // child: Link(
      //   uri: Uri.parse(linkUrl),
      //   builder: (context, function) {
      //     return InkWell(
      //       onTap: () {
      //         Routemaster.of(context).push(linkUrl);
      //       },
      //       child: Container(
      //         width: widget.width,
      //         height: widget.height,
      //         decoration: BoxDecoration(
      //           // crop
      //           borderRadius: BorderRadius.circular(20.0),
      //         ),
      //         clipBehavior: Clip.antiAlias, // crop method
      //         child: Column(
      //           children: [
      //             // 이미지 부분
      //             Container(
      //               width: widget.width,
      //               height: widget.height - _itemDescriptionHeight,
      //               color: Colors.white,
      //               child: Stack(
      //                 children: [
      //                   // 썸네일 이미지
      //                   ClipRect(
      //                     child: CustomImage(
      //                       key: ValueKey(widget.bookModel.thumbnailUrl.value),
      //                       duration: 500,
      //                       //hasMouseOverEffect: true,
      //                       width: widget.width,
      //                       height: widget.height - _itemDescriptionHeight,
      //                       image: widget.bookModel.thumbnailUrl.value,
      //                       hasAni: false,
      //                     ),
      //                   ),
      //                   // 그라데이션
      //                   Container(
      //                     width: widget.width,
      //                     height: widget.height - _itemDescriptionHeight,
      //                     decoration: (_mouseOver || _popmenuOpen) ? Snippet.shadowDeco() : null,
      //                   ),
      //                   // 편집하기, 추가, 메뉴 버튼 (반투명 배경)
      //                   ..._getOverlayMenu(),
      //                   // 디버그 정보
      //                   (kDebugMode) ? _getDebugInfo() : SizedBox.shrink(),
      //                 ],
      //               ),
      //             ),
      //             // 텍스트 부분
      //             Container(
      //               width: widget.width,
      //               height: _itemDescriptionHeight,
      //               color: (_mouseOver || _popmenuOpen) ? CretaColor.text[100] : Colors.white,
      //               padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
      //               child: Column(
      //                 children: [
      //                   SizedBox(
      //                     width: widget.width - 16 - 16,
      //                     child: Text(
      //                       widget.bookModel.name.value,
      //                       overflow: TextOverflow.ellipsis,
      //                       textAlign: TextAlign.left,
      //                       style: CretaFont.titleMedium.copyWith(color: CretaColor.text[700]),
      //                     ),
      //                   ),
      //                   SizedBox(height: 5),
      //                   Row(
      //                     children: [
      //                       // creator
      //                       Expanded(
      //                         child: Text(
      //                           widget.userPropertyModel.nickname,//widget.bookModel.creator,
      //                           overflow: TextOverflow.ellipsis,
      //                           textAlign: TextAlign.left,
      //                           style: CretaFont.buttonMedium.copyWith(color: CretaColor.text[400]),
      //                         ),
      //                       ),
      //                       // gap
      //                       SizedBox(width: 8),
      //                       // time
      //                       Text(
      //                         CretaCommonUtils.dateToDurationString(widget.watchHistoryModel?.updateTime ?? widget.bookModel.updateTime),
      //                         overflow: TextOverflow.ellipsis,
      //                         textAlign: TextAlign.left,
      //                         style: CretaFont.buttonMedium.copyWith(color: CretaColor.text[300]),
      //                       ),
      //                     ],
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
