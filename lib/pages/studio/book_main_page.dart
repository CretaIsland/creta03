// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_brace_in_string_interps, depend_on_referenced_packages, use_build_context_synchronously

//import 'dart:ui';

import 'dart:async';

import 'package:creta03/no_authority.dart';
import 'package:creta_common/common/creta_vars.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_user_io/data_io/user_property_manager.dart';
//import 'package:creta_common/common/creta_vars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hycop/common/undo/save_manager.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/hycop/account/account_manager.dart';
import 'package:hycop/hycop/hycop_factory.dart';
import 'package:hycop/hycop/socket/mouse_tracer.dart';
import 'package:hycop/hycop/socket/socket_client.dart';
import 'package:hycop/hycop/webrtc/webrtc_client.dart';
import 'package:provider/provider.dart';
import 'package:hycop/common/util/logger.dart';
//import 'package:hycop/hycop/absModel/abs_ex_model.dart';
//import 'package:hycop/hycop/account/account_manager.dart';
import 'package:creta03/lang/creta_studio_lang.dart';
import 'package:creta03/model/connected_user_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:creta_common/common/creta_snippet.dart';

import 'package:creta_common/common/creta_const.dart';
import '../../data_io/book_manager.dart';
import '../../data_io/connected_user_manager.dart';
import '../../data_io/contents_manager.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';
import '../../data_io/filter_manager.dart';
import '../../data_io/frame_manager.dart';
import '../../data_io/page_manager.dart';
import '../../data_io/template_manager.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/buttons/creta_label_text_editor.dart';
import '../../design_system/buttons/creta_scale_button.dart';
import '../../design_system/component/autoSizeText/creta_auto_size_text.dart';
import '../../design_system/component/autoSizeText/font_size_changing_notifier.dart';
import '../../design_system/component/creta_popup.dart';
import '../../design_system/component/custom_image.dart';
import '../../design_system/component/snippet.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
import '../../design_system/dialog/creta_alert_dialog.dart';
//import '../../design_system/dialog/creta_dialog.dart';
import '../../design_system/uploading_popup.dart';
import '../../design_system/text_field/creta_text_field.dart';
import 'package:creta_common/lang/creta_lang.dart';
import 'package:creta_studio_model/model/book_model.dart';
import '../../design_system/component/cross_scrollbar.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import 'package:creta_studio_model/model/page_model.dart';
import '../../routes.dart';
import '../login/creta_account_manager.dart';
import 'book_preview_menu.dart';
import 'book_publish.dart';
import 'book_top_menu.dart';
import 'containees/click_event.dart';
import 'containees/containee_nofifier.dart';
import 'containees/page/top_menu_notifier.dart';
import 'left_menu/depot/depot_display.dart';
import 'left_menu/left_menu.dart';
import 'containees/page/page_main.dart';
import 'left_menu/music/music_player_frame.dart';
import 'mouse_hider.dart';
import 'right_menu/book/book_editor_property.dart';
import 'right_menu/right_menu.dart';
import 'stick_menu.dart';
import 'studio_constant.dart';
import 'studio_main_menu.dart';
import 'studio_snippet.dart';
import 'studio_variables.dart';

// ignore: must_be_immutable
class BookMainPage extends StatefulWidget {
  //static bool onceBookInfoOpened = false;
  static BookManager? bookManagerHolder;
  static PageManager? pageManagerHolder;
  static TemplateManager? templateManagerHolder;
  static FilterManager? filterManagerHolder;
  static ConnectedUserManager? connectedUserHolder;
  // static FrameTemplateManager? polygonFrameManagerHolder;
  // static FrameTemplateManager? animationFrameManagerHolder;
  //static UserPropertyManager? userPropertyManagerHolder;
  static ContaineeNotifier? containeeNotifier;
  static MiniMenuNotifier? miniMenuNotifier;
  static TopMenuNotifier? topMenuNotifier;

  //static MiniMenuContentsNotifier? miniMenuContentsNotifier;

  //static LeftMenuEnum selectedStick = LeftMenuEnum.None;
  static LeftMenuNotifier? leftMenuNotifier;
  static ClickReceiverHandler clickReceiverHandler = ClickReceiverHandler();
  static ClickEventHandler clickEventHandler = ClickEventHandler();

  static bool thumbnailChanged = false;

  static Offset pageOffset = Offset.zero;

  static List<PageInfo> allPageInfos = [];

  static void warningNeedToLogin(BuildContext context) {
    CretaPopup.simple(
      context: context,
      title: CretaLang['needToLoginTitle']!,
      icon: Icons.login,
      question: CretaLang['needToLogin']!,
      yesBtText: CretaLang['close']!,
      onYes: () {},
      // noBtText: CretaStudioLang['noBtDnText']!,
      // onNo: () {},
      // onYes: () {
      //   LoginDialog.popupDialog(
      //     context: context,
      //     getBuildContext: () {
      //       return context;
      //     },
      //   );
      // },
    );
  }

  static void warningNeedToWaitUploding(BuildContext context) {
    CretaPopup.simple(
      context: context,
      title: CretaStudioLang['needToWaitUplodingTitle'] ?? 'Still uploading.',
      icon: Icons.login,
      question: CretaStudioLang['needToWaitUploding'] ??
          'The content has not been uploaded yet. You can publish it after the upload is finished. Please try again later.',
      yesBtText: CretaLang['close']!,
      onYes: () {},
      // noBtText: CretaStudioLang['noBtDnText']!,
      // onNo: () {},
      // onYes: () {
      //   LoginDialog.popupDialog(
      //     context: context,
      //     getBuildContext: () {
      //       return context;
      //     },
      //   );
      // },
    );
  }

  //static ContaineeEnum selectedClass = ContaineeEnum.Book;
  final bool isPreviewX;
  final bool isThumbnailX;
  final GlobalKey bookKey;
  final Size? size;
  final bool? isPublishedMode;
  final Function? toggleFullscreen;

  final Function? onGotoPrevBook;
  final Function? onGotoNextBook;

  static bool outSideClick = false;
  static GlobalKey leftMenuKey = GlobalObjectKey('LeftMenu');
  static GlobalKey rightMenuKey = GlobalObjectKey('RightMenu');

  // Music widget
  static Map<String, GlobalObjectKey<MusicPlayerFrameState>> musicKeyMap = {};
  static FrameModel? backGroundMusic;

  // overlay 관련 모음
  static final Map<String, FrameModel> _overlayFrameMap = {};
  static void clearOverlay() => _overlayFrameMap.clear();
  static FrameModel? findOverlay(String id) => _overlayFrameMap[id];
  static void removeOverlay(String id) => _overlayFrameMap.remove(id);
  static List<FrameModel> overlayList() => _overlayFrameMap.values.toList();
  static int overlayLength() => _overlayFrameMap.length;
  static void addOverlay(FrameModel model) {
    _overlayFrameMap[model.mid] = model;
  }

  static double getMaxOrderInBook() {
    // 자기 페이지에서 최후값이 아닌, 전체 북에서 최후의 값을 가져와야 한다.
    Map<String, FrameManager?> frameManagerMap = BookMainPage.pageManagerHolder!.frameManagerMap;
    double maxOrder = 0;
    for (FrameManager? manager in frameManagerMap.values) {
      double order = manager!.getMaxOrderWithOverlay();
      if (order > maxOrder) {
        maxOrder = order;
      }
    }
    return maxOrder;
  }

  BookMainPage({
    required this.bookKey,
    this.isPreviewX = false,
    this.isThumbnailX = false,
    this.size,
    this.isPublishedMode,
    this.toggleFullscreen,
    this.onGotoPrevBook,
    this.onGotoNextBook,
  }) : super(key: bookKey) {
    StudioVariables.isPreview = isPreviewX;
  }

  @override
  State<BookMainPage> createState() => _BookMainPageState();
}

class _BookMainPageState extends State<BookMainPage> {
  BookModel? _bookModel;
  bool _hasRWPermition = false;
  bool _hasROPermition = true;
  bool _onceDBGetComplete = false;
  final GlobalKey<CretaLabelTextEditorState> textFieldKey = GlobalKey<CretaLabelTextEditorState>();

  // final ScrollController controller = ScrollController();
  //ScrollController? horizontalScroll;
  //ScrollController? verticalScroll;

  // double pageWidth = 0;
  // double pageHeight = 0;
  double heightWidthRatio = 0;
  double widthRatio = 0;
  double heightRatio = 0;
  //double applyScale = 1;
  bool scaleChanged = false;

  double padding = 16;

  bool dropDownButtonOpened = false;

  // for socket
  SocketClient client = SocketClient();
  List<Color> userColorList = [Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.purple];
  late double screenWidthPercentage;
  late double screenHeightPrecentage;
  late double screenWidth;

  //List<LogicalKeyboardKey> keys = [];

  bool _fromPriviewToMain = false; // 돌아가기 버튼을 누르면 True  가 됨.

  Size? _previousSize; // 현재 사이즈 보관

  bool isMenuOpen = false;
  //Timer? _connectedUserTimer;

  //OffsetEventController? _linkSendEvent;
  //FrameEachEventController? _autoPlaySendEvent;
  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    _staticValuseDispose(); //static value 를 정리해준다.
    logger.info("---initState _BookMainPageState-------------------");
    //_hideMouseTimer();
    super.initState();

    // final OffsetEventController linkSendEvent = Get.find(tag: 'on-link-to-link-widget');
    // _linkSendEvent = linkSendEvent;
    // final FrameEachEventController autoPlaySendEvent = Get.find(tag: 'to-FrameEach');
    // _autoPlaySendEvent = autoPlaySendEvent;
    BookMainPage.clearOverlay();
    BookMainPage.musicKeyMap.clear();
    BookMainPage.backGroundMusic = null;

    //CretaAccountManager.initUserProperty();

    BookPreviewMenu.previewMenuPressed = false;

