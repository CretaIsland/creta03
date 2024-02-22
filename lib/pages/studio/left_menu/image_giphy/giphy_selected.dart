import 'package:creta03/design_system/component/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';

import '../../../../data_io/frame_manager.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_studio_model/model/contents_model.dart';
import '../../book_main_page.dart';

class GiphySelectedWidget extends StatefulWidget {
  final String gifUrl;
  final double width;
  final double height;
  // final void Function(String)? onPressed;

  const GiphySelectedWidget({
    super.key,
    required this.gifUrl,
    required this.width,
    required this.height,
    // this.onPressed,
  });

  @override
  State<GiphySelectedWidget> createState() => _GiphySelectedWidgetState();
}

class _GiphySelectedWidgetState extends State<GiphySelectedWidget> {
  bool _isHover = false;
  bool _isClicked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget gifBox = Container(
      width: _isClicked ? widget.width + 4 : widget.width,
      height: _isClicked ? widget.height + 4 : widget.height,
      decoration: BoxDecoration(
        border: Border.all(
          color: _isHover ? CretaColor.primary : CretaColor.text[400]!,
          width: _isHover ? 4 : 1,
        ),
        color: Colors.transparent,
      ),
      child: Center(
        child: CustomImage(
          width: widget.width,
          height: widget.height,
          image: widget.gifUrl,
        ),
      ),
    );

    // if (widget.onPressed == null) {
    //   return gifBox;
    // }

    Widget boxWhenDrag = SizedBox(
      width: 90,
      height: 90,
      child: Center(
        child: Stack(
          children: [
            CustomImage(
              width: widget.width,
              height: widget.height,
              image: widget.gifUrl,
            ),
            Container(
              color: Colors.transparent,
              width: _isClicked ? 3 : 1,
            ),
          ],
        ),
      ),
    );

    FrameManager? frameManager = BookMainPage.pageManagerHolder!.getSelectedFrameManager();

    ContentsModel giphyContent(String url, String bookMid) {
      ContentsModel retval = ContentsModel.withFrame(parent: '', bookMid: bookMid);

      retval.contentsType = ContentsType.image;
      retval.name = 'name.gif';
      retval.remoteUrl = url;
      return retval;
    }

    return InkWell(
      onHover: (isHover) {
        setState(() {
          _isHover = isHover;
          if (isHover == true) {
            _isClicked = isHover;
          }
        });
      },
      onTapDown: (details) {
        setState(() {
          _isClicked = true;
        });
      },
      onDoubleTap: () {
        _isClicked = true;
        // widget.onPressed?.call(widget.gifUrl);
      },
      onSecondaryTapDown: (details) {},
      child: Draggable(
        data: giphyContent(widget.gifUrl, frameManager!.bookModel.mid),
        feedback: boxWhenDrag,
        child: gifBox,
      ),
      //),
    );
  }
}
