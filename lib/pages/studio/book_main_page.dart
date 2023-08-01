// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_brace_in_string_interps, depend_on_referenced_packages

//import 'dart:ui';

import 'dart:async';

import 'package:creta03/pages/studio/studio_main_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hycop/common/undo/save_manager.dart';
import 'package:hycop/common/undo/undo.dart';
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

import '../../common/creta_constant.dart';
import '../../data_io/book_manager.dart';
import '../../data_io/connected_user_manager.dart';
import '../../data_io/filter_manager.dart';
import '../../data_io/frame_manager.dart';
import '../../data_io/page_manager.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/buttons/creta_label_text_editor.dart';
import '../../design_system/buttons/creta_scale_button.dart';
import '../../design_system/component/creta_icon_toggle_button.dart';
import '../../design_system/component/custom_image.dart';
import '../../design_system/component/snippet.dart';
import '../../design_system/creta_color.dart';
import '../../design_system/creta_font.dart';
import '../../model/book_model.dart';
import '../../design_system/component/cross_scrollbar.dart';
import '../../model/frame_model.dart';
import '../../model/page_model.dart';
import '../../routes.dart';
import '../login_page.dart';
import 'book_preview_menu.dart';
import 'book_publish.dart';
import 'containees/click_event.dart';
import 'containees/containee_nofifier.dart';
import 'left_menu/left_menu.dart';
import 'containees/page/page_main.dart';
import 'right_menu/right_menu.dart';
import 'stick_menu.dart';
import 'studio_constant.dart';
import 'studio_snippet.dart';
import 'studio_variables.dart';

// ignore: must_be_immutable
class BookMainPage extends StatefulWidget {
  static String selectedMid = '';
  //static bool onceBookInfoOpened = false;
  static BookManager? bookManagerHolder;
  static PageManager? pageManagerHolder;
  static FilterManager? filterManagerHolder;
  static ConnectedUserManager? connectedUserHolder;
  // static FrameTemplateManager? polygonFrameManagerHolder;
  // static FrameTemplateManager? animationFrameManagerHolder;
  //static UserPropertyManager? userPropertyManagerHolder;
  static ContaineeNotifier? containeeNotifier;
  static MiniMenuNotifier? miniMenuNotifier;
  //static MiniMenuContentsNotifier? miniMenuContentsNotifier;

  //static LeftMenuEnum selectedStick = LeftMenuEnum.None;
  static LeftMenuNotifier? leftMenuNotifier;
  static ClickReceiverHandler clickReceiverHandler = ClickReceiverHandler();
  static ClickEventHandler clickEventHandler = ClickEventHandler();

  static bool thumbnailChanged = false;
  static double pageWidth = 0;
  static double pageHeight = 0;

  //static ContaineeEnum selectedClass = ContaineeEnum.Book;
  final bool isPreviewX;
  final bool isThumbnailX;
  final GlobalKey bookKey;
  final Size? size;
  final bool? isPublishedMode;
  final Function? toggleFullscreen;

  static bool outSideClick = false;

  BookMainPage({
    required this.bookKey,
    this.isPreviewX = false,
    this.isThumbnailX = false,
    this.size,
    this.isPublishedMode,
    this.toggleFullscreen,
  }) : super(key: bookKey) {
    StudioVariables.isPreview = isPreviewX;
  }

  @override
  State<BookMainPage> createState() => _BookMainPageState();
}

class _BookMainPageState extends State<BookMainPage> {
  BookModel? _bookModel;
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

  List<LogicalKeyboardKey> keys = [];

  //Timer? _connectedUserTimer;

  //OffsetEventController? _linkSendEvent;
  //AutoPlayChangeEventController? _autoPlaySendEvent;

