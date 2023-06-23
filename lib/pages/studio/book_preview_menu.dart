import 'package:flutter/material.dart';

import '../../design_system/buttons/creta_transparent_button.dart';
import '../../design_system/creta_color.dart';
import '../../design_system/creta_font.dart';
import 'studio_constant.dart';
import 'studio_variables.dart';

class BookPreviewMenu extends StatefulWidget {
  static bool previewMenuPressed = false;
  final int pageNo;
  final int totalPage;
  final void Function() goBackProcess;
  final void Function() muteFunction;
  final void Function() playFunction;
  final void Function() gotoNext;
  final void Function() gotoPrev;
  const BookPreviewMenu({
    super.key,
    required this.pageNo,
    required this.totalPage,
    required this.goBackProcess,
    required this.muteFunction,
    required this.playFunction,
    required this.gotoNext,
    required this.gotoPrev,
  });

  @override
  State<BookPreviewMenu> createState() => _BookPreviewMenuState();
}

class _BookPreviewMenuState extends State<BookPreviewMenu> {
  bool _isHover = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      bottom: 0,
      child: MouseRegion(
        onExit: (val) {
          setState(() {
            _isHover = false;
          });
        },
        onEnter: (val) {
          setState(() {
            _isHover = true;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          width: StudioVariables.workWidth,
          height: LayoutConst.previewMenuHeight,
          color: CretaColor.text.withOpacity(_isHover ? 0.25 : 0.0),
          child: _isHover
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CretaTrasparentButton(
                          onPressed: widget.muteFunction,
                          icon1: Icons.volume_off_outlined,
                          icon2: Icons.volume_up_outlined,
                          iconSize: 20,
                          toggleValue: StudioVariables.isMute,
                        ),
                        const SizedBox(width: 15),
                        CretaTrasparentButton(
                          toggleValue: StudioVariables.isAutoPlay,
                          icon1: Icons.pause_outlined,
                          icon2: Icons.play_arrow_outlined,
                          onPressed: widget.playFunction,
                          iconSize: 20,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CretaTrasparentButton(
                          onPressed: widget.gotoPrev,
                          icon1: Icons.arrow_back_ios_new_outlined,
                          icon2: Icons.arrow_back_ios_new_outlined,
                          toggleValue: true,
                          iconSize: 20,
                          doToggle: false,
                        ),
                        Text(
                          _pageNoString(),
                          style: CretaFont.buttonLarge.copyWith(color: Colors.white),
                        ),
                        CretaTrasparentButton(
                          onPressed: widget.gotoNext,
                          icon1: Icons.arrow_forward_ios_outlined,
                          icon2: Icons.arrow_forward_ios_outlined,
                          toggleValue: true,
                          iconSize: 20,
                          doToggle: false,
                        ),
                      ],
                    ),
                    CretaTrasparentButton(
                      onPressed: widget.goBackProcess,
                      icon1: Icons.logout_outlined,
                      icon2: Icons.logout_outlined,
                      toggleValue: StudioVariables.isPreview,
                      iconSize: 20,
                      doToggle: false,
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }

  String _pageNoString() {
    String pageNo = widget.pageNo < 10 ? '0${widget.pageNo}' : '${widget.pageNo}';
    String totalPage = widget.totalPage < 10 ? '0${widget.totalPage}' : '${widget.totalPage}';
    return ' $pageNo / $totalPage ';
  }
}
