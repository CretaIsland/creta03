// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'dart:math';

//import 'package:creta03/lang/creta_studio_lang.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:hycop/common/util/logger.dart';

import '../../data_io/enterprise_manager.dart';
//import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/buttons/creta_elibated_button.dart';
import '../../design_system/component/custom_image.dart';
import '../../design_system/component/snippet.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
//import '../../design_system/menu/creta_popup_menu.dart';
//import 'package:creta_common/lang/creta_lang.dart';
//import '../../design_system/menu/creta_popup_menu.dart';
import '../../lang/creta_device_lang.dart';
import '../../model/enterprise_model.dart';
import '../studio/studio_constant.dart';
import 'admin_main_page.dart';

class EnterpriseGridItem extends StatefulWidget {
  final int index;
  final EnterpriseModel? enterpriseModel;
  final double width;
  final double height;
  final EnterpriseManager enterpriseManager;
  //final GlobalKey<EnterpriseGridItemState> itemKey;
  final AdminSelectedPage selectedPage;
  final void Function(EnterpriseModel? enterpriseModel) onEdit;
  final void Function(EnterpriseModel? enterpriseModel) onTap;
  final void Function() onInsert;
  final bool isSelected;

  const EnterpriseGridItem({
    super.key,
    //required this.itemKey,
    required this.enterpriseManager,
    required this.index,
    this.enterpriseModel,
    required this.width,
    required this.height,
    required this.selectedPage,
    required this.onEdit,
    required this.onTap,
    required this.onInsert,
    required this.isSelected,
  });

  @override
  EnterpriseGridItemState createState() => EnterpriseGridItemState();
}

class EnterpriseGridItemState extends State<EnterpriseGridItem> {
  //List<CretaMenuItem> _popupMenuList = [];
  bool mouseOver = false;
  int counter = 0;
  final Random random = Random();
  bool dropDownButtonOpened = false;
  int defaultThumbnailNumber = 100;
  double aWidth = 0;
  double aHeight = 0;
  final double borderWidth = 6.0;

  void notify(String mid) {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    defaultThumbnailNumber = random.nextInt(1000);

    // _popupMenuList = [
    //   CretaMenuItem(
    //     caption: CretaLang['edit']!,
    //     onPressed: () {
    //       widget.onEdit.call(widget.enterpriseModel);
    //     },
    //   ),
    // ];
  }

  @override
  Widget build(BuildContext context) {
    return _eachItem();
  }