  @override
  void initState() {
    super.initState();
    logger.info("---_BookMainPageState-----------------------------------------");

    // final OffsetEventController linkSendEvent = Get.find(tag: 'on-link-to-link-widget');
    // _linkSendEvent = linkSendEvent;
    // final AutoPlayChangeEventController autoPlaySendEvent = Get.find(tag: 'auto-play-to-frame');
    // _autoPlaySendEvent = autoPlaySendEvent;
    LoginPage.initUserProperty();

    BookPreviewMenu.previewMenuPressed = false;

    BookMainPage.containeeNotifier = ContaineeNotifier();
    BookMainPage.miniMenuNotifier = MiniMenuNotifier();
    BookMainPage.leftMenuNotifier = LeftMenuNotifier();
    //BookMainPage.miniMenuContentsNotifier = MiniMenuContentsNotifier();

    // 같은 페이지에서 객체만 바뀌면 static value 들은 그대로 남아있게 되므로
    // static value 도 초기화해준다.
    //BookMainPage.selectedMid = '';
    //BookMainPage.onceBookInfoOpened = false;

    BookMainPage.containeeNotifier!.set(ContaineeEnum.Book, doNoti: false);

    BookMainPage.bookManagerHolder = (widget.isPublishedMode ?? false)
        ? BookManager(tableName: 'creta_book_published')
        : BookManager();
    //BookMainPage.bookManagerHolder!.configEvent(notifyModify: false);
    BookMainPage.bookManagerHolder!.clearAll();
    BookMainPage.pageManagerHolder = (widget.isPublishedMode ?? false)
        ? PageManager(
            tableName: 'creta_page_published', isPublishedMode: widget.isPublishedMode ?? false)
        : PageManager();
    // BookMainPage.polygonFrameManagerHolder = FrameTemplateManager(frameType: FrameType.polygon);
    // BookMainPage.animationFrameManagerHolder = FrameTemplateManager(frameType: FrameType.animation);
    //BookMainPage.userPropertyManagerHolder = UserPropertyManager();

    if (LoginPage.userPropertyManagerHolder != null) {
      String userEmail = LoginPage.userPropertyManagerHolder!.userModel.email;
      BookMainPage.filterManagerHolder = FilterManager(userEmail);
      BookMainPage.filterManagerHolder!.getFilter();
    }
    BookMainPage.connectedUserHolder = ConnectedUserManager();

    String url = Uri.base.origin;
    String query = Uri.base.query;

    logger.finest("url=$url-------------------------------");
    logger.finest("query=$query-------------------------------");

    int pos = query.indexOf('&');
    String mid = pos > 0 ? query.substring(0, pos) : query;
    logger.finest("mid=$mid-------------------------------");

    if (mid.isEmpty) {
      mid = BookMainPage.selectedMid;
    }

    if (mid.isNotEmpty) {
      logger.info("1) --_BookMainPageState-----------------------------------------");
      BookMainPage.bookManagerHolder!.getFromDB(mid).then((value) async {
        BookMainPage.bookManagerHolder!.addRealTimeListen(mid);
        if (BookMainPage.bookManagerHolder!.getLength() > 0) {
          initChildren(BookMainPage.bookManagerHolder!.onlyOne() as BookModel);
        }
        return value;
      });
    } else {
      logger.info("2) --_BookMainPageState-----------------------------------------");
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
    mouseTracerHolder!.initialize();
    client.initialize(LoginPage.enterpriseHolder!.enterpriseModel!.socketUrl);
    client.connectServer(BookMainPage.selectedMid);

    mouseTracerHolder!.addListener(() {
      switch (mouseTracerHolder!.methodFlag) {
        case 'joinUser':
          mouseTracerHolder!.methodFlag = '';
          BookMainPage.connectedUserHolder!.connectNoti(BookMainPage.selectedMid,
              mouseTracerHolder!.targetUserName, mouseTracerHolder!.targetUserEmail);
          break;
        case 'leaveUser':
          mouseTracerHolder!.methodFlag = '';
          BookMainPage.connectedUserHolder!.disconnectNoti(BookMainPage.selectedMid,
              mouseTracerHolder!.targetUserName, mouseTracerHolder!.targetUserEmail);
          break;
        default:
          break;
      }
    });

    logger.info("end ---_BookMainPageState-----------------------------------------");

    afterBuild();
  }

  Future<void> afterBuild() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      logger.info("BookMainPage ---_BookMainPageState-----------------------------------------");
      while (_onceDBGetComplete == false) {
        await Future.delayed(Duration(seconds: 1));
      }
      //_startConnectedUserTimer();

      if (StudioVariables.isPreview) {
        //_takeAScreenShot();
        if (StudioVariables.isAutoPlay) {}
      } else {}
    });
  }

  Future<void> initChildren(BookModel model) async {
    saveManagerHolder!.setDefaultBook(model);
    saveManagerHolder!.addBookChildren('book=');
    saveManagerHolder!.addBookChildren('page=');
    saveManagerHolder!.addBookChildren('frame=');
    saveManagerHolder!.addBookChildren('contents=');
    saveManagerHolder!.addBookChildren('link=');

    BookMainPage.filterManagerHolder?.setBook(model);
    BookMainPage.connectedUserHolder?.setBook(model.mid);

    logger.info("3) --_BookMainPageState-----------------------------------------");

    // Get Pages
    await BookMainPage.pageManagerHolder!.initPage(model);
    logger.info("4) --_BookMainPageState-----------------------------------------");
    await BookMainPage.pageManagerHolder!.findOrInitAllFrameManager(model);
    logger.info("5) --_BookMainPageState-----------------------------------------");

    // Get Template Frames
    // BookMainPage.polygonFrameManagerHolder!.clearAll();
    // await _getPolygonFrameTemplates();
    // BookMainPage.animationFrameManagerHolder!.clearAll();
    // await _getAnimationFrameTemplates();

    // Get User property
    //await BookMainPage.userPropertyManagerHolder!.initUserProperty();

    _onceDBGetComplete = true;

    if (LoginPage.userPropertyManagerHolder != null) {
      StudioVariables.isMute = LoginPage.userPropertyManagerHolder!.getMute();
      if ((widget.isPublishedMode ?? false) == false) {
        StudioVariables.isAutoPlay = LoginPage.userPropertyManagerHolder!.getAutoPlay();
      }
    }

    HycopFactory.realtime!.startTemp(model.mid);
    HycopFactory.realtime!.setPrefix('creta');
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

  @override
  void dispose() {
    logger.severe('BookMainPage.dispose');

    //_stopConnectedUserTimer();

    BookMainPage.bookManagerHolder?.removeRealTimeListen();
    BookMainPage.pageManagerHolder?.removeRealTimeListen();
    BookMainPage.connectedUserHolder?.removeRealTimeListen();
    BookMainPage.pageManagerHolder?.clearFrameManager();

    saveManagerHolder?.stopTimer();
    saveManagerHolder?.unregisterManager('book');
    saveManagerHolder?.unregisterManager('page');
    saveManagerHolder?.unregisterManager('user');
    // controller.dispose();
    //verticalScroll?.dispose();
    //horizontalScroll?.dispose();

    HycopFactory.realtime!.stop();
    client.disconnect();
    if(webRTCClient != null) {
      webRTCClient!.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidthPercentage = MediaQuery.of(context).size.width * 0.01;
    screenHeightPrecentage = MediaQuery.of(context).size.height * 0.01;
    screenWidth = MediaQuery.of(context).size.width;
    DateTime lastEventTime = DateTime.now();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ContaineeNotifier>.value(
          value: BookMainPage.containeeNotifier!,
        ),
        ChangeNotifierProvider<MiniMenuNotifier>.value(
          value: BookMainPage.miniMenuNotifier!,
        ),
        ChangeNotifierProvider<LeftMenuNotifier>.value(
          value: BookMainPage.leftMenuNotifier!,
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
        ChangeNotifierProvider<MouseTracer>.value(value: mouseTracerHolder!)
      ],
      child: RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKey: _keyEventHandler,
        child: StudioVariables.isPreview
            ? Scaffold(body: _waitBook())
            : Snippet.CretaScaffold(
                title: Snippet.logo('studio', route: () {
                  Routemaster.of(context).push(AppRoutes.studioBookGridPage);
                }),
                invalidate: () {
                  setState(() {});
                },
                context: context,
                child: Stack(
                  children: [
                    MouseRegion(
                      onHover: (pointerEvent) {
                        //if (StudioVariables.allowMutilUser == true) {
                        if (mouseTracerHolder!.userMouseList.isEmpty) return;
                        if (lastEventTime
                            .add(Duration(milliseconds: 100))
                            .isBefore(DateTime.now())) {
                          client.moveCursor(pointerEvent.position.dx / screenWidthPercentage,
                              (pointerEvent.position.dy - 50) / screenHeightPrecentage);
                          lastEventTime = DateTime.now();
                        }
                        //}
                      },
                      child: _waitBook(),
                    ),
                    //if (StudioVariables.allowMutilUser == true) mouseArea(),
                    mouseArea(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget mouseArea() {
    return IgnorePointer(
      child: Consumer<MouseTracer>(builder: (context, mouseTracerManager, child) {
        return Stack(
          children: [
            for (int i = 0; i < mouseTracerHolder!.userMouseList.length; i++)
              cursorWidget(i, mouseTracerHolder!)
          ],
        );
      }),
    );
  }

  Widget cursorWidget(int index, MouseTracer mouseTracer) {
    int userColorLen = userColorList.length;
    Color mouseColor = userColorLen == 0
        ? CretaColor.primary
        : userColorList[index < userColorLen ? index : (index % userColorLen)];
    return Positioned(
        left: mouseTracer.userMouseList[index].cursorX * screenWidthPercentage,
        top: mouseTracer.userMouseList[index].cursorY * screenHeightPrecentage,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(
            Icons.pan_tool_alt,
            size: 30,
            color: mouseColor,
          ),
          Container(
            width: mouseTracer.userMouseList[index].userName.length * 10,
            height: 20,
            decoration: BoxDecoration(color: mouseColor, borderRadius: BorderRadius.circular(20)),
            child: Text(mouseTracer.userMouseList[index].userName,
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
    // var retval = CretaModelSnippet.waitDatum(
    //   managerList: [
    //     BookMainPage.bookManagerHolder!,
    //     BookMainPage.pageManagerHolder!,
    //   ],
    //   consumerFunc: consumerFunc,
    // );

    logger.info('wait _onceDBGetComplete');

    var retval = FutureBuilder<bool>(
        future: _waitDBJob(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasError) {
            //error가 발생하게 될 경우 반환하게 되는 부분
            logger.severe("data fetch error(WaitDatum)");
            return const Center(child: Text('data fetch error(WaitDatum)'));
          }
          if (snapshot.hasData == false) {
            logger.finest("wait data ...(WaitData)");
            return Center(
              child: Snippet.showWaitSign(),
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
    logger.info('_onceDBGetComplete=$_onceDBGetComplete wait end');
    return _onceDBGetComplete;
  }

  Widget consumerFunc() {
    logger.finest('consumerFunc');
    return Consumer<BookManager>(
        key: ValueKey('consumerFunc+${BookMainPage.selectedMid}'),
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
    _resize();
    if (StudioVariables.workHeight < 1) {
      return Container();
    }
    return MultiProvider(
      key: ValueKey('MultiProvider ${BookMainPage.selectedMid}'),
      providers: [
        ChangeNotifierProvider<PageManager>.value(
          value: BookMainPage.pageManagerHolder!,
        ),
      ],
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: StudioVariables.topMenuBarHeight),
              Container(
                color: LayoutConst.studioBGColor,
                height: StudioVariables.workHeight,
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
        ],
      ),
    );
  }

  void _resize() {
    double pageDisplayRate = 0.9;
    if (StudioVariables.isPreview) {
      StudioVariables.topMenuBarHeight = 0;
      StudioVariables.menuStickWidth = 0;
      StudioVariables.appbarHeight = 0;
      pageDisplayRate = 1;
    } else {
      StudioVariables.topMenuBarHeight = LayoutConst.topMenuBarHeight;
      StudioVariables.menuStickWidth = LayoutConst.menuStickWidth;
      StudioVariables.appbarHeight = CretaConstant.appbarHeight;
    }

    StudioVariables.displayWidth = widget.size?.width ?? MediaQuery.of(context).size.width;
    StudioVariables.displayHeight = widget.size?.height ?? MediaQuery.of(context).size.height;

    StudioVariables.workWidth = StudioVariables.displayWidth - StudioVariables.menuStickWidth;
    StudioVariables.workHeight = StudioVariables.displayHeight -
        StudioVariables.appbarHeight -
        StudioVariables.topMenuBarHeight;
    StudioVariables.workRatio = StudioVariables.workHeight / StudioVariables.workWidth;

    StudioVariables.applyScale = StudioVariables.scale / StudioVariables.fitScale;
    if (StudioVariables.autoScale == true || scaleChanged == true) {
      StudioVariables.virtualWidth = StudioVariables.workWidth * StudioVariables.applyScale;
      StudioVariables.virtualHeight = StudioVariables.workHeight * StudioVariables.applyScale;
    }
    scaleChanged = false;

    StudioVariables.availWidth = StudioVariables.virtualWidth * pageDisplayRate;
    StudioVariables.availHeight = StudioVariables.virtualHeight * pageDisplayRate;

    widthRatio = StudioVariables.availWidth / _bookModel!.width.value;
    heightRatio = StudioVariables.availHeight / _bookModel!.height.value;
    heightWidthRatio = _bookModel!.height.value / _bookModel!.width.value;

    if (widthRatio < heightRatio) {
      BookMainPage.pageWidth = StudioVariables.availWidth;
      BookMainPage.pageHeight = BookMainPage.pageWidth * heightWidthRatio;
      if (StudioVariables.autoScale == true) {
        StudioVariables.fitScale = widthRatio; // 화면에 꽉찾을때의 최적의 값
        StudioVariables.scale = widthRatio;
      }
    } else {
      BookMainPage.pageHeight = StudioVariables.availHeight;
      BookMainPage.pageWidth = BookMainPage.pageHeight / heightWidthRatio;
      if (StudioVariables.autoScale == true) {
        StudioVariables.fitScale = heightRatio; // 화면에 꽉찾을때의 최적의 값
        StudioVariables.scale = heightRatio;
      }
    }

    padding = 16 * (StudioVariables.displayWidth / 1920);
    if (padding < 2) {
      padding = 2;
    }

    logger.fine(
        "height=${StudioVariables.virtualHeight}, width=${StudioVariables.virtualWidth}, scale=${StudioVariables.fitScale}}");
  }

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
      key: GlobalObjectKey('LeftMenu'),
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
            //key: ValueKey(BookMainPage.containeeNotifier!.selectedClass.toString()),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: padding * 1.75,
        ),
        StudioMainMenu(),
        SizedBox(width: padding),
        Visibility(
          // Scale, Undo
          visible: StudioVariables.workHeight > 1 && StudioVariables.workWidth > 800 ? true : false,
          child: Row(
            children: [
              BTN.floating_l(
                icon: Icons.undo_outlined,
                onPressed: () {
                  setState(() {
                    mychangeStack.undo();
                  });
                },
                hasShadow: false,
                tooltip: CretaStudioLang.tooltipUndo,
              ),
              SizedBox(width: padding / 2),
              BTN.floating_l(
                icon: Icons.redo_outlined,
                onPressed: () {
                  setState(() {
                    mychangeStack.redo();
                  });
                },
                hasShadow: false,
                tooltip: CretaStudioLang.tooltipRedo,
              ),
              SizedBox(width: padding),
              CretaScaleButton(
                width: 180,
                onManualScale: () {
                  setState(() {
                    scaleChanged = true;
                  });
                },
                onAutoScale: () {
                  setState(() {
                    scaleChanged = true;
                  });
                },
                hasShadow: false,
                tooltip: CretaStudioLang.tooltipScale,
                extended: CretaIconToggleButton(
                  key: ValueKey('HandToolToggleButton'),
                  buttonStyle: ToggleButtonStyle.fill_gray_i_m,
                  toggleValue: StudioVariables.isHandToolMode,
                  icon1: Icons.transit_enterexit_outlined,
                  icon2: Icons.pan_tool_outlined,
                  tooltip: StudioVariables.isHandToolMode
                      ? CretaStudioLang.tooltipEdit
                      : CretaStudioLang.tooltipNoneEdit,
                  onPressed: () {
                    StudioVariables.isHandToolMode = !StudioVariables.isHandToolMode;
                    BookMainPage.bookManagerHolder!.notify();
                  },
                ),
              ),
              SizedBox(width: padding),
              CretaIconToggleButton(
                key: ValueKey('MuteToggleButton'),
                toggleValue: StudioVariables.isMute,
                icon1: Icons.volume_off_outlined,
                icon2: Icons.volume_up_outlined,
                tooltip: CretaStudioLang.tooltipVolume,
                buttonSize: 20,
                onPressed: () {
                  StudioVariables.globalToggleMute();
                },
              ),
              SizedBox(width: padding / 2),
              CretaIconToggleButton(
                key: ValueKey('AutoPlayToggleButton ${StudioVariables.isAutoPlay}'),
                toggleValue: StudioVariables.isAutoPlay,
                icon1: Icons.pause_outlined,
                icon2: Icons.play_arrow,
                tooltip: CretaStudioLang.tooltipPause,
                buttonSize: StudioVariables.isAutoPlay ? 20 : 30,
                onPressed: () {
                  //StudioVariables.globalToggleAutoPlay(_linkSendEvent, _autoPlaySendEvent);
                  StudioVariables.globalToggleAutoPlay();
                },
              ),
              //SizedBox(width: padding),
//VerticalDivider(),
              // SizedBox(width: padding / 2),
              // if (StudioVariables.isHandToolMode == false && StudioVariables.isLinkMode == false)
              //   BTN.floating_lc(
              //     icon: Icon(Icons.radio_button_checked_outlined,
              //         size: 20, color: CretaColor.primary),
              //     onPressed: () {
              //       setState(() {
              //         StudioVariables.isLinkMode = true;
              //         _globalToggleAutoPlay(forceValue: false);
              //       });
              //     },
              //     hasShadow: false,
              //     tooltip: CretaStudioLang.tooltipLink,
              //   ),
            ],
          ),
        ),
      ],
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
    return Consumer<ConnectedUserManager>(builder: (context, connectedUserManager, child) {
      Set<ConnectedUserModel> connectedUserSet = connectedUserManager
          .getConnectedUserSet(LoginPage.userPropertyManagerHolder!.userPropertyModel!.nickname);
      //print('Consumer<ConnectedUserManager>(${connectedUserSet.length} )');
      return Visibility(
          // 아바타
          visible: StudioVariables.workHeight > 1 && StudioVariables.workWidth > 800 ? true : false,
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
          //VerticalDivider(),
          BTN.floating_l(
            icon: Icons.person_add_outlined,
            onPressed: () {
              //setState(() {
              //StudioVariables.allowMutilUser = !StudioVariables.allowMutilUser;
              //});
            },
            hasShadow: false,
            tooltip: CretaStudioLang.tooltipInvite,
          ),
          SizedBox(width: padding),
          BTN.floating_l(
            icon: Icons.file_download_outlined,
            onPressed: () {},
            hasShadow: false,
            tooltip: CretaStudioLang.tooltipDownload,
          ),
          SizedBox(width: padding),
          BTN.floating_l(
            icon: Icons.smart_display_outlined,
            onPressed: () {
              // PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
              // if (pageModel == null) {
              //   return;
              // }
              // if (pageModel.isShow.value == false) {
              //   showSnackBar(context, CretaStudioLang.noUnshowPage);
              //   return;
              // }
              BookPreviewMenu.previewMenuPressed = false;
              LinkParams.isLinkNewMode = false;
              //StudioVariables.isLinkEditMode = false;
              //StudioVariables.globalToggleAutoPlay(_linkSendEvent, _autoPlaySendEvent,
              StudioVariables.globalToggleAutoPlay(forceValue: false, save: false);
              if (kReleaseMode) {
                // String url = '${AppRoutes.studioBookPreviewPage}?${BookMainPage.selectedMid}';
                // AppRoutes.launchTab(url);
                Routemaster.of(context)
                    .push('${AppRoutes.studioBookPreviewPage}?${BookMainPage.selectedMid}');
              } else {
                Routemaster.of(context)
                    .push('${AppRoutes.studioBookPreviewPage}?${BookMainPage.selectedMid}');
              }
            },
            hasShadow: false,
            tooltip: CretaStudioLang.tooltipPlay,
          ),
          SizedBox(width: padding),
          BTN.line_blue_it_m_animation(
              text: CretaStudioLang.publish,
              image: NetworkImage('https://docs.flutter.dev/assets/images/dash/dash-fainting.gif'),
              onPressed: () {
                //BookModel? model = BookMainPage.bookManagerHolder?.onlyOne() as BookModel?;

                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return BookPublishDialog(
                        key: GlobalKey(),
                        model: _bookModel,
                      );
                    });
              }),
          SizedBox(width: padding * 2.5),
        ],
      ),
    );
  }

  Widget _scrollArea(BuildContext context) {
    //verticalScroll ??= ScrollController(initialScrollOffset: StudioVariables.workHeight * 0.1);
    //horizontalScroll ??= ScrollController(initialScrollOffset: StudioVariables.workWidth * 0.1);

    //return Consumer<ContaineeNotifier>(builder: (context, notifier, child) {
    double scrollWidth = getScrollWidth();
    //double marginX = (StudioVariables.workWidth - StudioVariables.virtualWidth) / 2;
    double marginX = (scrollWidth - StudioVariables.virtualWidth) / 2;
    double marginY = (StudioVariables.workHeight - StudioVariables.virtualHeight) / 2;
    if (marginX < 0) marginX = 0;
    if (marginY < 0) marginY = 0;

    bool isPageExist = true;

    double totalWidth =
        StudioVariables.virtualWidth + LayoutConst.rightMenuWidth + LayoutConst.leftMenuWidth;

    // if (BookMainPage.selectedStick != LeftMenuEnum.None) {
    //   return Positioned(
    //     left: LayoutConst.leftMenuWidth,
    //     top: 0,
    //     child: scrollBox,
    //   );
    // }

    return Center(
        child: StudioVariables.isPreview
            ? noneScrollBox(isPageExist)
            : scrollBox(totalWidth, marginX, marginY));
    //});
  }

  Widget scrollBox(double totalWidth, double marginX, double marginY) {
    return Container(
      width: StudioVariables.workWidth, //scrollWidth,
      height: StudioVariables.workHeight,
      color: LayoutConst.studioBGColor,
      //color: Colors.green,
      child: Center(
        child: CrossScrollBar(
          key: ValueKey('CrossScrollBar_${_bookModel!.mid}'),
          //key: GlobalKey(),
          width: totalWidth,
          //width: StudioVariables.workWidth,
          marginX: marginX,
          marginY: marginY,
          // initialScrollOffsetX:
          //     horizontalScrollOffset ?? (totalWidth - StudioVariables.workWidth) * 0.5,
          // initialScrollOffsetY: vericalScrollOffset ?? StudioVariables.workHeight * 0.1,
          currentHorizontalScrollBarOffset: (value) {
            StudioVariables.horizontalScrollOffset = value;
          },
          currentVerticalScrollBarOffset: (value) {
            StudioVariables.verticalScrollOffset = value;
          },

          child: Center(child: Consumer<PageManager>(builder: (context, pageManager, child) {
            pageManager.reOrdering();
            PageModel? pageModel = pageManager.getSelected() as PageModel?;
            return _drawPage(context, pageModel);
          })),
        ),
      ),
    );
  }

  Widget noneScrollBox(bool isPageExist) {
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
                      CretaStudioLang.noUnshowPage,
                      style: CretaFont.headlineLarge,
                    ),
            ),
            BookPreviewMenu(
              goBackProcess: () {
                setState(() {
                  StudioVariables.isPreview = false;
                });
              },
              muteFunction: () {
                StudioVariables.globalToggleMute(save: false);
              },
              playFunction: () {
                //StudioVariables.globalToggleAutoPlay(_linkSendEvent, _autoPlaySendEvent,
                StudioVariables.globalToggleAutoPlay(save: false);
                // if (StudioVariables.isAutoPlay && StudioVariables.isPreview) {
                //   _startConnectedUserTimer();
                // }
              },
              gotoNext: () {
                BookPreviewMenu.previewMenuPressed = true;
                pageManager.gotoNext();
              },
              gotoPrev: () {
                BookPreviewMenu.previewMenuPressed = true;
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
    );
  }

  double getScrollWidth() {
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
    logger.info('PageMain Invoked ***** ${pageModel.width.value}');

    return PageMain(
      pageKey: GlobalObjectKey('PageKey${pageModel.mid}'),
      bookModel: _bookModel!,
      pageModel: pageModel,
      pageWidth: BookMainPage.pageWidth,
      pageHeight: BookMainPage.pageHeight + LayoutConst.miniMenuArea,
    );
  }

  // ignore: unused_element
  Widget _drawPrevPage(BuildContext context, PageManager pageManager) {
    logger.info('_drawPrevPage Invoked ***** ${LinkParams.invokerMid}');
    if (LinkParams.invokerMid == null) {
      return const SizedBox.shrink();
    }
    logger.info('_drawPrevPage Invoked *****');

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
    logger.info("showLeftMenu ${idx.name}");
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

  void _keyEventHandler(RawKeyEvent event) {
    final key = event.logicalKey;
    logger.info('key pressed $key');
    if (event is RawKeyDownEvent) {
      if (keys.contains(key)) return;
      // textField 의 focus bug 때문에, delete  key 를 사용할 수 없다.
      // if (event.isKeyPressed(LogicalKeyboardKey.delete)) {
      //   logger.info('delete pressed');
      //   accManagerHolder!.removeACC(context);
      // }
      if (event.isKeyPressed(LogicalKeyboardKey.tab)) {
        logger.info('tab pressed');
      }
      if (event.isKeyPressed(LogicalKeyboardKey.pageDown)) {
        logger.info("pageDown pressed");
      }
      if (event.isKeyPressed(LogicalKeyboardKey.pageUp)) {
        logger.info("pageUp pressed");
      }
      keys.add(key);
      // Ctrl Key Area
      if ((keys.contains(LogicalKeyboardKey.controlLeft) ||
          keys.contains(LogicalKeyboardKey.controlRight))) {
        if (keys.contains(LogicalKeyboardKey.keyZ)) {
          logger.info('Ctrl+Z pressed');
          // undo
        } else if (keys.contains(LogicalKeyboardKey.keyY)) {
          logger.info('Ctrl+Y pressed');
          // redo
        } else if (keys.contains(LogicalKeyboardKey.keyC)) {
          // copy
          logger.info('Ctrl+C pressed');
          if (BookMainPage.pageManagerHolder == null) return;
          FrameModel? frameModel = BookMainPage.pageManagerHolder!.getSelectedFrame();
          if (frameModel != null) {
            FrameManager? frameManager = BookMainPage.pageManagerHolder!.getSelectedFrameManager();
            StudioVariables.copyFrame(frameModel, frameManager!);
          } else {
            PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
            if (pageModel != null) {
              StudioVariables.copyPage(pageModel, BookMainPage.pageManagerHolder!);
            }
          }
        } else if (keys.contains(LogicalKeyboardKey.keyX)) {
          logger.info('Ctrl+X pressed');
          // Crop
          if (BookMainPage.pageManagerHolder == null) return;
          FrameModel? frameModel = BookMainPage.pageManagerHolder!.getSelectedFrame();
          if (frameModel != null) {
            FrameManager? frameManager = BookMainPage.pageManagerHolder!.getSelectedFrameManager();
            frameModel.isRemoved.set(true);
            StudioVariables.copyFrame(frameModel, frameManager!);
          } else {
            PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
            if (pageModel != null) {
              pageModel.isRemoved.set(true);
              StudioVariables.copyPage(pageModel, BookMainPage.pageManagerHolder!);
            }
          }
          BookMainPage.pageManagerHolder!.notify();
        } else if (keys.contains(LogicalKeyboardKey.keyV)) {
          logger.info('Ctrl+V pressed');
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
      }
    } else {
      keys.remove(key);
    }
  }
}
