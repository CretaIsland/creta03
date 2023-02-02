// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:provider/provider.dart';

import '../../../data_io/page_manager.dart';
import '../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../design_system/creta_color.dart';
import '../../../design_system/creta_font.dart';
import '../../../model/page_model.dart';

class LeftMenuPage extends StatefulWidget {
  const LeftMenuPage({super.key});

  @override
  State<LeftMenuPage> createState() => _LeftMenuPageState();
}

class _LeftMenuPageState extends State<LeftMenuPage> {
  PageManager? _pageManager;
  //final ScrollController _scrollController = ScrollController(initialScrollOffset: 0.0);

  @override
  Widget build(BuildContext context) {
    return Consumer<PageManager>(builder: (context, pageManager, child) {
      logger.finest('Consumer  ${pageManager.getLength()}');
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
      padding: const EdgeInsets.only(left: 10, right: 10),
      height: 36,
      color: CretaColor.text[100]!,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BTN.fill_gray_100_i_s(
              icon: Icons.add_outlined,
              onPressed: (() {
                _pageManager!.createNextPage();
              })),
          BTN.fill_gray_100_i_s(icon: Icons.delete_outlined, onPressed: (() {})),
          BTN.fill_gray_100_i_s(icon: Icons.account_tree_outlined, onPressed: (() {})),
        ],
      ),
    );
  }

  Widget _pageView() {
    List<AbsExModel> items = _pageManager!.modelList;
    if (items.isEmpty) {
      logger.finest('item is empty');
      return Container();
    }
    return Container();

    // return ReorderableListView(
    //   buildDefaultDragHandles: false,
    //   scrollController: _scrollController,
    //   children: [
    //     for (int i = 0; i < items.length; i++) eachCard(i, items[i] as PageModel),
    //   ],
    //   onReorder: (oldIndex, newIndex) => setState(() {}),
    // );
  }

  Widget eachCard(int pageIndex, PageModel model) {
    double pageRatio = _pageManager!.bookModel.getRatio();
    double width = 0;
    double height = 0;
    double pageHeight = 0;
    double pageWidth = 0;

    logger.finest('eachCard($pageIndex)');
    String pageNo = 'P ';
    pageNo += (pageIndex + 1).toString().padLeft(2, '0');
    return ReorderableDragStartListener(
      key: ValueKey(model.mid),
      index: pageIndex,
      child: GestureDetector(
        key: ValueKey(model.mid),
        onTapDown: (details) {
          //setState(() {
          logger.finest('selected = $model.mid');
          //pageManager.setSelectedIndex(context, model.mid);
          //});
        },
        onDoubleTapDown: (details) {
          logger.finest('double clicked = $model.id');
          logger.finest('dx=${details.localPosition.dx}, dy=${details.localPosition.dx}');
        },
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
            child: Card(
              color: _pageManager!.isPageSelected(model.mid)
                  ? CretaColor.text[200]!
                  : CretaColor.text[100]!,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 1.0,
                    color: _pageManager!.isPageSelected(model.mid)
                        ? CretaColor.primary
                        : CretaColor.text[300]!),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: SizedBox(
                height: 182.0,
                child: Column(
                  children: [
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      IconButton(
                        // 순환 버튼
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                        iconSize: 16,
                        onPressed: () {
                          setState(() {
                            model.isCircle.set(!model.isCircle.value);
                          });
                        },
                        icon:
                            Icon(model.isCircle.value ? Icons.autorenew : Icons.push_pin_outlined),
                        color: CretaColor.text[700]!,
                      ),
                      SizedBox(
                        height: 40,
                        width: 180,
                        //color: Colors.red,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              pageNo,
                              style: CretaFont.titleSmall,
                            ),
                            Text(
                              ' | ',
                              style: CretaFont.titleSmall,
                            ),
                            SizedBox(
                              width: 118,
                              child: Text(
                                model.name.value,
                                style: CretaFont.titleSmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        // 삭제 버튼
                        iconSize: 16,
                        onPressed: () {
                          setState(() {
                            //_pageManager!.removePage(context, model.mid);
                          });
                        },
                        icon: const Icon(Icons.delete_outline),
                        color: CretaColor.text[700]!,
                      ),
                    ]),
                    //_drawPage(pageManager.isSelected(model.id)),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 13),
                      //padding: const EdgeInsets.only(left: 20, top: 0),
                      child: SizedBox(
                        // 실제 페이지를 그리는 부분
                        height: 126.0,
                        child: LayoutBuilder(
                            builder: (BuildContext context, BoxConstraints constraints) {
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
                          logger.finest("pl:width=$width, height=$height, ratio=$pageRatio");
                          logger.finest("pl:pageWidth=$pageWidth, pageHeight=$pageHeight");

                          return SafeArea(
                            child: Container(
                              height: pageHeight,
                              width: pageWidth,
                              color: _pageManager!.isPageSelected(model.mid)
                                  ? CretaColor.text[200]!
                                  : CretaColor.text[100]!,
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(
            height: 5,
            thickness: 1,
            //color: CretaColor.divide,
            indent: 20,
            endIndent: 10,
          ),
        ]),
      ),
    );
  }
}
