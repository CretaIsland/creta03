// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'dart:async';
import 'dart:math';

import 'package:creta03/pages/studio/book_main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../../data_io/contents_manager.dart';
import '../../../data_io/frame_manager.dart';
import 'package:hycop/hycop.dart';
import 'package:provider/provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:creta_common/common/creta_common_utils.dart';

import 'package:creta_common/common/window_screenshot.dart';
import '../../../data_io/link_manager.dart';
import '../../../data_io/page_manager.dart';
import '../../../design_system/buttons/creta_button.dart';
import '../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../design_system/buttons/creta_label_text_editor.dart';
import '../../../design_system/buttons/creta_toggle_button.dart';
import '../../../design_system/component/creta_right_mouse_menu.dart';
import '../../../design_system/component/tree/my_tree_view.dart';
//import '../../../design_system/component/tree/src/models/node.dart';
import '../../../design_system/component/tree/src/models/node.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
import '../../../design_system/dialog/creta_alert_dialog.dart';
import '../../../design_system/menu/creta_popup_menu.dart';
import '../../../lang/creta_studio_lang.dart';
import 'package:creta_studio_model/model/book_model.dart';
import 'package:creta_studio_model/model/contents_model.dart';
import 'package:creta_common/model/creta_model.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import 'package:creta_studio_model/model/link_model.dart';
import 'package:creta_studio_model/model/page_model.dart';
import '../../../model/template_model.dart';
import '../containees/containee_nofifier.dart';
import '../containees/page/page_thumbnail.dart';
import '../studio_constant.dart';
import '../studio_variables.dart';

class LeftMenuPage extends StatefulWidget {
  static GlobalObjectKey<MyTreeViewState> treeViewKey =
      GlobalObjectKey<MyTreeViewState>('treeViewKey');
  static bool _flipToTree = true;
  static bool get flipToTree => _flipToTree;
  static List<Node> _nodes = [];
  static final Map<String, ContaineeEnum> _nodeKeys = {};
  static final Map<String, CretaModel> _nodeModels = {};
  static List<Node> get nodes => _nodes;
  static Map<String, ContaineeEnum> get nodeKeys => _nodeKeys;

  static Future<void> treeInvalidate() async {
    if (LeftMenuPage._flipToTree == false) {
      LeftMenuPage.treeViewKey.currentState?.setSelectedNode();
    }
  }

  static CretaModel? findModel(String key) {
    //print('findModel : $key');
    return _nodeModels[key];
  }

  static List<Node<dynamic>>? findChildren(String key) => _findChildren(key, _nodes);
  static List<Node<dynamic>>? _findChildren(String key, List<Node<dynamic>> pnodes) {
    //print('findChildren : $key');
    for (var ele in pnodes) {
      if (ele.key == key) {
        return ele.children;
      }
    }
    for (var ele in pnodes) {
      return _findChildren(key, ele.children);
    }
    return null;
  }

  static void _initNodeKeys(List<Node> pnodes) {
    for (Node ele in pnodes) {
      _nodeKeys[ele.key] = ele.keyType;
      _nodeModels[ele.key] = ele.data;
      _initNodeKeys(ele.children);
    }
  }

  static void initTreeNodes({PageManager? pageManager}) {
    //print('-------------initTreeNodes()------------------');
    pageManager ??= BookMainPage.pageManagerHolder;
    if (pageManager == null) return;
    PageModel? selectedModel = pageManager.getSelected() as PageModel?;
    if (selectedModel == null) {
      logger.warning('pageManagerHolder is not inited');
      // _nodes = [
      //   Node(
      //       label: 'samples',
      //       key: 'key',
      //       expanded: true,
      //       icon: Icons.folder_open, //Icons.folder,
      //       children: []),
      // ];
      return;
    }
    logger.fine('pageManagerHolder is inited');
    LeftMenuPage._nodes.clear();
    LeftMenuPage._nodes = pageManager.toNodes(selectedModel);
    _initNodeKeys(LeftMenuPage._nodes);
    // LeftMenuPage._nodes =
    //     BookMainPage.bookManagerHolder!.toNodes(pageManager.bookModel!, pageManager);
  }

  final bool isFolded;

  const LeftMenuPage({super.key, this.isFolded = false});

  @override
  State<LeftMenuPage> createState() => LeftMenuPageState();
}

class LeftMenuPageState extends State<LeftMenuPage> {
  PageManager? _pageManager;
  late ScrollController _scrollController;
  final GlobalKey<CretaLabelTextEditorState> textFieldKey = GlobalKey<CretaLabelTextEditorState>();
  TextEditingController templateNameController = TextEditingController();

  final double verticalPadding = 10;
  final double horizontalPadding = 19;
  //final double cardHeight = 246;
  final double headerHeight = 36;

  final double borderThick = 4;

  late double bodyHeight;
  late double bodyWidth;
  late double cardHeight;
  late double addCardSpace;

  late double _bodyHeight; // ----------------- added by Mai 230518
  late double _bodyWidth; // ----------------- added by Mai 230518
  late double _cardHeight; // ----------------- added by Mai 230518
  late double _addCardSpace; // ----------------- added by Mai 230519
  double widthScale = 1;

  int _pageCount = 0;
  bool _buildComplete = false;
  late GlobalObjectKey _pageViewKey;