    BookMainPage.containeeNotifier = ContaineeNotifier();
    BookMainPage.miniMenuNotifier = MiniMenuNotifier();
    BookMainPage.topMenuNotifier = TopMenuNotifier();
    BookMainPage.leftMenuNotifier = LeftMenuNotifier();
    CretaAutoSizeText.fontSizeNotifier = FontSizeChangingNotifier();
    //BookMainPage.miniMenuContentsNotifier = MiniMenuContentsNotifier();

    // 같은 페이지에서 객체만 바뀌면 static value 들은 그대로 남아있게 되므로
    // static value 도 초기화해준다.
    //StudioVariables.selectedBookMid = '';
    //BookMainPage.onceBookInfoOpened = false;

    BookMainPage.containeeNotifier!.set(ContaineeEnum.Book, doNoti: false);

    BookMainPage.bookManagerHolder = (widget.isPublishedMode ?? false)
        ? BookManager(tableName: 'creta_book_published')
        : BookManager();
    //BookMainPage.bookManagerHolder!.configEvent(notifyModify: false);
    BookMainPage.bookManagerHolder!.clearAll();
    BookMainPage.pageManagerHolder = (widget.isPublishedMode ?? false)
        ? PageManager(
            tableName: 'creta_page_published',
            isPublishedMode: widget.isPublishedMode ?? false,
            onGotoPrevBook: widget.onGotoPrevBook,
            onGotoNextBook: widget.onGotoNextBook,
          )
        : PageManager();

    BookMainPage.templateManagerHolder = TemplateManager();

    // BookMainPage.polygonFrameManagerHolder = FrameTemplateManager(frameType: FrameType.polygon);
    // BookMainPage.animationFrameManagerHolder = FrameTemplateManager(frameType: FrameType.animation);
    //BookMainPage.userPropertyManagerHolder = UserPropertyManager();

    String userEmail = CretaAccountManager.currentLoginUser.email;
    BookMainPage.filterManagerHolder = FilterManager(userEmail);
    BookMainPage.filterManagerHolder!.getFilter();
    BookMainPage.connectedUserHolder = ConnectedUserManager();

    String url = Uri.base.origin;
    String query = Uri.base.query;

    logger.info("url=$url-------------------------------");
    logger.info("query=$query-------------------------------");

    // int pos = query.indexOf('&');
    // String mid = pos > 0 ? query.substring(0, pos) : query;
    // logger.info("mid=$mid-------------------------------");
    //
    // if (mid.isEmpty) {
    //   mid = StudioVariables.selectedBookMid;
    // }
    String mid = StudioVariables.selectedBookMid;

    if (mid.isNotEmpty) {
      logger.fine("1) --_BookMainPageState-----------------------------------------");
      BookMainPage.bookManagerHolder!.getFromDB(mid).then((value) async {
        if (value != null) {
          BookMainPage.bookManagerHolder!.addRealTimeListen(mid);
          if (BookMainPage.bookManagerHolder!.getLength() > 0) {
            initChildren(BookMainPage.bookManagerHolder!.onlyOne() as BookModel);
          }
        }
        return value;
      });
    } else {
      //logger.severe("2) mid is empty ");
      BookModel sampleBook = BookMainPage.bookManagerHolder!.createSample();
      mid = sampleBook.mid;
      BookMainPage.bookManagerHolder!.saveSample(sampleBook).then((value) async {
        BookMainPage.bookManagerHolder!.insert(sampleBook);
        BookMainPage.bookManagerHolder!.addRealTimeListen(mid);
        if (BookMainPage.bookManagerHolder!.getLength() > 0) {
          initChildren(sampleBook);
        }
        return value;
      });
    }
    BookMainPage.leftMenuNotifier!.set(LeftMenuEnum.Page, doNotify: false); // 페이지가 열린 상태로 시작하게 한다.
    saveManagerHolder?.runSaveTimer();

    BookMainPage.clickReceiverHandler.init();
    mychangeStack.clear();

    mouseTracerHolder = MouseTracer();

    if (_useSocket()) {
      client.initialize(CretaAccountManager.getEnterprise!.socketUrl);
      client.connectServer(StudioVariables.selectedBookMid);
    }

    mouseTracerHolder!.addListener(() {
      switch (mouseTracerHolder!.flag) {
        case 'connectUser':
          for (var target in mouseTracerHolder!.targetUsers) {
            BookMainPage.connectedUserHolder!.connectNoti(
                StudioVariables.selectedBookMid, target["userName"]!, target["userId"]!);
          }
          mouseTracerHolder!.flag = '';
          mouseTracerHolder!.targetUsers.clear();
          break;
        case 'disconnectUser':
          for (var target in mouseTracerHolder!.targetUsers) {
            BookMainPage.connectedUserHolder!.disconnectNoti(
                StudioVariables.selectedBookMid, target["userName"]!, target["userId"]!);
          }
          mouseTracerHolder!.flag = '';
          mouseTracerHolder!.targetUsers.clear();
          break;
        default:
          break;
      }
    });

    DepotDisplay.initDepotTeamManagers();

    CretaTextField.mainFocusNode = FocusNode(
      onKeyEvent: (node, event) {
        // TextField 의 focusNode 가 onKeyEvent 를 정의하고 있지 않은 경우에만 여기로 도착한다.
        // 만약 정의하고 있으면 그 정의로 도착하고 여기로 도착하지 않게 된다.
        logger.info('${node.hasFocus}:focusNodeEventHandler  ${event.logicalKey.debugName}');
        if (node.hasFocus) {
          _focusNodeEventHandler(node, event);
        }
        return KeyEventResult.ignored;
      },
    );

    if (StudioVariables.isPreview == false) {
      StudioVariables.stopNextContents = false;
      StudioVariables.stopPaging = false;
      StudioVariables.hideMouse = false;
    }

