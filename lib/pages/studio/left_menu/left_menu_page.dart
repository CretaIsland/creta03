// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'package:creta03/pages/studio/book_main_page.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
import 'package:provider/provider.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../../data_io/page_manager.dart';
import '../../../design_system/buttons/creta_button.dart';
import '../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../design_system/buttons/creta_label_text_editor.dart';
import '../../../design_system/creta_color.dart';
import '../../../design_system/creta_font.dart';
import '../../../lang/creta_studio_lang.dart';
import '../../../model/creta_model.dart';
import '../../../model/page_model.dart';
import '../containees/containee_nofifier.dart';
import '../containees/page/page_thumbnail.dart';
import '../studio_constant.dart';
import '../studio_variables.dart';

class LeftMenuPage extends StatefulWidget {
  final bool isFolded;

  const LeftMenuPage({super.key, this.isFolded = false});

  @override
  State<LeftMenuPage> createState() => _LeftMenuPageState();
}

class _LeftMenuPageState extends State<LeftMenuPage> {
  PageManager? _pageManager;
  late ScrollController _scrollController;
  final GlobalKey<CretaLabelTextEditorState> textFieldKey = GlobalKey<CretaLabelTextEditorState>();

  final double verticalPadding = 10;
  final double horizontalPadding = 24;
  //final double cardHeight = 246;
  final double headerHeight = 36;
  final double menuBarHeight = 36;

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
    logger.finer('_LeftMenuPageState.initState');
    _scrollController = ScrollController(initialScrollOffset: 0.0);
    bodyWidth = LayoutConst.leftMenuWidth - horizontalPadding * 2;
    //bodyHeight = cardHeight - headerHeight;
    bodyHeight = bodyWidth * (1080 / 1920);
    cardHeight = bodyHeight + headerHeight;
    addCardSpace = headerHeight + verticalPadding;

