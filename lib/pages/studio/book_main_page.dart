// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_brace_in_string_interps, depend_on_referenced_packages

//import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hycop/common/undo/save_manager.dart';
import 'package:provider/provider.dart';
import 'package:hycop/common/util/logger.dart';
//import 'package:hycop/hycop/absModel/abs_ex_model.dart';
//import 'package:hycop/hycop/account/account_manager.dart';
import 'package:creta03/lang/creta_studio_lang.dart';
import 'package:creta03/model/connected_user_model.dart';
import 'package:creta03/pages/studio/sample_data.dart';
import '../../common/creta_constant.dart';
import '../../data_io/book_manager.dart';
import '../../data_io/frame_manager.dart';
import '../../data_io/page_manager.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/buttons/creta_label_text_editor.dart';
import '../../design_system/buttons/creta_scale_button.dart';
import '../../design_system/component/creta_icon_toggle_button.dart';
import '../../design_system/component/snippet.dart';
import '../../design_system/creta_color.dart';
import '../../design_system/creta_font.dart';
import '../../model/book_model.dart';
import '../../design_system/component/cross_scrollbar.dart';
import '../../model/creta_model.dart';
import '../../model/page_model.dart';
import '../../routes.dart';
import '../login_page.dart';
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

  //static ContaineeEnum selectedClass = ContaineeEnum.Book;
  final bool isPreview;
  BookMainPage({super.key, this.isPreview = false}) {
    StudioVariables.isPreview = isPreview;
  }

  @override
  State<BookMainPage> createState() => _BookMainPageState();
}

class _BookMainPageState extends State<BookMainPage> {
  late BookModel _bookModel;
  bool _onceDBGetComplete = false;
  final GlobalKey<CretaLabelTextEditorState> textFieldKey = GlobalKey<CretaLabelTextEditorState>();

  // final ScrollController controller = ScrollController();
  //ScrollController? horizontalScroll;
  //ScrollController? verticalScroll;

  double pageWidth = 0;
  double pageHeight = 0;
  double heightWidthRatio = 0;
  double widthRatio = 0;
  double heightRatio = 0;
  //double applyScale = 1;
  bool scaleChanged = false;

  double padding = 16;

  double? vericalScrollOffset;
  double? horizontalScrollOffset;

  @override
  void initState() {
    super.initState();
    logger.info("---_BookMainPageState-----------------------------------------");

    BookMainPage.containeeNotifier = ContaineeNotifier();
    BookMainPage.miniMenuNotifier = MiniMenuNotifier();
    BookMainPage.leftMenuNotifier = LeftMenuNotifier();
    //BookMainPage.miniMenuContentsNotifier = MiniMenuContentsNotifier();

    // 같은 페이지에서 객체만 바뀌면 static value 들은 그대로 남아있게 되므로
    // static value 도 초기화해준다.
    //BookMainPage.selectedMid = '';
    //BookMainPage.onceBookInfoOpened = false;

    BookMainPage.containeeNotifier!.set(ContaineeEnum.Book, doNoti: false);

    BookMainPage.bookManagerHolder = BookManager();
    BookMainPage.bookManagerHolder!.configEvent(notifyModify: false);
    BookMainPage.bookManagerHolder!.clearAll();
    BookMainPage.pageManagerHolder = PageManager();
    // BookMainPage.polygonFrameManagerHolder = FrameTemplateManager(frameType: FrameType.polygon);
    // BookMainPage.animationFrameManagerHolder = FrameTemplateManager(frameType: FrameType.animation);
    //BookMainPage.userPropertyManagerHolder = UserPropertyManager();

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
      BookMainPage.bookManagerHolder!.getFromDB(mid).then((value) async {
        BookMainPage.bookManagerHolder!.addRealTimeListen();
        if (BookMainPage.bookManagerHolder!.getLength() > 0) {
          initChildren(BookMainPage.bookManagerHolder!.onlyOne() as BookModel);
        }
        return value;
      });
    } else {
      BookModel sampleBook = BookMainPage.bookManagerHolder!.createSample();
      mid = sampleBook.mid;
      BookMainPage.bookManagerHolder!.saveSample(sampleBook).then((value) async {
        BookMainPage.bookManagerHolder!.addRealTimeListen();
        if (BookMainPage.bookManagerHolder!.getLength() > 0) {
          initChildren(sampleBook);
        }
        return value;
      });
    }
    BookMainPage.leftMenuNotifier!.set(LeftMenuEnum.Page, doNotify: false); // 페이지가 열린 상태로 시작하게 한다.
    saveManagerHolder?.runSaveTimer();

