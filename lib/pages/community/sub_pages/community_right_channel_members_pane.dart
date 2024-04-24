// ignore_for_file: prefer_const_constructors

//import 'package:creta03/pages/login/creta_account_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
//import 'dart:async';
//import 'package:flutter/gestures.dart';
//import 'package:hycop/hycop.dart';
//import 'package:hycop/common/util/logger.dart';
//import 'package:routemaster/routemaster.dart';
//import 'package:url_strategy/url_strategy.dart';
import '../../../design_system/buttons/creta_button_wrapper.dart';
//import '../../design_system/component/snippet.dart';
//import '../../design_system/menu/creta_drop_down.dart';
//import '../../design_system/menu/creta_popup_menu.dart';
//import '../../design_system/text_field/creta_search_bar.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
// import 'package:image_network/image_network.dart';
// import 'package:cached_network_image/cached_network_image.dart';
//import '../../common/cross_common_job.dart';
//import '../../../routes.dart';
//import '../../../design_system/component/creta_leftbar.dart';
// import '../../../design_system/menu/creta_popup_menu.dart';
// import '../../../design_system/component/creta_banner_pane.dart';
//import '../../../design_system/menu/creta_drop_down.dart';
// import '../../../design_system/menu/creta_drop_down_button.dart';
// import '../../../design_system/text_field/creta_search_bar.dart';
import '../../../lang/creta_commu_lang.dart';
import 'community_right_channel_pane.dart';
//import '../../../common/creta_utils.dart';
import '../../../design_system/component/creta_layout_rect.dart';
//import '../creta_playlist_ui_item.dart';
//import '../community_sample_data.dart';
//import 'community_right_pane_mixin.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';
import '../../../data_io/channel_manager.dart';
//import '../../../data_io/book_published_manager.dart';
//import '../../../data_io/playlist_manager.dart';
import 'package:creta_user_io/data_io/team_manager.dart';
import 'package:creta_user_io/data_io/user_property_manager.dart';
import '../../../data_io/watch_history_manager.dart';
import 'package:creta_common/model/app_enums.dart';
//import 'package:creta_studio_model/model/book_model.dart';
import '../../../model/channel_model.dart';
//import '../../../model/favorites_model.dart';
//import '../../../model/playlist_model.dart';
import '../../../model/subscription_model.dart';
import 'package:creta_user_model/model/team_model.dart';
import 'package:creta_user_model/model/user_property_model.dart';

//const double _rightViewTopPane = 40;
//const double _rightViewLeftPane = 40;
//const double _rightViewRightPane = 40;
//const double _rightViewBottomPane = 40;
// const double _rightViewItemGapX = 20;
// const double _rightViewItemGapY = 20;
//const double _scrollbarWidth = 13;
//const double _rightViewBannerMaxHeight = 436;
//const double _rightViewBannerMinHeight = 188 + 4;
//const double _rightViewToolbarHeight = 76;
//
// const double _itemMinWidth = 290.0;
// const double _itemMinHeight = 230.0;

bool isInUsingCanvaskit = false;

class CommunityRightChannelMembersPane extends StatefulWidget {
  const CommunityRightChannelMembersPane({
    super.key,
    required this.cretaLayoutRect,
    required this.scrollController,
    required this.filterBookType,
    required this.filterBookSort,
    required this.filterPermissionType,
    required this.filterSearchKeyword,
    required this.onUpdateModel,
    required this.currentChannelModel,
  });
  final CretaLayoutRect cretaLayoutRect;
  final ScrollController scrollController;
  final BookType filterBookType;
  final BookSort filterBookSort;
  final PermissionType filterPermissionType;
  final String filterSearchKeyword;
  final Function({ChannelModel? channelModel, SubscriptionModel? subscriptionModel})? onUpdateModel;
  final ChannelModel? currentChannelModel;

  @override
  State<CommunityRightChannelMembersPane> createState() => _CommunityRightChannelMembersPaneState();
}

class _CommunityRightChannelMembersPaneState extends State<CommunityRightChannelMembersPane> {
  final GlobalKey _key = GlobalKey();

  late ChannelManager channelManagerHolder;
  late UserPropertyManager userPropertyManagerHolder;
  late TeamManager teamManagerHolder;
  //late PlaylistManager playlistManagerHolder;
  //late BookPublishedManager bookPublishedManagerHolder;
  late WatchHistoryManager dummyManagerHolder;
  ChannelModel? _currentChannelModel;
  final Map<String, UserPropertyModel> _userPropertyMap =
      {}; // <UserPropertyModel.email, UserPropertyModel>
  final Map<String, TeamModel> _teamMap = {}; // <TeamManager.mid, TeamModel>
  //final List<PlaylistModel> _playlistModelList = [];
  //final Map<String, BookModel> _playlistsBooksMap = {}; // <Book.mid, Playlists.books>
  final Map<String, UserPropertyModel> _membersPropertyMap =
      {}; // <UserPropertyModel.email, UserPropertyModel>
  final List<String> _membersIdList = [];
  final Map<String, ChannelModel> _membersChannelMap = {};
  //bool _onceDBGetComplete = false;
  bool _hasNoChannelModel = false;
  late Future<bool> _dbGetComplete;

