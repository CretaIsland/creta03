import 'package:creta03/design_system/buttons/creta_toggle_button.dart';
import 'package:creta03/pages/login/creta_account_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
//import '../common/creta_utils.dart';
//import '../design_system/menu/creta_popup_menu.dart';
//import 'package:creta_common/lang/creta_lang.dart';
//import '../lang/creta_studio_lang.dart';
//import 'package:creta_common/model/app_enums.dart';
//import 'package:creta_studio_model/model/book_model.dart';
import '../design_system/text_field/creta_text_field.dart';
import '../model/playlist_model.dart';
import 'package:creta_common/model/creta_model.dart';
import 'package:creta_studio_model/model/book_model.dart';
import '../model/channel_model.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';
import '../../../design_system/dialog/creta_dialog.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
import '../../../design_system/component/custom_image.dart';
import '../../../design_system/buttons/creta_button_wrapper.dart';

class PlaylistManager extends CretaManager {
  PlaylistManager() : super('creta_playlist', null) {
    saveManagerHolder?.registerManager('playlist', this);
  }

  @override
  AbsExModel newModel(String mid) => PlaylistModel(mid);

  @override
  CretaModel cloneModel(CretaModel src) {
    PlaylistModel retval = newModel(src.mid) as PlaylistModel;
    src.copyTo(retval);
    return retval;
  }

  String prefix() => CretaManager.modelPrefix(ExModelType.book);

  // void queryPlaylistsFromList(List<String> playlistIdList) {
  //   clearAll();
  //   clearConditions();
  //   if (playlistIdList.isEmpty) {
  //     setState(DBState.idle);
  //     return;
  //   }
  //   addWhereClause('mid', QueryValue(value: playlistIdList, operType: OperType.whereIn));
  //   queryByAddedContitions();
  // }

  Future<PlaylistModel> createNewPlaylist({
    required String name,
    required String userId,
    required String channelId,
    required bool isPublic,
    required List<String> bookIdList,
  }) async {
    PlaylistModel plModel = PlaylistModel.withName(
      name: name,
      //userId: userId,
      channelId: channelId,
      isPublic: isPublic,
      //lastUpdateTime: DateTime.now(),
      bookIdList: bookIdList,
    );
    createToDB(plModel);
    await isGetListFromDBComplete().catchError((error, stackTrace) =>
        throw HycopUtils.getHycopException(
            error: error, defaultMessage: 'createNewPlaylist Failed !!!'));
    return plModel;
  }

  Future<bool> addBookToPlaylist(String playlistMid, String bookId) async {
    // check is_exist
    Map<String, QueryValue> query = {};
    query['isRemoved'] = QueryValue(value: false);
    //query['mid'] = QueryValue(value: playlistMid);
    query['channelId'] = QueryValue(value: CretaAccountManager.getUserProperty!.channelId);
    queryFromDB(query);
    List<AbsExModel> list = await isGetListFromDBComplete().catchError((error, stackTrace) =>
        throw HycopUtils.getHycopException(
            error: error, defaultMessage: 'addBookToPlaylist Failed !!!'));
    PlaylistModel? plModel;
    for (var model in list) {
      PlaylistModel pModel = model as PlaylistModel;
      if (pModel.getMid == playlistMid) {
        plModel = pModel;
        break;
      }
    }
    if (plModel == null) {
      // not exist in DB
      return false;
    }
    plModel.bookIdList.add(bookId);
    setToDB(plModel);
    await isGetListFromDBComplete().catchError((error, stackTrace) =>
        throw HycopUtils.getHycopException(
            error: error, defaultMessage: 'addFavoritesToDB Failed !!!'));
    return true;
  }

