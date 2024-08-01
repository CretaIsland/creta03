import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:creta_common/common/creta_vars.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/book_model.dart';
import 'package:creta_studio_model/model/page_model.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
//import 'package:get/get.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../design_system/component/creta_right_mouse_menu.dart';
import '../../../../design_system/component/custom_image.dart';
import 'package:creta_common/common/creta_snippet.dart';
import 'package:creta_common/lang/creta_lang.dart';
import '../../../../design_system/menu/creta_popup_menu.dart';
import '../../../../lang/creta_studio_lang.dart';
import '../../../../model/template_model.dart';
import '../../book_main_page.dart';
import '../../containees/containee_nofifier.dart';
import '../../studio_constant.dart';
import '../../studio_variables.dart';
import '../left_menu.dart';
// ignore: depend_on_referenced_packages

class TemplateList extends StatefulWidget {
  final String? queryText;
  final String selectedTab;
  final bool refreshToggle;
  final double width;
  final Size? bookSize;
  final bool showAll;

  const TemplateList({
    this.queryText,
    required this.selectedTab,
    required this.width,
    required this.refreshToggle,
    required this.bookSize,
    required this.showAll,
    super.key,
  });

  static Set<TemplateModel> shiftSelectedSet = {};
  static Set<TemplateModel> ctrlSelectedSet = {};

  @override
  State<TemplateList> createState() => _TemplateListClassState();
}

class _TemplateListClassState extends State<TemplateList> {
  final double verticalPadding = 16;
  final double horizontalPadding = 19;

  Future<List<TemplateModel>>? _templateList;
  int _selectedItemIndex = -1;

  // bool _dbJobComplete = false;

