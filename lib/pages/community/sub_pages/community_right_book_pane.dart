// ignore_for_file: prefer_const_constructors

import 'dart:ui';
import 'package:creta_common/common/creta_common_utils.dart';

import 'package:creta03/model/favorites_model.dart';
import 'package:creta03/model/subscription_model.dart';
//import 'package:creta03/pages/community/community_book_page.dart';
import 'package:flutter/rendering.dart';
import 'package:universal_html/html.dart';
import 'package:creta03/design_system/buttons/creta_button.dart';
import 'package:creta03/model/watch_history_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hycop/hycop.dart';
import 'package:url_launcher/link.dart';
//import 'dart:async';
//import 'package:flutter/gestures.dart';
//import 'package:hycop/hycop.dart';
//import 'package:hycop/common/util/logger.dart';
import 'package:routemaster/routemaster.dart';
//import 'package:url_strategy/url_strategy.dart';
import 'package:creta_common/common/cross_common_job.dart';
import '../../../design_system/buttons/creta_button_wrapper.dart';
//import '../../../design_system/buttons/creta_elibated_button.dart';
//import '../../design_system/buttons/creta_button.dart';
//import '../../../design_system/component/snippet.dart';
import '../../../design_system/component/creta_layout_rect.dart';
//import '../../design_system/menu/creta_drop_down.dart';
//import '../../design_system/menu/creta_popup_menu.dart';
//import '../../design_system/text_field/creta_search_bar.dart';
import '../../../design_system/text_field/creta_text_field.dart';
import 'package:creta_common/common/creta_color.dart';
//import 'package:image_network/image_network.dart';
//import 'package:cached_network_image/cached_network_image.dart';
//import '../../../pages/login_page.dart';
import '../../../lang/creta_commu_lang.dart';
import '../../../pages/login/creta_account_manager.dart';
//import '../../common/cross_common_job.dart';
import '../../../routes.dart';
//import 'sub_pages/community_left_menu_pane.dart';
//import '../../design_system/component/creta_basic_layout_mixin.dart';
import '../../../design_system/component/custom_image.dart';
import 'package:creta_common/common/creta_font.dart';
//import 'package:creta_common/lang/creta_lang.dart';
//import 'package:creta_common/common/creta_font.dart';
//import 'package:creta03/pages/community/community_sample_data.dart';
import '../creta_book_ui_item.dart';
//import '../../../design_system/buttons/creta_progress_slider.dart';
//import '../../design_system/text_field/creta_comment_bar.dart';
import 'community_comment_pane.dart';
import '../../../data_io/watch_history_manager.dart';
import '../../studio/book_main_page.dart';
import '../../studio/studio_variables.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/book_model.dart';
import '../../../model/channel_model.dart';
import 'package:creta_studio_model/model/contents_model.dart';
import 'package:creta_user_model/model/team_model.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import 'package:creta_studio_model/model/page_model.dart';
import 'package:creta_user_model/model/user_property_model.dart';
import '../../../model/playlist_model.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';
import '../../../data_io/book_published_manager.dart';
import '../../../data_io/channel_manager.dart';
import '../../../data_io/favorites_manager.dart';
import '../../../data_io/playlist_manager.dart';
import '../../../data_io/subscription_manager.dart';
import 'package:creta_user_io/data_io/team_manager.dart';
import 'package:creta_user_io/data_io/user_property_manager.dart';
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
  static String playlistId = '';

  @override
  State<CommunityRightBookPane> createState() => _CommunityRightBookPaneState();
}

class _CommunityRightBookPaneState extends State<CommunityRightBookPane> {
  //late List<CretaBookData> _cretaRelatedBookList;
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
  late FavoritesManager favoritesManagerHolder;
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
  final List<BookModel> _relatedBookList = [];
  final Map<String, bool> _favoritesBookIdMap = {}; // <Book.mid, isFavorites>
  //bool _bookIsInFavorites = false;
  //late GlobalKey _fullscreenBookKey;
  //late GlobalKey _fullscreenParentBookKey;
  late GlobalKey _bookKey;
  late GlobalKey _parentBookKey;
  final CrossCommonJob _crossCommonJob = CrossCommonJob();
  bool _isEditableBook = false;