  static bool _isPublic = true;
  static Widget newPlaylistPopUp({
    required BuildContext context,
    required BookModel bookModel,
    required Map<String, BookModel> bookModelMap,
    required Function(String, bool, BookModel, Map<String, BookModel>) onNewPlaylistDone,
    bool modifyMode = false,
    String modifyPlaylistId = '',
    String modifyName = '',
    bool modifyIsPublic = true,
    Function(String, String, bool)? onModifyPlaylistDone,
  }) {
    final TextEditingController textController = TextEditingController();
    _isPublic = modifyMode ? modifyIsPublic : true;
    return CretaDialog(
      width: 364.0,
      height: 243.0,
      title: modifyMode ? '재생목록 수정' : '새 재생목록',
      crossAxisAlign: CrossAxisAlignment.center,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // body
          SizedBox(
            height: 138,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
                  child: Text(
                    '이름',
                    style: CretaFont.titleSmall.copyWith(color: CretaColor.text[700]),
                  ),
                ),
                const SizedBox(height: 13),
                Container(
                  height: 30,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: CretaTextField(
                    height: 30,
                    textFieldKey: GlobalKey(),
                    value: modifyMode ? modifyName : '',
                    hintText: '',
                    controller: textController,
                    onEditComplete: (String value) {},
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '공개여부',
                        style: CretaFont.titleSmall.copyWith(color: CretaColor.text[700]),
                      ),
                      CretaToggleButton(
                        onSelected: (value) {
                          _isPublic = value;
                        },
                        defaultValue: modifyMode ? modifyIsPublic : true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // split-line
          Container(
            width: 364,
            height: 2.0,
            color: CretaColor.text[100], //Colors.grey.shade200,
          ),
          // bottom buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 12, 12, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Container()),
                BTN.fill_blue_t_m(
                  text: '완료',
                  width: 55,
                  height: 32,
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (modifyMode) {
                      onModifyPlaylistDone?.call(modifyPlaylistId, textController.text, _isPublic);
                    } else {
                      onNewPlaylistDone(textController.text, _isPublic, bookModel, bookModelMap);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _selectedPlaylistId = '';
  static Widget playlistSelectPopUp({
    required BuildContext context,
    required BookModel bookModel,
    required List<AbsExModel> playlistModelList,
    required Map<String, BookModel> bookModelMap,
    required Function(BuildContext, BookModel, Map<String, BookModel>) onNewPlaylist,
    required Function(String, String) onSelectDone,
    Map<String, ChannelModel>? channelMap,
  }) {
    _selectedPlaylistId = '';
    return CretaDialog(
      width: 364.0,
      height: 380.0,
      title: '재생목록에 추가',
      crossAxisAlign: CrossAxisAlignment.center,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // body
          Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 16), // top=20, bottom=16
            height: 275,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
                  child: Text(
                    '추가할 재생목록',
                    style: CretaFont.titleSmall,
                  ),
                ),
                const SizedBox(height: 12),
                PlaylistListControl(
                  size: const Size(333, 211),
                  playlist: playlistModelList,
                  bookModelMap: bookModelMap,
                  channelMap: channelMap,
                  selectCallback: (id) {
                    _selectedPlaylistId = id;
                  },
                ),
              ],
            ),
          ),
          // split-line
          Container(
            width: 364,
            height: 2.0,
            color: CretaColor.text[100], //Colors.grey.shade200,
          ),
          // bottom buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 12, 12, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Container()),
                BTN.line_gray_ti_m(
                  icon: null,
                  text: '새로 만들기',
                  width: 92,
                  onPressed: () {
                    Navigator.of(context).pop();
                    onNewPlaylist(context, bookModel, bookModelMap);
                  },
                ),
                const SizedBox(width: 8),
                BTN.fill_blue_t_m(
                    text: '완료',
                    width: 55,
                    height: 32,
                    onPressed: () {
                      Navigator.of(context).pop();
                      onSelectDone(_selectedPlaylistId, bookModel.getMid);
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _newPlaylistDone(String name, bool isPublic, BookModel bookModel,
      Map<String, BookModel> playlistsBooksMap) async {
    if (kDebugMode) print('_newPlaylistDone($name, $isPublic, ${bookModel.getMid})');
    PlaylistModel newPlaylist = await createNewPlaylist(
      name: name,
      userId: CretaAccountManager.getUserProperty!.getMid, //AccountManager.currentLoginUser.email,
      channelId: CretaAccountManager.getChannel!.getMid, //'test_channel_id',
      isPublic: isPublic,
      bookIdList: [bookModel.getMid],
    );
    //
    // success messagebox
    //
    modelList.add(newPlaylist);
    playlistsBooksMap.putIfAbsent(bookModel.getMid, () => bookModel);
  }

  void _modifyPlaylistDone(String playlistId, String name, bool isPublic) async {
    if (kDebugMode) print('_modifyPlaylistDone($playlistId, $name, $isPublic)');
    for (var model in modelList) {
      PlaylistModel plModel = model as PlaylistModel;
      if (plModel.getMid != playlistId) continue;
      plModel.name = name;
      plModel.isPublic = isPublic;
      setToDB(plModel);
    }
  }

  void modifyPlaylist(BuildContext context, PlaylistModel playlistModel) {
    showDialog(
      context: context,
      builder: (context) => PlaylistManager.newPlaylistPopUp(
        context: context,
        bookModel: BookModel(''),
        bookModelMap: {},
        onNewPlaylistDone: _newPlaylistDone,
        modifyMode: true,
        modifyPlaylistId: playlistModel.getMid,
        modifyName: playlistModel.name,
        modifyIsPublic: playlistModel.isPublic,
        onModifyPlaylistDone: _modifyPlaylistDone,
      ),
    );
  }

  void _newPlaylist(
      BuildContext context, BookModel bookModel, Map<String, BookModel> playlistsBooksMap) {
    showDialog(
      context: context,
      builder: (context) => PlaylistManager.newPlaylistPopUp(
        context: context,
        bookModel: bookModel,
        bookModelMap: playlistsBooksMap,
        onNewPlaylistDone: _newPlaylistDone,
      ),
    );
  }

  void _playlistSelectDone(String playlistMid, String bookId) async {
    if (kDebugMode) print('_playlistSelectDone($playlistMid, $bookId)');
    await addBookToPlaylist(playlistMid, bookId);
    //
    // success messagebox
    //
  }

  void addToPlaylist(
      BuildContext context, BookModel bookModel, Map<String, BookModel> playlistsBooksMap) async {
    showDialog(
      context: context,
      builder: (context) => PlaylistManager.playlistSelectPopUp(
        context: context,
        bookModel: bookModel,
        playlistModelList: modelList,
        bookModelMap: playlistsBooksMap,
        onNewPlaylist: _newPlaylist,
        onSelectDone: _playlistSelectDone,
      ),
    );
  }
}

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
class PlaylistListControl extends StatefulWidget {
  const PlaylistListControl({
    super.key,
    required this.size,
    required this.playlist,
    required this.bookModelMap,
    required this.selectCallback,
    this.channelMap,
  });
  final Size size;
  final List<AbsExModel> playlist;
  final Function(String) selectCallback;
  final Map<String, BookModel> bookModelMap;
  final Map<String, ChannelModel>? channelMap;

  @override
  State<PlaylistListControl> createState() => _PlaylistListControlState();
}

class _PlaylistListControlState extends State<PlaylistListControl> {
  String _selectedPlaylistId = '';
  String _hoverPlaylistId = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: MouseRegion(
        onExit: (value) {
          setState(() {
            _hoverPlaylistId = '';
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(width: 1, color: CretaColor.text[200]!),
          ),
          width: widget.size.width,
          height: widget.size.height,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Scrollbar(
            thumbVisibility: true,
            controller: _scrollController,
            // return ScrollConfiguration( // 스크롤바 감추기
            //   behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false), // 스크롤바 감추기
            child: ListView(
              //direction: Axis.vertical,
              scrollDirection: Axis.vertical,
              controller: _scrollController,
              children: [
                const SizedBox(height: 10),
                ...widget.playlist.expand((element) {
                  PlaylistModel plModel = element as PlaylistModel;
                  String channelName = widget.channelMap?[plModel.channelId]?.name ??
                      CretaAccountManager.getUserProperty!.nickname;
                  String bookThumbnailUrl = '';
                  if (plModel.bookIdList.isNotEmpty) {
                    BookModel? model = widget.bookModelMap[plModel.bookIdList[0]];
                    bookThumbnailUrl = model?.thumbnailUrl.value ?? '';
                  }
                  return [
                    InkWell(
                      hoverColor: Colors.transparent,
                      onHover: (value) {
                        if (value) {
                          setState(() {
                            _hoverPlaylistId = plModel.mid;
                          });
                        }
                      },
                      onTap: () {
                        setState(() {
                          _selectedPlaylistId = plModel.mid;
                          widget.selectCallback.call(_selectedPlaylistId);
                        });
                      },
                      child: Container(
                        color: (_hoverPlaylistId == plModel.mid) ? CretaColor.text[100] : null,
                        child: Container(
                          width: widget.size.width - 32,
                          height: 60,
                          margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color:
                                (_selectedPlaylistId == plModel.mid) ? CretaColor.text[200] : null,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 3.44, 0, 2.3),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        plModel.name,
                                        style: CretaFont.titleSmall
                                            .copyWith(color: CretaColor.text[700]),
                                      ),
                                      Text(
                                        channelName,
                                        style: CretaFont.buttonMedium
                                            .copyWith(color: CretaColor.text[500]),
                                      ),
                                    ],
                                  ),
                                ),
                                //Expanded(child: Container()),
                                SizedBox(
                                  width: 74,
                                  height: 44,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5.4),
                                    child: Stack(
                                      children: [
                                        (bookThumbnailUrl.isEmpty)
                                            ? const SizedBox(width: 74, height: 44)
                                            : CustomImage(
                                                width: 74,
                                                height: 44,
                                                hasAni: false,
                                                image: bookThumbnailUrl,
                                              ),
                                        (_hoverPlaylistId == plModel.mid)
                                            ? Opacity(
                                                opacity: 0.4,
                                                child: Container(
                                                  width: 74,
                                                  height: 44,
                                                  color: CretaColor.text[900],
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                        (_hoverPlaylistId == plModel.mid)
                                            ? SizedBox(
                                                width: 74,
                                                height: 44,
                                                child: Center(
                                                  child: Text(
                                                    '추가하기',
                                                    style: CretaFont.buttonSmall
                                                        .copyWith(color: Colors.white),
                                                  ),
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ];
                }),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
