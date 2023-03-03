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
import '../../data_io/page_manager.dart';
import '../../data_io/user_property_manager.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/buttons/creta_label_text_editor.dart';
import '../../design_system/buttons/creta_scale_button.dart';
import '../../design_system/component/snippet.dart';
import '../../design_system/creta_color.dart';
import '../../design_system/creta_font.dart';
import '../../model/book_model.dart';
import '../../design_system/component/cross_scrollbar.dart';
import '../../model/creta_model.dart';
import '../../model/page_model.dart';
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
  static bool onceBookInfoOpened = false;
  static BookManager? bookManagerHolder;
  static PageManager? pageManagerHolder;
  // static FrameTemplateManager? polygonFrameManagerHolder;
  // static FrameTemplateManager? animationFrameManagerHolder;
  static UserPropertyManager? userPropertyManagerHolder;
  static ContaineeNotifier? containeeNotifier;

  static LeftMenuEnum selectedStick = LeftMenuEnum.None;

  //static ContaineeEnum selectedClass = ContaineeEnum.Book;

  const BookMainPage({super.key});

  @override
  State<BookMainPage> createState() => _BookMainPageState();
}

class _BookMainPageState extends State<BookMainPage> {
  late BookModel _bookModel;
  bool _onceDBGetComplete = false;
  bool _isFirstOpen = true;
  final GlobalKey<CretaLabelTextEditorState> textFieldKey = GlobalKey<CretaLabelTextEditorState>();

  final ScrollController controller = ScrollController();
  final ScrollController horizontalScroll = ScrollController();
  final ScrollController verticalScroll = ScrollController();

  double pageWidth = 0;
  double pageHeight = 0;
  double heightWidthRatio = 0;
  double widthRatio = 0;
  double heightRatio = 0;
  double applyScale = 1;
  bool scaleChanged = false;

  double padding = 16;

  @override
  void initState() {
    super.initState();
    logger.finest("---_BookMainPageState-----------------------------------------");

    BookMainPage.containeeNotifier = ContaineeNotifier();

    // 같은 페이지에서 객체만 바뀌면 static value 들은 그대로 남아있게 되므로
    // static value 도 초기화해준다.
    //BookMainPage.selectedMid = '';
    BookMainPage.onceBookInfoOpened = false;
    BookMainPage.selectedStick = LeftMenuEnum.None;

    BookMainPage.containeeNotifier!.set(ContaineeEnum.Book, doNoti: false);

    BookMainPage.bookManagerHolder = BookManager();
    BookMainPage.bookManagerHolder!.configEvent(notifyModify: false);
    BookMainPage.bookManagerHolder!.clearAll();
    BookMainPage.pageManagerHolder = PageManager();
    // BookMainPage.polygonFrameManagerHolder = FrameTemplateManager(frameType: FrameType.polygon);
    // BookMainPage.animationFrameManagerHolder = FrameTemplateManager(frameType: FrameType.animation);
    BookMainPage.userPropertyManagerHolder = UserPropertyManager();

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
    BookMainPage.selectedStick = LeftMenuEnum.Page; // 페이지가 열린 상태로 시작하게 한다.
    saveManagerHolder?.runSaveTimer();
  }

  Future<void> initChildren(BookModel model) async {
    saveManagerHolder!.setDefaultBook(model);
    saveManagerHolder!.addBookChildren('book=');
    saveManagerHolder!.addBookChildren('page=');
    saveManagerHolder!.addBookChildren('contents=');

    // Get Pages
    await BookMainPage.pageManagerHolder!.initPage(model);

    // Get Template Frames
    // BookMainPage.polygonFrameManagerHolder!.clearAll();
    // await _getPolygonFrameTemplates();
    // BookMainPage.animationFrameManagerHolder!.clearAll();
    // await _getAnimationFrameTemplates();

    // Get User property
    await BookMainPage.userPropertyManagerHolder!.initUserProperty();

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

  @override
  void dispose() {
    logger.severe('BookMainPage.dispose');

    super.dispose();
    BookMainPage.bookManagerHolder?.removeRealTimeListen();
    BookMainPage.pageManagerHolder?.removeRealTimeListen();
    BookMainPage.pageManagerHolder?.clearFrame();

    saveManagerHolder?.stopTimer();
    saveManagerHolder?.unregisterManager('book');
    saveManagerHolder?.unregisterManager('page');
    saveManagerHolder?.unregisterManager('user');
    controller.dispose();
    verticalScroll.dispose();
    horizontalScroll.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ContaineeNotifier>.value(
          value: BookMainPage.containeeNotifier!,
        ),
        ChangeNotifierProvider<BookManager>.value(
          value: BookMainPage.bookManagerHolder!,
        ),
      ],
      child: Snippet.CretaScaffold(
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
        BookMainPage.userPropertyManagerHolder!,
      ],
      //userId: AccountManager.currentLoginUser.email,
      consumerFunc: consumerFunc,
    );