  @override
  void initState() {
    super.initState();

    widget.scrollController.addListener(_scrollListener);

    channelManagerHolder = ChannelManager();
    userPropertyManagerHolder = UserPropertyManager();
    teamManagerHolder = TeamManager();
    //playlistManagerHolder = PlaylistManager();
    //bookPublishedManagerHolder = BookPublishedManager();
    //favoritesManagerHolder = FavoritesManager();
    //subscriptionManagerHolder = SubscriptionManager();
    dummyManagerHolder = WatchHistoryManager();

    if (widget.currentChannelModel == null) {
      CretaManager.startQueries(
        joinList: [
          QuerySet(channelManagerHolder, _getCurrentChannelFromDB, _resultCurrentChannelFromDB),
          QuerySet(userPropertyManagerHolder, _getUserPropertyFromDB, _resultUserPropertyFromDB),
          QuerySet(teamManagerHolder, _getTeamsFromDB, _resultTeamsFromDB),
          QuerySet(dummyManagerHolder, _dummyCompleteDB, null),
        ],
        completeFunc: () {
          //_onceDBGetComplete = true;
        },
      );
    } else {
      _currentChannelModel = widget.currentChannelModel;
      CretaManager.startQueries(
        joinList: [
          QuerySet(
              userPropertyManagerHolder, _getMembersPropertyFromDB, _resultMembersPropertyFromDB),
          QuerySet(channelManagerHolder, _getMembersChannelFromDB, _resultMembersChannelFromDB),
          QuerySet(dummyManagerHolder, _dummyCompleteDB, null),
        ],
        completeFunc: () {
          //_onceDBGetComplete = true;
        },
      );
    }
    _dbGetComplete = _getDBGetComplete();
  }

  Future<bool> _getDBGetComplete() async {
    // while(_onceDBGetComplete == false) {
    //   await Future.delayed(const Duration(milliseconds: 250));
    // }
    await dummyManagerHolder.isGetListFromDBComplete();
    return true;
  }

  @override
  void dispose() {
    super.dispose();
    widget.scrollController.removeListener(_scrollListener);
  }

  void _scrollListener() {
    CommunityRightChannelPane.lastScreenHeight =
        MediaQuery.of(context).size.height + widget.scrollController.position.maxScrollExtent - 60;
    CommunityRightChannelPane.lastScrollPosition = widget.scrollController.offset;
    if (kDebugMode) {
      print('lastScreenHeight=${CommunityRightChannelPane.lastScreenHeight}');
      print('lastScrollPosition=${CommunityRightChannelPane.lastScrollPosition}');
    }
  }

  void _getCurrentChannelFromDB(List<AbsExModel> modelList) {
    channelManagerHolder.addWhereClause('isRemoved', QueryValue(value: false));
    channelManagerHolder.addWhereClause(
        'mid', QueryValue(value: CommunityRightChannelPane.channelId));
    channelManagerHolder.queryByAddedContitions();
  }

  void _resultCurrentChannelFromDB(List<AbsExModel> modelList) {
    if (modelList.isEmpty) return;
    _currentChannelModel = modelList[0] as ChannelModel; // 오직 1개만 있다고 가정
  }

  void _getUserPropertyFromDB(List<AbsExModel> modelList) {
    if ((_currentChannelModel?.userId ?? '').isEmpty) {
      userPropertyManagerHolder.setState(DBState.idle);
      return;
    }
    userPropertyManagerHolder.queryFromIdList([_currentChannelModel!.userId]);
  }

  void _resultUserPropertyFromDB(List<AbsExModel> modelList) {
    for (var model in modelList) {
      UserPropertyModel userModel = model as UserPropertyModel;
      //if (kDebugMode) print('_resultBooksFromDB(bookId=${bModel.getKeyId})');
      _userPropertyMap[userModel.getMid] = userModel;
    }
  }

  void _getTeamsFromDB(List<AbsExModel> modelList) {
    if ((_currentChannelModel?.teamId ?? '').isEmpty) {
      teamManagerHolder.setState(DBState.idle);
      return;
    }
    teamManagerHolder.queryFromIdList([_currentChannelModel!.teamId]);
  }

  void _resultTeamsFromDB(List<AbsExModel> modelList) {
    for (var model in modelList) {
      TeamModel teamModel = model as TeamModel;
      //if (kDebugMode) print('_resultBooksFromDB(${bModel.getKeyId})');
      _teamMap[teamModel.getMid] = teamModel;
    }
  }

  void _getMembersPropertyFromDB(List<AbsExModel> modelList) {
    if (widget.currentChannelModel == null ||
        (widget.currentChannelModel?.teamModel?.teamMembers.length ?? 0) == 0) {
      userPropertyManagerHolder.setState(DBState.idle);
      return;
    }
    userPropertyManagerHolder.queryFromIdList(widget.currentChannelModel!.teamModel!.teamMembers);
  }