  Widget _eachItem() {
    aWidth = widget.width - (borderWidth * 2);
    aHeight = widget.height - (borderWidth * 2);

    //double margin = mouseOver ? 0 : LayoutConst.enterpriseThumbSpacing / 2;
    //double margin = 0;

    // if (mouseOver) {
    //   aWidth = widget.width + 10;
    //   aHeight = widget.height + 10;
    // } else {
    //   aWidth = widget.width;
    //   aHeight = widget.height;
    // }

    return MouseRegion(
      onEnter: (value) {
        setState(() {
          mouseOver = true;
          //logger.finest('mouse over');
        });
      },
      onHover: (event) {
        //logger.finest('onHover');
      },
      onExit: (value) {
        setState(() {
          mouseOver = false;
        });
      },
      child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInCubic,
          width: aWidth,
          height: aHeight,
          decoration: BoxDecoration(
            //boxShadow: mouseOver ? StudioSnippet.basicShadow(offset: 4) : null,
            borderRadius: BorderRadius.circular(20.0),
            border: widget.enterpriseModel != null
                ? Border.all(
                    color: widget.isSelected ? Colors.yellow : Colors.grey.withOpacity(0.1),
                    width: borderWidth,
                  )
                : null,
          ),
          clipBehavior: Clip.antiAlias, // crop method
          child: (widget.enterpriseModel == null && widget.index < 0)
              ? _drawInsertButton()
              : _drawenterprise()),
    );
  }

  Widget _drawInsertButton() {
    return CretaElevatedButton(
      isVertical: true,
      height: aHeight,
      bgHoverColor: CretaColor.text[100]!,
      bgHoverSelectedColor: CretaColor.text[100]!,
      bgSelectedColor: CretaColor.text[100]!,
      bgColor: CretaColor.text[100]!,
      fgColor: CretaColor.primary[300]!,
      fgSelectedColor: CretaColor.primary,
      caption: CretaDeviceLang['newEnterprise']!,
      captionStyle: CretaFont.bodyMedium,
      radius: 20.0,
      onPressed: widget.onInsert,
      icon: const Icon(
        Icons.add_outlined,
        size: 96,
        color: CretaColor.primary,
      ),
    );
  }

  Widget _drawenterprise() {
    return InkWell(
      onDoubleTap: () {
        widget.onEdit.call(widget.enterpriseModel);
      },
      onTap: () {
        widget.onTap.call(widget.enterpriseModel);
        // setState(() {
        //   _isSelected = true;
        // });
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0 - borderWidth),
                  topRight: Radius.circular(20.0 - borderWidth)),
              child: Stack(
                children: [
                  _thumnailArea(),
                  //_controllArea(),
                  //if (widget.enterpriseModel != null && selectNotifierHolder.isSelected(widget.enterpriseModel!.mid))
                  // Positioned(
                  //   top: 4,
                  //   left: 4,
                  //   child: Container(
                  //     //padding: EdgeInsets.all(2), // Adjust padding as needed
                  //     decoration: BoxDecoration(
                  //       // border: Border.all(
                  //       //   color: Colors.white, // Change border color as needed
                  //       //   width: 2, // Change border width as needed
                  //       // ),
                  //       shape: BoxShape.circle,
                  //       color: Colors.white.withOpacity(0.5),
                  //     ),
                  //     child: Icon(
                  //       Icons.check_outlined,
                  //       size: 42,
                  //       color: Colors.red,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0 - borderWidth),
                    bottomRight: Radius.circular(20.0 - borderWidth)),
                child: _bottomArea()),
          ],
        ),
      ),
    );
  }

  // Widget _controllArea() {
  //   //String url = '${AppRoutes.deviceDetailPage}?${widget.enterpriseModel!.mid}';
  //   double controllAreaHeight = aHeight - LayoutConst.bookDescriptionHeight;
  //   if (mouseOver) {
  //     return Container(
  //       padding: const EdgeInsets.only(top: 8.0, right: 8),
  //       alignment: AlignmentDirectional.topEnd,
  //       decoration: mouseOver
  //           ? Snippet.gradationShadowDeco()
  //           : BoxDecoration(
  //               color: Colors.transparent,
  //             ),
  //       //width: aWidth,
  //       height: controllAreaHeight, //aHeight - LayoutConst.enterpriseDescriptionHeight,
  //       //color: CretaColor.text[200]!.withOpacity(0.2),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.end,
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.only(left: 4.0),
  //                 child: BTN.opacity_gray_i_s(
  //                   icon: Icons.menu,
  //                   onPressed: () {
  //                     logger.finest('menu pressed');
  //                     //widget.onEdit.call(widget.enterpriseModel);
  //                     // setState(() {
  //                     //   CretaPopupMenu.showMenu(
  //                     //       context: context,
  //                     //       globalKey: widget.itemKey,
  //                     //       popupMenu: _popupMenuList,
  //                     //       initFunc: () {
  //                     //         dropDownButtonOpened = true;
  //                     //       }).then((value) {
  //                     //     logger.finest('팝업메뉴 닫기');
  //                     //     setState(() {
  //                     //       dropDownButtonOpened = false;
  //                     //     });
  //                     //   });
  //                     //   dropDownButtonOpened = !dropDownButtonOpened;
  //                     // });
  //                   },
  //                   tooltip: CretaStudioLang['tooltipMenu']!,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           if (aHeight > 186)
  //             Padding(
  //               padding: const EdgeInsets.only(bottom: 8.0, left: 8),
  //               child: Container(
  //                 color: Colors.transparent,
  //                 height: 16,
  //                 child: Text(
  //                   widget.enterpriseModel!.description,
  //                   overflow: TextOverflow.ellipsis,
  //                   style: CretaFont.bodyESmall.copyWith(color: Colors.white),
  //                 ),
  //               ),
  //             ),
  //         ],
  //       ),
  //       //),
  //     );
  //   }
  //   return Container();
  // }

  Widget _thumnailArea() {
    int randomNumber = random.nextInt(1000);
    int duration = widget.index == 0 ? 500 : 500 + randomNumber;
    String url = '';

    if (widget.enterpriseModel == null || widget.enterpriseModel!.imageUrl.isEmpty) {
      url = 'https://picsum.photos/200/?random=$defaultThumbnailNumber';
    } else {
      url = widget.enterpriseModel!.imageUrl;
    }

    try {
      return SizedBox(
          width: aWidth,
          height: aHeight - LayoutConst.bookDescriptionHeight,
          child: CustomImage(
              key: UniqueKey(),
              hasMouseOverEffect: true,
              duration: duration,
              width: aWidth,
              height: aHeight,
              image: url));
    } catch (err) {
      logger.warning('CustomeImage failed $err');
      return SizedBox.shrink();
    }
  }

  Widget _bottomArea() {
    String firstAdmin =
        widget.enterpriseModel!.admins.isEmpty ? 'no admin' : widget.enterpriseModel!.admins.first;
    return Container(
      //width: aWidth,
      height: LayoutConst.bookDescriptionHeight,
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 6,
            child: Container(
                color: Colors.white,
                child: Snippet.TooltipWrapper(
                  tooltip: widget.enterpriseModel!.name,
                  fgColor: Colors.black,
                  bgColor: CretaColor.text[200]!,
                  child: Text(
                    widget.enterpriseModel!.name,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: CretaFont.bodyLarge,
                  ),
                )),
          ),
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.white,
              child: Snippet.TooltipWrapper(
                tooltip: firstAdmin,
                fgColor: Colors.black,
                bgColor: CretaColor.text[200]!,
                child: Text(
                  //CretaCommonUtils.dateToDurationString(widget.enterpriseModel!.updateTime),
                  firstAdmin,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: CretaFont.buttonMedium,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
