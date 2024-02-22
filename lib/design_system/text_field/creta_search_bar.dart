// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';

import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
//import 'package:hycop/hycop.dart';
//import 'package:flutter/material.dart';
//import 'package:outline_search_bar/outline_search_bar.dart';

class CretaSearchBar extends StatefulWidget {
  final double width;
  final double height;
  final void Function(String value) onSearch;
  final String hintText;

  const CretaSearchBar(
      {super.key,
      required this.hintText,
      required this.onSearch,
      this.width = 246,
      this.height = 32});

  const CretaSearchBar.long(
      {super.key,
      required this.hintText,
      required this.onSearch,
      this.width = 372,
      this.height = 32});

  @override
  State<CretaSearchBar> createState() => _CretaSearchBarState();
}

class _CretaSearchBarState extends State<CretaSearchBar> {
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
    // GlobalKey<State<StatefulWidget>> dummyKey = GlobalObjectKey('dummy');
    // CretaTextField.focusNodeMap[dummyKey] = _focusNode!;

    Timer.periodic(const Duration(microseconds: 100), (timer) {
      timer.cancel();
      _focusNode!.unfocus();
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
      child: SizedBox(
        height: widget.height,
        width: widget.width,
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
          placeholder: _clicked ? '' : widget.hintText,
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
    );
  }
}
