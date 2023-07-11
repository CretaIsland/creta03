// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import '../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../design_system/creta_color.dart';
import '../book_main_page.dart';
import '../studio_snippet.dart';
import 'left_menu_frame.dart';
import '../../../lang/creta_studio_lang.dart';
import '../../../design_system/creta_font.dart';
import '../studio_constant.dart';
import 'left_menu_page.dart';
import 'left_menu_text.dart';
import 'left_menu_widget.dart';

class LeftMenuNotifier extends ChangeNotifier {
  LeftMenuEnum _selectedStick = LeftMenuEnum.None;
  LeftMenuEnum get selectedStick => _selectedStick;

  void set(LeftMenuEnum val, {bool doNotify = true}) {
    _selectedStick = val;
    if (doNotify) {
      notifyListeners();
    }
  }

  void notify() => notifyListeners();
}

class LeftMenu extends StatefulWidget {
  //final LeftMenuEnum selectedStick;
  final Function onClose;
  const LeftMenu({
    super.key,
    required this.onClose,
  });

  @override
  State<LeftMenu> createState() => _LeftMenuState();
}

class _LeftMenuState
    extends State<LeftMenu> /* with SingleTickerProviderStateMixin,  LeftMenuMixin  */ {
  //final bool _closeWidget = false;
  bool isCollapsed = false;
  double _leftMenuWidth = LayoutConst.leftMenuWidth;
  bool _isButtonSelected(LeftMenuEnum val) => BookMainPage.leftMenuNotifier!.selectedStick == val;

  @override
  void initState() {
    //super.initAnimation(this);
    super.initState();
  }

  @override
  void dispose() {
    //super.disposeAnimation();
    super.dispose();
  }

  void changeState() {
    super.setState(() {
      isCollapsed = !isCollapsed;
    });
  }

  void _resize() {
    if (_isButtonSelected(LeftMenuEnum.Page) && isCollapsed) {
      _leftMenuWidth = LayoutConst.leftMenuWidthCollapsed + 20;
    } else {
      _leftMenuWidth = LayoutConst.leftMenuWidth;
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (BookMainPage.selectedStick == LeftMenuEnum.None) {
    //   return Container();
    // }

    return
        // super.buildAnimation(
        //   context,
        //   width: LayoutConst.leftMenuWidth,
        //   child:
        Consumer<LeftMenuNotifier>(builder: (context, leftMenuNotifier, child) {
      if (_isButtonSelected(LeftMenuEnum.None)) {
        return SizedBox.shrink();
      }
      _resize();
      return Container(
        width: _leftMenuWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: StudioSnippet.basicShadow(direction: ShadowDirection.rightBottum),
        ),
        child: Stack(
          children: [
            Positioned(
                right: 8,
                top: 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if ((_isButtonSelected(LeftMenuEnum.Page) && !isCollapsed) |
                        (!_isButtonSelected(LeftMenuEnum.Page) && isCollapsed) |
                        !isCollapsed)
                      BTN.fill_gray_i_m(
                        tooltip: CretaStudioLang.wide,
                        tooltipBg: CretaColor.text[700]!,
                        icon: Icons.open_in_full_outlined,
                        iconSize: 14,
                        onPressed: () async {},
                      ),
                    if (_isButtonSelected(LeftMenuEnum.Page))
                      BTN.fill_gray_i_m(
                        tooltip: isCollapsed ? CretaStudioLang.open : CretaStudioLang.collapsed,
                        tooltipBg: CretaColor.text[700]!,
                        icon: isCollapsed
                            ? Icons.keyboard_double_arrow_right_outlined
                            : Icons.keyboard_double_arrow_left_outlined,
                        onPressed: changeState,
                      ),
                    BTN.fill_gray_i_m(
                      tooltip: CretaStudioLang.close,
                      tooltipBg: CretaColor.text[700]!,
                      icon: Icons.close_sharp,
                      onPressed: () async {
                        //await _animationController.reverse();
                        widget.onClose.call();
                      },
                    ),
                    // super.closeButton(
                    //     icon: Icons.keyboard_double_arrow_left_outlined,
                    //     onClose: () {
                    //       widget.onClose.call();
                    //     }),
                  ],
                )),
            Positioned(
                left: isCollapsed ? 24 : 28, // ----- added by Mai 230517 ------
                top: isCollapsed ? 44 : 24, // ----- added by Mai 230517 ------
                child: _isButtonSelected(LeftMenuEnum.None)
                    ? SizedBox.shrink()
                    : Text(
                        CretaStudioLang
                            .menuStick[BookMainPage.leftMenuNotifier!.selectedStick.index],
                        style: CretaFont.titleLarge)),
            Positioned(
              top: 76,
              left: 0,
              width: _leftMenuWidth, // ----- added on 230518 ------
              child: eachWidget(BookMainPage.leftMenuNotifier!.selectedStick),
            )
          ],
          //),
        ),
        //).animate().scaleX(alignment: Alignment.centerLeft);
        // ).animate().scaleX(
        //     alignment: Alignment.centerLeft,
        //     delay: Duration.zero,
        //     duration: Duration(milliseconds: 50));
      );
    });
  }

  Widget eachWidget(LeftMenuEnum selected) {
    switch (selected) {
      case LeftMenuEnum.Template:
        return Container();
      case LeftMenuEnum.Page:
        return LeftMenuPage(isFolded: isCollapsed);
      case LeftMenuEnum.Frame:
        return LeftMenuFrame();
      case LeftMenuEnum.Storage:
        return Container();
      case LeftMenuEnum.Video:
        return Container();
      case LeftMenuEnum.Text:
        return LeftMenuText();
      case LeftMenuEnum.Figure:
        return Container();
      case LeftMenuEnum.Widget:
        return LeftMenuWidget();
      case LeftMenuEnum.Camera:
        return Container();
      case LeftMenuEnum.Comment:
        return Container();
      default:
        return Container();
    }
  }
}