  PlaylistModel? _playlistModelOnRightPane;
  int _selectedPlaylistIndex = -1;
  bool _showPlaylist = true;
  bool _showAllPlaylistItems = false;
  int _hoverPlaylistIndex = -1;
  final Map<String, ChannelModel> _channelMap = {};
  final ScrollController _playlistScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    StudioVariables.isAutoPlay = false;

    if (CommunityRightBookPane.bookId.isEmpty) {
      //String url = Uri.base.origin;
      //String query = Uri.base.query;
      //int pos = query.indexOf('&');
      //CommunityRightBookPane.bookId = (pos > 0) ? query.substring(0, pos) : query;
      Uri.base.queryParameters.forEach((key, value) {
        if (key == 'book') {
          CommunityRightBookPane.bookId = '$key=$value';
        } else if (key == 'playlist') {
          CommunityRightBookPane.playlistId = '$key=$value';
        }
      });
    }

    StudioVariables.selectedBookMid = CommunityRightBookPane.bookId;
    if (StudioVariables.selectedBookMid.isEmpty) {
      StudioVariables.selectedBookMid = "book=a5948eae-03ae-410f-8efa-f1a3c28e4f05";
    }

    //_fullscreenBookKey = GlobalObjectKey('_CommunityRightBookPaneState.fullscreenBookKey.${CommunityRightBookPane.bookId}.parent');
    //_fullscreenParentBookKey = GlobalObjectKey('_CommunityRightBookPaneState.fullscreenParentBookKey.${CommunityRightBookPane.bookId}.parent');
    _bookKey = GlobalObjectKey(
        '_CommunityRightBookPaneState.bookKey.${CommunityRightBookPane.bookId}.parent');
    _parentBookKey = GlobalObjectKey(
        '_CommunityRightBookPaneState.parentBookKey.${CommunityRightBookPane.bookId}.parent');

