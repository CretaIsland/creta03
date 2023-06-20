import 'package:creta03/design_system/buttons/creta_toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
//import '../common/creta_utils.dart';
//import '../design_system/menu/creta_popup_menu.dart';
//import '../lang/creta_lang.dart';
//import '../lang/creta_studio_lang.dart';
//import '../model/app_enums.dart';
//import '../model/book_model.dart';
import '../design_system/text_field/creta_text_field.dart';
import '../model/playlist_model.dart';
import '../model/creta_model.dart';
import 'creta_manager.dart';
import '../../../design_system/dialog/creta_dialog.dart';
import '../../../design_system/creta_color.dart';
import '../../../design_system/creta_font.dart';
import '../../../design_system/component/custom_image.dart';
import '../../../design_system/buttons/creta_button_wrapper.dart';

class PlaylistManager extends CretaManager {
  PlaylistManager() : super('creta_playlist') {
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

  Future<PlaylistModel> createNewPlaylist({
    required String name,
    required String userId,
    required String channelId,
    required bool isPublic,
    required List<String> bookIdList,
  }) async {
    PlaylistModel plModel = PlaylistModel.withName(
      name: name,
      userId: userId,
      channelId: channelId,
      isPublic: isPublic,
      lastUpdateTime: DateTime.now(),
      bookIdList: bookIdList,
    );
    createToDB(plModel);
    await isGetListFromDBComplete().catchError((error, stackTrace) =>
        throw HycopUtils.getHycopException(error: error, defaultMessage: 'createNewPlaylist Failed !!!'));
    return plModel;
  }

  Future<bool> addBookToPlaylist(String playlistMid, String bookId) async {
    // check is_exist
    Map<String, QueryValue> query = {};
    query['isRemoved'] = QueryValue(value: false);
    query['mid'] = QueryValue(value: playlistMid);
    queryFromDB(query);
    List<AbsExModel> list = await isGetListFromDBComplete().catchError((error, stackTrace) =>
        throw HycopUtils.getHycopException(error: error, defaultMessage: 'addBookToPlaylist Failed !!!'));
    if (list.isEmpty) {
      // not exist in DB
      return false;
    }
    // exist in DB => set to DB
    PlaylistModel plModel = list[0] as PlaylistModel; // 무조건 1개만 있다고 가정
    plModel.bookIdList.add(bookId);
    setToDB(plModel);
    await isGetListFromDBComplete().catchError((error, stackTrace) =>
        throw HycopUtils.getHycopException(error: error, defaultMessage: 'addFavoritesToDB Failed !!!'));
    return true;
  }

  static bool _isPublic = true;
  static Widget newPlaylistPopUp({
    required BuildContext context,
    required String bookId,
    required Function(String, bool, String) onNewPlaylistDone,
  }) {
    final TextEditingController textController = TextEditingController();
    _isPublic = true;
    return CretaDialog(
      width: 364.0,
      height: 243.0,
      title: '새 재생목록',
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
                    value: '',
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
                        defaultValue: true,
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
                    onNewPlaylistDone(textController.text, _isPublic, bookId);
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
    required String bookId,
    required List<PlaylistModel> playlistModelList,
    required Function(String) onNewPlaylist,
    required Function(String, String) onSelectDone,
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
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(width: 1, color: CretaColor.text[200]!),
                  ),
                  width: 333,
                  height: 211,
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Wrap(
                    direction: Axis.vertical,
                    children: [
                      const SizedBox(height: 10),
                      ...playlistModelList.expand((element) {
                        return [
                          InkWell(
                            onTap: () {
                              _selectedPlaylistId = element.mid;
                            },
                            child: Container(
                              width: 301,
                              height: 60,
                              margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                              color: (_selectedPlaylistId == element.mid) ? CretaColor.text[200] : null,
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
                                            element.name,
                                            style: CretaFont.titleSmall.copyWith(color: CretaColor.text[700]),
                                          ),
                                          Text(
                                            element.userId,
                                            style: CretaFont.buttonMedium.copyWith(color: CretaColor.text[500]),
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
                                        child: CustomImage(
                                            width: 74, height: 44, image: 'https://picsum.photos/200/?random=1'),
                                      ),
                                    ),
                                  ],
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
                    onNewPlaylist(bookId);
                  },
                ),
                const SizedBox(width: 8),
                BTN.fill_blue_t_m(
                    text: '완료',
                    width: 55,
                    height: 32,
                    onPressed: () {
                      Navigator.of(context).pop();
                      onSelectDone(_selectedPlaylistId, bookId);
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}