// ignore_for_file: prefer_const_constructors

import 'dart:ui';
import 'package:creta03/common/creta_utils.dart';
import 'package:creta03/model/subscription_model.dart';
import 'package:flutter/rendering.dart';
import 'package:universal_html/html.dart';
import 'package:creta03/design_system/buttons/creta_button.dart';
import 'package:creta03/model/watch_history_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hycop/hycop.dart';
//import 'dart:async';
//import 'package:flutter/gestures.dart';
//import 'package:hycop/hycop.dart';
//import 'package:hycop/common/util/logger.dart';
//import 'package:routemaster/routemaster.dart';
//import 'package:url_strategy/url_strategy.dart';
import '../../../common/cross_common_job.dart';
import '../../../design_system/buttons/creta_button_wrapper.dart';
//import '../../../design_system/buttons/creta_elibated_button.dart';
//import '../../design_system/buttons/creta_button.dart';
//import '../../../design_system/component/snippet.dart';
import '../../../design_system/component/creta_layout_rect.dart';
//import '../../design_system/menu/creta_drop_down.dart';
//import '../../design_system/menu/creta_popup_menu.dart';
//import '../../design_system/text_field/creta_search_bar.dart';
import '../../../design_system/text_field/creta_text_field.dart';
import '../../../design_system/creta_color.dart';
//import 'package:image_network/image_network.dart';
//import 'package:cached_network_image/cached_network_image.dart';
//import '../../../pages/login_page.dart';
import '../../../pages/login/creta_account_manager.dart';
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
//import '../../../design_system/buttons/creta_progress_slider.dart';
//import '../../design_system/text_field/creta_comment_bar.dart';
import 'community_comment_pane.dart';
import '../../../data_io/watch_history_manager.dart';
import '../../studio/book_main_page.dart';
import '../../studio/studio_variables.dart';
import '../../../model/app_enums.dart';
import '../../../model/book_model.dart';
import '../../../model/channel_model.dart';
import '../../../model/contents_model.dart';
import '../../../model/team_model.dart';
import '../../../model/frame_model.dart';
import '../../../model/page_model.dart';
import '../../../model/user_property_model.dart';
import '../../../model/playlist_model.dart';
import '../../../data_io/creta_manager.dart';
import '../../../data_io/book_published_manager.dart';
import '../../../data_io/channel_manager.dart';
import '../../../data_io/favorites_manager.dart';
import '../../../data_io/playlist_manager.dart';
import '../../../data_io/subscription_manager.dart';
import '../../../data_io/team_manager.dart';
import '../../../data_io/user_property_manager.dart';
import '../../../data_io/contents_manager.dart';
import '../../../data_io/enterprise_manager.dart';

class CommunityRightBookPane extends StatefulWidget {
  const CommunityRightBookPane({
    super.key,
    required this.cretaLayoutRect,
    required this.scrollController,
    required this.onUpdateBookModel,
  });
  final CretaLayoutRect cretaLayoutRect;
  final ScrollController scrollController;
  final Function(BookModel, UserPropertyModel, bool, Function)? onUpdateBookModel;

  static String bookId = '';
  static FavoritesManager? favoritesManagerHolder;

  @override
  State<CommunityRightBookPane> createState() => _CommunityRightBookPaneState();
}

class _CommunityRightBookPaneState extends State<CommunityRightBookPane> {
  late List<CretaBookData> _cretaRelatedBookList;
  final List<ContentsModel> _usingContentsList = [];
  List<String> _hashtagValueList = [];
  bool _hashtagEditMode = false;
  final TextEditingController _hashtagController = TextEditingController();
  bool _usingContentsFullView = false;
  late BookPublishedManager bookPublishedManagerHolder;
  late ChannelManager channelManagerHolder;
  late TeamManager teamManagerHolder;
  late UserPropertyManager userPropertyManagerHolder;
  late WatchHistoryManager watchHistoryManagerHolder;
  //late FavoritesManager favoritesManagerHolder;
  late PlaylistManager playlistManagerHolder;
  late SubscriptionManager subscriptionManagerHolder;
  late ContentsManager contentsManagerHolder;
  late EnterpriseManager dummyManagerHolder;
  //bool _onceDBGetComplete = false;
  BookModel? _currentBookModel;
  final List<ChannelModel> _channelList = [];
  ChannelModel? _channelModel;
  //UserPropertyModel? _userPropertyModel;
  SubscriptionModel? _subscriptionModel;
  final Map<String, String> _userIdMap = {};
  final Map<String, UserPropertyModel> _userPropertyMap = {};
  final Map<String, String> _teamIdMap = {};
  final Map<String, TeamModel> _teamMap = {};
  final List<PlaylistModel> _playlistModelList = [];
  final Map<String, BookModel> _playlistsBooksMap = {}; // <Book.mid, Playlists.books>
  bool _bookIsInFavorites = false;
  late GlobalKey bookKey;
  late GlobalKey bookKeyParent;
  final CrossCommonJob _crossCommonJob = CrossCommonJob();
  bool _isEditableBook = false;

