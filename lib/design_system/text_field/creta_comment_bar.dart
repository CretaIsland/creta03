// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';

import '../creta_color.dart';
import '../creta_font.dart';
//import 'package:hycop/hycop.dart';
//import 'package:flutter/material.dart';
//import 'package:outline_search_bar/outline_search_bar.dart';

class CretaCommentBar extends StatefulWidget {
  final double? width;
  //final double height;
  final Widget? thumb;
  final void Function(String value) onSearch;
  final String hintText;

  const CretaCommentBar({
    super.key,
    required this.hintText,
    required this.onSearch,
    this.width,
    this.thumb,
    //this.height = 56,
  });

  @override
  State<CretaCommentBar> createState() => _CretaCommentBarState();
}

class _CretaCommentBarState extends State<CretaCommentBar> {
  final TextEditingController _controller = TextEditingController();
  FocusNode? _focusNode;
  String _searchValue = '';
  bool _hover = false;
  bool _clicked = false;

  @override
  void initState() {
    _focusNode = FocusNode();
    _focusNode!.addListener(() {
      if (_focusNode!.hasFocus) {
        _controller.selection = TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onExit: (val) {
        setState(() {
          _hover = false;
          _clicked = false;
        });
      },
      onEnter: (val) {
        setState(() {
          _hover = true;
        });
      },
      child: Container(
        height: 56,
        width: widget.width,
        padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
        decoration: BoxDecoration(
          // crop
          borderRadius: BorderRadius.circular(30),
          color: CretaColor.text[100],
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            (widget.thumb == null)
                ? Container()
                : Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                // crop
                borderRadius: BorderRadius.circular(20),
                color: Colors.yellow,
              ),
              clipBehavior: Clip.antiAlias,
              child: widget.thumb,
            ),
            (widget.thumb == null)
                ? SizedBox()
                : SizedBox(width: 8),
            Expanded(
              child: CupertinoSearchTextField(
                focusNode: _focusNode,
                //padding: EdgeInsetsDirectional.fromSTEB(18, top, end, bottom)
                enabled: true,
                autofocus: true,
                decoration: BoxDecoration(
                  color: _clicked
                      ? Colors.white
                      : _hover
                          ? CretaColor.text[200]!
                          : CretaColor.text[100]!,
                  border: _clicked ? Border.all(color: CretaColor.primary) : null,
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: EdgeInsetsDirectional.all(0),
                controller: _controller,
                placeholder: _clicked ? null : widget.hintText,
                placeholderStyle: CretaFont.bodySmall.copyWith(color: CretaColor.text[400]!),
                prefixInsets: EdgeInsetsDirectional.only(start: 18),
                prefixIcon: Container(),
                style: CretaFont.bodySmall.copyWith(color: CretaColor.text[900]!),
                suffixInsets: EdgeInsetsDirectional.only(end: 18),
                suffixIcon: Icon(CupertinoIcons.search),
                suffixMode: OverlayVisibilityMode.always,
                onSubmitted: ((value) {
                  _searchValue = value;
                  logger.finest('search $_searchValue');
                  widget.onSearch(_searchValue);
                }),
                onSuffixTap: () {
                  _searchValue = _controller.text;
                  logger.finest('search $_searchValue');
                  widget.onSearch(_searchValue);
                },
                onTap: () {
                  setState(() {
                    _clicked = true;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
