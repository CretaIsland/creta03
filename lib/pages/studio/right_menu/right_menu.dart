// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../../design_system/buttons/creta_label_text_editor.dart';
import '../../../model/book_model.dart';
import '../book_main_page.dart';

import '../../../design_system/creta_font.dart';
import '../studio_constant.dart';
import '../left_menu/left_menu_mixin.dart';
import '../studio_snippet.dart';
import '../studio_variables.dart';
import 'right_menu_book.dart';

class RightMenu extends StatefulWidget {
  //final RightMenuEnum selectedStick;
  final Function onClose;
  const RightMenu({super.key, required this.onClose});

  @override
  State<RightMenu> createState() => _RightMenuState();
}

class _RightMenuState extends State<RightMenu> with SingleTickerProviderStateMixin, LeftMenuMixin {
  final GlobalKey<CretaLabelTextEditorState> textFieldKey = GlobalKey<CretaLabelTextEditorState>();

  @override
  void initState() {
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
    Widget title = eachTitle(BookMainPage.selectedClass);
    return super.buildAnimation(
      context,
      width: LayoutConst.rightMenuWidth,
      shadowDirection: ShadowDirection.leftTop,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: LayoutConst.rightMenuTitleHeight,
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
          SizedBox(
            width: LayoutConst.rightMenuWidth,
            child: eachWidget(BookMainPage.selectedClass),
          )
        ],
      ),
    );
  }

  Widget eachWidget(RightMenuEnum selected) {
    switch (selected) {
      case RightMenuEnum.Book:
        return RightMenuBook();
      case RightMenuEnum.Page:
        return Container();
      case RightMenuEnum.Frame:
        return Container();
      case RightMenuEnum.Contents:
        return Container();

      default:
        return Container();
    }
  }

  Widget eachTitle(RightMenuEnum selected) {
    switch (selected) {
      case RightMenuEnum.Book:
        {
          String name = '';
          BookModel? model = bookManagerHolder?.onlyOne() as BookModel?;
          if (model == null) {
            return Container();
          }
          name = model.name.value;

          return CretaLabelTextEditor(
            textFieldKey: textFieldKey,
            height: 32,
            width: StudioVariables.displayWidth * 0.25,
            text: name,
            textStyle: CretaFont.titleLarge,
            align: TextAlign.center,
            onEditComplete: (value) {
              setState(() {
                model.name.set(value);
              });
              bookManagerHolder?.notify();
            },
            onLabelHovered: () {},
          );
        }
      case RightMenuEnum.Page:
        return Text(
          "Page Property",
          style: CretaFont.titleLarge.copyWith(overflow: TextOverflow.ellipsis),
        );
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