  Timer? _screenshotTimer;
  Rect? _thumbArea;

  bool _resetPostion = false;
  bool _saveAsSharedTemplate = false;

  //bool _flipToTree = true;

  //final int _firstPage = 100;

  //OffsetEventController? _linkSendEvent;

  // void _scrollListener() {
  //   setState(() {
  //     scrollOffset = _scrollController.offset;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    //_scrollController.addListener(_scrollListener);
    logger.finer('LeftMenuPageState.initState');
    bodyWidth = LayoutConst.leftMenuWidth - horizontalPadding * 2;
    //bodyHeight = cardHeight - headerHeight;
    bodyHeight = bodyWidth * (1080 / 1920);
    cardHeight = bodyHeight + headerHeight;
    addCardSpace = headerHeight + verticalPadding;
    _pageViewKey = GlobalObjectKey('pageViewKey');
    _scrollController = ScrollController(initialScrollOffset: 0.0);
    _scrollController.addListener(() {
      // ScrollDirection scrollDirection = _scrollController.position.userScrollDirection;

      // if (_pageManager != null) {
      //   PageModel? page = _pageManager!.getSelected() as PageModel?;
      //   if (page != null && page.pageIndex >= 0) {
      //
      //     if (scrollDirection != ScrollDirection.idle) {
      //       double scrollEnd = _scrollController.offset +
      //           (scrollDirection == ScrollDirection.reverse
      //               ? (cardHeight - 80)
      //               : -(cardHeight - 80));
      //                 scrollEnd = min(_scrollController.position.maxScrollExtent,
      //           max(_scrollController.position.minScrollExtent, scrollEnd));
      //       _scrollController.jumpTo(scrollEnd);
      //     }
      //   }
      // }
    });