    BookMainPage.clickReceiverHandler.init();
  }

  Future<void> initChildren(BookModel model) async {
    saveManagerHolder!.setDefaultBook(model);
    saveManagerHolder!.addBookChildren('book=');
    saveManagerHolder!.addBookChildren('page=');
    saveManagerHolder!.addBookChildren('frame=');
    saveManagerHolder!.addBookChildren('contents=');

    // Get Pages
    await BookMainPage.pageManagerHolder!.initPage(model);

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
      StudioVariables.isAutoPlay = LoginPage.userPropertyManagerHolder!.getAutoPlay();
    }
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

    super.dispose();
    BookMainPage.bookManagerHolder?.removeRealTimeListen();
    BookMainPage.pageManagerHolder?.removeRealTimeListen();
    BookMainPage.pageManagerHolder?.clearFrameManager();

    saveManagerHolder?.stopTimer();
    saveManagerHolder?.unregisterManager('book');
    saveManagerHolder?.unregisterManager('page');
    saveManagerHolder?.unregisterManager('user');
    // controller.dispose();
    //verticalScroll?.dispose();
    //horizontalScroll?.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      ],
      child: widget.isPreview
          ? Scaffold(body: _waitBook())
          : Snippet.CretaScaffold(
              title: Snippet.logo('studio'),
              context: context,
              child: _waitBook(),
            ),
    );
  }

  Widget _waitBook() {
    if (_onceDBGetComplete) {
      logger.finest('already _onceDBGetComplete');
      return consumerFunc();
    }
    //var retval = CretaModelSnippet.waitData(
    var retval = CretaModelSnippet.waitDatum(
      managerList: [
        BookMainPage.bookManagerHolder!,
        BookMainPage.pageManagerHolder!,
        // BookMainPage.polygonFrameManagerHolder!,
        // BookMainPage.animationFrameManagerHolder!,
        // LoginPage.userPropertyManagerHolder!,
      ],
      //userId: AccountManager.currentLoginUser.email,
      consumerFunc: consumerFunc,
    );

    //_onceDBGetComplete = true;
    logger.finest('first_onceDBGetComplete bookmain');
    return retval;
    //return consumerFunc();
  }

  Widget consumerFunc() {
    logger.finest('consumerFunc');
    return Consumer<BookManager>(
        key: ValueKey('consumerFunc+${BookMainPage.selectedMid}'),
        builder: (context, bookManager, child) {
          logger.info('Consumer  ${bookManager.getLength()}');
          _bookModel = bookManager.onlyOne()! as BookModel;
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
              SizedBox(height: LayoutConst.topMenuBarHeight),
              Container(
                color: LayoutConst.studioBGColor,
                height: StudioVariables.workHeight,
                child: Row(
                  children: [
                    if (widget.isPreview == false)
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
          if (widget.isPreview == false) _topMenu(),
        ],
      ),
    );
  }

  void _resize() {
    StudioVariables.displayWidth = MediaQuery.of(context).size.width;
    StudioVariables.displayHeight = MediaQuery.of(context).size.height;

    StudioVariables.workWidth = StudioVariables.displayWidth - LayoutConst.menuStickWidth;
    StudioVariables.workHeight =
        StudioVariables.displayHeight - CretaConstant.appbarHeight - LayoutConst.topMenuBarHeight;
    StudioVariables.workRatio = StudioVariables.workHeight / StudioVariables.workWidth;

    StudioVariables.applyScale = StudioVariables.scale / StudioVariables.fitScale;
    if (StudioVariables.autoScale == true || scaleChanged == true) {
      StudioVariables.virtualWidth = StudioVariables.workWidth * StudioVariables.applyScale;
      StudioVariables.virtualHeight = StudioVariables.workHeight * StudioVariables.applyScale;
    }
    scaleChanged = false;

    StudioVariables.availWidth = StudioVariables.virtualWidth * 0.9;
    StudioVariables.availHeight = StudioVariables.virtualHeight * 0.9;

    widthRatio = StudioVariables.availWidth / _bookModel.width.value;
    heightRatio = StudioVariables.availHeight / _bookModel.height.value;
    heightWidthRatio = _bookModel.height.value / _bookModel.width.value;

    if (widthRatio < heightRatio) {
      pageWidth = StudioVariables.availWidth;
      pageHeight = pageWidth * heightWidthRatio;
      if (StudioVariables.autoScale == true) {
        StudioVariables.fitScale = widthRatio; // 화면에 꽉찾을때의 최적의 값
        StudioVariables.scale = widthRatio;
      }
    } else {
      pageHeight = StudioVariables.availHeight;
      pageWidth = pageHeight / heightWidthRatio;
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
        if (widget.isPreview == false) _openLeftMenu(),
        if (widget.isPreview == false) _openRightMenu(),
      ],
    );
  }

  Widget _openLeftMenu() {
    return LeftMenu(
      onClose: () {
        BookMainPage.leftMenuNotifier!.set(LeftMenuEnum.None);
      },
    );
  }

  Widget _openRightMenu() {
    return Positioned(
        top: 0,
        left: StudioVariables.workWidth - LayoutConst.rightMenuWidth,
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
        Icon(Icons.menu_outlined),
        SizedBox(width: padding),
        Visibility(
          // Scale, Undo
          visible: StudioVariables.workHeight > 1 && StudioVariables.workWidth > 800 ? true : false,
          child: Row(
            children: [
              BTN.floating_l(
                icon: Icons.undo_outlined,
                onPressed: () {},
                hasShadow: false,
                tooltip: CretaStudioLang.tooltipUndo,
              ),
              SizedBox(width: padding / 2),
              BTN.floating_l(
                icon: Icons.redo_outlined,
                onPressed: () {},
                hasShadow: false,
                tooltip: CretaStudioLang.tooltipRedo,
              ),
              SizedBox(width: padding),
              CretaScaleButton(
                width: 162,
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
              ),
              SizedBox(width: padding),
              CretaIconToggleButton(
                toggleValue: StudioVariables.isMute,
                icon1: Icons.volume_off_outlined,
                icon2: Icons.volume_up_outlined,
                tooltip: CretaStudioLang.tooltipVolume,
                onPressed: () {
                  _globalToggleMute();
                },
              ),

              SizedBox(width: padding),
              CretaIconToggleButton(
                toggleValue: StudioVariables.isAutoPlay,
                icon1: Icons.pause_outlined,
                icon2: Icons.play_arrow_outlined,
                tooltip: CretaStudioLang.tooltipPause,
                onPressed: () {
                  _globalToggleAutoPlay();
                },
              ),
              SizedBox(width: padding),
              BTN.floating_l(
                icon: Icons.transit_enterexit_outlined,
                onPressed: () {
                  StudioVariables.handToolMode = false;
                  BookMainPage.bookManagerHolder!.notify();
                },
                hasShadow: false,
                tooltip: CretaStudioLang.tooltipEdit,
              ),
              SizedBox(width: padding),
              BTN.floating_l(
                icon: Icons.pan_tool_outlined,
                onPressed: () {
                  StudioVariables.handToolMode = true;
                  BookMainPage.bookManagerHolder!.notify();
                },
                hasShadow: false,
                tooltip: CretaStudioLang.tooltipNoneEdit,
              ),
              //VerticalDivider(),
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
            text: _bookModel.name.value,
            textStyle: CretaFont.titleMedium.copyWith(),
            align: TextAlign.center,
            onEditComplete: (value) {
              setState(() {
                _bookModel.name.set(value);
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
    return Visibility(
        // 아바타
        visible: StudioVariables.workHeight > 1 && StudioVariables.workWidth > 800 ? true : false,
        child: StudioVariables.workHeight > 1 && StudioVariables.workWidth > 1300
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: SampleData.connectedUserList.map((e) {
                  return _eachAvartar(e);
                }).toList(),
              )
            : _standForAvartar(SampleData.connectedUserList));
  }

  Widget _eachAvartar(ConnectedUserModel? user) {
    if (user == null) {
      return Container();
    }
    return Snippet.TooltipWrapper(
      tooltip: user.name,
      bgColor: (user.state == ActiveState.active ? Colors.red : Colors.grey),
      fgColor: Colors.white,
      child: SizedBox(
        width: 34,
        height: 34,
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: CircleAvatar(
            //radius: 28,
            backgroundColor: user.state == ActiveState.active ? Colors.red : Colors.grey,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: CircleAvatar(
                //radius: 25,
                backgroundImage: user.image,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _standForAvartar(List<ConnectedUserModel> userList) {
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
      if (ele.state == ActiveState.active) {
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
            onPressed: () {},
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
              if (StudioVariables.isAutoPlay) {
                _globalToggleAutoPlay();
              }
              String url = '${AppRoutes.studioBookPreviewPage}?${BookMainPage.selectedMid}';
              AppRoutes.launchTab(url);
              //Routemaster.of(context).push(AppRoutes.studioBookPreviewPage);
            },
            hasShadow: false,
            tooltip: CretaStudioLang.tooltipPlay,
          ),
          SizedBox(width: padding),
          BTN.line_blue_it_m_animation(
              text: CretaStudioLang.publish,
              image: NetworkImage('https://docs.flutter.dev/assets/images/dash/dash-fainting.gif'),
              onPressed: () {}),
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

    double totalWidth =
        StudioVariables.virtualWidth + LayoutConst.rightMenuWidth + LayoutConst.leftMenuWidth;

    Widget scrollBox = Container(
      width: StudioVariables.workWidth, //scrollWidth,
      height: StudioVariables.workHeight,
      color: LayoutConst.studioBGColor,
      //color: Colors.green,
      child: Center(
        child: CrossScrollBar(
          key: ValueKey('CrossScrollBar_${_bookModel.mid}'),
          //key: GlobalKey(),
          width: totalWidth,
          //width: StudioVariables.workWidth,
          marginX: marginX,
          marginY: marginY,
          initialScrollOffsetX:
              horizontalScrollOffset ?? (totalWidth - StudioVariables.workWidth) * 0.5,
          initialScrollOffsetY: vericalScrollOffset ?? StudioVariables.workHeight * 0.1,
          currentHorizontalScrollBarOffset: (value) {
            horizontalScrollOffset = value;
          },
          currentVerticalScrollBarOffset: (value) {
            vericalScrollOffset = value;
          },
          child: Center(child: _drawPage(context)),
        ),
      ),
    );

    // if (BookMainPage.selectedStick != LeftMenuEnum.None) {
    //   return Positioned(
    //     left: LayoutConst.leftMenuWidth,
    //     top: 0,
    //     child: scrollBox,
    //   );
    // }

    return Center(child: scrollBox);
    //});
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

  Widget _drawPage(BuildContext context) {
    return Consumer<PageManager>(builder: (context, pageManager, child) {
      PageModel? pageModel = pageManager.getSelected() as PageModel?;
      if (pageModel == null) {
        return const SizedBox.shrink();
      }
      pageModel.width.set(_bookModel.width.value, save: false, noUndo: true);
      pageModel.height.set(_bookModel.height.value, save: false, noUndo: true);
      logger.fine('PageMain Invoked ***** ${pageModel.width.value}');

      return PageMain(
        key: ValueKey(pageModel.mid),
        bookModel: _bookModel,
        pageModel: pageModel,
        pageWidth: pageWidth,
        pageHeight: pageHeight,
      );
    });
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

  void _globalToggleMute() {
    StudioVariables.isMute = !StudioVariables.isMute;
    LoginPage.userPropertyManagerHolder?.setMute(StudioVariables.isMute);
    if (BookMainPage.pageManagerHolder == null) {
      return;
    }
    PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
    if (pageModel == null) {
      return;
    }
    FrameManager? frameManager = BookMainPage.pageManagerHolder!.findFrameManager(pageModel.mid);
    if (frameManager == null) {
      return;
    }
    if (StudioVariables.isMute == true) {
      logger.info('frameManager.setSoundOff()--------');
      frameManager.setSoundOff();
    } else {
      logger.info('frameManager.resumeSound()--------');
      frameManager.resumeSound();
    }
  }

  void _globalToggleAutoPlay() {
    StudioVariables.isAutoPlay = !StudioVariables.isAutoPlay;
    LoginPage.userPropertyManagerHolder?.setAutoPlay(StudioVariables.isAutoPlay);
    if (BookMainPage.pageManagerHolder == null) {
      return;
    }
    PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
    if (pageModel == null) {
      return;
    }
    FrameManager? frameManager = BookMainPage.pageManagerHolder!.findFrameManager(pageModel.mid);
    if (frameManager == null) {
      return;
    }
    if (StudioVariables.isAutoPlay == true) {
      logger.info('frameManager.resume()--------');
      frameManager.resume();
    } else {
      logger.info('frameManager.pause()--------');
      frameManager.pause();
    }
  }
}
