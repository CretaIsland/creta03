// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'package:creta03/data_io/page_manager.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:provider/provider.dart';

import '../../../../design_system/creta_font.dart';
import '../../../../lang/creta_studio_lang.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/book_model.dart';
import '../../../../model/page_model.dart';
import '../../book_main_page.dart';
import '../../studio_constant.dart';
import '../property_mixin.dart';
import '../right_menu.dart';

class PageProperty extends StatefulWidget {
  const PageProperty({super.key});

  @override
  State<PageProperty> createState() => _PagePropertyState();
}

class _PagePropertyState extends State<PageProperty> with PropertyMixin {
  // ignore: unused_field
  //late ScrollController _scrollController;
  double horizontalPadding = 24;
  BookModel? _book;
  // ignore: unused_field
  PageModel? _model;
  // ignore: unused_field
  PageManager? _pageManager;
  bool _isTransitionOpen = false;

  @override
  void initState() {
    logger.finer('_PagePropertyState.initState');
    super.initMixin();
    super.initState();
  }

  @override
  void dispose() {
    //_scrollController.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PageManager>(builder: (context, pageManager, child) {
      _book = BookMainPage.bookManagerHolder?.onlyOne() as BookModel?;
      if (_book == null) {
        return Center(
          child: Text("No CretaBook Selected", style: CretaFont.titleLarge),
        );
      }
      _pageManager = pageManager;
      pageManager.reOrdering();
      _model = pageManager.getSelected();
      if (_model == null) {
        BookMainPage.selectedClass = RightMenuEnum.Book;
        return RightMenu(
          onClose: () {
            setState(() {
              if (BookMainPage.selectedClass == RightMenuEnum.Book) {
                BookMainPage.onceBookInfoOpened = true;
              }
              BookMainPage.selectedClass = RightMenuEnum.None;
            });
          },
        );
      }
      return //SizedBox(
          //padding: EdgeInsets.all(horizontalPadding),
          //width: LayoutConst.rightMenuWidth,
          //child:
          Column(children: [
        //propertyDivider(height: 4),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: _pageColor(),
        ),
        propertyDivider(),
        _pageTransition(),
        propertyDivider(),
      ]);
      //);
    });
  }

  Widget _pageColor() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: colorPropertyCard(
        title: CretaStudioLang.pageBgColor,
        color1: _model!.bgColor1.value,
        color2: _model!.bgColor2.value,
        opacity: _model!.opacity.value,
        gradationType: _model!.gradationType.value,
        cardOpenPressed: () {
          setState(() {});
        },
        onOpacityDragComplete: (value) {
          setState(() {
            _model!.opacity.set(1 - (value / 100));
            logger.fine('opacity1=${_model!.opacity.value}');
          });
          BookMainPage.bookManagerHolder?.notify();
        },
        onGradationTapPressed: (type, color1, color2) {
          logger.finest('GradationIndicator clicked');
          setState(() {
            if (_model!.gradationType.value == type) {
              _model!.gradationType.set(GradationType.none);
            } else {
              _model!.gradationType.set(type);
            }
          });
          BookMainPage.bookManagerHolder?.notify();
        },
        onColor1Changed: (val) {
          setState(() {
            _model!.bgColor1.set(val);
          });
          BookMainPage.bookManagerHolder?.notify();
        },
        onColor2Changed: (val) {
          setState(() {
            _model!.bgColor2.set(val);
          });
          BookMainPage.bookManagerHolder?.notify();
        },
      ),
    );
  }

  Widget _pageTransition() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: propertyCard(
          isOpen: _isTransitionOpen,
          onPressed: () {
            setState(() {
              _isTransitionOpen = !_isTransitionOpen;
            });
          },
          titleWidget: Text(CretaStudioLang.transitionPage, style: CretaFont.titleSmall),
          //trailWidget: isColorOpen ? _gradationButton() : _colorIndicator(),
          trailWidget: Center(
            child: Text(CretaStudioLang.fadeIn, style: CretaFont.titleSmall),
          ),
          bodyWidget: SizedBox(
            height: 300,
            child: Center(
              child: Text("Not yet implemented", style: CretaFont.titleSmall),
            ),
          )),
    );
  }
}

// class _Chip extends StatelessWidget {
//   const _Chip({
//     required this.label,
//     required this.onDeleted,
//     required this.index,
//   });

//   final String label;
//   final ValueChanged<int> onDeleted;
//   final int index;

//   @override
//   Widget build(BuildContext context) {
//     return Chip(
//       clipBehavior: Clip.antiAlias,
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(24),
//         side: BorderSide(
//           width: 1,
//           color: CretaColor.text[700]!,
//         ),
//       ),
//       labelPadding: const EdgeInsets.symmetric(horizontal: 4.0),
//       label: Text(
//         '#$label',
//         style: CretaFont.buttonMedium.copyWith(color: CretaColor.text[700]!),
//       ),
//       deleteIcon: Icon(
//         Icons.close,
//         size: 18,
//       ),
//       onDeleted: () {
//         onDeleted(index);
//       },
//     );
//   }
// }