    //_onceDBGetComplete = true;
    logger.finest('first_onceDBGetComplete');
    return retval;
    //return consumerFunc();
  }

  Widget consumerFunc() {
    logger.finest('consumerFunc');
    return Consumer<BookManager>(builder: (context, bookManager, child) {
      logger.finest('Consumer  ${bookManager.getLength()}');
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
          _topMenu(),
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

    applyScale = StudioVariables.scale / StudioVariables.fitScale;
    if (StudioVariables.autoScale == true || scaleChanged == true) {
      StudioVariables.virtualWidth = StudioVariables.workWidth * applyScale;
      StudioVariables.virtualHeight = StudioVariables.workHeight * applyScale;
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

    logger.finest(
        "height=${StudioVariables.workHeight}, width=${StudioVariables.workWidth}, scale=${StudioVariables.fitScale}}");
  }

  Widget _workArea() {
    return Stack(
      children: [
        _scrollArea(context),
        BookMainPage.selectedStick == LeftMenuEnum.None
            ? Container(width: 0, height: 0, color: Colors.transparent)
            : LeftMenu(
                onClose: () {
                  setState(() {
                    BookMainPage.selectedStick = LeftMenuEnum.None;
                  });
                },
              ),
        _openRightMenu(),
      ],
    );
  }

  Widget _openRightMenu() {
    return Consumer<ContaineeNotifier>(builder: (context, containeeNotifier, child) {
      logger.finest('Consumer  ContaineeNotifier');
      return _shouldRightMenuOpen()
          ? Positioned(
              top: 0,
              left: StudioVariables.workWidth - LayoutConst.rightMenuWidth,
              child: RightMenu(
                onClose: () {
                  setState(() {
                    if (containeeNotifier.selectedClass == ContaineeEnum.Book) {
                      BookMainPage.onceBookInfoOpened = true;
                    }
                    containeeNotifier.clear();
                  });
                },
              )
            )
          : Container(width: 0, height: 0, color: Colors.transparent);
    });
  }

  bool _shouldRightMenuOpen() {
    if (BookMainPage.containeeNotifier!.selectedClass == ContaineeEnum.None) {
      return false;
    }
    if (BookMainPage.containeeNotifier!.selectedClass == ContaineeEnum.Book ||
        _isFirstOpen == true) {
      _isFirstOpen = false;
      if (BookMainPage.onceBookInfoOpened == true) {
        return false;
      }
      return true;
    }
    return true;
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
              BTN.floating_l(
                icon: Icons.volume_off_outlined,
                onPressed: () {},
                hasShadow: false,
                tooltip: CretaStudioLang.tooltipVolume,
              ),
              SizedBox(width: padding),
              BTN.floating_l(
                icon: Icons.pause_outlined,
                onPressed: () {},
                hasShadow: false,
                tooltip: CretaStudioLang.tooltipPause,
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
              setState(() {
                BookMainPage.onceBookInfoOpened = false;
                BookMainPage.containeeNotifier!.set(ContaineeEnum.Book);
              });
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
            onPressed: () {},
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
    // if (StudioVariables.autoScale == true ||
    //     StudioVariables.scale - StudioVariables.fitScale <= 0) {
    if (StudioVariables.autoScale == true) {
      return _drawPage(context);
    }
    double marginX = (StudioVariables.workWidth - StudioVariables.virtualWidth) / 2;
    double marginY = (StudioVariables.workHeight - StudioVariables.virtualHeight) / 2;
    if (marginX < 0) marginX = 0;
    if (marginY < 0) marginY = 0;
    return CrossScrollBar(
      key: GlobalKey(),
      width: StudioVariables.virtualWidth,
      marginX: marginX,
      marginY: marginY,
      child: _drawPage(context),
    );
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
      logger.finest('PageMain Invoked');
      if (pageModel == null) {
        return const SizedBox.shrink();
      }

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
    logger.finest("showLeftMenu ${idx.name}");
    setState(() {
      // if (BookMainPage.selectedStick == idx) {
      //   BookMainPage.selectedStick = LeftMenuEnum.None;
      // } else {
      //   BookMainPage.selectedStick = idx;
      // }
    });
  }
}
