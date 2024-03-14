import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:flutter/material.dart';
//import 'package:get/get.dart';
import '../../../../design_system/component/creta_right_mouse_menu.dart';
import '../../../../design_system/component/custom_image.dart';
import 'package:creta_common/common/creta_snippet.dart';
import 'package:creta_common/lang/creta_lang.dart';
import '../../../../design_system/menu/creta_popup_menu.dart';
import '../../../../lang/creta_studio_lang.dart';
import '../../../../model/template_model.dart';
import '../../book_main_page.dart';
import '../../studio_variables.dart';
// ignore: depend_on_referenced_packages

class TemplateList extends StatefulWidget {
  final String? queryText;
  final bool refreshToggle;
  final double width;
  const TemplateList({
    this.queryText,
    required this.width,
    required this.refreshToggle,
    super.key,
  });

  static Set<TemplateModel> shiftSelectedSet = {};
  static Set<TemplateModel> ctrlSelectedSet = {};

  @override
  State<TemplateList> createState() => _TemplateListClassState();
}

class _TemplateListClassState extends State<TemplateList> {
  final double verticalPadding = 16;
  final double horizontalPadding = 24;

  Future<List<TemplateModel>>? _templateList;
  int _selectedItemIndex = -1;

  // bool _dbJobComplete = false;

  @override
  void didUpdateWidget(TemplateList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.queryText != widget.queryText) {
      _templateList =
          BookMainPage.templateManagerHolder!.getTemplateList(queryText: widget.queryText);
    }
    if (oldWidget.refreshToggle != widget.refreshToggle) {
      _templateList =
          BookMainPage.templateManagerHolder!.getTemplateList(queryText: widget.queryText);
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
    _templateList =
        BookMainPage.templateManagerHolder!.getTemplateList(queryText: widget.queryText);
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
              height: 352.0,
              alignment: Alignment.center,
              child: const Text(CretaLang.nodatafounded),
            );
          }
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              height: StudioVariables.workHeight - 220.0,
              child: GridView.builder(
                itemCount: snapshot.data!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: spacing,
                  crossAxisSpacing: spacing,
                  crossAxisCount: 2,
                  childAspectRatio: 160 / (95 + 24),
                ),
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

                  double imageWidth = widget.width / 2 - spacing;
                  double imageHeight =
                      imageWidth * templateModel.height.value / templateModel.width.value;

                  return InkWell(
                    onTapDown: (detail) {
                      setState(() {
                        _selectedItemIndex = index;
                      });
                    },
                    onSecondaryTapDown: (details) {
                      if (_selectedItemIndex == index) {
                        onRightMouseButton.call(details, templateModel, context);
                      }
                    },
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      (thumbnailUrl.isEmpty)
                          ? SizedBox(
                              width: imageWidth,
                              height: imageHeight,
                              child: Image.asset('assets/no_image.png'), // No Image
                            )
                          : Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: _selectedItemIndex == index
                                      ? CretaColor.primary
                                      : Colors.transparent,
                                  width: 4.0,
                                ),
                              ),
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
                        alignment: Alignment.centerLeft,
                        width: 160.0,
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
                  );
                },
              ),
            ),
          );
        } else {
          return Container(
            padding: EdgeInsets.symmetric(vertical: verticalPadding),
            height: 352.0,
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
            caption: CretaStudioLang.tooltipDelete,
            onPressed: () async {
              BookMainPage.templateManagerHolder!.deleteModel(templateModel!);
            }),
        CretaMenuItem(
            caption: CretaStudioLang.tooltipApply,
            onPressed: () async {
              //await depotManager.removeDepots(ele);
            }),
      ],
      itemHeight: 24,
      x: details.globalPosition.dx,
      y: details.globalPosition.dy,
      width: 150,
      height: 72,
      iconSize: 12,
      alwaysShowBorder: true,
      borderRadius: 8,
    );
  }
}