    //final OffsetEventController linkSendEvent = Get.find(tag: 'on-link-to-link-widget');
    //_linkSendEvent = linkSendEvent;
    afterBuild();
  }

  Future<void> afterBuild() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  @override
  void dispose() {
    //_scrollController.stop();
    super.dispose();
  }

  // ----------------- Added by Mai 230518 -----------------
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
    return Consumer<PageManager>(builder: (context, pageManager, child) {
      _pageManager = pageManager;
      pageManager.reOrdering();
      pageManager.resetPageSize();
      _pageCount = pageManager.getAvailLength();
      logger.finest('PageManager Consumer  $_pageCount');
      if (pageManager.getSelected() == null && _pageCount > 0) {
        pageManager.setSelected(0);
        BookMainPage.containeeNotifier!.set(ContaineeEnum.Page);
      }
      _resize(); // ----------------- Added by Mai 230516 -----------------
      return Column(
        children: [
          _menuBar(),
          _pageView(),
        ],
      );
    });
  }

  Widget _menuBar() {
    return Container(
      height: menuBarHeight,
      color: CretaColor.text[100]!,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: BTN.fill_gray_100_i_m(
                tooltip: CretaStudioLang.newPage,
                tooltipBg: CretaColor.text[700]!,
                icon: Icons.add_outlined,
                onPressed: (() {
                  _pageManager!.createNextPage();
                  _scrollController
                      .jumpTo(_scrollController.position.maxScrollExtent + cardHeight * 3);
                })),
          ),
          //BTN.fill_gray_100_i_s(icon: Icons.delete_outlined, onPressed: (() {})),
          if (!widget.isFolded)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: BTN.fill_gray_100_i_m(
                  tooltip: CretaStudioLang.treePage,
                  tooltipBg: CretaColor.text[700]!,
                  icon: Icons.account_tree_outlined,
                  onPressed: (() {})),
            ),
        ],
      ),
    );
  }

  Widget _pageView() {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      height: StudioVariables.workHeight - 100,
      child: ReorderableListView(
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
              target.order.set(_pageManager!.getBetweenOrder(newIndex));
            });
          }
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
                  width: 180,
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
                      tooltip: CretaStudioLang.linkFrameTooltip,
                      tooltipFg: CretaColor.text,
                      icon: LinkParams.isLinkNewMode
                          ? Icons.close
                          : Icons.radio_button_checked_outlined,
                      decoType: CretaButtonDeco.opacity,
                      iconColor: CretaColor.primary,
                      buttonColor: CretaButtonColor.primary,
                      onPressed: () {
                        logger.info("page header onPageLink");
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
                  tooltip: CretaStudioLang.copy,
                  tooltipBg: CretaColor.text[700]!,
                  icon: Icons.content_copy_outlined,
                  onPressed: () {
                    // Copy Page
                  },
                ),
                BTN.fill_gray_i_m(
                  tooltip: CretaStudioLang.showUnshow,
                  tooltipBg: CretaColor.text[700]!,
                  icon: model.isShow.value
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  onPressed: () {
                    model.isShow.set(!(model.isShow.value));
                    _pageManager!.notify();
                  },
                ),
                BTN.fill_gray_image_m(
                  tooltip: CretaStudioLang.tooltipDelete,
                  tooltipBg: CretaColor.text[700]!,
                  iconImageFile: "assets/delete.svg",
                  onPressed: () {
                    // Delete Page
                    mychangeStack.startTrans();
                    model.isRemoved.set(true);
                    _pageManager!.removeChild(model.mid);
                    mychangeStack.endTrans();
                    _pageManager!.notify();
                  },
                ),
                //  BTN.fill_gray_i_m(
                //   tooltip: CretaStudioLang.tooltipDelete,
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

  Widget _body(int pageIndex, PageModel model) {
    //logger.finest('_body($bodyHeight, $bodyWidth)');

    double pageRatio = _pageManager!.bookModel!.getRatio();
    double width = 0;
    double height = 0;
    double pageHeight = 0;
    double pageWidth = 0;
    return GestureDetector(
      key: ValueKey(model.mid),
      onTapDown: (details) {
        //setState(() {
        logger.finest('selected = ${model.mid}');
        _pageManager!.setSelectedMid(model.mid);
        BookMainPage.containeeNotifier!.set(ContaineeEnum.Page);
        //BookMainPage.bookManagerHolder?.notify();
        //});
      },
      onDoubleTapDown: (details) {
        logger.finest('double clicked = $model.id');
        logger.finest('dx=${details.localPosition.dx}, dy=${details.localPosition.dx}');
      },
      child: SizedBox(
        // 실제 페이지를 그리는 부분
        height: _bodyHeight,
        width: _bodyWidth,
        child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
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
                color: _pageManager!.isSelected(model.mid)
                    ? CretaColor.text[100]!
                    : CretaColor.text[200]!,
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
                  model.isShow.value == false
                      ? Container(
                          height: pageHeight,
                          width: pageWidth,
                          color: Colors.black.withOpacity(0.25))
                      : Container(),
                ],
              ),
            ),
          );
        }),
      ),
    );
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
    //   logger.info('pageThumnail exist ${pageModel.thumbnailUrl.value}');

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
    //logger.info('pageThumnail not exist');

    if (pageIndex == 0) {
      BookMainPage.firstThumbnailKey = GlobalObjectKey('firstPageKey${pageModel.mid}');
    }
    return PageThumbnail(
      key: pageIndex == 0
          ? BookMainPage.firstThumbnailKey
          : ValueKey('PageThumbnail$pageIndex${pageModel.mid}'),
      pageIndex: pageIndex,
      bookModel: _pageManager!.bookModel!,
      pageModel: pageModel,
      pageWidth: width,
      pageHeight: height,
    );
  }

  Widget _addCard() {
    // double bodyHeight = cardHeight - headerHeight;
    // double bodyWidth = LayoutConst.leftMenuWidth - horizontalPadding * 2;
    //logger.finest('addCard($bodyHeight,$bodyWidth)');
    return Column(
      key: UniqueKey(),
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
                          _pageManager!.createNextPage();
                        });
                      }),
                  SizedBox(height: widget.isFolded ? 12 * widthScale : 12), // added by Mai 230516
                  if (!widget.isFolded)
                    Text(
                      CretaStudioLang.newPage,
                      style: CretaFont.buttonLarge,
                    )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _emptyCard() {
    // double bodyHeight = cardHeight - headerHeight;
    // double bodyWidth = LayoutConst.leftMenuWidth - horizontalPadding * 2;
    logger.info('emptyCard($bodyHeight,$bodyWidth)');
    return SizedBox(
      key: UniqueKey(),
      height: _bodyHeight,
      width: _bodyWidth,
    );
  }

  // Widget _addButton() {
  //   return ElevatedButton(
  //     style: ButtonStyle(
  //       elevation: MaterialStateProperty.all<double>(0.0),
  //       shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
  //       overlayColor: MaterialStateProperty.resolveWith<Color?>(
  //         (Set<MaterialState> states) {
  //           if (states.contains(MaterialState.hovered)) {
  //             return CretaColor.text[200]!;
  //           }
  //           return CretaColor.text[100]!;
  //         },
  //       ),
  //       backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
  //       // foregroundColor: MaterialStateProperty.resolveWith<Color?>(
  //       //   (Set<MaterialState> states) {
  //       //     //if (states.contains(MaterialState.hovered)) return widget.fgColor;
  //       //     return (selected ? widget.fgSelectedColor : widget.fgColor);
  //       //   },
  //       // ),
  //       shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
  //       // shape: MaterialStateProperty.all<RoundedRectangleBorder>(
  //       //   RoundedRectangleBorder(
  //       //     borderRadius: BorderRadius.circular(96),
  //       //     //side: BorderSide(color: selected ? Colors.white : widget.borderColor),
  //       //   ),
  //       // ),
  //     ),
  //     onPressed: () {
  //       setState(() {
  //         _pageManager!.createNextPage();
  //       });
  //     },
  //     child: Padding(
  //       padding: const EdgeInsets.all(20.0),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Icon(
  //             Icons.add_outlined,
  //             size: 96,
  //             color: CretaColor.primary,
  //           ),
  //           Text(
  //             CretaStudioLang.newPage,
  //             style: CretaFont.bodyMedium,
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
