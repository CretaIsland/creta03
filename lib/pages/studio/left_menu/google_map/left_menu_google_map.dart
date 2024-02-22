import 'package:creta03/data_io/frame_manager.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/page_model.dart';
import 'package:creta03/pages/studio/book_main_page.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/undo/undo.dart';

import '../left_menu_ele_button.dart';

class LeftMenuMap extends StatefulWidget {
  final double width;
  final double height;
  final String title;
  final TextStyle titleStyle;
  final TextStyle dataStyle;

  const LeftMenuMap({
    super.key,
    required this.title,
    required this.width,
    required this.height,
    required this.titleStyle,
    required this.dataStyle,
  });

  @override
  State<LeftMenuMap> createState() => _LeftMenuMapState();
}

class _LeftMenuMapState extends State<LeftMenuMap> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 24.0),
          child: Text(widget.title, style: widget.dataStyle),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: Stack(
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: Image.asset('assets/google_map_thumbnail.png', fit: BoxFit.cover),
              ),
              _playerFG(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _playerFG() {
    return LeftMenuEleButton(
      height: 80,
      width: 80,
      onPressed: () {
        _createMapFrame(frameType: FrameType.map)
            .then((value) => BookMainPage.pageManagerHolder!.notify());
      },
      child: Container(),
    );
  }

  Future<void> _createMapFrame({required FrameType frameType}) async {
    PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
    if (pageModel == null) return;

    double width = pageModel.width.value * 0.5;
    double height = pageModel.height.value * 0.5;
    double x = (pageModel.width.value - width) / 2;
    double y = (pageModel.height.value - height) / 2;

    FrameManager? frameManager = BookMainPage.pageManagerHolder!.getSelectedFrameManager();
    if (frameManager == null) {
      return;
    }

    mychangeStack.startTrans();
    await frameManager.createNextFrame(
      doNotify: false,
      size: Size(width, height),
      pos: Offset(x, y),
      bgColor1: Colors.transparent,
      type: frameType,
    );
    mychangeStack.endTrans();
  }
}