  @override
  void initState() {
    super.initState();

    StudioVariables.isAutoPlay = false;

    if (CommunityRightBookPane.bookId.isEmpty) {
      //String url = Uri.base.origin;
      String query = Uri.base.query;

      int pos = query.indexOf('&');
      CommunityRightBookPane.bookId = (pos > 0) ? query.substring(0, pos) : query;
    }

    StudioVariables.selectedBookMid = CommunityRightBookPane.bookId;
    if (StudioVariables.selectedBookMid.isEmpty) {
      StudioVariables.selectedBookMid = "book=a5948eae-03ae-410f-8efa-f1a3c28e4f05";
    }

    bookKeyParent = GlobalObjectKey('_CommunityRightBookPaneState.${CommunityRightBookPane.bookId}.parent');
    bookKey = GlobalObjectKey('_CommunityRightBookPaneState.${CommunityRightBookPane.bookId}');

    bookPublishedManagerHolder = BookPublishedManager();
    channelManagerHolder = ChannelManager();
    CommunityRightBookPane.favoritesManagerHolder = FavoritesManager();
    playlistManagerHolder = PlaylistManager();
    teamManagerHolder = TeamManager();
    userPropertyManagerHolder = UserPropertyManager();
    subscriptionManagerHolder = SubscriptionManager();
    dummyManagerHolder = EnterpriseManager();

    final BookModel dummyBook = BookModel('');
    final PageModel dummyPage = PageModel('', dummyBook);
    final FrameModel dummyFrame = FrameModel('', '');
    contentsManagerHolder = ContentsManager(
      pageModel: dummyPage,
      frameModel: dummyFrame,
      tableName: 'creta_contents_published',
    );

    CretaManager.startQueries(
      joinList: [
        QuerySet(bookPublishedManagerHolder, _getBooksFromDB, _resultBooksFromDB),
        QuerySet(channelManagerHolder, _getChannelsFromDB, _resultChannelsFromDB),
        QuerySet(userPropertyManagerHolder, _getUserPropertyFromDB, _resultUserPropertyFromDB),
        QuerySet(teamManagerHolder, _getTeamsFromDB, _resultTeamsFromDB),
        QuerySet(CommunityRightBookPane.favoritesManagerHolder!, _getFavoritesFromDB, _resultFavoritesFromDB),
        QuerySet(playlistManagerHolder, _getPlaylistsFromDB, _resultPlaylistsFromDB),
        QuerySet(bookPublishedManagerHolder, _getPlaylistsBooksFromDB, _resultPlaylistsBooksFromDB),
        QuerySet(subscriptionManagerHolder, _getSubscriptionFromDB, _resultSubscriptionFromDB),
        QuerySet(contentsManagerHolder, _getContentsFromDB, _resultContentsFromDB),
        QuerySet(dummyManagerHolder, _dummyCompleteDB, null),
      ],
      completeFunc: () {
        //_onceDBGetComplete = true;
      },
    );

    _cretaRelatedBookList = CommunitySampleData.getCretaBookList();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.selection = TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
      }
    });
    _controller.text = '';

    WatchHistoryModel whModel = WatchHistoryModel.withName(
      userId: AccountManager.currentLoginUser.email,
      bookId: CommunityRightBookPane.bookId,
      //lastUpdateTime: DateTime.now(),
    );
    watchHistoryManagerHolder = WatchHistoryManager();
    watchHistoryManagerHolder.createToDB(whModel);
    //bookManagerHolder!.configEvent(notifyModify: false);
    //watchHistoryManagerHolder!.clearAll();
  }

  void _getBooksFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('start _getBooksFromDB()');
    bookPublishedManagerHolder.addWhereClause('isRemoved', QueryValue(value: false));
    bookPublishedManagerHolder.addWhereClause('mid', QueryValue(value: CommunityRightBookPane.bookId));
    bookPublishedManagerHolder.queryByAddedContitions();
  }

  void _resultBooksFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('start _resultBooksFromDB(${modelList.length})');
    if (modelList.isEmpty) {
      // no book-data in DB
      return;
    }
    _currentBookModel = modelList[0] as BookModel; // 오직 1개만 있다고 가정
    _userIdMap[_currentBookModel!.creator] = _currentBookModel!.creator;
    _hashtagValueList = CretaUtils.jsonStringToList(_currentBookModel!.hashTag.value);

    String currentLoginedUserId = CretaAccountManager.getUserProperty?.getMid ?? 'null@null.null';
    String owner = '<${PermissionType.owner.name}>$currentLoginedUserId';
    _isEditableBook = _currentBookModel!.shares.contains(owner);
  }

  void _getChannelsFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('start _getChannelsFromDB()');
    if (_currentBookModel == null) {
      // no book-data ==> skip
      channelManagerHolder.setState(DBState.idle);
      return;
    }
    channelManagerHolder.queryFromIdList(_currentBookModel!.channels);
  }

  void _resultChannelsFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('start _resultChannelFromDB(${modelList.length})');
    final Map<String, ChannelModel> channelMap = {};
    for (var model in modelList) {
      ChannelModel chModel = model as ChannelModel;
      channelMap[chModel.mid] = chModel;
    }
    if (_currentBookModel != null) {
      for (final channelId in _currentBookModel!.channels) {
        ChannelModel? chModel = channelMap[channelId];
        if (chModel == null) continue;
        _channelList.add(chModel);
        if (chModel.userId.isNotEmpty) {
          _userIdMap[chModel.userId] = chModel.userId;
        }
        if (chModel.teamId.isNotEmpty) {
          _teamIdMap[chModel.teamId] = chModel.teamId;
        }
      }
      if (_channelList.isNotEmpty) {
        _channelModel = _channelList[0];
      }
    }
  }

  void _getUserPropertyFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('start _getUserPropertyFromDB(${modelList.length})');
    userPropertyManagerHolder.queryFromIdMap(_userIdMap);
  }

  void _resultUserPropertyFromDB(List<AbsExModel> modelList) {
    for (var model in modelList) {
      UserPropertyModel userModel = model as UserPropertyModel;
      //if (kDebugMode) print('_resultBooksFromDB(bookId=${bModel.getKeyId})');
      _userPropertyMap[userModel.getMid] = userModel;
    }
  }

  void _getTeamsFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('start _getUserPropertyFromDB(${modelList.length})');
    teamManagerHolder.queryFromIdMap(_teamIdMap);
  }

  void _resultTeamsFromDB(List<AbsExModel> modelList) {
    for (var model in modelList) {
      TeamModel teamModel = model as TeamModel;
      //if (kDebugMode) print('_resultBooksFromDB(bookId=${bModel.getKeyId})');
      _teamMap[teamModel.getMid] = teamModel;
    }
  }

  void _getFavoritesFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('start _getFavoritesFromDB(${modelList.length})');
    if (_currentBookModel == null) {
      // no book-data ==> skip
      CommunityRightBookPane.favoritesManagerHolder!.setState(DBState.idle);
      return;
    }
    List<AbsExModel> bookList = [_currentBookModel!];
    CommunityRightBookPane.favoritesManagerHolder!.queryFavoritesFromBookModelList(bookList);
  }

  void _resultFavoritesFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('start _resultFavoritesFromDB(${modelList.length})');
    if (modelList.isEmpty) {
      // this book is not in favorites
      _bookIsInFavorites = false;
    } else {
      // something is exist in DB ==> Favorites
      _bookIsInFavorites = true;
    }
  }

  void _getPlaylistsFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('_getPlaylistsFromDB');
    playlistManagerHolder.addWhereClause('isRemoved', QueryValue(value: false));
    playlistManagerHolder.addWhereClause(
        'channelId', QueryValue(value: CretaAccountManager.getUserProperty!.channelId));
    playlistManagerHolder.queryByAddedContitions();
  }

  void _resultPlaylistsFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('_playlistModelList.modelList.length=${modelList.length}');
    for (var plModel in modelList) {
      _playlistModelList.add(plModel as PlaylistModel);
    }
  }

  void _getPlaylistsBooksFromDB(List<AbsExModel> modelList) {
    final List<String> bookIdList = [];
    for (var model in modelList) {
      PlaylistModel plModel = model as PlaylistModel;
      if (plModel.bookIdList.isNotEmpty) {
        bookIdList.add(plModel.bookIdList[0]);
      }
    }
    bookPublishedManagerHolder.queryFromIdList(bookIdList);
  }

  void _resultPlaylistsBooksFromDB(List<AbsExModel> modelList) {
    for (var model in modelList) {
      BookModel bModel = model as BookModel;
      //if (kDebugMode) print('_resultBooksFromDB(bookId=${bModel.getKeyId})');
      _playlistsBooksMap[bModel.getMid] = bModel;
    }
  }

  void _getSubscriptionFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('start _getSubscriptionFromDB(${modelList.length})');
    if (_currentBookModel == null || _channelModel == null) {
      // no book-data ==> skip
      subscriptionManagerHolder.setState(DBState.idle);
      return;
    }
    subscriptionManagerHolder.addWhereClause('isRemoved', QueryValue(value: false));
    subscriptionManagerHolder.addWhereClause(
        'channelId', QueryValue(value: CretaAccountManager.getUserProperty!.channelId));
    subscriptionManagerHolder.addWhereClause('subscriptionChannelId', QueryValue(value: _channelModel!.mid));
    subscriptionManagerHolder.queryByAddedContitions();
  }

  void _resultSubscriptionFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('start _resultSubscriptionFromDB(${modelList.length})');
    if (modelList.isNotEmpty) {
      _subscriptionModel = modelList[0] as SubscriptionModel;
    }
  }

  void _getContentsFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('start _getContentsFromDB(${modelList.length})');
    if (_currentBookModel == null) {
      // no book-data ==> skip
      contentsManagerHolder.setState(DBState.idle);
      return;
    }
    contentsManagerHolder.addWhereClause('isRemoved', QueryValue(value: false));
    contentsManagerHolder.addWhereClause('realTimeKey', QueryValue(value: _currentBookModel!.mid));
    contentsManagerHolder.queryByAddedContitions();
  }

  void _resultContentsFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('start _resultContentsFromDB(${modelList.length})');
    if (modelList.isNotEmpty) {
      for (var model in modelList) {
        _usingContentsList.add(model as ContentsModel);
      }
    }
  }

  void _dummyCompleteDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('start _dummyCompleteDB(${modelList.length})');
    if (_currentBookModel != null) {
      if (kDebugMode) print('_resultFavoritesFromDB(updateBookModel)');
      // channel mapping to user,teams
      for (var chModel in _channelList) {
        chModel.getModelFromMaps(_userPropertyMap, _teamMap);
      }
      // creator
      UserPropertyModel? creatorUserModel = _userPropertyMap[_currentBookModel!.creator];
      if (creatorUserModel != null) {
        widget.onUpdateBookModel?.call(_currentBookModel!, creatorUserModel, _bookIsInFavorites, addToPlaylist);
        setState(() {
          _controller.text = _currentBookModel?.description.value ?? '';
        });
      }
    }
    dummyManagerHolder.setState(DBState.idle);
  }

  void addToPlaylist() async {
    if (_currentBookModel != null) {
      playlistManagerHolder.addToPlaylist(context, _currentBookModel!, _playlistsBooksMap);
    }
  }

  Widget _getHashtagWidget(String hashtag) {
    // return CretaElevatedButton(
    //   height: 32,
    //   caption: hashtag,
    //   captionStyle: CretaFont.bodyMedium.copyWith(fontSize: 13),
    //   onPressed: () {},
    //   bgHoverColor: CretaColor.text[100]!,
    //   bgHoverSelectedColor: CretaColor.text[100]!,
    //   bgSelectedColor: Colors.white,
    //   borderColor: CretaColor.text[700]!,
    //   borderSelectedColor: CretaColor.text[700]!,
    //   fgColor: CretaColor.text[700]!,
    //   fgSelectedColor: CretaColor.text[700]!,
    // );
    return BTN.line_gray_t_m(
      width: null,
      height: 32,
      isSelectedWidget: false,
      text: _hashtagEditMode ? '$hashtag x' : hashtag,
      sidePadding: CretaButtonSidePadding(left: 8, right: 8),
      onPressed: () {
        if (_hashtagEditMode) {
          setState(() {
            //_hashtagValueList = _hashtagValueList.where((item) => item != hashtag).toList();
            _hashtagValueList.remove(hashtag);
            _currentBookModel?.hashTag.set(CretaUtils.listToString(_hashtagValueList));
          });
        }
      },
    );
  }

  List<Widget> _getHashtagList() {
    return _hashtagValueList.map((e) => _getHashtagWidget(e)).toList();
    // return [
    //   _getHashtagWidget('#크레타북'),
    //   _getHashtagWidget('#추천'),
    //   _getHashtagWidget('#인기'),
    //   _getHashtagWidget('#해시태그'),
    //   _getHashtagWidget('#목록입니다'),
    //   _getHashtagWidget('#스페이싱'),
    //   _getHashtagWidget('#스페이싱'),
    //   _getHashtagWidget('#스페이싱'),
    //   _getHashtagWidget('#스페이싱'),
    //   // BTN.opacity_gray_it_s(
    //   //   text: '#크레타북',
    //   //   textStyle: CretaFont.buttonMedium,
    //   //   //width: null,
    //   //   onPressed: () {},
    //   //   width: null,
    //   // ),
    //   // BTN.opacity_gray_it_s(
    //   //   text: '#추천',
    //   //   textStyle: CretaFont.buttonMedium,
    //   //   //width: null,
    //   //   onPressed: () {},
    //   //   width: null,
    //   // ),
    //   // SizedBox(width: 12),
    //   // BTN.opacity_gray_it_s(
    //   //   text: '#인기',
    //   //   textStyle: CretaFont.buttonMedium,
    //   //   //width: null,
    //   //   onPressed: () {},
    //   // ),
    //   // SizedBox(width: 12),
    //   // BTN.opacity_gray_it_s(
    //   //   text: '#해시태그',
    //   //   textStyle: CretaFont.buttonMedium,
    //   //   //width: null,
    //   //   onPressed: () {},
    //   // ),
    // ];
  }

  void _toggleFullscreen() {
    setState(() {
      StudioVariables.isFullscreen = !StudioVariables.isFullscreen;
      if (StudioVariables.isFullscreen) {
        document.documentElement?.requestFullscreen();
      } else {
        document.exitFullscreen();
      }
    });
  }

  Widget _getBookPreview(Size size) {
    if (_cretaRelatedBookList.isNotEmpty) {
      // return Container(
      //   decoration: BoxDecoration(
      //     // crop
      //     borderRadius: BorderRadius.circular(20.0),
      //   ),
      //   clipBehavior: Clip.antiAlias,
      //   child: Stack(
      //     children: [
      //       ClipRect(
      //         child: CustomImage(
      //             key: bookKey,
      //             duration: 500,
      //             hasMouseOverEffect: false,
      //             width: size.width,
      //             height: size.height,
      //             image: _cretaRelatedBookList[0].thumbnailUrl),
      //       ),
      //       Container(
      //         width: size.width,
      //         height: size.height,
      //         decoration: bookMouseOver ? Snippet.shadowDeco() : null,
      //       ),
      //     ],
      //   ),
      // );
      return RepaintBoundary(
        key: bookKeyParent,
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: BookMainPage(
            //bookKey: GlobalObjectKey('BookPreivew${StudioVariables.selectedBookMid}'),
            bookKey: bookKey,
            isPreviewX: true,
            size: size,
            isPublishedMode: true,
            toggleFullscreen: _toggleFullscreen,
          ),
        ),
      );
    }
    return Container();
  }

  //double _value = 0;
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
      child: SizedBox(
        width: size.width,
        height: size.height,
        //margin: EdgeInsets.fromLTRB(80, 0, 0, 0),
        child: Stack(
          children: [
            _getBookPreview(size),
/*
            // top-buttons (share, download, add-to-playlist)
            !bookMouseOver
                ? Container()
                : Container(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 16 - 8),
                    child: Column(
                      children: [
                        Row(
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
                              icon: Icons.playlist_add_outlined,
                              buttonColor: CretaButtonColor.blueGray,
                              onPressed: () {},
                            ),
                            SizedBox(width: 12),
                            BTN.fill_blue_i_l(
                              icon: Icons.file_download_outlined,
                              buttonColor: CretaButtonColor.blueGray,
                              onPressed: () {},
                            ),
                          ],
                        ),
                        Expanded(child: Container()),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: Container()),
                            BTN.fill_blue_i_l(
                              icon: Icons.volume_up_outlined,
                              buttonColor: CretaButtonColor.blueGray,
                              onPressed: () {},
                            ),
                            SizedBox(width: 8),
                            BTN.fill_blue_i_l(
                              icon: Icons.fullscreen_outlined,
                              buttonColor: CretaButtonColor.blueGray,
                              onPressed: () {},
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
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
            // center play button
            !bookMouseOver
                ? SizedBox.shrink()
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
*/
            //
            //
            //
            //
            // bottom-buttons (fullscreen, mute) //////////////////////////////////////////////////////////
            //
            //
            //
            // progress-bar
            // !bookMouseOver
            //     ? SizedBox.shrink()
            //     : Container(
            //         height: size.height,
            //         padding: EdgeInsets.fromLTRB(20, 24, 20, 16 - 4),
            //         child: Column(
            //           children: [
            //             Expanded(child: Container()),
            //             CretaProgressSlider(
            //               height: 24,
            //               barThickness: 8,
            //               min: 0,
            //               max: 100,
            //               value: _value,
            //               inactiveTrackColor: Colors.white,
            //               onChanged: (value) {
            //                 setState(() {
            //                   _value = value;
            //                   //print('value=$value');
            //                 });
            //               },
            //             ),
            //           ],
            //         ),
            //       ),
          ],
        ),
      ),
    );
  }

  Widget _getChannelInfoPane() {
    return Container(
      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      margin: EdgeInsets.only(top: 24),
      child: Row(
        children: [
          SizedBox(
            width: 52,
            height: 52,
            child: (_channelModel == null)
                ? SizedBox.shrink()
                // : CustomImage(
                //     //key: ValueKey('related-${item.thumbnailUrl}'),
                //     image: _channelList[0].profileImg,
                //     width: 210,
                //     height: 160,
                //     hasMouseOverEffect: false,
                //     hasAni: false,
                //   ),
                : userPropertyManagerHolder.imageCircle(
                    _channelModel!.profileImg,
                    _channelModel!.name,
                    radius: 52,
                  ),
          ),
          SizedBox(
            width: 12,
          ),
          Text(
            _channelModel?.name ?? '',
            style: CretaFont.titleELarge.copyWith(color: CretaColor.text[700]),
          ),
          SizedBox(
            width: 42,
          ),
          Text(
            (_channelModel != null) ? '구독자 ${_channelModel!.followerCount}명' : '',
            style: CretaFont.buttonLarge.copyWith(color: CretaColor.text[400]),
          ),
          SizedBox(
            width: 16,
          ),
          (_channelModel == null || CretaAccountManager.getUserProperty!.channelId == _channelModel?.mid)
              ? SizedBox.shrink()
              : BTN.fill_blue_t_m(
                  text: (_subscriptionModel == null) ? '구독하기' : '구독중',
                  width: 84,
                  onPressed: () {
                    if (_subscriptionModel == null) {
                      subscriptionManagerHolder
                          .createSubscription(
                        CretaAccountManager.getUserProperty!.channelId,
                        _channelModel!.mid,
                      )
                          .then(
                        (value) {
                          showSnackBar(context, '구독되었습니다');
                          setState(() {
                            _subscriptionModel = SubscriptionModel.withName(
                                channelId: CretaAccountManager.getUserProperty!.channelId,
                                subscriptionChannelId: _channelModel!.mid);
                          });
                        },
                      );
                    } else {
                      subscriptionManagerHolder
                          .removeSubscription(
                        CretaAccountManager.getUserProperty!.channelId,
                        _channelModel!.mid,
                      )
                          .then(
                        (value) {
                          showSnackBar(context, '구독 해지되었습니다');
                          setState(() {
                            _subscriptionModel = null;
                          });
                        },
                      );
                    }
                  },
                ),
        ],
      ),
    );
  }

  bool _clickedDescriptionEditButton = false;
  //String _description = ''
  //    '한강의 사계절을 한강 철교를 중심으로 표현해 보았습니다. 즐겁게 감상하세요.\n보다 자세한 사항은 아래 블로그를 방문해 주세요.\n\n이 콘텐츠의 사용 조건(저작권) : MIT\n이 콘텐츠가 포함하고 있는 원본 저작권 표시 : YG Entertainment, SME, Hive...';
  String _descriptionChanging = '';
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  void takeSnapshot() {
    RenderRepaintBoundary boundary = bookKeyParent.currentContext!.findRenderObject() as RenderRepaintBoundary;
    boundary.toImage().then((value) {
      value.toByteData(format: ImageByteFormat.png).then((value) {
        Uint8List memImageData = value!.buffer.asUint8List();
        if (kDebugMode) print('memImageData=$memImageData');
      });
    });
  }

  Widget _getBookDescriptionPane() {
    _descriptionChanging = _currentBookModel?.description.value ?? '';
    return SizedBox(
      width: _usingContentsRect.width,
      //height: size.height,
      //padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(12, 24, 22, 0),
            child: Row(
              children: [
                Container(
                  height: 32,
                  padding: EdgeInsets.fromLTRB(0, 3, 0, 2),
                  child: Text(
                    '내용',
                    style: CretaFont.titleELarge.copyWith(color: CretaColor.text[700], fontWeight: CretaFont.semiBold),
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(child: Container()),
                (!kDebugMode || !_crossCommonJob.isInUsingCanvaskit())
                    ? SizedBox.shrink()
                    : BTN.fill_gray_200_i_s(
                        icon: Icons.camera_outlined,
                        onPressed: () {
                          takeSnapshot();
                        },
                      ),
                if (kDebugMode) SizedBox(width: 8),
                (_clickedDescriptionEditButton || !_isEditableBook)
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
          ),
          SizedBox(height: 4),
          RawKeyboardListener(
            focusNode: FocusNode(),
            onKey: (RawKeyEvent event) {
              if (event.logicalKey == LogicalKeyboardKey.escape) {
                // Do something when ESC key is pressed
                setState(() {
                  //print('_description(1)=$_description');
                  _controller.text = _descriptionChanging;
                  _clickedDescriptionEditButton = false;
                });
              }
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, (22 - _usingContentsRect.childLeftPadding), 0),
              child: CupertinoTextField(
                //customizedDisableColor: Colors.white,
                minLines: 3,
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _focusNode,
                padding: EdgeInsets.fromLTRB(
                  _usingContentsRect.childLeftPadding,
                  0,
                  _usingContentsRect.childLeftPadding,
                  _usingContentsRect.childLeftPadding,
                ),
                enabled: _clickedDescriptionEditButton,
                autofocus: false,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: _clickedDescriptionEditButton
                      ? Border.all(color: CretaColor.text[200]!)
                      : Border.all(color: Colors.white /*Color.fromARGB(255, 250, 250, 250)*/),
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
                  _descriptionChanging = value;
                },
                onSubmitted: ((value) {
                  _descriptionChanging = value;
                }),
                onTapOutside: (event) {
                  //logger.fine('onTapOutside($_searchValue)');
                  if (_clickedDescriptionEditButton) {
                    if (_currentBookModel != null) {
                      _currentBookModel?.description.set(
                        _descriptionChanging,
                        save: false,
                        noUndo: false,
                        dontChangeBookTime: true,
                      );
                      bookPublishedManagerHolder.setToDB(_currentBookModel!);
                      setState(() {
                        // _description = _descriptionOld;
                        //print('_description(2)=$_description');
                        _clickedDescriptionEditButton = false;
                      });
                    }
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
    );
  }

  final ScrollController _usingContentsScrollController = ScrollController();

  Widget _getUsinContentsPane() {
    if (_usingContentsFullView) {
      return Container(
        width: _usingContentsRect.width,
        padding: EdgeInsets.fromLTRB(
          _usingContentsRect.childLeftPadding,
          _usingContentsRect.childTopPadding,
          _usingContentsRect.childRightPadding,
          _usingContentsRect.childBottomPadding,
        ),
        margin: EdgeInsets.fromLTRB(
          _usingContentsRect.childMargin.left,
          _usingContentsRect.childMargin.top,
          _usingContentsRect.childMargin.right,
          _usingContentsRect.childMargin.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '위 크레타북에서 사용된 콘텐츠',
                  style: CretaFont.titleELarge.copyWith(color: CretaColor.text[700], fontWeight: CretaFont.semiBold),
                  textAlign: TextAlign.left,
                ),
                Expanded(child: Container()),
                BTN.fill_gray_t_es(
                  text: '접어두기',
                  width: 58,
                  textColor: CretaColor.text[400],
                  onPressed: () {
                    setState(() {
                      _usingContentsFullView = !_usingContentsFullView;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(
              width: _usingContentsRect.childWidth,
              child: Wrap(
                direction: Axis.horizontal, // 나열 방향
                //alignment: WrapAlignment.start, // 정렬 방식
                spacing: 20, // 좌우 간격
                runSpacing: 20, // 상하 간격
                children: _usingContentsList.map((item) {
                  return SizedBox(
                    width: 210,
                    height: 160,
                    child: CustomImage(
                      //key: ValueKey('related-${item.thumbnailUrl}'),
                      duration: 500,
                      hasMouseOverEffect: false,
                      hasAni: false,
                      image: item.thumbnailUrl ?? '',
                      width: 210,
                      height: 160,
                      useDefaultErrorImage: true,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    }
    return _usingContentsRect.childContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '위 크레타북에서 사용된 콘텐츠',
                style: CretaFont.titleELarge.copyWith(color: CretaColor.text[700], fontWeight: CretaFont.semiBold),
                textAlign: TextAlign.left,
              ),
              Expanded(child: Container()),
              BTN.fill_gray_t_es(
                text: '전체보기',
                width: 58,
                textColor: CretaColor.text[400],
                onPressed: () {
                  setState(() {
                    _usingContentsFullView = !_usingContentsFullView;
                  });
                },
              ),
            ],
          ),
          Expanded(child: Container()),
          SizedBox(
            width: _usingContentsRect.childWidth,
            height: 160,
            //color: Colors.green,
            // child: Scrollbar(
            //   thumbVisibility: false,
            //   controller: _usingContentsScrollController,
            child: ListView(
              controller: _usingContentsScrollController,
              // 스크롤 방향 설정. 수평적으로 스크롤되도록 설정
              scrollDirection: Axis.horizontal,
              // 컨테이너들을 ListView의 자식들로 추가
              children: [
                Wrap(
                  direction: Axis.horizontal, // 나열 방향
                  //alignment: WrapAlignment.start, // 정렬 방식
                  spacing: 20, // 좌우 간격
                  //runSpacing: 20, // 상하 간격
                  children: _usingContentsList.map((item) {
                    return SizedBox(
                      width: 210,
                      height: 160,
                      child: CustomImage(
                        //key: ValueKey('related-${item.thumbnailUrl}'),
                        duration: 500,
                        hasMouseOverEffect: false,
                        hasAni: false,
                        image: item.thumbnailUrl ?? '',
                        width: 210,
                        height: 160,
                        useDefaultErrorImage: true,
                      ),
                    );
                  }).toList(),
                ),
              ],
              //),
            ),
          ),
        ],
      ),
    );
  }

  bool _getAdminModeOfCurrentBook() {
    if (_currentBookModel == null) return false;
    for (var owner in _currentBookModel!.owners) {
      if (owner == AccountManager.currentLoginUser.email) {
        return true;
      }
    }
    return false;
  }

  Widget _getCommentsPane() {
    return Container(
      //color: Colors.red,
      width: _usingContentsRect.width,
      //height: size.height,
      padding: EdgeInsets.fromLTRB(_usingContentsRect.childLeftPadding, 0, _usingContentsRect.childRightPadding, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '댓글',
            style: CretaFont.titleELarge.copyWith(color: CretaColor.text[700], fontWeight: CretaFont.semiBold),
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
            paneWidth: _usingContentsRect.childWidth,
            paneHeight: null,
            showAddCommentBar: true,
            bookId: CommunityRightBookPane.bookId,
            isAdminMode: _getAdminModeOfCurrentBook(),
          ),
        ],
      ),
    );
  }

  Widget _getRelatedBookList(double width) {
    // double height = _cretaRelatedBookList.length * 256;
    // if (_cretaRelatedBookList.isNotEmpty) {
    //   height += ((_cretaRelatedBookList.length - 1) * 20);
    // }
    return SizedBox(
      width: width,
      //height: height,
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
            width: 306,
            height: 230,
          );
        }).toList(),
      ),
    );
  }

  Size _bookAreaSize = Size.zero;
  CretaLayoutRect _sideAreaRect = CretaLayoutRect.zero;
  CretaLayoutRect _usingContentsRect = CretaLayoutRect.zero;
  final double _bookAreaRatio = (9 / 16);
  void _resize(BuildContext context) {
    //_sideAreaSize = Size(346, 1000);
    bool noSideArea = widget.cretaLayoutRect.childWidth < 800;
    _sideAreaRect = CretaLayoutRect.fromPadding(noSideArea ? 0 : 346, 1000, 20, 20, 20, 20);
    double bookAreaWidth = widget.cretaLayoutRect.childWidth - 20 - _sideAreaRect.width;
    double bookAreaHeight = bookAreaWidth * _bookAreaRatio;
    _bookAreaSize = Size(bookAreaWidth, bookAreaHeight);
    _usingContentsRect = CretaLayoutRect.fromPadding(bookAreaWidth, 206 + 40 + 40 - 12 - 5, 12, 40 - 12 - 5, 22, 40);
  }

  Widget _getMainPane() {
    return SizedBox(
      width: _bookAreaSize.width,
      // padding: EdgeInsets.fromLTRB(
      //   widget.cretaLayoutRect.childLeftPadding,
      //   widget.cretaLayoutRect.childTopPadding,
      //   0,
      //   widget.cretaLayoutRect.childBottomPadding,
      // ),
      child: Column(
        children: [
          // book
          _getBookMainPane(_bookAreaSize),
          // channel info
          _getChannelInfoPane(),
          // description
          _getBookDescriptionPane(),
          // using contents list
          _getUsinContentsPane(),
          // comments
          _getCommentsPane(),
          // gap-space
          SizedBox(height: 40),
          //     ],
          //   ),
          // ),
          //),
        ],
      ),
    );
  }

  Widget _getSidePane() {
    return SizedBox(
      width: _sideAreaRect.width,
      child: Column(
        children: [
          // hashtag
          Container(
            //height: 210,
            padding: EdgeInsets.fromLTRB(
              _sideAreaRect.childLeftPadding,
              _sideAreaRect.childTopPadding,
              _sideAreaRect.childRightPadding,
              _sideAreaRect.childBottomPadding,
            ),
            decoration: BoxDecoration(
              color: CretaColor.text[100],
              border: Border.all(color: CretaColor.text[100]!),
              borderRadius: BorderRadius.circular(20),
            ),

            child: Column(
              children: [
                // hashtag title
                Row(
                  children: [
                    Text(
                      '해시태그',
                      style: CretaFont.titleLarge.copyWith(color: CretaColor.text[700]),
                    ),
                    Expanded(child: Container()),
                    (!_isEditableBook)
                        ? Container()
                        : BTN.fill_gray_200_i_s(
                            icon: _hashtagEditMode ? Icons.check_outlined : Icons.edit_outlined,
                            onPressed: () {
                              setState(() {
                                _hashtagEditMode = !_hashtagEditMode;
                              });
                            },
                          ),
                  ],
                ),
                // gap-space
                SizedBox(height: 20),
                // hashtag body
                SizedBox(
                  //color: Colors.blue,
                  width: _sideAreaRect.childWidth,
                  child: Wrap(
                    //direction: Axis.horizontal, // 나열 방향
                    //alignment: WrapAlignment.start, // 정렬 방식
                    spacing: 8, // 좌우 간격
                    runSpacing: 8, // 상하 간격
                    children: _getHashtagList(),
                  ),
                ),
                _hashtagEditMode ? SizedBox(height: 20) : SizedBox.shrink(),
                _hashtagEditMode
                    // ? CretaSearchBar(
                    //     hintText: '해시태그를 입력하세요',
                    //     onSearch: (value) {
                    //       setState(() {
                    //         _hashtagValueList.add(value);
                    //       });
                    //     },
                    //   )
                    ? CretaTextField(
                        textFieldKey: GlobalKey(),
                        controller: _hashtagController,
                        value: '',
                        hintText: '',
                        width: _sideAreaRect.childWidth,
                        height: 30,
                        onEditComplete: (value) {
                          if (_hashtagEditMode && value.isNotEmpty) {
                            setState(() {
                              _hashtagController.text = '';
                              _hashtagValueList.add(value);
                              _currentBookModel?.hashTag.set(CretaUtils.listToString(_hashtagValueList));
                            });
                          }
                        },
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
          // related book
          Container(
            //height: 1000,
            padding: EdgeInsets.fromLTRB(12, 20, 12, 0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '연관 크레타북',
                      style: CretaFont.titleLarge.copyWith(color: CretaColor.text[700]),
                    ),
                    Expanded(child: Container()),
                  ],
                ),
                SizedBox(height: 20),
                _getRelatedBookList(_sideAreaRect.childWidth),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (StudioVariables.isFullscreen) {
      double width = MediaQuery.of(context).size.width;
      double height = MediaQuery.of(context).size.height;
      return _getBookPreview(Size(width, height));
    }
    _resize(context);
    return Scrollbar(
      key: _key,
      thumbVisibility: true,
      controller: widget.scrollController,
      child: SingleChildScrollView(
        controller: widget.scrollController,
        child: Container(
          padding: EdgeInsets.fromLTRB(
            widget.cretaLayoutRect.childLeftPadding,
            widget.cretaLayoutRect.childTopPadding,
            widget.cretaLayoutRect.childRightPadding,
            widget.cretaLayoutRect.childBottomPadding,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // main (book, descriptio, comment, etc...)
              _getMainPane(),
              // gap-space
              if (_sideAreaRect.childWidth > 0) SizedBox(width: 20),
              // side (playlist, hashtag, related book, etc...)
              if (_sideAreaRect.childWidth > 0) _getSidePane(),
            ],
          ),
        ),
      ),
    );
  }
}