    //final OffsetEventController linkSendEvent = Get.find(tag: 'on-link-to-link-widget');
    //_linkSendEvent = linkSendEvent;
    afterBuild();
  }

  void resetPosition() {
    setState(() {
      _resetPostion = true;
    });
  }

  Future<void> afterBuild() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _buildComplete = true;
      if (!StudioVariables.isPreview && widget.isFolded == false) {
        _startScreenshotTimer();
      }
    });
  }

  @override
  void dispose() {
    //_scrollController.stop();
    logger.fine('left_menu_page disposed..........................');
    LeftMenuPage._nodes.clear();
    _stopScreenshotTimer();
    super.dispose();
  }

  void _resize() {
    if (widget.isFolded) {
      widthScale = LayoutConst.leftMenuWidthCollapsed / LayoutConst.leftMenuWidth;
      _bodyWidth = LayoutConst.leftMenuWidthCollapsed - horizontalPadding * widthScale * 2;
    } else {
      widthScale = 1;
      _bodyWidth = LayoutConst.leftMenuWidth - horizontalPadding * widthScale * 2;
    }
    _bodyHeight = bodyHeight * widthScale;
    // _bodyWidth = bodyWidth * widthScale;

    _cardHeight = cardHeight * widthScale;
    _addCardSpace = addCardSpace * widthScale;
  }

  @override
  Widget build(BuildContext context) {
    if (_resetPostion) {
      _moveToPageEnd();
    }
    return Consumer<PageManager>(builder: (context, pageManager, child) {
      _pageManager = pageManager;
      pageManager.reOrdering();
      pageManager.resetPageSize();
      _pageCount = pageManager.getAvailLength();

      if (pageManager.getSelected() == null && _pageCount > 0) {
        pageManager.setSelected(0);

        BookMainPage.containeeNotifier!.set(ContaineeEnum.Page);
      }
      _resize();
      return Stack(
        children: [
          Column(
            children: [
              _menuBar(),
              LeftMenuPage._flipToTree ? _pageView() : _treeView(),
            ],
          ),
        ],
      );
    });
  }

  Widget _menuBar() {
    return Container(
      height: LayoutConst.leftMenuBarHeight,
      color: CretaColor.text[100]!,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: BTN.fill_gray_100_i_m(
                tooltip: CretaStudioLang['newPage']!,
                tooltipBg: CretaColor.text[700]!,
                icon: Icons.add_outlined,
                onPressed: (() {
                  _pageManager!.createNextPage(_pageCount + 1);
                  _moveToPageEnd();
                })),
          ),
          //BTN.fill_gray_100_i_s(icon: Icons.delete_outlined, onPressed: (() {})),
          if (!widget.isFolded)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: BTN.fill_gray_100_i_m(
                  tooltip: CretaStudioLang['treePage']!,
                  tooltipBg: CretaColor.text[700]!,
                  icon: LeftMenuPage._flipToTree
                      ? Icons.account_tree_outlined
                      : Icons.splitscreen_outlined,
                  onPressed: (() {
                    setState(
                      () {
                        LeftMenuPage._flipToTree = !LeftMenuPage._flipToTree;
                      },
                    );
                    BookMainPage.leftMenuNotifier?.notify();
                  })),
            ),
        ],
      ),
    );
  }

  Widget _pageView() {
    return Container(
        padding: const EdgeInsets.only(top: 10),
        height: StudioVariables.workHeight - 100,
        //color: Colors.amber,
        child: ReorderableListView(
          key: _pageViewKey,
          buildDefaultDragHandles: false,
          scrollController: _scrollController,
          children: [
            ..._cardList(),
            _addCard(),
            _emptyCard(),
          ],
          onReorder: (oldIndex, newIndex) {
            logger.finest('oldIndex=$oldIndex, newIndex=$newIndex');
            CretaModel? target = _pageManager!.getNthModel(oldIndex);
            if (target != null) {
              setState(() {
                target.order.set(
                  _pageManager!.getBetweenOrder(newIndex),
                );
              });
            }
          },
        ));
  }

  Widget _treeView() {
    LeftMenuPage.initTreeNodes(pageManager: _pageManager);
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      height: StudioVariables.workHeight - 100,
      child: MyTreeView(
        key: LeftMenuPage.treeViewKey,
        //nodes: LeftMenuPage._nodes,
        pageManager: _pageManager!,
        removePage: _pageManager!.removePage,
        removeFrame: _removeFrame,
        removeContents: _removeContents,
        removeLink: _removeLink,
        showUnshow: (model, index) {
          BookMainPage.containeeNotifier!.notify();
          if (model is PageModel || model is FrameModel) {
            _pageManager!.notify();
          } else if (model is ContentsModel) {
            FrameManager? frameManager = _pageManager!.findCurrentFrameManager();
            //frameManager?.notify();
            if (frameManager != null) {
              ContentsManager? contentsManager =
                  frameManager.getContentsManager(model.parentMid.value);
              //contentsManager?.notify();
              contentsManager?.afterShowUnshow(model, index, null);
            }
          }
          //...more...
        },
      ),
    );
  }

  List<Widget> _cardList() {
    if (_pageManager!.getAvailLength() == 0) {
      logger.finest('_pageManager!.modelList is empty');
      return [];
    }
    int count = 0;
    List<Widget> retval = [];
    List<CretaModel> orderList = _pageManager!.copyOrderMap();
    for (var ele in orderList) {
      PageModel page = ele as PageModel;
      retval.add(eachCard(count, page));
      count++;
      if (count == 99) {
        break;
      }
    }
    return retval;
  }

  Widget eachCard(int pageIndex, PageModel model) {
    //logger.finest('eachCard($pageIndex)');
    return ReorderableDragStartListener(
      key: ValueKey(model.mid),
      index: pageIndex,
      child: Column(children: [
        Container(
          margin: EdgeInsets.symmetric(
              vertical: verticalPadding * widthScale, horizontal: horizontalPadding * widthScale),
          //height: pageIndex == _pageCount - 1 ? cardHeight * 3 : cardHeight,
          height: _cardHeight,
          child: Column(
            children: [
              if (!widget.isFolded) _header(pageIndex, model),
              _body(pageIndex, model),
              //pageIndex == _pageCount - 1 ? _emptyCard() : Container(),
            ],
          ),
        ),
      ]),
      //),
    );
  }

  Widget _header(int pageIndex, PageModel model) {
    return SizedBox(
      //color: Colors.amber,
      height: headerHeight,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  (pageIndex + 1).toString().padLeft(2, '0'),
                  style: model.isShow.value
                      ? CretaFont.titleSmall
                      : CretaFont.titleSmall.copyWith(color: CretaColor.text[300]!),
                ),
                const SizedBox(width: 10),
                CretaLabelTextEditor(
                  textFieldKey: textFieldKey,
                  text: model.name.value,
                  textStyle: model.isShow.value
                      ? CretaFont.titleSmall
                      : CretaFont.titleSmall.copyWith(color: CretaColor.text[300]!),
                  width: 160,
                  height: 20,
                  onEditComplete: (value) {
                    setState(() {
                      model.name.set(value);
                    });
                  },
                  onLabelHovered: () {},
                ),
              ],
            ),
            Row(
              children: [
                if (_pageManager!.isSelected(model.mid) == false)
                  BTN.fill_blue_i_menu(
                      tooltip: CretaStudioLang['linkFrameTooltip']!,
                      tooltipFg: CretaColor.text,
                      icon: LinkParams.isLinkNewMode
                          ? Icons.close
                          : Icons.radio_button_checked_outlined,
                      decoType: CretaButtonDeco.opacity,
                      iconColor: CretaColor.primary,
                      buttonColor: CretaButtonColor.primary,
                      onPressed: () {
                        logger.fine("page header onPageLink");
                        //BookMainPage.containeeNotifier!.setFrameClick(true);
                        //BookMainPage.containeeNotifier!.set(ContaineeEnum.Page);
                        setState(() {
                          LinkParams.isLinkNewMode = !LinkParams.isLinkNewMode;
                        });
                        if (LinkParams.isLinkNewMode) {
                          if (LinkParams.linkNew(model)) {
                            //_linkSendEvent?.sendEvent(Offset(1, 1));
                            BookMainPage.bookManagerHolder?.notify();
                          }
                        } else {
                          LinkParams.linkCancel(model);
                        }
                      }),
                BTN.fill_gray_i_m(
                    tooltip: CretaStudioLang['copy']!,
                    tooltipBg: CretaColor.text[700]!,
                    icon: Icons.content_copy_outlined,
                    onPressed: () async {
                      //PageModel? page = _pageManager!.getSelected() as PageModel?;
                      //if (page != null) {
                      await _pageManager?.copyPage(model);
                      setState(() {});
                    }),
                BTN.fill_gray_i_m(
                  tooltip: model.isTimeBase()
                      ? CretaStudioLang['timeBasePage']!
                      : CretaStudioLang['showUnshow']!,
                  tooltipBg: CretaColor.text[700]!,
                  icon: model.isTimeBase()
                      ? Icons.timer_outlined
                      : model.isShow.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                  onPressed: () {
                    if (model.isTimeBase() == false) {
                      _showUnshowPage(model);
                    }
                  },
                ),
                BTN.fill_gray_image_m(
                  tooltip: CretaStudioLang['tooltipDelete']!,
                  tooltipBg: CretaColor.text[700]!,
                  iconImageFile: "assets/delete.svg",
                  onPressed: () {
                    // Delete Page
                    logger.fine('remove page');
                    _pageManager!.removePage(model);
                    //mychangeStack.startTrans();
                    // model.isRemoved.set(true);
                    // _pageManager!.removeChild(model.mid).then((value) {
                    //   mychangeStack.endTrans();
                    //   if (_pageManager!.isSelected(model.mid)) {
                    //     _pageManager!.gotoFirst();
                    //   } else {
                    //     _pageManager!.notify();
                    //   }
                    //   return null;
                    // });
                  },
                ),
                if (_pageManager!.isSelected(model.mid) == true)
                  BTN.fill_gray_i_m(
                    tooltip: CretaStudioLang['newTemplate']!,
                    tooltipBg: CretaColor.text[700]!,
                    icon: Icons.file_copy,
                    onPressed: () {
                      _saveAsTemplate(model);
                    },
                  ),
                //  BTN.fill_gray_i_m(
                //   tooltip: CretaStudioLang['tooltipDelete']!,
                //   tooltipBg: CretaColor.text[700]!,
                //   icon: Icons.delete_outlined,
                //   onPressed: () {
                //     // Delete Page
                //     model.isRemoved.set(true);
                //     _pageManager!.notify();
                //   },
                // ),
              ],
            ),
          ]),
    );
  }

  void _showUnshowPage(PageModel model) {
    model.isShow.set(!(model.isShow.value));
    _pageManager?.notify();
    // if (LeftMenuPage.treeViewKey.currentState != null && LeftMenuPage._flipToTree == false) {
    //   LeftMenuPage.treeViewKey.currentState?.treeInvalidate();
    // }
  }

  // void _removePage(PageModel model) {
  //   mychangeStack.startTrans();
  //   model.isRemoved.set(
  //     true,
  //     doComplete: (val) {
  //       if (_pageManager!.isSelected(model.mid)) {
  //         if (!_pageManager!.gotoNext()) {
  //           !_pageManager!.gotoPrev();
  //         }
  //       }
  //     },
  //   );
  //   _pageManager!.removeChild(model.mid).then((value) {
  //     //mychangeStack.endTrans();
  //     if (_pageManager!.isSelected(model.mid)) {
  //       if (!_pageManager!.gotoNext()) {
  //         !_pageManager!.gotoPrev();
  //       }
  //     }
  //     _pageManager!.notify();
  //     LeftMenuPage.treeInvalidate();
  //     return;
  //   });
  // }

  Future<void> _removeFrame(FrameModel frame) async {
    mychangeStack.startTrans();
    FrameManager? frameManager = _pageManager!.findFrameManager(frame.parentMid.value);
    frame.isRemoved.set(true);
    await frameManager!.removeChild(frame.mid);
    mychangeStack.endTrans();
    BookMainPage.containeeNotifier!.set(ContaineeEnum.Page, doNoti: true);
    _pageManager!.notify();
    LeftMenuPage.treeInvalidate();
  }

  void _removeContents(ContentsModel contents) {
    String pageMid = _pageManager!.getSelectedMid();
    FrameManager? frameManager = _pageManager!.findFrameManager(pageMid);
    if (frameManager == null) {
      logger.severe('Invalid pageMid $pageMid');
      return;
    }
    ContentsManager? contentsManager = frameManager.getContentsManager(contents.parentMid.value);
    if (contentsManager == null) {
      return;
    }
    BookMainPage.containeeNotifier!.setFrameClick(true);
    contentsManager.removeSelected(context).then((value) {
      BookMainPage.containeeNotifier!.notify();
      //_pageManager!.notify();
      frameManager.notify();
      Future.delayed(const Duration(seconds: 1)).then((value) {
        LeftMenuPage.treeInvalidate();
        return null;
      });
      return null;
    });
  }

  void _removeLink(LinkModel link) async {
    String pageMid = _pageManager!.getSelectedMid();
    FrameManager? frameManager = _pageManager!.findFrameManager(pageMid);
    if (frameManager == null) {
      logger.severe('Invalid pageMid $pageMid');
      return;
    }
    String frameModelMid = frameManager.getSelectedMid();
    ContentsManager? contentsManager = frameManager.findContentsManagerByMid(frameModelMid);
    if (contentsManager == null) {
      return;
    }
    LinkManager? linkManager = contentsManager.findLinkManager(
      link.parentMid.value,
      createIfNotExist: false,
    );
    if (linkManager == null) {
      return;
    }

    BookMainPage.containeeNotifier!.setFrameClick(true);
    await linkManager.delete(link: link);
    linkManager.reOrdering();
    LeftMenuPage.initTreeNodes();
    LeftMenuPage.treeInvalidate();
  }

  Widget _body(int pageIndex, PageModel model) {
    //logger.finest('_body($bodyHeight, $bodyWidth)');

    double pageRatio = _pageManager!.bookModel!.getRatio();
    double width = 0;
    double height = 0;
    double pageHeight = 0;
    double pageWidth = 0;

    // 실제 페이지를 그리는 부분
    Widget drwaArea = LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      // width = constraints.maxWidth - borderThick * 2;
      // height = constraints.maxHeight - borderThick * 2;
      width = constraints.maxWidth;
      height = constraints.maxHeight;
      if (pageRatio > 1) {
        // 세로형
        pageHeight = height;
        pageWidth = pageHeight * (1 / pageRatio);
      } else {
        // 가로형
        pageWidth = width;
        pageHeight = pageWidth * pageRatio;
        if (pageHeight > height) {
          // 화면에서 page 를 표시하는 영역은 항상 가로형으로 항상 세로는
          // 가로보다 작다.  이러다 보니, 세로 사이지그 화면의 영역을 오버하는
          // 경우가 생기게 된다.  그러나 세로형의 경우는 이런 일이 발생하지 않는다.
          pageHeight = height;
          pageWidth = pageHeight * (1 / pageRatio);
        }
      }
      //logger.finest("pl:width=$width, height=$height, ratio=$pageRatio");
      //logger.finest("pl:pageWidth=$pageWidth, pageHeight=$pageHeight");
      return SafeArea(
        child: Container(
          height: pageHeight,
          width: pageWidth,
          decoration: BoxDecoration(
            border: Border.all(
                width: borderThick,
                color: _pageManager!.isSelected(model.mid)
                    ? CretaColor.primary
                    : CretaColor.text[300]!),
            color:
                _pageManager!.isSelected(model.mid) ? CretaColor.text[100]! : CretaColor.text[200]!,
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              //_thumnailArea(pageWidth, pageHeight, model.thumbnailUrl.value),
              widget.isFolded
                  ? Container(
                      color: Colors.white,
                      child: Center(
                        child: Text(
                          (pageIndex + 1).toString().padLeft(2, '0'),
                          style: model.isShow.value
                              ? CretaFont.titleLarge
                              : CretaFont.titleLarge.copyWith(color: CretaColor.text[300]!),
                        ),
                      ),
                    )
                  : _thumnailAreaReal(pageIndex, pageWidth, pageHeight, model),
              if (model.isShow.value == false)
                Container(
                    height: pageHeight, width: pageWidth, color: Colors.white.withOpacity(0.75)),
            ],
          ),
        ),
      );
    });

    Widget timeBase = Container(
      color: Colors.white.withOpacity(0.5),
      height: _bodyHeight - borderThick * 2,
      width: _bodyWidth - borderThick * 2,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${model.startDate.value} ${model.startTime.value}',
              style: CretaFont.titleMedium.copyWith(color: CretaColor.primary),
            ),
            Text(
              '${model.endDate.value} ${model.endTime.value}',
              style: CretaFont.titleMedium.copyWith(color: CretaColor.primary),
            ),
          ],
        ),
      ),
    );

    return GestureDetector(
      key: ValueKey(model.mid),
      onTapDown: (details) {
        //setState(() {
        logger.finest('selected = ${model.mid}');
        _pageManager!.setSelectedMid(model.mid);
        //print('222222222');

        BookMainPage.containeeNotifier!.set(ContaineeEnum.Page);
        //BookMainPage.bookManagerHolder?.notify();
        //});
      },
      onDoubleTapDown: (details) {
        logger.finest('double clicked = $model.id');
        logger.finest('dx=${details.localPosition.dx}, dy=${details.localPosition.dx}');
      },
      onSecondaryTapDown: (details) {
        if (StudioVariables.isPreview) {
          return;
        }
        logger.fine('right mouse button clicked ${details.globalPosition}');
        logger.fine('right mouse button clicked ${details.localPosition}');
        CretaRightMouseMenu.showMenu(
          title: 'leftRightMouseMenu',
          context: context,
          popupMenu: [
            CretaMenuItem(
                caption: CretaStudioLang['copy']!,
                onPressed: () {
                  StudioVariables.clipPage(model, _pageManager!);
                  //widget.onFrameShowUnshow.call(frameModel.mid);
                }),
            CretaMenuItem(
                caption: CretaStudioLang['crop']!,
                onPressed: () {
                  model.isRemoved.set(true);
                  StudioVariables.cropPage(model, _pageManager!);
                  _pageManager?.notify();
                  //widget.onFrameShowUnshow.call(frameModel.mid);
                }),
            CretaMenuItem(
                disabled:
                    StudioVariables.clipBoard != null && StudioVariables.clipBoardDataType == 'page'
                        ? false
                        : true,
                caption: CretaStudioLang['paste']!,
                onPressed: () {
                  if (StudioVariables.clipBoard is PageModel?) {
                    PageModel? page = StudioVariables.clipBoard as PageModel?;
                    PageManager? srcManager = StudioVariables.clipBoardManager as PageManager?;
                    if (page != null && srcManager != null) {
                      _pageManager?.copyPage(page,
                          srcPageManager: srcManager, targetOrder: model.order.value);
                    }
                  }
                }),
            // if (_pageManager!.isSelected(model.mid) == true)
            //   CretaMenuItem(
            //       caption: CretaStudioLang['newTemplate']!,
            //       onPressed: () async {
            //         Navigator.of(context).pop();
            //         await _saveAsTemplate(model);
            //         //widget.onFrameShowUnshow.call(frameModel.mid);
            //       }),
          ],
          itemHeight: 24,
          x: details.globalPosition.dx,
          y: details.globalPosition.dy,
          width: 224,
          height: 110,
          //textStyle: CretaFont.bodySmall,
          iconSize: 12,
          alwaysShowBorder: true,
          borderRadius: 8,
        );
      },
      child: (model.isTimeBase() == true)
          ? Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: _bodyHeight,
                  width: _bodyWidth,
                  child: drwaArea,
                ),
                timeBase,
              ],
            )
          : SizedBox(
              height: _bodyHeight,
              width: _bodyWidth,
              child: drwaArea,
            ),
    );
  }

  Future<void> _saveAsTemplate(PageModel pageModel) async {
    bool isCancel = false;
    String? templateName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return CretaAlertDialog(
          title: CretaStudioLang['inputTemplateName']!,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: templateNameController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: CretaStudioLang['inputTemplateName']!,
                ),
                onSubmitted: (value) {
                  Navigator.of(context).pop(value);
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 28.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(CretaStudioLang['saveAsSharedTemplate']!, style: CretaFont.bodyMedium),
                  CretaToggleButton(
                      width: 54,
                      height: 28,
                      onSelected: (value) {
                        setState(() {
                          _saveAsSharedTemplate = value;
                        });
                      },
                      defaultValue: _saveAsSharedTemplate),
                ]),
              ),
            ],
          ),
          onPressedOK: () {
            Navigator.of(context).pop(templateNameController.text);
          },
          onPressedCancel: () {
            Navigator.of(context).pop(templateNameController.text);
            isCancel = true;
          },
        );
      },
    );

    if (isCancel) {
      return;
    }
    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(CretaStudioLang['templateCreating']!, style: CretaFont.bodyMedium),
              ),
            ],
          ),
        );
      },
    );

    await takePageScreenShot();

    if (templateName != null && templateName.isNotEmpty) {
      String? alreadyExistMid = await BookMainPage.templateManagerHolder!
          .isAlreadyExis(realTimeKey: pageModel.mid, name: templateName);

      String userEmail =
          _saveAsSharedTemplate ? 'SHARED_TEMPLATE' : AccountManager.currentLoginUser.email;
      TemplateModel templateModel = TemplateModel(alreadyExistMid ?? '');

      //print('pageModel.thumbnailUrl = ${pageModel.thumbnailUrl.value}');

      templateModel.copyFrom(pageModel, newMid: alreadyExistMid);
      templateModel.parentMid.set(userEmail);
      templateModel.name.set(templateName);
      templateModel.setRealTimeKey(pageModel.mid);

      //print('templateModel.thumbnailUrl = ${templateModel.thumbnailUrl.value}');

      String message = CretaStudioLang['templateCreated']!;
      if (alreadyExistMid != null) {
        BookMainPage.templateManagerHolder!.setToDB(templateModel);
        message = CretaStudioLang['templateUpdated']!;
      } else {
        BookMainPage.templateManagerHolder!.createToDB(templateModel);
      }
      FrameManager? frameManager = BookMainPage.pageManagerHolder!.findCurrentFrameManager();
      if (frameManager == null) {
        return;
      }
      frameManager.copyFrames(templateModel.mid, userEmail, samePage: false);
      // ignore: use_build_context_synchronously

      // ignore: use_build_context_synchronously
      showSnackBar(context, message);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }
  }
  // Widget _thumnailArea(double width, double height, String url) {
  //   return CustomImage(
  //       key: UniqueKey(),
  //       hasMouseOverEffect: false,
  //       hasAni: false,
  //       width: width,
  //       height: height,
  //       image: url);
  // }

  Widget _thumnailAreaReal(int pageIndex, double width, double height, PageModel pageModel) {
    // if (pageModel.thumbnailUrl.value.isNotEmpty &&
    //     pageModel.thumbnailUrl.value.substring(0, 'https://picsum.photos/'.length) !=
    //         'https://picsum.photos/') {
    //   logger.fine('pageThumnail exist ${pageModel.thumbnailUrl.value}');

    //   if (pageModel.isShow.value) {
    //     if (_firstPage > pageIndex) {
    //       _firstPage = pageIndex;
    //       _pageManager!.bookModel!.thumbnailUrl.set(pageModel.thumbnailUrl.value);
    //     }
    //   }

    //   return CustomImage(
    //       key: GlobalKey(),
    //       hasMouseOverEffect: false,
    //       hasAni: false,
    //       width: width,
    //       height: height,
    //       image: pageModel.thumbnailUrl.value);
    // }
    //logger.fine('pageThumnail not exist');

    // GlobalObjectKey? thumbKey = _pageManager!.thumbKeyMap[pageModel.mid];
    // if (thumbKey == null) {
    //   thumbKey = GlobalObjectKey('Thumb$pageIndex${pageModel.mid}');
    //   _pageManager!.thumbKeyMap[pageModel.mid] = thumbKey;
    // }
    //print('PageThumbnail---------${pageModel.name.value}----------------------------------------');
    return PageThumbnail(
      key: BookMainPage.pageManagerHolder!.registerPageThumbnail(pageModel.mid),
      pageIndex: pageIndex,
      bookModel: _pageManager!.bookModel!,
      pageModel: pageModel,
      pageWidth: width,
      pageHeight: height,
      changeEventReceived: _changeEventReceived,
    );
  }

  Widget _addCard() {
    // double bodyHeight = cardHeight - headerHeight;
    // double bodyWidth = LayoutConst.leftMenuWidth - horizontalPadding * 2;
    //logger.finest('addCard($bodyHeight,$bodyWidth)');
    return GestureDetector(
      key: UniqueKey(),
      onSecondaryTapDown: (details) {
        if (StudioVariables.isPreview) {
          return;
        }
        logger.fine('right mouse button clicked ${details.globalPosition}');
        logger.fine('right mouse button clicked ${details.localPosition}');
        CretaRightMouseMenu.showMenu(
          title: 'leftAddRightMouseMenu',
          context: context,
          popupMenu: [
            CretaMenuItem(
                disabled:
                    StudioVariables.clipBoard != null && StudioVariables.clipBoardDataType == 'page'
                        ? false
                        : true,
                caption: CretaStudioLang['paste']!,
                onPressed: () {
                  if (StudioVariables.clipBoard is PageModel?) {
                    PageModel? page = StudioVariables.clipBoard as PageModel?;
                    PageManager? srcManager = StudioVariables.clipBoardManager as PageManager?;
                    if (page != null && srcManager != null) {
                      _pageManager?.copyPage(page,
                          srcPageManager: srcManager, targetOrder: _pageManager!.lastOrder());
                    }
                  }
                }),
          ],
          itemHeight: 24,
          x: details.globalPosition.dx,
          y: details.globalPosition.dy,
          width: 150,
          height: 36,
          //textStyle: CretaFont.bodySmall,
          iconSize: 12,
          alwaysShowBorder: true,
          borderRadius: 8,
        );
      },
      child: Column(
        children: [
          SizedBox(
            height: _addCardSpace,
          ),
          DottedBorder(
            dashPattern: const [6, 6],
            strokeWidth: borderThick / 2,
            strokeCap: StrokeCap.round,
            color: CretaColor.primary[300]!,
            // padding: EdgeInsets.symmetric(horizontal: horizontalPadding * widthScale),
            child: SizedBox(
              // 실제 페이지를 그리는 부분
              height: _bodyHeight,
              width: _bodyWidth,
              // decoration: BoxDecoration(
              //   border: Border.all(width: 2, color: CretaColor.text[300]!),
              // ),

              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //_addButton(),
                    BTN.fill_blue_i_l(
                        size: widget.isFolded ? Size(25, 25) : Size(48, 48),
                        icon: Icons.add_outlined,
                        onPressed: () {
                          setState(() {
                            _pageManager!.createNextPage(_pageCount + 1);
                          });
                        }),
                    SizedBox(height: widget.isFolded ? 12 * widthScale : 12), // added by Mai 230516
                    if (!widget.isFolded)
                      Text(
                        CretaStudioLang['newPage']!,
                        style: CretaFont.buttonLarge,
                      )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyCard() {
    // double bodyHeight = cardHeight - headerHeight;
    // double bodyWidth = LayoutConst.leftMenuWidth - horizontalPadding * 2;
    logger.fine('emptyCard($bodyHeight,$bodyWidth)');
    return SizedBox(
      key: UniqueKey(),
      height: _bodyHeight + 20,
      width: _bodyWidth,
    );
  }

  void _changeEventReceived(String pageMid) {
    if (widget.isFolded) {
      return;
    }

    if (_buildComplete == false) {
      return;
    }
    if (_pageCount <= 1) {
      return;
    }
    if (_pageManager == null) {
      return;
    }
    PageModel? selected = _pageManager!.getSelected() as PageModel?;
    if (selected == null) {
      return;
    }
    if (pageMid != selected.mid) {
      return;
    }

    Rect? pageViewArea = CretaCommonUtils.getArea(_pageViewKey);
    if (pageViewArea == null) {
      return;
    }
    _thumbArea = BookMainPage.pageManagerHolder!.getThumbImageArea();

    bool contained = false;
    if (_thumbArea != null) {
      contained = CretaCommonUtils.isRectContained(pageViewArea, _thumbArea!);
    }
    if (contained) {
      return;
    }

    int pageIndex = _pageManager!.getPageIndex(pageMid);
    if (pageIndex < 0) {
      return;
    }

    ScrollDirection scrollDirection = _scrollController.position.userScrollDirection;
    if (scrollDirection != ScrollDirection.idle) {
      return;
    }
    double fullCardHeight = cardHeight + verticalPadding * widthScale * 2;

    double scrollEnd = pageIndex * fullCardHeight;
    scrollEnd = min(_scrollController.position.maxScrollExtent,
        max(_scrollController.position.minScrollExtent, scrollEnd));

    if (scrollEnd == _scrollController.offset) {
      return;
    }
    // 만약 보이는 전체 면적이 카드 크기 2배보다 작으면,  최상단으로 올린다.
    // 또는 제일 첫번째 카드 여도 마찬가지다.
    if (pageViewArea.height <= fullCardHeight * 2 || pageIndex == 0) {
      _scrollController.jumpTo(scrollEnd);
      return;
    }
    // 그렇지 않다면, 두번째 위치로 놓는다.
    scrollEnd = (pageIndex - 1) * fullCardHeight;
    scrollEnd = min(_scrollController.position.maxScrollExtent,
        max(_scrollController.position.minScrollExtent, scrollEnd));
    _scrollController.jumpTo(scrollEnd);
  }

  void _startScreenshotTimer() {
    _screenshotTimer ??= Timer.periodic(Duration(seconds: 30), (t) {
      if (widget.isFolded) {
        //print('widget is folded');
        return;
      }
      // if (saveManagerHolder!.isSomethingSaved() == false) {
      //   print('isSomethingSaved is false');
      //   return;
      // }
      if (BookMainPage.thumbnailChanged == false) {
        //print('thumbnailChanged is false');
        return;
      }
      Rect? pageViewArea = CretaCommonUtils.getArea(_pageViewKey);
      if (pageViewArea == null) {
        //print('pageViewArea is null');
        return;
      }

      // 제일 첫번째를 가져온다.

      _thumbArea = BookMainPage.pageManagerHolder!.getFirstThumbImageArea();
      if (_thumbArea != null) {
        if (CretaCommonUtils.isRectContained(pageViewArea, _thumbArea!)) {
          // 이미 화면에 완전히 보인다.
          logger.fine('start first _takeAScreenShot()');
          _takeAScreenShot(_thumbArea!);
          //BookMainPage.bookManagerHolder!.notify();
          return;
        } else {
          //print('1. isRectContained is false ');
        }
      } else {
        //print('1._thumbArea is null');
      }

      // 이때는 selecte 된 Page thumbnail 을 찍는 다.
      _thumbArea = BookMainPage.pageManagerHolder!.getThumbImageArea();
      if (_thumbArea != null) {
        if (CretaCommonUtils.isRectContained(pageViewArea, _thumbArea!)) {
          // 이미 화면에 완전히 보인다.
          logger.fine('start selected _takeAScreenShot()');

          _takeAScreenShot(_thumbArea!);
          //BookMainPage.bookManagerHolder!.notify();
          return;
        } else {
          //print('2. isRectContained is false ');
        }
      } else {
        //print('2._thumbArea is null');
      }
    });
  }

  void _stopScreenshotTimer() {
    _screenshotTimer?.cancel();
  }

  void _takeAScreenShot(Rect area) {
    //print('_takeAScreenShot.......');
    BookMainPage.thumbnailChanged = false;
    BookModel? bookModel = BookMainPage.bookManagerHolder!.onlyOne() as BookModel?;
    if (bookModel == null) {
      logger.warning('book model is null');
      return;
    }
    if (bookModel.isAutoThumbnail.value == false) {
      return;
    }

    //print('start uploadScreenshot.......');
    WindowScreenshot.uploadScreenshot(
      bookId: HycopUtils.midToKey(bookModel.mid),
      offset: area.topLeft,
      size: area.size,
    ).then((value) {
      //print('end uploadScreenshot.......');
      BookModel? bookModel = BookMainPage.bookManagerHolder!.onlyOne() as BookModel?;
      if (value.isNotEmpty && bookModel != null) {
        // 기존에 있던 썸네일 파일은 제거 (Hycop 0.4.25)
        HycopFactory.storage!.deleteFileFromUrl(bookModel.thumbnailUrl.value).then((_) {
          bookModel.thumbnailUrl.set(value, noUndo: true, save: false);
          bookModel.thumbnailType.set(ContentsType.image, noUndo: true, save: false);
          logger.info('book Thumbnail saved !!! ${bookModel.mid}, $value');
          // 재귀적으로 계속 변경이 일어난 것으로 보고 계속 호출되는 것을 막기 위해, DB 에 직접 쓴다.
          BookMainPage.bookManagerHolder?.setToDB(bookModel);
          //print('save thumbnailUrl complete.......');
        });
      }
      return null;
    });
  }

  Future<void> takePageScreenShot() async {
    PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
    if (pageModel == null) {
      return;
    }
    Rect? thumbArea = BookMainPage.pageManagerHolder!.getThumbImageArea();
    if (thumbArea == null) {
      return;
    }

    // print(
    //     '_takeAScreenShot(${thumbArea.left.round()},${thumbArea.top.round()},${thumbArea.width.round()},${thumbArea.height.round()} )');

    String url = await WindowScreenshot.uploadScreenshot(
      bookId: HycopUtils.midToKey(pageModel.mid),
      offset: thumbArea.topLeft,
      size: thumbArea.size,
    );
    if (url.isNotEmpty) {
      // 기존에 있던 썸네일 파일은 제거 (Hycop 0.4.25)
      HycopFactory.storage!.deleteFileFromUrl(pageModel.thumbnailUrl.value).then((value) {
        pageModel.thumbnailUrl.set(url, noUndo: true, save: false);
        //print('page Thumbnail saved !!! ${pageModel.mid}, $url');
        // 재귀적으로 계속 변경이 일어난 것으로 보고 계속 호출되는 것을 막기 위해, DB 에 직접 쓴다.
        BookMainPage.pageManagerHolder?.setToDB(pageModel);
      });
    }

    return;
  }

  void _moveToPageEnd() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent + cardHeight * 3);
  }
}
