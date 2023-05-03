// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../data_io/frame_manager.dart';
import '../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../design_system/buttons/creta_label_text_editor.dart';
import '../../../design_system/creta_color.dart';
import '../../../lang/creta_studio_lang.dart';
import '../../../model/book_model.dart';
import '../../../model/contents_model.dart';
import '../../../model/frame_model.dart';
import '../../../model/page_model.dart';
import '../book_main_page.dart';

import '../../../design_system/creta_font.dart';
import '../containees/containee_nofifier.dart';
import '../studio_constant.dart';
import '../studio_snippet.dart';
import '../studio_variables.dart';
import 'book/right_menu_book.dart';
import 'page/page_property.dart';
import 'right_menu_frame_and_contents.dart';

class RightMenu extends StatefulWidget {
  static bool isOpen = false;
  //final ContaineeEnum selectedStick;
  final Function onClose;
  const RightMenu({super.key, required this.onClose});

  @override
  State<RightMenu> createState() => _RightMenuState();
}

class _RightMenuState
    extends State<RightMenu> /* with SingleTickerProviderStateMixin, LeftMenuMixin */ {
  final GlobalKey<CretaLabelTextEditorState> textFieldKey = GlobalKey<CretaLabelTextEditorState>();
  //late ScrollController _scrollController;

  bool _isFirstOpen = true;

  @override
  void initState() {
    //_scrollController = ScrollController(initialScrollOffset: 0.0);
    //super.initAnimation(this);
    super.initState();
  }

  @override
  void dispose() {
    //super.disposeAnimation();
    super.dispose();
  }

  bool _shouldRightMenuOpen() {
    if (BookMainPage.containeeNotifier!.selectedClass == ContaineeEnum.None) {
      return false;
    }
    if (BookMainPage.containeeNotifier!.selectedClass == ContaineeEnum.Book ||
        _isFirstOpen == true) {
      _isFirstOpen = false;
      // if (BookMainPage.onceBookInfoOpened == true) {
      //   return false;
      // }
      return true;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return
        // SizedBox(
        //   height: StudioVariables.workHeight,
        //   child:
        //       // super.buildAnimation(
        //   context,
        //   width: LayoutConst.rightMenuWidth,
        //   shadowDirection: ShadowDirection.leftTop,
        //   child:
        Consumer<ContaineeNotifier>(builder: (context, containeeNotifier, child) {
      if (_shouldRightMenuOpen() == false) {
        RightMenu.isOpen = false;
        return SizedBox.shrink();
      }
      Widget title = _eachTitle(BookMainPage.containeeNotifier!.selectedClass);
      RightMenu.isOpen = true;

      return Container(
        height: StudioVariables.workHeight,
        width: LayoutConst.rightMenuWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: StudioSnippet.basicShadow(direction: ShadowDirection.leftTop),
        ),
        child: ListView(
          shrinkWrap: true,
          //controller: _scrollController,
          //mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: LayoutConst.rightMenuTitleHeight -
                  (BookMainPage.containeeNotifier!.selectedClass == ContaineeEnum.Book ? 0 : 4),
              width: LayoutConst.rightMenuWidth,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 8, left: 8,
                    child: BTN.fill_gray_i_m(
                      tooltip: CretaStudioLang.close,
                      tooltipBg: CretaColor.text[700]!,
                      icon: Icons.keyboard_double_arrow_right_outlined,
                      onPressed: () async {
                        //await _animationController.reverse();
                        RightMenu.isOpen = false;
                        widget.onClose.call();
                      },
                    ),
                    // super.closeButton(
                    //     icon: Icons.keyboard_double_arrow_right_outlined,
                    //     onClose: widget.onClose),
                  ),
                  SizedBox(
                    width: 300,
                    child: title,
                  ),
                ],
              ),
            ),
            // BookMainPage.containeeNotifier!.selectedClass == ContaineeEnum.Book
            //     ? SizedBox.shrink()
            //     : Divider(
            //         height: 4,
            //         color: CretaColor.text[200]!,
            //         indent: 0,
            //         endIndent: 0,
            //       ),
            SizedBox(
              width: LayoutConst.rightMenuWidth,
              child: _eachWidget(BookMainPage.containeeNotifier!.selectedClass),
            )
          ],
        ),
        //),
        //),
        //).animate().scaleX(alignment: Alignment.centerRight);
        // ).animate().scaleX(
        //         alignment: Alignment.centerRight,
        //         delay: Duration.zero,
        //         duration: Duration(milliseconds: 50));
      );
    });
  }

  Widget _eachWidget(ContaineeEnum selected) {
    switch (selected) {
      case ContaineeEnum.Book:
        return RightMenuBook();
      case ContaineeEnum.Page:
        return PageProperty();
      case ContaineeEnum.Frame:
        return RightMenuFrameAndContents(
            key: GlobalKey(), selectedTap: CretaStudioLang.frameTabBar.values.first);
      // {
      //   FrameModel? frame = BookMainPage.pageManagerHolder!.getSelectedFrame();
      //   if (frame == null) {
      //     return Container();
      //   }
      //   return FrameProperty(key: ValueKey(frame.mid), model: frame);
      // }
      case ContaineeEnum.Contents:
        return RightMenuFrameAndContents(
            key: GlobalKey(), selectedTap: CretaStudioLang.frameTabBar.values.last);
      // BookModel? model = BookMainPage.bookManagerHolder?.onlyOne() as BookModel?;
      // FrameModel? frame = BookMainPage.pageManagerHolder!.getSelectedFrame();
      // FrameManager? frameManager = BookMainPage.pageManagerHolder!.getSelectedFrameManager();
      // if (frame != null && frameManager != null) {
      //   ContentsManager? contentsManager = frameManager.getContentsManager(frame.mid);
      //   ContentsModel? contents = frameManager.getCurrentModel(frame.mid);
      //   if (contents != null) {
      //     logger.info('ContentsProperty ${contents.mid}');
      //     return Column(
      //       children: [
      //         if (contentsManager != null)
      //           ContentsOrderedList(
      //               width: LayoutConst.rightMenuWidth,
      //               height: LayoutConst.contentsListHeight,
      //               contentsManager: contentsManager),
      //         ContentsProperty(
      //             key: ValueKey(contents.mid),
      //             model: contents,
      //             frameManager: frameManager,
      //             book: model),
      //       ],
      //     );
      //   }
      // }
      // return Container();

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

  Widget _eachTitle(ContaineeEnum selected) {
    logger.info('_eachTitle $selected');
    switch (selected) {
      case ContaineeEnum.Book:
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
      case ContaineeEnum.Page:
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
      case ContaineeEnum.Frame:
        {
          String title = '';
          FrameModel? model = BookMainPage.pageManagerHolder?.getSelectedFrame();
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
      case ContaineeEnum.Contents:
        {
          FrameManager? frameManager = BookMainPage.pageManagerHolder?.getSelectedFrameManager();
          FrameModel? frameModel = BookMainPage.pageManagerHolder?.getSelectedFrame();
          if (frameModel == null || frameManager == null) {
            return Container();
          }
          ContentsModel? contents = frameManager.getCurrentModel(frameModel.mid);
          if (contents == null) {
            return Container();
          }
          return Text(
            contents.name,
            textAlign: TextAlign.center,
            style: CretaFont.titleLarge.copyWith(overflow: TextOverflow.ellipsis),
          );
        }
      default:
        return Text(
          "... Property",
          style: CretaFont.titleLarge.copyWith(overflow: TextOverflow.ellipsis),
        );
    }
  }
}