    logger.info("end ---_BookMainPageState-----------------------------------------");
// //for webRTC
//     mediaDeviceDataHolder = MediaDeviceData();
//     peersDataHolder = PeersData();
//     producerDataHolder = ProducerData();
//     mediaDeviceDataHolder!.loadMediaDevice().then((value) {
//       webRTCClient = WebRTCClient(
//           roomId: StudioVariables.selectedBookMid,
//           peerId: AccountManager.currentLoginUser.email,
//           //serverUrl: "wss://devcreta.com:447",
//           serverUrl: LoginPage.enterpriseHolder!.enterpriseModel!.webrtcUrl,
//           peerName: LoginPage.userPropertyManagerHolder!.userPropertyModel!.nickname);
//       webRTCClient!.connectSocket();
//     });
    isLangInit = initLang();
    afterBuild();
  }

  Future<void> afterBuild() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      logger.info("BookMainPage ---afterBuild-----------------------------------------");
      while (_onceDBGetComplete == false) {
        await Future.delayed(Duration(seconds: 1));
      }
      //_startConnectedUserTimer();

      if (StudioVariables.isPreview) {
        //_takeAScreenShot();
        if (StudioVariables.isAutoPlay) {}
      } else {}
      _fromPriviewToMain = false;
    });
  }

  Future<void> initChildren(BookModel model) async {
    if (AccountManager.currentLoginUser.isLoginedUser) {
      // print('owners=${model.owners.toString()}');
      // print('writers=${model.owners.toString()}');
      // print('readers=${model.owners.toString()}');
      // print('creator=${model.creator.toString()}');
      // print('login=${AccountManager.currentLoginUser.email}');

      bool isCreator = model.creator == AccountManager.currentLoginUser.email;
      bool isOwner = model.owners.contains(AccountManager.currentLoginUser.email);
      bool hasWriter = model.writers.contains(AccountManager.currentLoginUser.email);

      // print('isCreator = $isCreator');
      // print('isOwner = $isOwner');
      // print('hasWriter = $hasWriter');

      _hasROPermition = model.readers.contains(AccountManager.currentLoginUser.email);
      _hasRWPermition = isOwner || hasWriter || isCreator;

      // print('_hasROPermition = $_hasROPermition');
      // print('_hasRWPermition = $_hasRWPermition');

      if (_hasRWPermition == false && _hasROPermition == true) {
        // 읽기 권한만 있는 경우
        StudioVariables.isPreview = true;
      }
    } else {
      logger.info('Its not loggined user');
    }

    saveManagerHolder!.setDefaultBook(model);
    saveManagerHolder!.addBookChildren('book=');
    saveManagerHolder!.addBookChildren('page=');
    saveManagerHolder!.addBookChildren('frame=');
    saveManagerHolder!.addBookChildren('contents=');
    saveManagerHolder!.addBookChildren('link=');

    BookMainPage.filterManagerHolder?.setBook(model);
    BookMainPage.connectedUserHolder?.setBook(model.mid);

    logger.fine("3) --_BookMainPageState-----------------------------------------");

    // Get Pages
    await BookMainPage.pageManagerHolder!.initPage(model);
    logger.fine("4) --_BookMainPageState-----------------------------------------");
    await BookMainPage.pageManagerHolder!.findOrInitAllFrameManager(model);
    logger.fine("5) --_BookMainPageState-----------------------------------------");

    // Get Template Frames
    // BookMainPage.polygonFrameManagerHolder!.clearAll();
    // await _getPolygonFrameTemplates();
    // BookMainPage.animationFrameManagerHolder!.clearAll();
    // await _getAnimationFrameTemplates();

    // Get User property
    //await BookMainPage.userPropertyManagerHolder!.initUserProperty();

    //_onceDBGetComplete = true;

    if (widget.isPublishedMode ?? false) {
      StudioVariables.isMute = false;
      StudioVariables.isAutoPlay = true;
    } else {
      StudioVariables.isMute = CretaAccountManager.getMute();
      if ((widget.isPublishedMode ?? false) == false) {
        StudioVariables.isAutoPlay = CretaAccountManager.getAutoPlay();
      }
    }

    if (AccountManager.currentLoginUser.isLoginedUser) {
      HycopFactory.realtime!.startTemp(model.mid);
      HycopFactory.realtime!.setPrefix('creta');
    }

    if (model.backgroundMusicFrame.value.isNotEmpty) {
      BookMainPage.backGroundMusic = await CretaManager.getModelFromDB(
        model.backgroundMusicFrame.value,
        (widget.isPublishedMode ?? false) ? "creta_frame_published" : "creta_frame",
        FrameModel('', model.mid),
      ) as FrameModel?;
    }

    _onceDBGetComplete = true;
  }

  //   Future<int> _getPolygonFrameTemplates() async {
  //   int frameCount = 0;
  //   BookMainPage.polygonFrameManagerHolder!.startTransaction();
  //   try {
  //     frameCount = await BookMainPage.polygonFrameManagerHolder!.getFrames();
  //     if (frameCount < StudioConst.maxMyFavFrame) {
  //       for (int i = 0; i < StudioConst.maxMyFavFrame - frameCount; i++) {
  //         await BookMainPage.polygonFrameManagerHolder!.createNextFrame();
  //       }
  //       frameCount = StudioConst.maxMyFavFrame;
  //     }
  //   } catch (e) {
  //     logger.finest('something wrong $e');
  //     await BookMainPage.polygonFrameManagerHolder!.createNextFrame();
  //     await BookMainPage.polygonFrameManagerHolder!.createNextFrame();
  //     await BookMainPage.polygonFrameManagerHolder!.createNextFrame();
  //     await BookMainPage.polygonFrameManagerHolder!.createNextFrame();
  //     frameCount = 1;
  //   }
  //   BookMainPage.polygonFrameManagerHolder!.endTransaction();
  //   return frameCount;
  // }

  // Future<int> _getAnimationFrameTemplates() async {
  //   int frameCount = 0;
  //   BookMainPage.animationFrameManagerHolder!.startTransaction();
  //   try {
  //     frameCount = await BookMainPage.animationFrameManagerHolder!.getFrames();
  //     if (frameCount < StudioConst.maxMyFavFrame) {
  //       for (int i = 0; i < StudioConst.maxMyFavFrame - frameCount; i++) {
  //         await BookMainPage.animationFrameManagerHolder!.createNextFrame();
  //       }
  //       frameCount = 1;
  //     }
  //   } catch (e) {
  //     logger.finest('something wrong $e');
  //     await BookMainPage.animationFrameManagerHolder!.createNextFrame();
  //     await BookMainPage.animationFrameManagerHolder!.createNextFrame();
  //     await BookMainPage.animationFrameManagerHolder!.createNextFrame();
  //     await BookMainPage.animationFrameManagerHolder!.createNextFrame();
  //     frameCount = 1;
  //   }
  //   BookMainPage.animationFrameManagerHolder!.endTransaction();
  //   return frameCount;
  // }

  // // isPreview 모드에서 마우스 커서 안보임 관련 변수들
  // int _mouseMoveCount = 0;
  // DateTime? _lastMouseMoveTime;
  // Timer? _mouseMovetimer;
  // OffsetEventController? _sendMouseEvent;
  // void _hideMouseTimer() {
  //   // isPreViewMode = true 인 경우만
  //   // 이전 타이머를 취소하고 새 타이머를 시작

  //   if (StudioVariables.isPreview == true) {
  //     final OffsetEventController sendMouseEvent = Get.find(tag: 'on-link-to-link-widget');
  //     _sendMouseEvent = sendMouseEvent;

  //     //print('hide mouse 1');
  //     //StudioVariables.hideMouse = true;
  //     //SystemChannels.mouseCursor.invokeMethod('mouseCursor', 'none');
  //     //_mouseMovetimer?.cancel();
  //     _mouseMovetimer = Timer.periodic(Duration(seconds: 1), (t) {
  //       // 3초 동안 마우스 움직임이 없으면 커서를 숨김
  //       if (StudioVariables.isPreview == true) {
  //         if (_lastMouseMoveTime != null) {
  //           if (StudioVariables.hideMouse == false &&
  //               DateTime.now().difference(_lastMouseMoveTime!).inSeconds >= 3) {
  //             logger.info('3 second passed');
  //             if (_fromPriviewToMain == false) {
  //               // 페이지가 넘어가는 중에, setState 가 동작하면 안된다.
  //               setState(() {
  //                 StudioVariables.hideMouse = true;
  //                 _sendMouseEvent?.sendEvent(Offset.zero);
  //               });
  //             }
  //             _mouseMoveCount = 0;
  //           }
  //         } else {
  //           // setState(() {
  //           //   print('hide mouse 2');
  //           //   StudioVariables.hideMouse = true;
  //           // });
  //         }
  //       }
  //     });
  //   } else {
  //     StudioVariables.hideMouse = false;
  //   }
  // }

  bool _useSocket() {
    // 임시로 소켓을 사용하지 않음.
    return false;
    // return ((widget.isPublishedMode ?? false) == false &&
    //     StudioVariables.isPreview == false &&
    //     AccountManager.currentLoginUser.isLoginedUser);
  }

  @override
  void dispose() {
    logger.severe('BookMainPage.dispose');

    if (BookMainPage.backGroundMusic != null) {
      FrameManager.stopBackgroundMusic(BookMainPage.backGroundMusic!);
    }

    // 아직 save  되지 않은 Queue 를 모두 save 한다.
    saveManagerHolder?.stopTimer();
    saveManagerHolder?.saveForce(notify: false);

    //_mouseMovetimer?.cancel();
    //_stopConnectedUserTimer();
    if (_fromPriviewToMain == false) {
      _staticValuseDispose();
    }

    if (_useSocket()) {
      client.disconnect(notify: false);
    }
    if (webRTCClient != null) {
      webRTCClient!.close();
    }
    super.dispose();

    //CretaTextField.mainFocusNode?.dispose();
    logger.info('BookMainPage.dispose end');
  }

  void _staticValuseDispose() {
    if (AccountManager.currentLoginUser.isLoginedUser) {
      BookMainPage.bookManagerHolder?.removeRealTimeListen();
      BookMainPage.pageManagerHolder?.removeRealTimeListen();
      BookMainPage.connectedUserHolder?.removeRealTimeListen();
    }
    BookMainPage.pageManagerHolder?.clearFrameManager();

    BookMainPage.allPageInfos.clear();

    saveManagerHolder?.stopTimer();
    saveManagerHolder?.unregisterManager('book');
    saveManagerHolder?.unregisterManager('page');
    saveManagerHolder?.unregisterManager('user');
    // controller.dispose();
    //verticalScroll?.dispose();
    //horizontalScroll?.dispose();

    logger.info("---_staticValuseDispose end-------------------");
    if (AccountManager.currentLoginUser.isLoginedUser) {
      HycopFactory.realtime!.stop();
    }
  }

  static Future<bool>? isLangInit;

  Future<bool>? initLang() async {
    await Snippet.setLang();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    screenWidthPercentage = MediaQuery.of(context).size.width * 0.01;
    screenHeightPrecentage = MediaQuery.of(context).size.height * 0.01;
    screenWidth = MediaQuery.of(context).size.width;
    DateTime lastEventTime = DateTime.now();

    //print('hideMouse = ${StudioVariables.hideMouse}');

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ContaineeNotifier>.value(
          value: BookMainPage.containeeNotifier!,
        ),
        ChangeNotifierProvider<MiniMenuNotifier>.value(
          value: BookMainPage.miniMenuNotifier!,
        ),
        ChangeNotifierProvider<TopMenuNotifier>.value(
          value: BookMainPage.topMenuNotifier!,
        ),
        ChangeNotifierProvider<LeftMenuNotifier>.value(
          value: BookMainPage.leftMenuNotifier!,
        ),
        ChangeNotifierProvider<FontSizeChangingNotifier>.value(
          value: CretaAutoSizeText.fontSizeNotifier!,
        ),

        // ChangeNotifierProvider<MiniMenuContentsNotifier>.value(
        //   value: BookMainPage.miniMenuContentsNotifier!,
        // ),
        ChangeNotifierProvider<BookManager>.value(
          value: BookMainPage.bookManagerHolder!,
        ),
        ChangeNotifierProvider<ConnectedUserManager>.value(
          value: BookMainPage.connectedUserHolder!,
        ),
        ChangeNotifierProvider<MouseTracer>.value(value: mouseTracerHolder!),
        ChangeNotifierProvider<UserPropertyManager>.value(
            value: CretaAccountManager.userPropertyManagerHolder),
      ],
      child: //RawKeyboardListener(
          //  키보드 이벤트 도착 순서 :   _keyEventHandler,  onKeyEvent,and onKey
          //autofocus: true,
          //focusNode: CretaTextField.mainFocusNode!, // _focusNodeEventHandler 가 호출됨.
          //onKey: _keyEventHandler,
          //child:
          FutureBuilder<bool>(
              future: isLangInit,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  //error가 발생하게 될 경우 반환하게 되는 부분
                  logger.severe("data fetch error(WaitDatum)");
                  return const Center(child: Text('data fetch error(WaitDatum)'));
                }
                if (snapshot.hasData == false) {
                  //print('xxxxxxxxxxxxxxxxxxxxx');
                  logger.finest("wait data ...(WaitData)");
                  return Center(
                    child: CretaSnippet.showWaitSign(),
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  logger.finest("founded ${snapshot.data!}");
                  // if (snapshot.data!.isEm
                  return Consumer<UserPropertyManager>(
                      builder: (context, userPropertyManager, childWidget) {
                    return _bookMain(lastEventTime);
                  });
                }
                return const SizedBox.shrink();
              }),
      //),
    );
  }

  Widget _bookMain(DateTime lastEventTime) {
    return StudioVariables.isPreview
        ? Scaffold(
            body: MouseHider(
              fromPriviewToMain: _fromPriviewToMain,
              child: _waitBook(),
              onMouseHideChanged: () {
                BookMainPage.pageManagerHolder?.notify();
              },
            ),
          )
        : Snippet.CretaScaffold(
            isStudioEditor: true,
            noVerticalVar: true,
            // title: Snippet.logo(CretaVars.instance.serviceTypeString(), route: () {
            //   Routemaster.of(context).push(AppRoutes.studioBookGridPage);
            // }),
            onFoldButtonPressed: () {
              setState(() {});
            },

            invalidate: () {
              setState(() {});
            },
            context: context,
            child: Stack(
              children: [
                MouseRegion(
                  onHover: (pointerEvent) {
                    //if (StudioVariables.allowMutilUser == true) {
                    if (mouseTracerHolder!.mouseCursorList.isEmpty) return;
                    if (_useSocket()) {
                      if (lastEventTime.add(Duration(milliseconds: 100)).isBefore(DateTime.now())) {
                        client.changeCursorPosition(
                            pointerEvent.position.dx / screenWidthPercentage,
                            (pointerEvent.position.dy - 50) / screenHeightPrecentage);

                        lastEventTime = DateTime.now();
                      }
                    }
                    //}
                  },
                  child: _waitBook(),
                ),
                //if (StudioVariables.allowMutilUser == true) mouseArea(),
                mouseArea(), // 프레임이나 텍스트를 원하는 위치에 그릴 수 있도록 추적하는 기능
              ],
            ),
          );
  }

  void _focusNodeEventHandler(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.delete:
          _deleteSelectedModel();
          return;
        case LogicalKeyboardKey.arrowRight:
          _nextContents(false);
          return;
        case LogicalKeyboardKey.arrowLeft:
          _nextContents(true);
          return;
        case LogicalKeyboardKey.pageDown:
          BookPreviewMenu.previewMenuPressed = StudioVariables.isPreview;
          BookMainPage.pageManagerHolder?.gotoNext();
          return;
        case LogicalKeyboardKey.pageUp:
          BookPreviewMenu.previewMenuPressed = StudioVariables.isPreview;
          BookMainPage.pageManagerHolder?.gotoPrev();
          return;
        case LogicalKeyboardKey.insert:
          if (StudioVariables.isPreview == false) {
            StudioVariables.globalToggleAutoPlay(save: true);
            BookTopMenu.invalidate();
          } else {
            StudioVariables.stopNextContents = !StudioVariables.stopNextContents;
            BookTopMenu.invalidate();
          }
          return;
        default:
          return;
      }
    }

    if (StudioVariables.isCtrlPressed) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.keyM:
          //print("ctrl+M pressed = mute"); // muteButton
          StudioVariables.globalToggleMute(save: true);
          BookTopMenu.invalidate();
          return;
        case LogicalKeyboardKey.keyZ:
          // undo
          setState(() {
            mychangeStack.undo();
          });
          return;
        case LogicalKeyboardKey.keyY:
          // redo
          setState(() {
            mychangeStack.redo();
          });
          return;
        case LogicalKeyboardKey.keyC:
          // copy
          logger.info('Ctrl+C pressed');
          _copy();
          return;
        case LogicalKeyboardKey.keyX:
          logger.info('Ctrl+X pressed');
          // Crop
          _crop();
          return;
        case LogicalKeyboardKey.keyV:
          logger.info('Ctrl+V pressed');
          _paste();
          return;
      }
    }
  }

  void _keyEventHandler(KeyEvent event) {
    // 그리고 포커스 이벤트는 기본적으로  여기에 가장 먼저 도착한다.
    // 이후 focusNode 의 onKeyEvent, onKey 순서로 도착한다.
    // 이 말인 즉슨, 포커스를 가지고 있던, 없던, 모든 키보드 이벤트가 다 도착한다는 뜻이다.
    // 그래서 Text Box 에서 먹고 끝나야 하는 Key 까지도 도착하는 것을 막을 수 없다.
    // 여기에 먼저 도착하기 때문이다.
    // 그런데 focus 정보가 넘어오지 않기 때문에, 따라서, 여기서는 mainFocusNode.hasFocus 를 사용한다.
    if (CretaTextField.mainFocusNode == null || CretaTextField.mainFocusNode!.hasFocus == false) {
      return;
    }

    // if (event is RawKeyUpEvent) {
    //   if (_singleButtonEvent(event.logicalKey) == true) {
    //     return;
    //   }
    // }

    //logger.severe('RawKeyboardListener  ${event.logicalKey.debugName}');
    _combiButtonEvent(event);
  }

  void _combiButtonEvent(KeyEvent event) {
    final key = event.logicalKey;
    bool? isPressed;
    if (event is KeyDownEvent) {
      logger.info('combination Key Pressed  ${key.debugName}');
      isPressed = true;
    } else if (event is KeyUpEvent) {
      logger.info('combination Key Released  ${key.debugName}');
      isPressed = false;
    }
    if (isPressed != null) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.shiftLeft:
        case LogicalKeyboardKey.shiftRight:
          StudioVariables.isShiftPressed = isPressed;
          break;
        case LogicalKeyboardKey.controlLeft:
        case LogicalKeyboardKey.controlRight:
          StudioVariables.isCtrlPressed = isPressed;
          break;
      }
    }

    // if (event is RawKeyDownEvent) {
    //   if (keys.contains(key)) return;
    //   keys.add(key);
    //   // Ctrl Key Area
    //   if ((keys.contains(LogicalKeyboardKey.controlLeft) ||
    //       keys.contains(LogicalKeyboardKey.controlRight))) {
    //     if (keys.contains(LogicalKeyboardKey.keyM)) {
    //       //print("ctrl+M pressed = mute"); // muteButton
    //       StudioVariables.globalToggleMute(save: true);
    //       BookTopMenu.invalidate();
    //     } else if (keys.contains(LogicalKeyboardKey.keyZ)) {
    //       setState(() {
    //         mychangeStack.undo();
    //       });
    //       // undo
    //     } else if (keys.contains(LogicalKeyboardKey.keyY)) {
    //       setState(() {
    //         mychangeStack.redo();
    //       });
    //     } else if (keys.contains(LogicalKeyboardKey.keyC)) {
    //       // copy
    //       logger.info('Ctrl+C pressed');
    //       _copy();
    //     } else if (keys.contains(LogicalKeyboardKey.keyX)) {
    //       logger.info('Ctrl+X pressed');
    //       // Crop
    //       _crop();
    //     } else if (keys.contains(LogicalKeyboardKey.keyV)) {
    //       logger.info('Ctrl+V pressed');
    //       _paste();
    //     }
    //   }
    // } else {
    //   keys.remove(key);
    // }
  }
  // // ignore: unused_element
  // bool _singleButtonEvent(LogicalKeyboardKey logicalKey) {
  //   bool retval = __singleButtonEvent(logicalKey);
  //   if (retval == true) {
  //     logger.info('main _singleButtonEvent ${logicalKey.debugName} pressed');
  //   }
  //   return retval;
  // }

  // // unused
  // bool __singleButtonEvent(LogicalKeyboardKey logicalKey) {
  //   switch (logicalKey) {
  //     case LogicalKeyboardKey.delete:
  //       _deleteSelectedModel();
  //       return true;
  //     case LogicalKeyboardKey.arrowRight:
  //       return true;
  //     case LogicalKeyboardKey.arrowLeft:
  //       return true;
  //     case LogicalKeyboardKey.pageDown:
  //       BookPreviewMenu.previewMenuPressed = StudioVariables.isPreview;
  //       BookMainPage.pageManagerHolder?.gotoNext();
  //       return true;
  //     case LogicalKeyboardKey.pageUp:
  //       BookPreviewMenu.previewMenuPressed = StudioVariables.isPreview;
  //       BookMainPage.pageManagerHolder?.gotoPrev();
  //       return true;
  //     case LogicalKeyboardKey.insert:
  //       StudioVariables.globalToggleAutoPlay(save: true);
  //       BookTopMenu.invalidate();
  //       return true;
  //     default:
  //       return false;
  //   }
  // }

  Widget mouseArea() {
    return IgnorePointer(
      child: Consumer<MouseTracer>(builder: (context, mouseTracerManager, child) {
        return Stack(
          children: [
            for (int i = 0; i < mouseTracerHolder!.mouseCursorList.length; i++)
              cursorWidget(i, mouseTracerHolder!)
          ],
        );
      }),
    );
  }

  Widget cursorWidget(int index, MouseTracer mouseTracer) {
    Color mouseColor = mouseTracer.mouseCursorList[index].cursorColor;
    return Positioned(
        left: mouseTracer.mouseCursorList[index].x * screenWidthPercentage,
        top: mouseTracer.mouseCursorList[index].y * screenHeightPrecentage,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(
            Icons.pan_tool_alt,
            size: 30,
            color: mouseColor,
          ),
          Container(
            width: mouseTracer.mouseCursorList[index].userName.length * 10,
            height: 20,
            decoration: BoxDecoration(color: mouseColor, borderRadius: BorderRadius.circular(20)),
            child: Text(mouseTracer.mouseCursorList[index].userName,
                style: const TextStyle(color: Colors.white), textAlign: TextAlign.center),
          )
        ]));
  }

  // Widget _waitBook() {
  //   while (_onceDBGetComplete == false) {
  //     logger.finest('wait until _onceDBGetComplete');
  //     Future.delayed(
  //       Duration(microseconds: 500),
  //     );
  //   }
  //   return consumerFunc();
  // }

  Widget _waitBook() {
    if (_onceDBGetComplete) {
      logger.finest('already _onceDBGetComplete');
      return consumerFunc();
    }
    // var retval = CretaManager.waitDatum(
    //   managerList: [
    //     BookMainPage.bookManagerHolder!,
    //     BookMainPage.pageManagerHolder!,
    //   ],
    //   consumerFunc: consumerFunc,
    // );

    logger.fine('wait _onceDBGetComplete');

    var retval = FutureBuilder<bool>(
        future: _waitDBJob(),
        //future: _waitDBJob(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasError) {
            //error가 발생하게 될 경우 반환하게 되는 부분
            logger.severe("data fetch error(WaitDatum)");
            return const Center(child: Text('data fetch error(WaitDatum)'));
          }
          if (snapshot.hasData == false) {
            logger.finest("wait data ...(WaitData)");
            return Center(
              child: CretaSnippet.showWaitSign(),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            logger.finest("founded ${snapshot.data!}");
            // if (snapshot.data!.isEmpty) {
            //   return const Center(child: Text('no book founded'));
            // }
            return consumerFunc();
          }
          return const SizedBox.shrink();
        });

    return retval;
  }

  Future<bool> _waitDBJob() async {
    while (_onceDBGetComplete == false) {
      await Future.delayed(Duration(microseconds: 500));
    }
    logger.fine('_onceDBGetComplete=$_onceDBGetComplete wait end');
    return _onceDBGetComplete;
  }

  Widget consumerFunc() {
    logger.finest('consumerFunc');
    return Consumer<BookManager>(
        key: ValueKey('consumerFunc+${StudioVariables.selectedBookMid}'),
        builder: (context, bookManager, child) {
          //print('Consumer  ${bookManager.onlyOne()!.mid}');
          String receivedMid = bookManager.onlyOne()!.mid;
          _bookModel ??= bookManager.onlyOne()! as BookModel;
          //print('Consumer  ${_bookModel!.mid}');
          if (receivedMid != _bookModel!.mid) {
            logger.severe("Received mid is not current mid");
            logger.severe("current=${_bookModel!.mid} != received $receivedMid");
          }
          _bookModel!.parentMid.set(_bookModel!.mid, noUndo: true);
          BookMainPage.bookManagerHolder!.setParentMid(_bookModel!.mid);
          return _mainPage();
        });
  }

  Widget _mainPage() {
    // print('build _hasROPermition = $_hasROPermition');
    // print('build _hasRWPermition = $_hasRWPermition');
    if (_hasRWPermition == false && _hasROPermition == false) {
      // 파일을 열 권한이 없음.
      return NoAuthority();
    }
    _resize();
    if (StudioVariables.workHeight < 1) {
      return Container();
    }
    return MultiProvider(
      key: ValueKey('MultiProvider ${StudioVariables.selectedBookMid}'),
      providers: [
        ChangeNotifierProvider<PageManager>.value(
          value: BookMainPage.pageManagerHolder!,
        ),
      ],
      child: Stack(
        children: [
          if (BookMainPage.backGroundMusic != null)
            FrameManager.backgroundMusic(BookMainPage.backGroundMusic!),
          Column(
            children: [
              SizedBox(height: StudioVariables.topMenuBarHeight),
              Container(
                color: LayoutConst.studioBGColor,
                height: StudioVariables.workHeight,
                //width: StudioVariables.workWidth,
                child: Row(
                  children: [
                    if (StudioVariables.isPreview == false)
                      StickMenu(
                        selectFunction: _showLeftMenu,
                      ),
                    Expanded(
                      child: _workArea(),
                    ),
                    // StudioVariables.autoScale == true
                    //     ? Expanded(
                    //         child: _workArea(),
                    //       )
                    //     : SizedBox(
                    //         width: StudioVariables.workWidth,
                    //         child: _workArea(),
                    //       )
                  ],
                ),
              ),
            ],
          ),
          if (StudioVariables.isPreview == false) _topMenu(),
          if (StudioVariables.isPreview == false)
            UploadingPopup(
              key: UploadingPopup.uploadPopupKey,
            ),
        ],
      ),
    );
  }

  void _resize() {
    // display :  웹화면에서 주소창을 제외한 전체 사이즈
    // work : 앱바, 톱메뉴, 스택메뉴를 제외한 전체 사이즈
    // virtua :  workWidth 에 현재 scale 적용한 영역, 실제 객체가 존재할 수 있는 Width
    //  virtualWidth :  workWidth 에 현재 scale 적용한 영역,
    //  virtualHeightPerPage :  workHeight 에 scale 을 적용한 영역, 하나의 페이지가 들어갈 수 영역
    //  virtualHeight :  3개의 페이지가 들어갈 수 있는 영역
    //  avail :  virtual 에 pageDisplayRate 0.85 를 곱한 영역,  실제로 사용할 수 있는 영역
    //  drawable :  가로 세로 영역을

    // widthRatio :  availWidth 와 실제 페이지 width(절대값) 의 비율. 클수록, 페이지가 가로로 좁은 것이다.
    // heightRatio :  avaliHeight 와 실제 페이지 hegight(절대값)의 비요류 클루록 페이작 납작한 것이다.
    //  widthRatio > heightRatio 라는 것은 세로형이라는 뜻이다.
    //  widthRatio < heightRatio 라는 것은 가로형이라는 뜻이다.

    if (StudioVariables.isPreview) {
      StudioVariables.topMenuBarHeight = 0;
      StudioVariables.menuStickWidth = 0;
      StudioVariables.appbarHeight = 0;
      StudioVariables.pageDisplayRate = 1;
    } else {
      StudioVariables.topMenuBarHeight = LayoutConst.topMenuBarHeight;
      StudioVariables.menuStickWidth = LayoutConst.menuStickWidth;
      StudioVariables.appbarHeight = CretaConst.appbarHeight;
      StudioVariables.pageDisplayRate = 0.849;
    }

    StudioVariables.displayWidth = widget.size?.width ?? MediaQuery.of(context).size.width;
    StudioVariables.displayHeight = widget.size?.height ?? MediaQuery.of(context).size.height;

    StudioVariables.workWidth = StudioVariables.displayWidth - StudioVariables.menuStickWidth;
    StudioVariables.workHeight = StudioVariables.displayHeight -
        StudioVariables.appbarHeight -
        StudioVariables.topMenuBarHeight;

    if (StudioVariables.autoScale == true || scaleChanged) {
      scaleChanged = false;

      widthRatio =
          (StudioVariables.workWidth * StudioVariables.pageDisplayRate / _bookModel!.width.value);
      heightRatio =
          (StudioVariables.workHeight * StudioVariables.pageDisplayRate / _bookModel!.height.value);
      heightWidthRatio = _bookModel!.height.value / _bookModel!.width.value;

      if (widthRatio < heightRatio) {
        //print('세로형');
        StudioVariables.fitScale = widthRatio; // 화면에 꽉찾을때의 최적의 값
        StudioVariables.scale = widthRatio;
      } else {
        //print('가로형 또는 정방형');
        StudioVariables.fitScale = heightRatio; // 화면에 꽉찾을때의 최적의 값
        StudioVariables.scale = heightRatio;
      }
      StudioVariables.applyScale = StudioVariables.scale * StudioVariables.pageDisplayRate;
    } else {
      StudioVariables.applyScale = StudioVariables.scale * StudioVariables.pageDisplayRate;
    }

    double workScale = StudioVariables.scale / StudioVariables.fitScale;

    //int pageLength = BookMainPage.pageManagerHolder!.getAvailLength();
    int pageLength = 1;

    StudioVariables.availWidth = StudioVariables.workWidth * workScale;
    StudioVariables.availHeight = StudioVariables.workHeight * workScale;

    StudioVariables.virtualWidth = StudioVariables.availWidth;
    StudioVariables.virtualHeight = StudioVariables.availHeight * pageLength;

    //print('pageLength=$pageLength, StudioVariables.virtualHeight=${StudioVariables.virtualHeight}');

    // virtual width 에서, 페이지 부분이 얼마나 떨어져 있는지 나타냄.
    // BookMainPage.pageOffset = Offset(
    //   (StudioVariables.virtualWidth - (_bookModel!.width.value * StudioVariables.applyScale)) / 2,
    //   (StudioVariables.virtualHeight - (_bookModel!.height.value * StudioVariables.applyScale)) / 2,
    // );

    BookMainPage.pageOffset = BookMainPage.bookManagerHolder!.getPageIndexOffset();

    padding = 16 * (StudioVariables.displayWidth / 1920);
    if (padding < 2) {
      padding = 2;
    }
    logger
        .info('StudioVariables.displayWidth======================${StudioVariables.displayWidth}');
    logger.fine(
        "height=${StudioVariables.virtualHeight}, width=${StudioVariables.virtualWidth}, scale=${StudioVariables.fitScale}}");
  }

  // Offset getPageIndexOffset(int pageIndex) {
  //   return Offset(
  //     (StudioVariables.virtualWidth - (_bookModel!.width.value * StudioVariables.applyScale)) / 2,
  //     (StudioVariables.availHeight * pageIndex -
  //             (_bookModel!.height.value * StudioVariables.applyScale)) /
  //         2,
  //   );
  // }

  Widget _workArea() {
    return Stack(
      children: [
        _scrollArea(context),
        if (StudioVariables.isPreview == false) _openLeftMenu(),
        if (StudioVariables.isPreview == false) _openRightMenu(),
      ],
    );
  }

  Widget _openLeftMenu() {
    return LeftMenu(
      key: BookMainPage.leftMenuKey,
      onClose: () {
        BookMainPage.leftMenuNotifier!.set(LeftMenuEnum.None);
      },
    );
  }

  Widget _openRightMenu() {
    return Positioned(
        top: 0,
        // left: StudioVariables.workWidth - LayoutConst.rightMenuWidth,
        right: 0,
        child: RightMenu(
            key: BookMainPage.rightMenuKey,
            onClose: () {
              BookMainPage.containeeNotifier!.set(ContaineeEnum.None);
            }));
  }

  Widget _topMenu() {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: StudioSnippet.basicShadow(),
        ),
        height: LayoutConst.topMenuBarHeight,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _controllers(),
                Row(
                  children: [
                    _avartars(),
                    SizedBox(width: padding * 2.5),
                    _trailButtons(),
                  ],
                ),
              ],
            ),
            _titles(),
          ],
        ));
  }

  Widget _controllers() {
    return BookTopMenu(
      key: BookTopMenu.topMenuKey,
      padding: padding,
      onManualScale: () {
        setState(() {
          scaleChanged = false;
        });
      },
      onAutoScale: () {
        setState(() {
          scaleChanged = true;
        });
      },
      onUndo: () {
        setState(() {
          mychangeStack.undo();
        });
      },
      onRedo: () {
        setState(() {
          mychangeStack.redo();
        });
      },
      onTextCreate: () {
        setState(() {
          // Create Text Box
          if (CretaVars.instance.serviceType == ServiceType.barricade) {
            // 바리케이트 타입의 경우, TextBox 을 막바로 생성한다.
            FrameManager? frameManager = BookMainPage.pageManagerHolder?.getSelectedFrameManager();
            if (frameManager == null) return;
            frameManager.createTextAndFrame(context,
                pos: Offset.zero, size: CretaVars.instance.defaultFrameSize());
          } else {
            BookMainPage.topMenuNotifier?.set(ClickToCreateEnum.textCreate);
          }
        });
      },
      onFrameCreate: () {
        setState(() {
          // Create Frame Box
          if (CretaVars.instance.serviceType == ServiceType.barricade) {
            // 바리케이트 타입의 경우, frame 을 막바로 생성한다.
            FrameManager? frameManager = BookMainPage.pageManagerHolder?.getSelectedFrameManager();
            if (frameManager != null) {
              frameManager
                  .createNextFrame(
                pos: Offset.zero,
                size: CretaVars.instance.defaultFrameSize(),
                bgColor1: Colors.amberAccent,
              )
                  .then((value) {
                frameManager.afterCreateFrame(value);

                return null;
              });
            }
          } else {
            BookMainPage.topMenuNotifier?.set(ClickToCreateEnum.frameCreate);
          }
        });
      },
    );
  }

  Widget _titles() {
    return Visibility(
      // 제목
      visible: StudioVariables.workHeight > 1 ? true : false,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CretaLabelTextEditor(
            textFieldKey: textFieldKey,
            height: 32,
            width: StudioVariables.displayWidth * 0.25,
            text: _bookModel!.name.value,
            textStyle: CretaFont.titleMedium.copyWith(),
            align: TextAlign.center,
            maxLine: 1,
            onEditComplete: (value) {
              setState(() {
                _bookModel!.name.set(value);
              });
            },
            onLabelHovered: () {
              BookMainPage.containeeNotifier!.set(ContaineeEnum.Book);
            },
          ),
        ],
      ),
    );
  }

  Widget _avartars() {
    if (AccountManager.currentLoginUser.isLoginedUser) {
      return Consumer<ConnectedUserManager>(builder: (context, connectedUserManager, child) {
        Set<ConnectedUserModel> connectedUserSet =
            connectedUserManager.getConnectedUserSet(CretaAccountManager.getUserProperty!.nickname);
        //print('Consumer<ConnectedUserManager>(${connectedUserSet.length} )');
        return Visibility(
            // 아바타
            visible:
                StudioVariables.workHeight > 1 && StudioVariables.workWidth > 800 ? true : false,
            child: StudioVariables.workHeight > 1 && StudioVariables.workWidth > 1300
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: connectedUserSet.map((e) {
                      return _eachAvartar(e);
                    }).toList(),
                  )
                : _standForAvartar(connectedUserSet));
      });
    }
    return SizedBox.square();
  }

  Widget _eachAvartar(ConnectedUserModel? user) {
    if (user == null) {
      return Container();
    }
    return Snippet.TooltipWrapper(
      tooltip: user.name,
      bgColor: (user.isConnected ? Colors.red : Colors.grey),
      fgColor: Colors.white,
      child: SizedBox(
        width: 34,
        height: 34,
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: CircleAvatar(
            //radius: 28,
            backgroundColor: user.isConnected ? Colors.red : Colors.grey,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: CircleAvatar(
                //radius: 25,
                backgroundImage: NetworkImage(user.imageUrl),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _standForAvartar(Set<ConnectedUserModel> userList) {
    if (userList.isEmpty) {
      return Container();
    }

    if (userList.length == 1) {
      return _eachAvartar(userList.first);
    }

    String name = '';
    for (var ele in userList) {
      if (name.isNotEmpty) {
        name += ',';
      }
      name += ele.name;
    }
    String count = userList.length.toString();
    Color bgColor = Colors.grey;
    for (var ele in userList) {
      if (ele.isConnected) {
        bgColor = Colors.red;
        break;
      }
    }
    return Snippet.TooltipWrapper(
      tooltip: name,
      bgColor: bgColor,
      fgColor: Colors.white,
      child: SizedBox(
        width: 34,
        height: 34,
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: CircleAvatar(
            //radius: 28,
            backgroundColor: bgColor,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: CircleAvatar(
                backgroundColor: CretaColor.primary,
                //radius: 25,
                //backgroundImage: userList.first.image,
                child: Text(count, style: CretaFont.bodySmall.copyWith(color: Colors.white)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _trailButtons() {
    return Visibility(
      //  발행하기 등
      visible:
          StudioVariables.workHeight > 1 && StudioVariables.workWidth > LayoutConst.minWorkWidth
              ? true
              : false,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BTN.floating_l(
            icon: Icons.note_add_outlined,
            onPressed: () async {
              BookModel newBook = BookMainPage.bookManagerHolder!.createSample();
              BookMainPage.bookManagerHolder!.saveSample(newBook).then((value) {
                String url = '${AppRoutes.studioBookMainPage}?${newBook.mid}';
                AppRoutes.launchTab(url);
              });
            },
            hasShadow: false,
            tooltip: CretaStudioLang['newBook'] ?? '새로운 북 만들기기',
          ),
          SizedBox(width: padding),
          BTN.floating_l(
            icon: Icons.copy_outlined,
            onPressed: () async {
              BookModel? model = BookMainPage.bookManagerHolder!.onlyOne() as BookModel?;
              if (model == null) {
                return;
              }
              BookManager.newbBackgroundMusicFrame = '';
              BookMainPage.bookManagerHolder!.makeCopy(model.mid, model, null).then((newOne) {
                BookMainPage.pageManagerHolder!.copyBook(newOne.mid, newOne.mid).then((value) {
                  String url = '${AppRoutes.studioBookMainPage}?${newOne.mid}';
                  if (BookManager.newbBackgroundMusicFrame.isNotEmpty) {
                    //  백그라운드 뮤직을 복사한다.
                    (newOne as BookModel)
                        .backgroundMusicFrame
                        .set(BookManager.newbBackgroundMusicFrame, save: false);
                    BookMainPage.bookManagerHolder!.setToDB(newOne);
                  }
                  AppRoutes.launchTab(url);
                  return null;
                });
              });
            },
            hasShadow: false,
            tooltip: CretaLang['makeCopy'] ?? '사본 만들기',
          ),
          SizedBox(width: padding),
          BTN.floating_l(
            icon: Icons.person_add_outlined,
            onPressed: () {
              if (AccountManager.currentLoginUser.isLoginedUser == false) {
                BookMainPage.warningNeedToLogin(context);
                return;
              }

              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CretaAlertDialog(
                      title: CretaLang['invite']!,
                      width: LayoutConst.rightMenuWidth,
                      height: 687,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      //child: Container(
                      content: BookEditorProperty(
                          isDialog: true,
                          model: _bookModel!,
                          parentNotify: () {
                            setState(() {});
                          }),
                      onPressedOK: () {
                        Navigator.of(context).pop();
                      },
                      // content: Container(
                      //   padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      //   width: LayoutConst.rightMenuWidth,
                      //   child: BookEditorProperty(
                      //       isDialog: true,
                      //       model: _bookModel!,
                      //       parentNotify: () {
                      //         setState(() {});
                      //       }),
                      // ),
                    );
                    // return BookPublishDialog(
                    //   key: GlobalKey(),
                    //   model: _bookModel,
                    //   currentStep: 2,
                    //   title: CretaStudioLang['tooltipInvite']!,
                    //   prevBtTitle: CretaLang['cancel']!,
                    //   nextBtTitle: CretaLang['confirm']!,
                    //   onPrev: () {
                    //     Navigator.of(context).pop();
                    //   },
                    //   onNext: () {
                    //     Navigator.of(context).pop();
                    //   },
                    // );
                  });
            },
            hasShadow: false,
            tooltip: CretaStudioLang['tooltipInvite']!,
          ),
          SizedBox(width: padding),
          BTN.floating_l(
            icon: Icons.file_download_outlined,
            onPressed: () {
              if (AccountManager.currentLoginUser.isLoginedUser == false) {
                BookMainPage.warningNeedToLogin(context);
                return;
              }
              logger.fine('donwload in studio');
              StudioMainMenu.downloadDialog(context);
              // CretaPopup.yesNoDialog(
              //   context: context,
              //   title: "${CretaStudioLang['export']!}      ",
              //   icon: Icons.file_download_outlined,
              //   question: CretaStudioLang['downloadConfirm']!,
              //   noBtText: CretaVars.instance.isDeveloper
              //       ? CretaStudioLang['noBtDnTextDeloper']!
              //       : CretaStudioLang['noBtDnText']!,
              //   yesBtText: CretaStudioLang['yesBtDnText']!,
              //   yesIsDefault: true,
              //   onNo: () {
              //     if (CretaVars.instance.isDeveloper) {
              //       BookMainPage.bookManagerHolder
              //           ?.download(context, BookMainPage.pageManagerHolder, false);
              //     }
              //   },
              //   onYes: () {
              //     BookMainPage.bookManagerHolder
              //         ?.download(context, BookMainPage.pageManagerHolder, true);
              //   },
              // );
            },
            hasShadow: false,
            tooltip: CretaLang['download']!,
          ),
          SizedBox(width: padding),
          BTN.floating_l(
            icon: Icons.smart_display_outlined,
            onPressed: () async {
              // 가기전에 모든것을 save 한다.
              saveManagerHolder?.stopTimer();
              await saveManagerHolder?.saveForce(notify: false);

              // PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
              // if (pageModel == null) {
              //   return;
              // }
              // if (pageModel.isShow.value == false) {
              //   showSnackBar(context, CretaStudioLang['noUnshowPage']!);
              //   return;
              // }
              BookPreviewMenu.previewMenuPressed = false;
              LinkParams.isLinkNewMode = false;
              //StudioVariables.isLinkEditMode = false;
              //StudioVariables.globalToggleAutoPlay(_linkSendEvent, _autoPlaySendEvent,
              StudioVariables.globalToggleAutoPlay(forceValue: true, save: true);
              // 미리보기
              _fromPriviewToMain = true;

              if (kReleaseMode) {
                // String url = '${AppRoutes.studioBookPreviewPage}?${StudioVariables.selectedBookMid}';
                // AppRoutes.launchTab(url);
                Routemaster.of(context)
                    .push('${AppRoutes.studioBookPreviewPage}?${StudioVariables.selectedBookMid}');
              } else {
                Routemaster.of(context)
                    .push('${AppRoutes.studioBookPreviewPage}?${StudioVariables.selectedBookMid}');
              }
            },
            hasShadow: false,
            tooltip: CretaStudioLang['tooltipPlay']!,
          ),
          SizedBox(width: padding),
          BTN.floating_l(
            icon: Icons.delete_outline,
            onPressed: () async {
              BookModel? thisOne = BookMainPage.bookManagerHolder!.onlyOne() as BookModel?;
              if (thisOne == null) return;
              CretaPopup.yesNoDialog(
                context: context,
                title: CretaLang['deleteConfirmTitle']!,
                icon: Icons.file_download_outlined,
                question: CretaLang['deleteConfirm']!,
                noBtText: CretaStudioLang['noBtDnText']!,
                yesBtText: CretaStudioLang['yesBtDnText']!,
                yesIsDefault: true,
                onNo: () {},
                onYes: () async {
                  logger.fine('onPressedOK()');
                  String name = thisOne.name.value;
                  await BookMainPage.bookManagerHolder!
                      .removeBook(thisOne, BookMainPage.pageManagerHolder!);
                  showSnackBar(context, '$name${CretaLang['bookDeleted']!}');
                  Routemaster.of(context).push(AppRoutes.studioBookGridPage);
                },
              );
            },
            hasShadow: false,
            tooltip: CretaLang['delete'] ?? '휴지통으로 보내기',
          ),
          Padding(
            padding: EdgeInsets.only(left: padding),
            child: BTN.line_blue_it_m_animation(
                text: CretaStudioLang['publish']!,
                image:
                    NetworkImage('https://docs.flutter.dev/assets/images/dash/dash-fainting.gif'),
                onPressed: () {
                  //BookModel? model = BookMainPage.bookManagerHolder?.onlyOne() as BookModel?;
                  if (AccountManager.currentLoginUser.isLoginedUser == false) {
                    BookMainPage.warningNeedToLogin(context);
                    return;
                  }

                  if (BookMainPage.bookManagerHolder!
                          .uploadCompleteTest(BookMainPage.pageManagerHolder, _bookModel!) ==
                      false) {
                    BookMainPage.warningNeedToWaitUploding(context);
                    return;
                  }

                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return BookPublishDialog(
                          key: GlobalKey(),
                          model: _bookModel,
                        );
                      });
                }),
          ),
          SizedBox(width: padding * 2.5),
        ],
      ),
    );
  }

  Widget _scrollArea(BuildContext context) {
    bool isPageExist = true;

    //double scrollWidth = _getScrollWidth();
    //double scrollWidth = StudioVariables.workWidth;
    double marginX = (StudioVariables.workWidth - StudioVariables.virtualWidth) / 2;
    double marginY = (StudioVariables.workHeight - StudioVariables.virtualHeight) / 2;
    if (marginX < 0) marginX = 0;
    if (marginY < 0) marginY = 0;
    // double totalWidth =
    //     StudioVariables.virtualWidth + LayoutConst.rightMenuWidth + LayoutConst.leftMenuWidth;
    // double scrollWidth = 0;
    // double marginX = 0;
    // double marginY = 0;
    double totalWidth = StudioVariables.virtualWidth;

    //print('margin=$marginX, $marginY');

    return KeyboardListener(
      autofocus: true,
      focusNode: CretaTextField.mainFocusNode!, // _focusNodeEventHandler 가 호출됨.
      onKeyEvent: _keyEventHandler,
      child: Center(
          child: StudioVariables.isPreview
              ? noneScrollBox(isPageExist)
              : scrollBox(totalWidth, marginX, marginY)),
    );
    //});
  }

// Ctrl + Mouse Wheel action
  void _onMouseWheelScroll(PointerScaleEvent event) {
    //print('_onMouseWheelScroll move...${event.kind}, ${event.buttons}');
    if (event.kind == PointerDeviceKind.mouse && event.buttons == 0) {
      double delta = event.scale > 1 ? 0.15 : -0.15;

      //print('wheel move.222222..$delta, $aaa');
      setState(() {
        // StudioVariables.scale = (StudioVariables.scale + delta).clamp(
        //   CretaScaleButton.scalePlot.first / 100,
        //   CretaScaleButton.scalePlot.last / 100,
        // );
        //print('before StudioVariables.scale=${StudioVariables.scale}');
        StudioVariables.scale += delta;
        StudioVariables.scale = StudioVariables.scale.clamp(
          CretaScaleButton.scalePlot.first / 100,
          CretaScaleButton.scalePlot.last / 100,
        );
        StudioVariables.autoScale = false;
        //print('after StudioVariables.scale=${StudioVariables.scale}');
      });
    }
  }

  Widget scrollBox(double totalWidth, double marginX, double marginY) {
    //print('----------scrollbaox---------------');

    double initialOffsetX = (StudioVariables.virtualWidth - StudioVariables.workWidth) / 2;
    if (initialOffsetX < 0) {
      initialOffsetX = 0;
    }
    double initialOffsetY = (StudioVariables.virtualHeight - StudioVariables.workHeight) / 2;
    if (initialOffsetY < 0) {
      initialOffsetY = 0;
    }

    return Container(
      width: StudioVariables.workWidth,
      height: StudioVariables.workHeight,
      color: LayoutConst.studioBGColor,
      //color: Colors.greenAccent,
      child: Center(
        child: CrossScrollBar(
          key: ValueKey('CrossScrollBar_${_bookModel!.mid}'),
          width: totalWidth,
          marginX: marginX,
          marginY: marginY,
          currentHorizontalScrollBarOffset: (value) {
            StudioVariables.horizontalScrollOffset = value;
          },
          currentVerticalScrollBarOffset: (value) {
            StudioVariables.verticalScrollOffset = value;
          },
          initialScrollOffsetX: initialOffsetX,
          initialScrollOffsetY: initialOffsetY,
          child: Listener(
            onPointerSignal: (pointerSignal) {
              //print('wheel move...$pointerSignal');
              if (StudioVariables.isCtrlPressed) {
                if (pointerSignal is PointerScaleEvent) {
                  _onMouseWheelScroll(pointerSignal);
                } // Ctrl + Mouse Wheel
              }
            },
            child: Center(child: Consumer<PageManager>(builder: (context, pageManager, child) {
              pageManager.reOrdering();
              PageModel? pageModel = pageManager.getSelected() as PageModel?;
              return _drawPage(context, pageModel);
            })),
          ),
        ),
      ),
    );
  }

  Widget noneScrollBox(bool isPageExist) {
    // WillPopScope(
    //   onWillPop: () async {
    //     //showSnackBar(context, CretaLang['cantGoBack']!);
    //     return false; // 뒤로가기 금지
    //   },
    //   child:

    return LayoutBuilder(builder: (context, constraints) {
      // 사이즉 변하는 중인지 알아낸다.
      final currentSize = Size(constraints.maxWidth, constraints.maxHeight);
      if (_previousSize != null && _previousSize != currentSize) {
        StudioVariables.isSizeChanging = true;
      } else {
        StudioVariables.isSizeChanging = false;
      }
      _previousSize = currentSize;
      return Container(
        width: StudioVariables.workWidth, //scrollWidth,
        height: StudioVariables.workHeight,
        color: LayoutConst.studioBGColor,
        //color: Colors.green,
        child: Consumer<PageManager>(builder: (context, pageManager, child) {
          pageManager.reOrdering();
          if (BookPreviewMenu.previewMenuPressed == false) {
            isPageExist = pageManager.gotoFirst();
          }
          int? pageNo = pageManager.getSelectedNumber();
          if (pageNo == null) {
            return SizedBox.shrink();
          }
          PageModel? pageModel = pageManager.getSelected() as PageModel?;
          int totalPage = pageManager.getAvailLength();
          return Stack(
            children: [
              Center(
                child: _drawPrevPage(context, pageManager),
              ),
              Center(
                child: isPageExist
                    ? _drawPage(context, pageModel)
                    : Text(
                        CretaStudioLang['noUnshowPage']!,
                        style: CretaFont.headlineLarge,
                      ),
              ),
              if (StudioVariables.hideMouse == false)
                BookPreviewMenu(
                  goBackProcess: () {
                    //setState(() {
                    StudioVariables.isPreview = false;
                    //});
                    // 돌아기기
                    _fromPriviewToMain = true;
                    StudioVariables.stopPaging = false;
                    StudioVariables.stopNextContents = false;

                    if (kReleaseMode) {
                      // String url = '${AppRoutes.studioBookPreviewPage}?${StudioVariables.selectedBookMid}';
                      // AppRoutes.launchTab(url);
                      Routemaster.of(context).push(
                          '${AppRoutes.studioBookMainPage}?${StudioVariables.selectedBookMid}');
                    } else {
                      Routemaster.of(context).push(
                          '${AppRoutes.studioBookMainPage}?${StudioVariables.selectedBookMid}');
                    }
                  },
                  muteFunction: () {
                    MouseHider.lastMouseMoveTime = DateTime.now();
                    StudioVariables.globalToggleMute(save: false);
                  },
                  playFunction: () {
                    MouseHider.lastMouseMoveTime = DateTime.now();
                    //StudioVariables.globalToggleAutoPlay(_linkSendEvent, _autoPlaySendEvent,
                    setState(() {
                      StudioVariables.stopPaging = !StudioVariables.stopPaging;
                    });
                    //StudioVariables.globalToggleAutoPlay(save: false);
                    // if (StudioVariables.isAutoPlay && StudioVariables.isPreview) {
                    //   _startConnectedUserTimer();
                    // }
                  },
                  gotoNext: () {
                    MouseHider.lastMouseMoveTime = DateTime.now();
                    BookPreviewMenu.previewMenuPressed = true;
                    StudioVariables.stopPaging = false;
                    StudioVariables.stopNextContents = false;
                    pageManager.gotoNext();
                  },
                  gotoPrev: () {
                    MouseHider.lastMouseMoveTime = DateTime.now();
                    BookPreviewMenu.previewMenuPressed = true;
                    StudioVariables.stopPaging = false;
                    StudioVariables.stopNextContents = false;
                    pageManager.gotoPrev();
                  },
                  pageNo: pageNo,
                  totalPage: totalPage,
                  isPublishedMode: widget.isPublishedMode,
                  toggleFullscreen: widget.toggleFullscreen,
                ),
            ],
          );
        }),
        //),
      );
    });
  }

  // ignore: unused_element
  double _getScrollWidth() {
    double retval = StudioVariables.workWidth;
    if (BookMainPage.containeeNotifier!.selectedClass != ContaineeEnum.None) {
      retval = retval - LayoutConst.rightMenuWidth;
    }
    if (BookMainPage.leftMenuNotifier!.selectedStick != LeftMenuEnum.None) {
      retval = retval - LayoutConst.leftMenuWidth;
    }
    return retval;
  }

  // Widget _drawPage(BuildContext context) {
  //   return Container(
  //     width: StudioVariables.virtualWidth,
  //     height: StudioVariables.virtualHeight,
  //     color: LayoutConst.studioBGColor,
  //     //color: Colors.amber,
  //     child: Center(
  //       child: GestureDetector(
  //         onLongPressDown: (details) {
  //           logger.finest('page clicked');
  //           setState(() {
  //            BookMainPage.containeeNotifier!.set(ContaineeEnum.Page);
  //           });
  //         },
  //         child: Container(
  //           decoration: BoxDecoration(
  //             color: _bookModel.opacity.value == 1
  //                 ? _bookModel.bgColor1.value
  //                 : _bookModel.bgColor1.value.withOpacity(_bookModel.opacity.value),
  //             boxShadow: StudioSnippet.basicShadow(),
  //             gradient: StudioSnippet.gradient(_bookModel.gradationType.value,
  //                 _bookModel.bgColor1.value, _bookModel.bgColor2.value),
  //           ),
  //           width: pageWidth,
  //           height: pageHeight,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _drawPage(BuildContext context, PageModel? pageModel) {
    if (pageModel == null) {
      return const SizedBox.shrink();
    }
    pageModel.width.set(_bookModel!.width.value, save: false, noUndo: true);
    pageModel.height.set(_bookModel!.height.value, save: false, noUndo: true);
    logger.info('PageMain Invoked ***** ${pageModel.mid}');

    // pageMain은  페이지 영역뿐만 아니고, 페이지 외부 여백까지 모두 덮어쓰고 있다.
    return PageMain(
      pageKey: GlobalObjectKey('PageKey${pageModel.mid}'),
      bookModel: _bookModel!,
      pageModel: pageModel,
      pageWidth: StudioVariables.availWidth,
      pageHeight: StudioVariables.availHeight, // + LayoutConst.miniMenuArea,
    );
  }

  Widget _drawPrevPage(BuildContext context, PageManager pageManager) {
    logger.fine('_drawPrevPage Invoked ***** ${LinkParams.invokerMid}');
    if (LinkParams.invokerMid == null) {
      return const SizedBox.shrink();
    }
    logger.fine('_drawPrevPage Invoked *****');

    return Center(
      child: Container(
        width: StudioVariables.virtualWidth,
        height: StudioVariables.virtualHeight,
        color: LayoutConst.studioBGColor,
        //color: Colors.amber,
        child: CustomImage(
          hasMouseOverEffect: false,
          hasAni: false,
          width: StudioVariables.virtualWidth,
          height: StudioVariables.virtualHeight,
          image: _bookModel!.thumbnailUrl.value,
        ),
      ),
      //),
    );
  }

  void _showLeftMenu(LeftMenuEnum idx) {
    logger.fine("showLeftMenu ${idx.name}");
    // setState(() {
    //   // if (BookMainPage.selectedStick == idx) {
    //   //   BookMainPage.selectedStick = LeftMenuEnum.None;
    //   // } else {
    //   //   BookMainPage.selectedStick = idx;
    //   // }
    // });
  }

  // void _startConnectedUserTimer() async {
  //   // print('_startConnectedUserTimer----------------------------------');
  //   if (BookMainPage.connectedUserHolder != null) {
  //     await BookMainPage.connectedUserHolder!.getConnectedUser();
  //     BookMainPage.connectedUserHolder!.notify();
  //   }
  //   _connectedUserTimer ??=
  //       Timer.periodic(Duration(seconds: ConnectedUserManager.monitorPerid), (t) {
  //     //print('_startConnectedUserTimer----------------------------------');
  //     if (BookMainPage.connectedUserHolder != null &&
  //         LoginPage.userPropertyManagerHolder!.userPropertyModel != null) {
  //       String myName = LoginPage.userPropertyManagerHolder!.userPropertyModel!.nickname;
  //       ConnectedUserModel? model = BookMainPage.connectedUserHolder!.aleadyCreated(myName);
  //       if (model != null) {
  //         model.imageUrl = LoginPage.userPropertyManagerHolder!.userPropertyModel!.profileImg;
  //         model.setUpdateTime();
  //         model.isRemoved.set(false, save: false, noUndo: true);
  //         BookMainPage.connectedUserHolder?.update(connectedUser: model, doNotify: false);
  //         // print('update user ${model.name}---${model.mid}-------------------------------');
  //       } else {
  //         //print(
  //         //    'create user ${LoginPage.userPropertyManagerHolder!.userModel.name}----------------------------------');
  //         BookMainPage.connectedUserHolder?.createNext(
  //             user: LoginPage.userPropertyManagerHolder!.userPropertyModel!, doNotify: false);
  //       }
  //       BookMainPage.connectedUserHolder!.removeOld(myName);
  //     }
  //   });
  // }

  // void _stopConnectedUserTimer() {
  //   _connectedUserTimer?.cancel();
  //   _connectedUserTimer = null;
  // }

  void _copy() {
    if (BookMainPage.pageManagerHolder == null) return;
    FrameModel? frameModel = BookMainPage.pageManagerHolder!.getSelectedFrame();
    if (frameModel != null) {
      FrameManager? frameManager = BookMainPage.pageManagerHolder!.getSelectedFrameManager();
      StudioVariables.clipFrame(frameModel, frameManager!);
    } else {
      PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
      if (pageModel != null) {
        StudioVariables.clipPage(pageModel, BookMainPage.pageManagerHolder!);
      }
    }
  }

  void _paste() {
    if (BookMainPage.pageManagerHolder == null) return;
    // Paste
    if (StudioVariables.clipBoard is PageModel?) {
      PageModel? page = StudioVariables.clipBoard as PageModel?;
      PageManager? srcManager = StudioVariables.clipBoardManager as PageManager?;
      if (page != null && srcManager != null) {
        BookMainPage.pageManagerHolder?.copyPage(page, srcPageManager: srcManager);
      }
    } else if (StudioVariables.clipBoard is FrameModel?) {
      FrameManager? frameManager = BookMainPage.pageManagerHolder!.getSelectedFrameManager();
      if (frameManager == null) {
        return;
      }
      PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
      if (pageModel == null) {
        return;
      }
      FrameModel? frame = StudioVariables.clipBoard as FrameModel?;
      FrameManager? srcManager = StudioVariables.clipBoardManager as FrameManager?;
      if (frame != null && srcManager != null) {
        frameManager.copyFrame(frame,
            parentMid: pageModel.mid,
            srcFrameManager: srcManager,
            samePage: pageModel.mid == frame.parentMid.value);
      }
    }
  }

  void _crop() {
    if (BookMainPage.pageManagerHolder == null) return;
    FrameModel? frameModel = BookMainPage.pageManagerHolder!.getSelectedFrame();
    if (frameModel != null) {
      FrameManager? frameManager = BookMainPage.pageManagerHolder!.getSelectedFrameManager();
      frameModel.isRemoved.set(true);
      StudioVariables.clipFrame(frameModel, frameManager!);
    } else {
      PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
      if (pageModel != null) {
        pageModel.isRemoved.set(true);
        StudioVariables.clipPage(pageModel, BookMainPage.pageManagerHolder!);
      }
    }
    BookMainPage.pageManagerHolder!.notify();
  }

  Future<void> _deleteSelectedModel() async {
    if (BookMainPage.pageManagerHolder == null) return;
    FrameModel? frameModel = BookMainPage.pageManagerHolder!.getSelectedFrame();
    if (frameModel != null) {
      FrameManager? frameManager = BookMainPage.pageManagerHolder!.getSelectedFrameManager();
      if (frameManager != null && frameManager.getAvailLength() > 0) {
        ContentsManager? contentsManager = frameManager.getContentsManager(frameModel.mid);
        if (contentsManager != null && contentsManager.getAvailLength() > 0) {
          if (await contentsManager.removeSelected(context) == true) {
            frameManager.notify();
            return;
          }
        }
        if (await frameManager.removeSelected(context) == true) {
          return;
        }
      }
    }
    await BookMainPage.pageManagerHolder!.removeSelected(context);
  }

  Future<void> _nextContents(bool backWard) async {
    if (BookMainPage.pageManagerHolder == null) return;
    FrameModel? frameModel = BookMainPage.pageManagerHolder!.getSelectedFrame();
    if (frameModel == null) {
      return;
    }
    FrameManager? frameManager = BookMainPage.pageManagerHolder!.getSelectedFrameManager();
    if (frameManager == null || frameManager.getAvailLength() == 0) {
      return;
    }
    ContentsManager? contentsManager = frameManager.getContentsManager(frameModel.mid);
    if (contentsManager == null || contentsManager.getAvailLength() == 0) {
      return;
    }

    if (backWard == true) {
      contentsManager.gotoPrev();
    } else {
      contentsManager.gotoNext();
    }
    contentsManager.notify();
  }
}
