// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../design_system/buttons/creta_label_text_editor.dart';
import '../../../design_system/creta_color.dart';
import '../../../model/book_model.dart';
import '../../../model/page_model.dart';
import '../book_main_page.dart';

import '../../../design_system/creta_font.dart';
import '../studio_constant.dart';
import '../left_menu/left_menu_mixin.dart';
import '../studio_snippet.dart';
import '../studio_variables.dart';
import 'book/right_menu_book.dart';
import 'page/page_property.dart';

class RightMenu extends StatefulWidget {
  //final RightMenuEnum selectedStick;
  final Function onClose;
  const RightMenu({super.key, required this.onClose});

  @override
  State<RightMenu> createState() => _RightMenuState();
}

class _RightMenuState extends State<RightMenu> with SingleTickerProviderStateMixin, LeftMenuMixin {
  final GlobalKey<CretaLabelTextEditorState> textFieldKey = GlobalKey<CretaLabelTextEditorState>();
  //late ScrollController _scrollController;
  @override
  void initState() {
    //_scrollController = ScrollController(initialScrollOffset: 0.0);
    super.initAnimation(this);
    super.initState();
  }

  @override
  void dispose() {
    super.disposeAnimation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget title = _eachTitle(BookMainPage.selectedClass);
    return SizedBox(
      height: StudioVariables.workHeight,
      child: super.buildAnimation(
        context,
        width: LayoutConst.rightMenuWidth,
        shadowDirection: ShadowDirection.leftTop,
        child: ListView(
          shrinkWrap: true,
          //mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: LayoutConst.rightMenuTitleHeight -
                  (BookMainPage.selectedClass == RightMenuEnum.Book ? 0 : 4),
              width: LayoutConst.rightMenuWidth,
              child: Row(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 8),
                        child: super.closeButton(
                            icon: Icons.keyboard_double_arrow_right_outlined,
                            onClose: widget.onClose),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2, left: 16.0),
                        child: Center(
                          child: SizedBox(
                            width: 300,
                            child: title,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            BookMainPage.selectedClass == RightMenuEnum.Book
                ? SizedBox.shrink()
                : Divider(
                    height: 4,
                    color: CretaColor.text[200]!,
                    indent: 0,
                    endIndent: 0,
                  ),
            SizedBox(
              width: LayoutConst.rightMenuWidth,
              child: _eachWidget(BookMainPage.selectedClass),
            )
          ],
        ),
      ),
    );
  }

  Widget _eachWidget(RightMenuEnum selected) {
    switch (selected) {
      case RightMenuEnum.Book:
        return RightMenuBook();
      case RightMenuEnum.Page:
        return PageProperty();
      case RightMenuEnum.Frame:
        return Container();
      case RightMenuEnum.Contents:
        return Container();

      default:
        return Container();
    }
  }

  Widget _showTitleText({required String title, required void Function(String) onEditComplete}) {
    logger.finest('_showTitletext $title');
    return CretaLabelTextEditor(
      textFieldKey: textFieldKey,
      height: 32,
      width: StudioVariables.displayWidth * 0.25,
      text: title,
      textStyle: CretaFont.titleLarge,
      align: TextAlign.center,
      onEditComplete: onEditComplete,
      onLabelHovered: () {},
    );
  }

  Widget _eachTitle(RightMenuEnum selected) {
    logger.finest('_eachTitle $selected');
    switch (selected) {
      case RightMenuEnum.Book:
        {
          String title = '';
          BookModel? model = BookMainPage.bookManagerHolder?.onlyOne() as BookModel?;
          if (model == null) {
            return Container();
          }
          title = model.name.value;
          return _showTitleText(
            title: title,
            onEditComplete: (value) {
              setState(() {
                model.name.set(value);
              });
              BookMainPage.bookManagerHolder?.notify();
            },
          );
        }
      case RightMenuEnum.Page:
        {
          String title = '';
          PageModel? model = BookMainPage.pageManagerHolder?.getSelected() as PageModel?;
          if (model == null) {
            return Container();
          }
          title = model.name.value;
          return _showTitleText(
            title: title,
            onEditComplete: (value) {
              setState(() {
                model.name.set(value);
              });
              BookMainPage.bookManagerHolder?.notify();
            },
          );
        }
      case RightMenuEnum.Frame:
        return Text(
          "Frame Property",
          style: CretaFont.titleLarge.copyWith(overflow: TextOverflow.ellipsis),
        );
      case RightMenuEnum.Contents:
        return Text(
          "Contents Property",
          style: CretaFont.titleLarge.copyWith(overflow: TextOverflow.ellipsis),
        );

      default:
        return Text(
          "... Property",
          style: CretaFont.titleLarge.copyWith(overflow: TextOverflow.ellipsis),
        );
    }
  }
}
