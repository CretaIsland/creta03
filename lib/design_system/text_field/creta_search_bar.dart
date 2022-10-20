// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';

import '../creta_color.dart';
import '../creta_font.dart';
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
  TextEditingController controller = TextEditingController();
  String searchValue = '';
  bool hover = false;
  bool clicked = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onExit: (val) {
        setState(() {
          hover = false;
          clicked = false;
        });
      },
      onEnter: (val) {
        setState(() {
          hover = true;
        });
      },
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: CupertinoSearchTextField(
          enabled: true,
          autofocus: true,
          decoration: BoxDecoration(
            color: clicked
                ? Colors.white
                : hover
                    ? CretaColor.text[200]!
                    : CretaColor.text[100]!,
            border: clicked ? Border.all(color: CretaColor.primary) : null,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: EdgeInsetsDirectional.all(0),
          controller: controller,
          placeholder: clicked ? null : widget.hintText,
          placeholderStyle: CretaFont.bodySmall.copyWith(color: CretaColor.text[400]!),
          prefixInsets: EdgeInsetsDirectional.only(start: 18),
          prefixIcon: Container(),
          style: CretaFont.bodySmall.copyWith(color: CretaColor.text[900]!),
          suffixInsets: EdgeInsetsDirectional.only(end: 18),
          suffixIcon: Icon(CupertinoIcons.search),
          suffixMode: OverlayVisibilityMode.always,
          onSubmitted: ((value) {
            searchValue = value;
            logger.finest(context, 'search $searchValue');
            widget.onSearch(searchValue);
          }),
          onSuffixTap: () {
            searchValue = controller.text;
            logger.finest(context, 'search $searchValue');
            widget.onSearch(searchValue);
          },
          onTap: () {
            setState(() {
              clicked = true;
            });
          },
        ),
      ),
    );
  }
}