  void _resultMembersPropertyFromDB(List<AbsExModel> modelList) {
    for (var model in modelList) {
      UserPropertyModel userModel = model as UserPropertyModel;
      if (kDebugMode) print('_resultMembersPropertyFromDB(bookId=${userModel.nickname})');
      _membersPropertyMap[userModel.getMid] = userModel;
      _membersIdList.add(userModel.getMid);
    }
  }

  void _getMembersChannelFromDB(List<AbsExModel> modelList) {
    if (widget.currentChannelModel == null || _membersIdList.isEmpty) {
      channelManagerHolder.setState(DBState.idle);
      return;
    }
    channelManagerHolder.addWhereClause('isRemoved', QueryValue(value: false));
    channelManagerHolder.addWhereClause(
        'userId', QueryValue(value: _membersIdList, operType: OperType.whereIn));
    channelManagerHolder.queryByAddedContitions();
  }

  void _resultMembersChannelFromDB(List<AbsExModel> modelList) {
    for (var model in modelList) {
      ChannelModel chModel = model as ChannelModel;
      //if (kDebugMode) print('_resultBooksFromDB(bookId=${bModel.getKeyId})');
      _membersChannelMap[chModel.getMid] = chModel;
      chModel.getModelFromMaps(_membersPropertyMap, {});
    }
  }

  void _dummyCompleteDB(List<AbsExModel> modelList) {
    if (widget.currentChannelModel == null) {
      if (_currentChannelModel != null) {
        _currentChannelModel?.getModelFromMaps(_userPropertyMap, _teamMap);
        widget.onUpdateModel?.call(channelModel: _currentChannelModel);
      } else {
        _hasNoChannelModel = true;
      }
      return;
    }
    if (CommunityRightChannelPane.lastScrollPosition > 0) {
      //widget.scrollController.jumpTo(CommunityRightChannelPane.lastScrollPosition);
      //widget.scrollController.initialScrollOffset = CommunityRightChannelPane.lastScrollPosition;
    }
    dummyManagerHolder.setState(DBState.idle);
  }

  Widget _getItemPane() {
    if (_hasNoChannelModel) {
      return Scrollbar(
        key: _key,
        thumbVisibility: true,
        controller: widget.scrollController,
        child: SizedBox(
          child: Center(
            child: Text('No channel Info !!!'),
          ),
        ),
      );
    }
    return Scrollbar(
      key: _key,
      thumbVisibility: true,
      controller: widget.scrollController,
      child: ListView.builder(
        controller: widget.scrollController,
        padding: EdgeInsets.fromLTRB(
          widget.cretaLayoutRect.childLeftPadding,
          widget.cretaLayoutRect.childTopPadding,
          widget.cretaLayoutRect.childRightPadding,
          widget.cretaLayoutRect.childBottomPadding,
        ),
        itemCount: 1,
        itemBuilder: (context, index) {
          return Wrap(
            direction: Axis.horizontal,
            spacing: 20, // 좌우 간격
            runSpacing: 20, // 상하 간격
            children: _membersIdList.map((data) {
              UserPropertyModel? userModel = _membersPropertyMap[data];
              if (userModel == null) return SizedBox.shrink();
              ChannelModel? chModel = _membersChannelMap[userModel.channelId];
              if (chModel == null) return SizedBox.shrink();
              return Container(
                width: 264,
                height: 278,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(width: 1, color: CretaColor.text[200]!),
                ),
                padding: EdgeInsets.fromLTRB(0, 31, 0, 31),
                child: SizedBox(
                  child: Column(
                    children: [
                      userPropertyManagerHolder
                          .imageCircle(userModel.profileImgUrl, userModel.nickname, radius: 84 / 2),
                      SizedBox(height: 20),
                      Text(
                        chModel.name,
                        style: CretaFont.titleELarge.copyWith(color: CretaColor.text[700]),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '${CretaCommuLang['subsriber']} ${chModel.followerCount}명',
                        style: CretaFont.buttonLarge.copyWith(color: CretaColor.text[400]),
                      ),
                      SizedBox(height: 22),
                      BTN.fill_blue_t_m(
                        text: CretaCommuLang['subscribe'],
                        width: 84,
                        height: 34,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // if (_onceDBGetComplete) {
    //   return _getItemPane();
    // }
    var retval = Scrollbar(
      controller: widget.scrollController,
      child: CretaManager.waitDatum(
        initScreenHeight: CommunityRightChannelPane.lastScreenHeight,
        managerList: (widget.currentChannelModel == null)
            ? [
                channelManagerHolder,
                userPropertyManagerHolder,
                teamManagerHolder,
                dummyManagerHolder
              ]
            : [userPropertyManagerHolder, channelManagerHolder, dummyManagerHolder],
        //userId: AccountManager.currentLoginUser.email,
        consumerFunc: _getItemPane,
        dbComplete: _dbGetComplete,
      ),
    );
    //_onceDBGetComplete = true;
    return retval;
  }
}