  @override
  void didUpdateWidget(TemplateList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.queryText != widget.queryText) {
      _templateList = BookMainPage.templateManagerHolder!
          .getTemplateList(widget.selectedTab, queryText: widget.queryText);
    }
    if (oldWidget.refreshToggle != widget.refreshToggle) {
      _templateList = BookMainPage.templateManagerHolder!
          .getTemplateList(widget.selectedTab, queryText: widget.queryText);
    }
    if (oldWidget.selectedTab != widget.selectedTab) {
      _templateList = BookMainPage.templateManagerHolder!
          .getTemplateList(widget.selectedTab, queryText: widget.queryText);
    }
  }

  @override
  void initState() {
    // print('initState-------------------');
    super.initState();
    // _dbJobComplete = false;
    // depotManager.getContentInfoList(contentsType: widget.contentsType).then(
    //   (value) {
    //     SelectionManager.filteredContents = value;
    //     _dbJobComplete = true;
    //     return value;
    //   },
    // );

    _templateList = BookMainPage.templateManagerHolder!.getTemplateList(widget.selectedTab,
        queryText: widget.queryText, bookSize: widget.bookSize, showAll: widget.showAll);
  }

  // Future<List<TemplateModel>> _waitDbJobComplete() async {
  //   while (_dbJobComplete == false) {
  //     await Future.delayed(const Duration(milliseconds: 100));
  //   }
  //   return SelectionManager.filteredContents;
  // }

  @override
  Widget build(BuildContext context) {
    const double spacing = 8.0;
    const double borderWidth = 4.0;

    int itemCount = CretaVars.instance.serviceType == ServiceType.barricade ? 1 : 2;
    return FutureBuilder<List<TemplateModel>>(
      initialData: const [],
      future: _templateList,
      //future: BookMainPage.templateManagerHolder!.getTemplateList(queryText: widget.queryText),
      // future: _waitDbJobComplete(),
      //future: depotManager.getContentInfoList(contentsType: widget.contentsType),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: verticalPadding),
              height: 332.0,
              alignment: Alignment.center,
              child: Text(CretaLang['nodatafounded']!),
            );
          }
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              height: StudioVariables.workHeight - 210.0,
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                shrinkWrap: true,
                // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //   mainAxisSpacing: spacing,
                //   crossAxisSpacing: CretaVars.instance.serviceType == ServiceType.barricade
                //       ? spacing * 2
                //       : spacing,
                //   crossAxisCount: itemCount,
                //   // childAspectRatio: CretaVars.instance.serviceType == ServiceType.barricade
                //   //     ? (360 + borderWidth * 2) / (28 + 24 + borderWidth * 2 + 20)
                //   //     : 160 / (95 + 24),
                // ),
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  TemplateModel templateModel = snapshot.data![index];
                  String? thumbnailUrl = templateModel.thumbnailUrl.value;
                  // bool isSelected = TemplateList.ctrlSelectedSet.contains(templateModel) ||
                  //     TemplateList.shiftSelectedSet.contains(templateModel);
                  // print('thumbnailUrl=$thumbnailUrl------------');
                  // 사이즈를 bodywidth 에 맞추는 작업을 해야 한다.
                  // imageHeight  는 다음과 같이 구해진다.
                  // bodyWidth : x = templateModel.width.value : templateModel.height.value
                  // x = bodyWidth * templateModel.height.value / templateModel.width.value

                  double imageWidth = widget.width / itemCount - spacing;
                  double imageHeight =
                      imageWidth * templateModel.height.value / templateModel.width.value;

                  // if (_selectedItemIndex == index) {
                  //   imageHeight = imageHeight + borderWidth * 2;
                  // }

                  return InkWell(
                    onTapDown: (details) {
                      setState(() {
                        _selectedItemIndex = index;
                      });
                      onRightMouseButton.call(details, templateModel, context);
                    },
                    onSecondaryTapDown: (details) {
                      if (_selectedItemIndex == index) {
                        onRightMouseButton.call(details, templateModel, context);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        (thumbnailUrl.isEmpty)
                            ? SizedBox(
                                width: imageWidth,
                                height: imageHeight + 6,
                                child: Image.asset('assets/no_image.png'), // No Image
                              )
                            // ignore: avoid_unnecessary_containers
                            : Container(
                                decoration: _selectedItemIndex == index
                                    ? BoxDecoration(
                                        border: Border.all(
                                          color: CretaColor.primary,
                                          width: borderWidth,
                                        ),
                                      )
                                    : null,
                                child: CustomImage(
                                  key: GlobalObjectKey('CustomImage${templateModel.mid}$index'),
                                  width: imageWidth,
                                  height: imageHeight,
                                  image: thumbnailUrl,
                                  hasAni: false,
                                ),
                              ),
                        Container(
                          padding: const EdgeInsets.only(top: 4.0),
                          alignment: Alignment.center,
                          width: 180.0,
                          height: 20.0,
                          child: Text(
                            templateModel.name.value,
                            maxLines: 1,
                            style: CretaFont.bodyESmall,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ]),
                    ),
                  );
                },
              ),
            ),
          );
        } else {
          return Container(
            padding: EdgeInsets.symmetric(vertical: verticalPadding),
            height: 332.0,
            alignment: Alignment.center,
            child: CretaSnippet.showWaitSign(),
          );
          // if (_dbJobComplete == false) {
          //   return Container(
          //     padding: EdgeInsets.symmetric(vertical: verticalPadding),
          //     height: 352.0,
          //     alignment: Alignment.center,
          //     child: CretaSnippet.showWaitSign(),
          //   );
          // } else {
          //   return const SizedBox.shrink();
          // }
        }
      },
    );
  }

  void onRightMouseButton(
      TapDownDetails details, TemplateModel? templateModel, BuildContext context) {
    CretaRightMouseMenu.showMenu(
      title: 'templateRightMouseMenu',
      context: context,
      popupMenu: [
        CretaMenuItem(
            caption: CretaStudioLang['tooltipDelete']!,
            onPressed: () async {
              BookMainPage.templateManagerHolder!.deleteModel(templateModel!);
            }),
        CretaMenuItem(
            caption: CretaStudioLang['applyTempateToNewPage'] ?? "새로운 페이지에 템플릿 적용",
            onPressed: () async {
              int pageCount = BookMainPage.pageManagerHolder!.getAvailLength();
              BookModel? book = BookMainPage.bookManagerHolder!.onlyOne() as BookModel?;
              PageModel pageModel = PageModel('', book!);
              pageModel.copyFrom(templateModel!, newMid: pageModel.mid);
              pageModel.parentMid.set(book.mid);
              pageModel.name.set('${CretaLang['noNamepage']!} ${pageCount + 1}');
              pageModel.setRealTimeKey(book.mid);
              pageModel.order.set(BookMainPage.pageManagerHolder!.safeLastOrder() + 1);

              // print('templateModel!.mid = ${templateModel.mid}');
              // print('pageModel.mid = ${pageModel.mid}');
              // print('pageModel.parentMid = ${pageModel.parentMid.value}');
              // print('pageModel.type = ${pageModel.type}');

              FrameManager frameManager = FrameManager(pageModel: templateModel, bookModel: book);
              await frameManager.updateParent(templateModel.mid, pageModel, book.mid);
              await BookMainPage.pageManagerHolder!.createNextPageByModel(pageModel);

              // frame 들의 parentMid 를  신규 page mid 를 넣는다.

              // 여기서 left_menu_page  로 자동으로 넘어가도록 이벤트 처리를 해야함.
              BookMainPage.leftMenuNotifier!.set(LeftMenuEnum.Page);
              BookMainPage.containeeNotifier!.set(ContaineeEnum.Page);
              LeftMenu.leftMenuPageKey.currentState?.resetPosition();
            }),
        CretaMenuItem(
            caption: CretaStudioLang['applyTempateToCurrentPage'] ?? "현재 페이지에 템플릿 적용",
            onPressed: () async {
              // 아직 구현 안했음.
              showSnackBar(context, 'Not yet implemented');

              // PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
              // if (pageModel != null) {
              //   FrameManager? targetFrameManager =
              //       BookMainPage.pageManagerHolder!.getSelectedFrameManager();
              //   FrameManager srcFrameManager =
              //       FrameManager(pageModel: templateModel!, bookModel: pageModel.bookModel);
              //   if (targetFrameManager != null) {
              //     srcFrameManager.copyFrames(pageModel.mid, pageModel.bookModel.mid);
              //   }
              //   //pageModel.copyFrom(templateModel!, newMid: pageModel.mid);
              // }
            }),
        CretaMenuItem(
            caption: CretaStudioLang['modifyTemplate'] ?? "템플릿 편집",
            onPressed: () async {
              // 아직 구현 안했음.
              showSnackBar(context, 'Not yet implemented');
            }),
      ],
      itemHeight: 24,
      x: details.globalPosition.dx,
      y: details.globalPosition.dy,
      width: 280,
      height: 110,
      iconSize: 12,
      alwaysShowBorder: true,
      borderRadius: 8,
    );
  }
}
