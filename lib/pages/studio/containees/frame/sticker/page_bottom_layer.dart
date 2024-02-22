import 'package:flutter/material.dart';

import 'package:creta_studio_model/model/page_model.dart';
import '../../../book_main_page.dart';

class PageBottomLayer extends StatefulWidget {
  final double pageWidth;
  final double pageHeight;
  final PageModel pageModel;

  const PageBottomLayer(
      {super.key, required this.pageWidth, required this.pageHeight, required this.pageModel});

  @override
  State<PageBottomLayer> createState() => PageBottomLayerState();
}

class PageBottomLayerState extends State<PageBottomLayer> {
  void invalidate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: BookMainPage.pageOffset.dx,
      top: BookMainPage.pageOffset.dy,
      child: Container(
        color: widget.pageModel.dragOnMove == true
            ? Colors.black.withOpacity(0.25)
            : Colors.transparent,
        width: widget.pageWidth,
        height: widget.pageHeight,
      ),
    );
  }
}