    bookPublishedManagerHolder = BookPublishedManager();
    channelManagerHolder = ChannelManager();
    favoritesManagerHolder = FavoritesManager();
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
        QuerySet(bookPublishedManagerHolder, _getRelatedBooksFromDB, _resultRelatedBooksFromDB),
        QuerySet(channelManagerHolder, _getChannelsFromDB, _resultChannelsFromDB),
        QuerySet(favoritesManagerHolder, _getFavoritesFromDB, _resultFavoritesFromDB),
        QuerySet(playlistManagerHolder, _getPlaylistsFromDB, _resultPlaylistsFromDB),
        QuerySet(playlistManagerHolder, _getMyPlaylistsFromDB, _resultMyPlaylistsFromDB),
        QuerySet(bookPublishedManagerHolder, _getPlaylistsBooksFromDB, _resultPlaylistsBooksFromDB),
        QuerySet(channelManagerHolder, _getPlaylistChannelsFromDB, _resultPlaylistChannelsFromDB),
        QuerySet(userPropertyManagerHolder, _getUserPropertyFromDB, _resultUserPropertyFromDB),
        QuerySet(teamManagerHolder, _getTeamsFromDB, _resultTeamsFromDB),
        QuerySet(subscriptionManagerHolder, _getSubscriptionFromDB, _resultSubscriptionFromDB),
        QuerySet(contentsManagerHolder, _getContentsFromDB, _resultContentsFromDB),
        QuerySet(dummyManagerHolder, _dummyCompleteDB, null),
      ],
      completeFunc: () {
        //_onceDBGetComplete = true;
      },
    );

    //_cretaRelatedBookList = CommunitySampleData.getCretaBookList();

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
    if (AccountManager.currentLoginUser.isLoginedUser) {
      watchHistoryManagerHolder.createToDB(whModel);
    }
    //bookManagerHolder!.configEvent(notifyModify: false);
    //watchHistoryManagerHolder!.clearAll();
  }

  void _getRelatedBooksFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('start _getRelatedBooksFromDB()');
    bookPublishedManagerHolder.addCretaFilters(
      bookType: BookType.none,
      bookSort: BookSort.updateTime,
      permissionType: PermissionType.reader,
      searchKeyword: '',
      hashtag: '',
    );
    bookPublishedManagerHolder.queryByAddedContitions();
  }

  void _resultRelatedBooksFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('start _resultBooksFromDB(${modelList.length})');
    if (modelList.isEmpty) {
      // no book-data in DB
      return;
    }
    final Map<String, String> bookIdMap = {};
    for (var model in modelList) {
      BookModel bookModel = model as BookModel;
      if (bookModel.getMid == _currentBookModel?.getMid) continue;
      bookIdMap.putIfAbsent(bookModel.getMid, () {
        _relatedBookList.add(bookModel);
        return bookModel.getMid;
      });
    }
  }

  void _getBooksFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('start _getBooksFromDB()');
    if (CommunityRightBookPane.bookId.isEmpty) {
      // no book-data ==> skip
      bookPublishedManagerHolder.setState(DBState.idle);
      return;
    }
    bookPublishedManagerHolder.addWhereClause('isRemoved', QueryValue(value: false));
    bookPublishedManagerHolder.addWhereClause(
        'mid', QueryValue(value: CommunityRightBookPane.bookId));
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
    _hashtagValueList = CretaCommonUtils.jsonStringToList(_currentBookModel!.hashTag.value);

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
      favoritesManagerHolder.setState(DBState.idle);
      return;
    }
    List<AbsExModel> bookList = [_currentBookModel!];
    if (AccountManager.currentLoginUser.isLoginedUser) {
      for (var bookModel in _relatedBookList) {
        bookList.add(bookModel);
      }
    }
    favoritesManagerHolder.queryFavoritesFromBookModelList(bookList);
  }

  void _resultFavoritesFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('start _resultFavoritesFromDB(${modelList.length})');
    if (modelList.isEmpty) {
      // this book is not in favorites
      //_bookIsInFavorites = false;
    } else {
      // something is exist in DB ==> Favorites
      //_bookIsInFavorites = true;
      for (var model in modelList) {
        FavoritesModel favModel = model as FavoritesModel;
        _favoritesBookIdMap[favModel.bookId] = true;
      }
    }
  }

  void _getPlaylistsFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('_getPlaylistsFromDB');
    if (CommunityRightBookPane.playlistId.isEmpty) {
      // no playlist ==> skip
      playlistManagerHolder.setState(DBState.idle);
      return;
    }
    playlistManagerHolder.addWhereClause('isRemoved', QueryValue(value: false));
    playlistManagerHolder.addWhereClause(
        'mid', QueryValue(value: CommunityRightBookPane.playlistId));
    playlistManagerHolder.queryByAddedContitions();
  }

  void _resultPlaylistsFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('_playlistModelList.modelList.length=${modelList.length}');
    if (modelList.isNotEmpty) {
      _playlistModelOnRightPane = modelList[0] as PlaylistModel;
    }
  }

  void _getMyPlaylistsFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('_getMyPlaylistsFromDB');
    if (AccountManager.currentLoginUser.isLoginedUser == false) {
      playlistManagerHolder.setState(DBState.idle);
      return;
    }
    playlistManagerHolder.addWhereClause('isRemoved', QueryValue(value: false));
    playlistManagerHolder.addWhereClause(
        'channelId', QueryValue(value: CretaAccountManager.getUserProperty!.channelId));
    playlistManagerHolder.queryByAddedContitions();
  }

  void _resultMyPlaylistsFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('_playlistModelList.modelList.length=${modelList.length}');
    for (var plModel in modelList) {
      _playlistModelList.add(plModel as PlaylistModel);
    }
  }

  void _getPlaylistsBooksFromDB(List<AbsExModel> modelList) {
    final Map<String, String> bookIdMap = {};
    for (var model in modelList) {
      PlaylistModel plModel = model as PlaylistModel;
      if (plModel.bookIdList.isNotEmpty) {
        bookIdMap.putIfAbsent(plModel.bookIdList[0], () => plModel.bookIdList[0]);
      }
    }
    _playlistModelOnRightPane?.bookIdList
        .forEach((bookId) => bookIdMap.putIfAbsent(bookId, () => bookId));
    final List<String> bookIdList = [];
    bookIdMap.forEach((key, value) => bookIdList.add(key));
    bookPublishedManagerHolder.queryFromIdList(bookIdList);
  }

  void _resultPlaylistsBooksFromDB(List<AbsExModel> modelList) {
    for (var model in modelList) {
      BookModel bModel = model as BookModel;
      //if (kDebugMode) print('_resultBooksFromDB(bookId=${bModel.getKeyId})');
      _playlistsBooksMap[bModel.getMid] = bModel;
    }
  }

  void _getPlaylistChannelsFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('start _getPlaylistChannelsFromDB()');
    if (_playlistModelOnRightPane == null) {
      // no book-data ==> skip
      channelManagerHolder.setState(DBState.idle);
      return;
    }
    // channel in playlist
    final Map<String, String> channelIdMap = {};
    _playlistModelOnRightPane?.bookIdList.forEach((bookId) {
      BookModel? bookModel = _playlistsBooksMap[bookId];
      if (bookModel == null) return;
      channelIdMap.putIfAbsent(bookModel.channels[0], () => bookModel.channels[0]);
    });
    // channel in related book list
    for (var bookModel in _relatedBookList) {
      if (bookModel.channels.isEmpty) continue;
      channelIdMap.putIfAbsent(bookModel.channels[0], () => bookModel.channels[0]);
    }
    //
    final List<String> channelIdList = [];
    channelIdMap.forEach((key, value) {
      channelIdList.add(value);
    });
    channelManagerHolder.queryFromIdList(channelIdList);
  }

  void _resultPlaylistChannelsFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('start _resultPlaylistChannelsFromDB(${modelList.length})');
    for (var model in modelList) {
      ChannelModel chModel = model as ChannelModel;
      _channelMap[chModel.mid] = chModel;
      if (chModel.userId.isNotEmpty) {
        _userIdMap[chModel.userId] = chModel.userId;
      }
      if (chModel.teamId.isNotEmpty) {
        _teamIdMap[chModel.teamId] = chModel.teamId;
      }
    }
  }

  void _getSubscriptionFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('start _getSubscriptionFromDB(${modelList.length})');
    if (_currentBookModel == null ||
        _channelModel == null ||
        AccountManager.currentLoginUser.isLoginedUser == false) {
      // no book-data ==> skip
      subscriptionManagerHolder.setState(DBState.idle);
      return;
    }
    subscriptionManagerHolder.addWhereClause('isRemoved', QueryValue(value: false));
    subscriptionManagerHolder.addWhereClause(
        'channelId', QueryValue(value: CretaAccountManager.getUserProperty!.channelId));
    subscriptionManagerHolder.addWhereClause(
        'subscriptionChannelId', QueryValue(value: _channelModel!.mid));
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
        widget.onUpdateBookModel?.call(_currentBookModel!, creatorUserModel,
            _favoritesBookIdMap[_currentBookModel!.getMid] ?? false, addToPlaylist);
        setState(() {
          _controller.text = _currentBookModel?.description.value ?? '';
        });
      }
      //
      _channelMap.forEach((channelId, channelModel) {
        channelModel.getModelFromMaps(_userPropertyMap, _teamMap);
      });
      //
      if (_playlistModelOnRightPane != null) {
        for (int idx = 0; idx < _playlistModelOnRightPane!.bookIdList.length; idx++) {
          String bookId = _playlistModelOnRightPane!.bookIdList[idx];
          if (bookId == _currentBookModel!.getMid) {
            _selectedPlaylistIndex = idx;
            break;
          }
        }
      }
    }
    dummyManagerHolder.setState(DBState.idle);
  }

  void addToPlaylist() async {
    if (_currentBookModel != null) {
      playlistManagerHolder.addToPlaylist(context, _currentBookModel!, _playlistsBooksMap);
    }
  }

  List<Widget> _getPlaylists(BuildContext context) {
    final List<Widget> playlistWidgetList = [];
    for (int idx = 0; idx < _playlistModelOnRightPane!.bookIdList.length; idx++) {
      String bookId = _playlistModelOnRightPane!.bookIdList[idx];
      BookModel? bookModel = _playlistsBooksMap[bookId];
      if (bookModel == null) return [SizedBox.shrink()];
      String channelName = _channelMap[bookModel.channels[0]]?.name ?? '';
      String linkUrl = '${AppRoutes.communityBook}?$bookId&${_playlistModelOnRightPane?.getMid}';
      Widget widget = Link(
        uri: Uri.parse(linkUrl),
        builder: (linkContext, function) {
          return InkWell(
            hoverColor: Colors.transparent,
            onHover: (value) {
              if (value) {
                setState(() {
                  _hoverPlaylistIndex = idx;
                });
              }
            },
            onTap: () {
              Routemaster.of(context).push(linkUrl);
            },
            child: Container(
              color: (idx == _hoverPlaylistIndex)
                  ? CretaColor.text[200]
                  : (_currentBookModel?.mid == bookModel.mid)
                      ? CretaColor.primary[100]
                      : null,
              child: SizedBox(
                width: 306,
                height: 74,
                //margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(6),
                //   color: (_selectedPlaylistId == bookModel.mid) ? CretaColor.text[200] : null,
                // ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 90,
                        height: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Stack(
                            children: [
                              (bookModel.thumbnailUrl.value.isEmpty)
                                  ? const SizedBox(width: 74, height: 44)
                                  : CustomImage(
                                      width: 90,
                                      height: 50,
                                      hasAni: false,
                                      image: bookModel.thumbnailUrl.value,
                                    ),
                              if (_currentBookModel?.mid == bookModel.mid &&
                                  idx != _hoverPlaylistIndex)
                                Opacity(
                                  opacity: 0.4,
                                  child: Container(
                                    width: 90,
                                    height: 50,
                                    color: CretaColor.text[900],
                                  ),
                                ),
                              if (_currentBookModel?.mid == bookModel.mid &&
                                  idx != _hoverPlaylistIndex)
                                SizedBox(
                                  width: 90,
                                  height: 50,
                                  child: Center(
                                    child: Icon(
                                      Icons.play_arrow,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 4, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 172 - 4,
                              child: Text(
                                bookModel.name.value,
                                overflow: TextOverflow.ellipsis,
                                style: CretaFont.bodyMedium.copyWith(color: CretaColor.text[700]),
                              ),
                            ),
                            SizedBox(
                              width: 172 - 4,
                              child: Text(
                                channelName,
                                overflow: TextOverflow.ellipsis,
                                style: CretaFont.buttonMedium.copyWith(color: CretaColor.text[400]),
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
          );
        },
      );
      playlistWidgetList.add(widget);
    }
    return playlistWidgetList;
  }

  Widget _getPlaylistWidget(BuildContext context) {
    int bookCount = _playlistModelOnRightPane!.bookIdList.length;
    final bool showScrollbar = (bookCount > 5);
    double playlistHeight =
        _showPlaylist ? (showScrollbar && !_showAllPlaylistItems ? 400 : bookCount * 74 + 2) : 0;
    return Container(
      width: _sideAreaRect.width,
      height: _showPlaylist ? 20 + 32 + 20 + playlistHeight + 20 + 2 : 74,
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
      decoration: BoxDecoration(
        color: CretaColor.text[100],
        border: Border.all(color: CretaColor.text[100]!),
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        width: _sideAreaRect.childWidth,
        height: 32 + 20 + playlistHeight,
        child: Column(
          children: [
            SizedBox(
              width: _sideAreaRect.childWidth,
              height: 32,
              child: Row(
                children: [
                  Text(
                    _playlistModelOnRightPane!.name,
                    style: CretaFont.titleLarge.copyWith(color: CretaColor.text[700]),
                  ),
                  if (bookCount > 5)
                    BTN.fill_gray_t_es(
                      text: _showAllPlaylistItems
                          ? CretaCommuLang['viewShort']
                          : CretaCommuLang['viewAll'],
                      width: 69,
                      buttonColor: CretaButtonColor.gray100light,
                      textColor: CretaColor.text[400],
                      onPressed: () =>
                          setState(() => (_showAllPlaylistItems = !_showAllPlaylistItems)),
                    ),
                  Expanded(child: Container()),
                  BTN.fill_gray_i_m(
                    icon: _showPlaylist
                        ? Icons.keyboard_arrow_up_sharp
                        : Icons.keyboard_arrow_down_sharp,
                    iconSize: 24,
                    iconColor: CretaColor.text[700],
                    buttonColor: CretaButtonColor.gray100light,
                    onPressed: () => setState(() => (_showPlaylist = !_showPlaylist)),
                  ),
                ],
              ),
            ),
            if (_showPlaylist) SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: MouseRegion(
                onExit: (value) {
                  setState(() {
                    _hoverPlaylistIndex = -1;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(width: 1, color: CretaColor.text[100]! /*Colors.white*/),
                    color: Colors.white,
                  ),
                  width: _sideAreaRect.childWidth,
                  height: playlistHeight,
                  child: Scrollbar(
                    thumbVisibility: true,
                    controller: _playlistScrollController,
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context)
                          .copyWith(scrollbars: showScrollbar), // 스크롤바 감추기
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        controller: _playlistScrollController,
                        children: _getPlaylists(context),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
            _currentBookModel?.hashTag.set(CretaCommonUtils.listToString(_hashtagValueList));
          });
        }
      },
    );
  }

  List<Widget> _getHashtagList() {
    return _hashtagValueList.map((e) => _getHashtagWidget(e)).toList();
  }

  void _toggleFullscreen() {
    //setState(() {
    StudioVariables.isFullscreen = !StudioVariables.isFullscreen;
    if (StudioVariables.isFullscreen) {
      document.documentElement?.requestFullscreen();
    } else {
      document.exitFullscreen();
    }
    //});
  }

  void _onGotoPrevBook() {
    if (_selectedPlaylistIndex < 0) return;
    if (_playlistModelOnRightPane == null) return;
    if (_playlistModelOnRightPane!.bookIdList.length == 1) return;
    int prevIdx = _selectedPlaylistIndex - 1;
    if (prevIdx < 0) {
      // 맨앞이면 마지막으로 이동 금지?
      return;
    }
    String bookId = _playlistModelOnRightPane!.bookIdList[prevIdx];
    String linkUrl = '${AppRoutes.communityBook}?$bookId&${_playlistModelOnRightPane?.getMid}';
    Routemaster.of(context).push(linkUrl);
  }

  void _onGotoNextBook() {
    if (_selectedPlaylistIndex < 0) return;
    if (_playlistModelOnRightPane == null) return;
    if (_playlistModelOnRightPane!.bookIdList.length == 1) return;
    int nextIdx = _selectedPlaylistIndex + 1;
    if (nextIdx >= _playlistModelOnRightPane!.bookIdList.length) {
      // 맨뒤면 처음으로 이동 금지?
      return;
    }
    String bookId = _playlistModelOnRightPane!.bookIdList[nextIdx];
    String linkUrl = '${AppRoutes.communityBook}?$bookId&${_playlistModelOnRightPane?.getMid}';
    Routemaster.of(context).push(linkUrl);
  }

  Widget _getBookPreview(Size size, {GlobalKey? bookKey, GlobalKey? parentKey}) {
    //if (_cretaRelatedBookList.isNotEmpty) {
    return RepaintBoundary(
      key: bookKey ?? _parentBookKey,
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: BookMainPage(
          bookKey: parentKey ?? _bookKey,
          isPreviewX: true,
          size: size,
          isPublishedMode: true,
          toggleFullscreen: _toggleFullscreen,
          onGotoPrevBook: CommunityRightBookPane.playlistId.isEmpty ? null : _onGotoPrevBook,
          onGotoNextBook: CommunityRightBookPane.playlistId.isEmpty ? null : _onGotoNextBook,
        ),
      ),
    );
    //}
    //return Container();
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
            if (!StudioVariables.isFullscreen) _getBookPreview(size),
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
            (_channelModel != null)
                ? '${CretaCommuLang['subsriber']} ${_channelModel!.followerCount}'
                : '',
            style: CretaFont.buttonLarge.copyWith(color: CretaColor.text[400]),
          ),
          SizedBox(
            width: 16,
          ),
          (_channelModel == null ||
                  CretaAccountManager.getUserProperty?.channelId == _channelModel?.mid ||
                  AccountManager.currentLoginUser.isLoginedUser == false)
              ? SizedBox.shrink()
              : BTN.fill_blue_t_m(
                  text: (_subscriptionModel == null)
                      ? CretaCommuLang['subscribe']
                      : CretaCommuLang['subscribing'],
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
                          showSnackBar(context, CretaCommuLang['subscribed']);
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
                          showSnackBar(context, CretaCommuLang['unsubscribed']);
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
  String _descriptionChanging = '';
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  void takeSnapshot() {
    RenderRepaintBoundary boundary =
        _parentBookKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
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
                    CretaCommuLang['details'],
                    style: CretaFont.titleELarge
                        .copyWith(color: CretaColor.text[700], fontWeight: CretaFont.semiBold),
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
          KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (KeyEvent event) {
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
                  CretaCommuLang['usedContents'],
                  style: CretaFont.titleELarge
                      .copyWith(color: CretaColor.text[700], fontWeight: CretaFont.semiBold),
                  textAlign: TextAlign.left,
                ),
                Expanded(child: Container()),
                BTN.fill_gray_t_es(
                  text: CretaCommuLang['fold'],
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
                CretaCommuLang['usedContents'],
                style: CretaFont.titleELarge
                    .copyWith(color: CretaColor.text[700], fontWeight: CretaFont.semiBold),
                textAlign: TextAlign.left,
              ),
              Expanded(child: Container()),
              BTN.fill_gray_t_es(
                text: CretaCommuLang['viewAll'],
                width: 66,
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
      padding: EdgeInsets.fromLTRB(
          _usingContentsRect.childLeftPadding, 0, _usingContentsRect.childRightPadding, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            CretaCommuLang['comment'],
            style: CretaFont.titleELarge
                .copyWith(color: CretaColor.text[700], fontWeight: CretaFont.semiBold),
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

  void _addToFavorites(String bookId, bool isFavorites) async {
    if (isFavorites) {
      // already in favorites => remove favorites from DB
      await favoritesManagerHolder.removeFavoritesFromDB(
          bookId, AccountManager.currentLoginUser.email);
      setState(() {
        _favoritesBookIdMap[bookId] = false;
      });
    } else {
      // not exist in favorites => add favorites to DB
      await favoritesManagerHolder.addFavoritesToDB(bookId, AccountManager.currentLoginUser.email);
      setState(() {
        _favoritesBookIdMap[bookId] = true;
      });
    }
  }

  void _addToPlaylist(BookModel bookModel) async {
    playlistManagerHolder.addToPlaylist(context, bookModel, _playlistsBooksMap);
  }

  // void _onRemoveBook(String bookId) async {
  //   for (int i = 0; i < _cretaBooksList.length; i++) {
  //     BookModel bookModel = _cretaBooksList[i];
  //     if (bookModel.getMid != bookId) continue;
  //     bookModel.isRemoved.set(true);
  //     bookPublishedManagerHolder.setToDB(bookModel).then((value) {
  //       setState(() {
  //         _cretaBooksList.removeAt(i);
  //       });
  //     });
  //     break;
  //   }
  // }

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
        // children: _cretaRelatedBookList.map((item) {
        //   return CretaBookItem(
        //     key: item.uiKey,
        //     cretaBookData: item,
        //     width: 306,
        //     height: 230,
        //   );
        // }).toList(),
        children: _relatedBookList.map((bookModel) {
          ChannelModel? chModel =
              bookModel.channels.isEmpty ? null : _channelMap[bookModel.channels[0]];
          return CretaBookUIItem(
            key: GlobalObjectKey('_getRelatedBookList.${bookModel.getMid}'),
            bookModel: bookModel,
            userPropertyModel: _userPropertyMap[bookModel.creator],
            channelModel: chModel,
            width: 306,
            height: 230,
            isFavorites: _favoritesBookIdMap[bookModel.getMid] ?? false,
            addToFavorites: _addToFavorites,
            addToPlaylist: _addToPlaylist,
            onRemoveBook: null, //_onRemoveBook,
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
    _usingContentsRect =
        CretaLayoutRect.fromPadding(bookAreaWidth, 206 + 40 + 40 - 12 - 5, 12, 40 - 12 - 5, 22, 40);
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

  Widget _getSidePane(BuildContext context) {
    return SizedBox(
      key: GlobalObjectKey(GlobalObjectKey(
          '_CommunityRightBookPaneState.getSidePane.${CommunityRightBookPane.bookId}')),
      width: _sideAreaRect.width,
      child: Column(
        children: [
          if (_playlistModelOnRightPane != null) _getPlaylistWidget(context),
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
                      CretaCommuLang['hashtag'],
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
                              _currentBookModel?.hashTag
                                  .set(CretaCommonUtils.listToString(_hashtagValueList));
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
                      CretaCommuLang['popularBook'],
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
    // if (StudioVariables.isFullscreen) {
    //   double width = MediaQuery.of(context).size.width;
    //   double height = MediaQuery.of(context).size.height;
    //   return _getBookPreview(
    //     Size(width, height),
    //     bookKey: _fullscreenBookKey,
    //     parentKey: _fullscreenParentBookKey,
    //   );
    // }
    _resize(context);
    return Stack(
      children: [
        Scrollbar(
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
                  if (_sideAreaRect.childWidth > 0) _getSidePane(context),
                ],
              ),
            ),
          ),
        ),
        if (StudioVariables.isFullscreen) _getBookPreview(MediaQuery.of(context).size),
      ],
    );
  }
}
