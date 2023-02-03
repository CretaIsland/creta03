// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:provider/provider.dart';

import '../../../data_io/page_manager.dart';
import '../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../design_system/buttons/creta_label_text_editor.dart';
import '../../../design_system/creta_color.dart';
import '../../../design_system/creta_font.dart';
import '../../../lang/creta_studio_lang.dart';
import '../../../model/page_model.dart';
import '../studio_constant.dart';
import '../studio_variables.dart';

class LeftMenuPage extends StatefulWidget {
  const LeftMenuPage({super.key});

  @override
  State<LeftMenuPage> createState() => _LeftMenuPageState();
}

class _LeftMenuPageState extends State<LeftMenuPage> {
  PageManager? _pageManager;
  final ScrollController _scrollController = ScrollController(initialScrollOffset: 0.0);
  final GlobalKey<CretaLabelTextEditorState> textFieldKey = GlobalKey<CretaLabelTextEditorState>();

  final double verticalPadding = 14;
  final double horizontalPadding = 24;
  final double cardHeight = 258;
  final double headerHeight = 36;
  final double menuBarHeight = 36;

  int _pageCount = 0;

  // void _scrollListener() {
  //   setState(() {
  //     scrollOffset = _scrollController.offset;
  //   });
  // }

  @override
  void initState() {
    //_scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PageManager>(builder: (context, pageManager, child) {
      _pageCount = pageManager.getAvailLength();
      logger.finest('Consumer  $_pageCount');
      _pageManager = pageManager;
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
          BTN.fill_gray_100_i_s(
              icon: Icons.add_outlined,
              onPressed: (() {
                _pageManager!.createNextPage();
                _scrollController
                    .jumpTo(_scrollController.position.maxScrollExtent + cardHeight * 2);
              })),
          //BTN.fill_gray_100_i_s(icon: Icons.delete_outlined, onPressed: (() {})),
          BTN.fill_gray_100_i_s(icon: Icons.account_tree_outlined, onPressed: (() {})),
        ],
      ),
    );
  }

  Widget _pageView() {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      height: StudioVariables.workHeight,
      child: ReorderableListView(
        buildDefaultDragHandles: false,
        scrollController: _scrollController,
        children: [
          ..._cardList(),
          _addCard(),
          _emptyCard(),
        ],
        onReorder: (oldIndexVal, newIndexVal) {
          int oldIndex = oldIndexVal;
          int newIndex =
              oldIndexVal < newIndexVal && newIndexVal > 1 ? newIndexVal - 1 : newIndexVal;
          logger.finer('oldIndex=$oldIndex, newIndex=$newIndex');
          List<AbsExModel> avaiList = _pageManager!.getAvailModelList();
          PageModel aOld = avaiList[oldIndex] as PageModel;
          PageModel aNew = avaiList[newIndex] as PageModel;

          // if (newIndex == 0) {
          //   // 제일앞에 것보다 order 가 작아야 하다.
          //   double firstOrder = aNew.order.value - StudioConst.orderVar;

          // }

          PageModel tmp = PageModel(aOld.mid);
          tmp.copyFrom(aOld, newMid: aOld.mid, pMid: aOld.parentMid.value);

          double oldOrder = tmp.order.value;
          double newOrder = aNew.order.value;

          mychangeStack.startTrans();
          aNew.order.set(oldOrder);
          tmp.order.set(newOrder);
          mychangeStack.endTrans();
          setState(() {
            _pageManager!.replace(oldIndex, aNew);
            _pageManager!.replace(newIndex, tmp);
          });
        },
      ),
    );
  }

  // Widget _eachCard(int pageIndex, PageModel model) {
  //   double pageRatio = _pageManager!.bookModel.getRatio();
  //   double width = 0;
  //   double height = 0;
  //   double pageHeight = 0;
  //   double pageWidth = 0;

  //   //String pageNo = (pageIndex + 1).toString().padLeft(2, '0');

  //   return ReorderableDragStartListener(
  //     key: ValueKey(model.mid),
  //     index: pageIndex,
  //     child: Padding(
  //       padding: const EdgeInsets.fromLTRB(20, 0, 20, 13),
  //       //padding: const EdgeInsets.only(left: 20, top: 0),
  //       child: SizedBox(
  //         // 실제 페이지를 그리는 부분
  //         height: 126.0,
  //         child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
  //           width = constraints.maxWidth;
  //           height = constraints.maxHeight;
  //           if (pageRatio > 1) {
  //             // 세로형
  //             pageHeight = height;
  //             pageWidth = pageHeight * (1 / pageRatio);
  //           } else {
  //             // 가로형
  //             pageWidth = width;
  //             pageHeight = pageWidth * pageRatio;
  //             if (pageHeight > height) {
  //               // 화면에서 page 를 표시하는 영역은 항상 가로형으로 항상 세로는
  //               // 가로보다 작다.  이러다 보니, 세로 사이지그 화면의 영역을 오버하는
  //               // 경우가 생기게 된다.  그러나 세로형의 경우는 이런 일이 발생하지 않는다.
  //               pageHeight = height;
  //               pageWidth = pageHeight * (1 / pageRatio);
  //             }
  //           }
  //           logger.finest("pl:width=$width, height=$height, ratio=$pageRatio");
  //           logger.finest("pl:pageWidth=$pageWidth, pageHeight=$pageHeight");

  //           return SafeArea(
  //             child: Container(
  //               height: pageHeight,
  //               width: pageWidth,
  //               color: _pageManager!.isPageSelected(model.mid)
  //                   ? CretaColor.text[200]!
  //                   : CretaColor.text[100]!,
  //             ),
  //           );
  //         }),
  //       ),
  //     ),
  //   );
  // }

  List<Widget> _cardList() {
    if (_pageManager!.modelList.isEmpty) {
      logger.finest('_pageManager!.modelList is empty');
      return [];
    }
    int count = 0;
    List<Widget> retval = [];
    for (var ele in _pageManager!.modelList) {
      PageModel page = ele as PageModel;
      if (page.isRemoved.value == true) {
        continue;
      }
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
          margin: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: horizontalPadding),
          //height: pageIndex == _pageCount - 1 ? cardHeight * 3 : cardHeight,
          height: cardHeight,
          child: Column(
            children: [
              _header(pageIndex, model),
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
                  style: CretaFont.titleSmall,
                ),
                const SizedBox(width: 10),
                CretaLabelTextEditor(
                  textFieldKey: textFieldKey,
                  text: model.name.value,
                  textStyle: CretaFont.titleSmall,
                  width: 200,
                  height: 20,
                  onEditComplete: (value) {
                    setState(() {
                      model.name.set(value);
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                BTN.fill_gray_i_m(
                  icon: Icons.content_copy_outlined,
                  onPressed: () {
                    // Copy Page
                  },
                ),
                BTN.fill_gray_i_m(
                  icon: model.isShow.value
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  onPressed: () {
                    model.isShow.set(!(model.isShow.value));
                    _pageManager!.notify();
                  },
                ),
                BTN.fill_gray_i_m(
                  icon: Icons.delete_outlined,
                  onPressed: () {
                    // Delete Page
                    model.isRemoved.set(true);
                    _pageManager!.notify();
                  },
                ),
              ],
            ),
          ]),
    );
  }

  Widget _body(int pageIndex, PageModel model) {
    double bodyHeight = cardHeight - headerHeight;
    double bodyWidth = LayoutConst.leftMenuWidth - horizontalPadding * 2;
    //logger.finest('_body($bodyHeight, $bodyWidth)');
    double pageRatio = _pageManager!.bookModel.getRatio();
    double width = 0;
    double height = 0;
    double pageHeight = 0;
    double pageWidth = 0;
    return GestureDetector(
      key: ValueKey(model.mid),
      onTapDown: (details) {
        //setState(() {
        logger.finest('selected = ${model.mid}');
        _pageManager!.setSelectedIndex(context, model.mid);
        //});
      },
      onDoubleTapDown: (details) {
        logger.finest('double clicked = $model.id');
        logger.finest('dx=${details.localPosition.dx}, dy=${details.localPosition.dx}');
      },
      child: Container(
        // 실제 페이지를 그리는 부분
        height: bodyHeight,
        width: bodyWidth,
        decoration: BoxDecoration(
          border: Border.all(
              width: 2,
              color: _pageManager!.isPageSelected(model.mid)
                  ? CretaColor.primary
                  : CretaColor.text[300]!),
        ),
        child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
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
              color: _pageManager!.isPageSelected(model.mid)
                  ? CretaColor.text[200]!
                  : CretaColor.text[100]!,
              child: Center(
                child: Text(
                  model.order.value.toString(),
                  style: CretaFont.titleELarge.copyWith(color: CretaColor.text[700]!),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _addCard() {
    double bodyHeight = cardHeight - headerHeight;
    double bodyWidth = LayoutConst.leftMenuWidth - horizontalPadding * 2;
    //logger.finest('addCard($bodyHeight,$bodyWidth)');
    return Column(
      key: UniqueKey(),
      children: [
        SizedBox(
          height: headerHeight + verticalPadding,
        ),
        Container(
          // 실제 페이지를 그리는 부분
          height: bodyHeight,
          width: bodyWidth,
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: CretaColor.text[300]!),
          ),
          child: Center(
            child: _addButton(),
          ),
        ),
      ],
    );
  }

  Widget _emptyCard() {
    double bodyHeight = cardHeight - headerHeight;
    double bodyWidth = LayoutConst.leftMenuWidth - horizontalPadding * 2;
    logger.finest('emptyCard($bodyHeight,$bodyWidth)');
    return SizedBox(
      key: UniqueKey(),
      height: bodyHeight,
      width: bodyWidth,
    );
  }

  Widget _addButton() {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(0.0),
        shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered)) {
              return CretaColor.text[200]!;
            }
            return CretaColor.text[100]!;
          },
        ),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        // foregroundColor: MaterialStateProperty.resolveWith<Color?>(
        //   (Set<MaterialState> states) {
        //     //if (states.contains(MaterialState.hovered)) return widget.fgColor;
        //     return (selected ? widget.fgSelectedColor : widget.fgColor);
        //   },
        // ),
        shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
        // shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        //   RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(96),
        //     //side: BorderSide(color: selected ? Colors.white : widget.borderColor),
        //   ),
        // ),
      ),
      onPressed: () {
        setState(() {
          _pageManager!.createNextPage();
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_outlined,
              size: 96,
              color: CretaColor.primary,
            ),
            Text(
              CretaStudioLang.newPage,
              style: CretaFont.bodyMedium,
            )
          ],
        ),
      ),
    );
  }
}
